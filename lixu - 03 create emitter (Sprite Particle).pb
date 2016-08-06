;Lixu - Create emitter (Sprite Particle)

IncludeFile "lixu.pbi"

InitSprite()
InitKeyboard()
InitMouse()

UsePNGImageDecoder()

UseModule lixu

OpenWindow(0, 0, 0, 800, 600, "Lixu Particle", #PB_Window_SystemMenu|#PB_Window_ScreenCentered)
OpenWindowedScreen(WindowID(0), 0, 0, 800, 600)

;Load Sprite
star = LoadSprite(#PB_Any, "assets\image\star_particle.png", #PB_Sprite_AlphaBlending)

;Create particles emitter
lixu::EmitterCreate("example", #PB_Particle_Point, star)
lixu::ParticleRate("example", 150)
lixu::ParticleColorsRange("example", RGB(255, 0, 0), RGB(0, 0, 255), 10)
lixu::ParticleSizeRange("example", 10, 60)
lixu::ParticleSpeedRange("example", -2, -1, 2, -3)
lixu::ParticleRotateRange("example", -3, 3)
lixu::ParticleTimeToLife("example", 200)

;Events Loop
Repeat  ;Window
  Repeat ;Screen
    Event = WindowEvent()
     
    Select Event    
      Case #PB_Event_CloseWindow
        End
    EndSelect  
  Until Event=0
    
  
  ClearScreen(RGB(255, 255, 255))
  ExamineKeyboard()
  ExamineMouse()
  
  ;Play emitter
  lixu::EmitterPlay("example", MouseX(), MouseY())
  
  FlipBuffers()
Until KeyboardPushed(#PB_Key_Escape)
; IDE Options = PureBasic 5.31 (Windows - x86)
; CursorPosition = 44
; FirstLine = 1
; EnableXP