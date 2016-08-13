;Lixu - Create emitter (#PB_Particle_Box)

IncludeFile "lixu.pbi"

InitSprite()
InitKeyboard()
InitMouse()

OpenWindow(0, 0, 0, 800, 600, "Lixu Particle", #PB_Window_SystemMenu|#PB_Window_ScreenCentered)
OpenWindowedScreen(WindowID(0), 0, 0, 800, 600)

;Create particles emitter (Default Particle type : #PB_Particle_Box)
lixu::EmitterCreate("example")
lixu::ParticleColorsRange("example", RGB(255, 0, 0), RGB(0, 0, 255), 10)
lixu::ParticleSizeRange("example", 10, 60)
lixu::ParticleSpeedRange("example",0, 0.5, 0, 1)
lixu::ParticleTimeToLife("example", 400)

;Events Loop
Repeat
  Repeat
    Event = WindowEvent()
     
    Select Event    
      Case #PB_Event_CloseWindow
        End
    EndSelect  
  Until Event=0
    
  ClearScreen(RGB(0, 0, 0))
  ExamineKeyboard()
  
  ;Play emitter
  lixu::EmitterPlay("example", 0, 0)
  
  FlipBuffers()
Until KeyboardPushed(#PB_Key_Escape)
; IDE Options = PureBasic 5.42 LTS (Windows - x86)
; CursorPosition = 20
; EnableXP