;Lixu - Create emitter without 

IncludeFile "lixu.pbi"

InitSprite()
InitKeyboard()
InitMouse()
UsePNGImageDecoder()  

OpenWindow(0, 0, 0, 800, 600, "Lixu Particle", #PB_Window_SystemMenu|#PB_Window_ScreenCentered)
OpenWindowedScreen(WindowID(0), 0, 0, 800, 600)

;Load Sprite
star = LoadSprite(#PB_Any, "assets/image/star_particle.png", #PB_Sprite_AlphaBlending) 

;Create particles emitter
lixu::EmitterCreate("example", #PB_Ignore, star)

lixu::ParticleRate("example", 150)
lixu::ParticleColorsRange("example", RGB(255, 255, 255), RGB(0, 0, 255), 10)
lixu::ParticleSizeRange("example", 5, 50)
lixu::ParticleSpeedRange("example", -1, -1, 1, 2)
lixu::ParticleTimeToLife("example", 400)
lixu::ParticleRotateRange("example", -1, 1)

;Events Loop
Repeat
  Repeat
    Event = WindowEvent()
     
    Select Event    
      Case #PB_Event_CloseWindow
        End
    EndSelect  
  Until Event=0
    
  
  ClearScreen(RGB(75, 0, 130))
  ExamineKeyboard()
  ExamineMouse()
  
  ;Play emitter (Inutile de préciser la position x y)
  lixu::EmitterPlay("example")
  
  FlipBuffers()
Until KeyboardPushed(#PB_Key_Escape)
; IDE Options = PureBasic 5.42 LTS (Windows - x86)
; CursorPosition = 13
; EnableXP