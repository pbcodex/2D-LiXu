;Lixu - Effet StarField

IncludeFile "lixu.pbi"

InitSprite()
InitKeyboard()
InitMouse()

UseModule lixu

OpenWindow(0, 0, 0, 1024, 768, "Lixu Particle", #PB_Window_SystemMenu|#PB_Window_ScreenCentered)
OpenWindowedScreen(WindowID(0), 0, 0, 1024, 768)

;Create particles emitter
lixu::EmitterCreate("starfield", #PB_Particle_Point)
lixu::ParticleRate("starfield", 150)
lixu::ParticleColorsRange("starfield", RGB(255, 0, 0), RGB(0, 0, 255), 10)
lixu::ParticleSizeRange("starfield", 15, 50)
lixu::ParticleSpeedRange("starfield", -3, -3, 3, 3)
lixu::ParticleTimeToLife("starfield", 600)

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
  ExamineMouse()
  
  ;Play emitter
  lixu::EmitterPlay("starfield", ScreenWidth()/2, ScreenHeight()/2)
  
  FlipBuffers()
Until KeyboardPushed(#PB_Key_Escape)
; IDE Options = PureBasic 5.40 LTS (Windows - x86)
; EnableXP