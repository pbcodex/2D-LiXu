;Lixu - Create emitter and play once

IncludeFile "lixu.pbi"

;Ball Structure
Structure Square
  idSprite.i
  x.i
  y.i
  crash.b
EndStructure
Dim Balls.Square(9)

InitSprite()
InitKeyboard()
InitMouse()

OpenWindow(0, 0, 0, 800, 600, "Lixu Particle", #PB_Window_SystemMenu|#PB_Window_ScreenCentered)
OpenWindowedScreen(WindowID(0), 0, 0, 800, 600)

;Create Square
Square = CreateSprite(#PB_Any, 8, 8)
StartDrawing(SpriteOutput(Square))
Box(0, 0, 8, 8, RGB(255, 255, 255))
StopDrawing()

;Create 10 balls
For i = 0 To 9
  With Balls(i)
    \idSprite = CopySprite(Square, #PB_Any)
    \x = i * 32
    \y = 180
    ZoomSprite(\idSprite, 16, 16)
  EndWith
Next

;Create Platform
Platform = CopySprite(Square, #PB_Any)
ZoomSprite(Platform, 300, 8)

;Create Ground
Ground = CopySprite(Square, #PB_Any)
ZoomSprite(Ground, 800, 8)

;Create particles emitter explose
lixu::EmitterCreate("explose", #PB_Particle_Point, Square)
lixu::ParticleRate("explose", 10)
lixu::ParticleColorsRange("explose", RGB(255, 255, 255), RGB(255, 255, 255), 1)
lixu::ParticleSizeRange("explose", 8, 8)
lixu::ParticleSpeedRange("explose", -2, -3, 2, 0.5)
lixu::ParticleTimeToLife("explose", 40)

;Events Loop
Repeat  ;Window
  Repeat ;Screen
    Event = WindowEvent()
     
    Select Event    
      Case #PB_Event_CloseWindow
        End
    EndSelect  
  Until Event=0
    
  ClearScreen(RGB(0, 0, 0))
  ExamineKeyboard()
  
  ;Show Platform
  DisplaySprite(Platform, 0, 200)
  
  ;Show Ground
  DisplaySprite(Ground, 0, 500)
  
  ;Show Balls
  For i = 0 To 9
    With Balls(i)
      If \x < 297 ;on the platform
        \x + 1
      Else ;balls fall
        \x + 1
        \y + 2
        RotateSprite(\idSprite, 1, #PB_Relative)
      EndIf
      
      ;DisplaySprite(\idSprite, \x, \y)
      
      ;Collide(Ground, Ball) ==> Play explode)
      If SpriteCollision(\idSprite, 300, \y, Ground, 0, 500)
        \x = 0
        \y = 180
        \crash = #True
        RotateSprite(\idSprite, 0, #PB_Absolute)
      EndIf
      
      If \crash = #True
        lixu::EmitterPlay("explose", 450, 500, #False)
      EndIf
      
      ;Display ball
      DisplaySprite(\idSprite, \x, \y)
      
      ;Display ball crashing
      If lixu::EmitterActif("explose") = #False
        lixu::EmitterActif("explose", #True)
        \crash = #False
      EndIf
      
    EndWith
  Next
  
  FlipBuffers()
Until KeyboardPushed(#PB_Key_Escape)
; IDE Options = PureBasic 5.31 (Windows - x86)
; CursorPosition = 94
; FirstLine = 57
; Folding = --
; EnableXP