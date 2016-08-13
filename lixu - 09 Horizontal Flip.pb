;Lixu - Flip Horizontal
IncludeFile "lixu.pbi"

InitSprite()
InitKeyboard()
InitMouse()
UseJPEGImageDecoder()
UsePNGImageDecoder()

OpenWindow(0, 0, 0, 800, 600, "Lixu : Flip Horizontal", #PB_Window_SystemMenu|#PB_Window_ScreenCentered)
OpenWindowedScreen(WindowID(0), 0, 0, 800, 600)

;Load Background
Background = LoadSprite(#PB_Any, "Assets\image/blur1.jpg", #PB_Sprite_AlphaBlending)
ZoomSprite(Background, 800, 600)

;Logo PureBasic
Logo = LoadSprite(#PB_Any, "Assets/image/purebasiclogo.png", #PB_Sprite_AlphaBlending)

;Flip Horizontal
lixu::SpriteFlipHorizontal(Logo)

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
  
  DisplaySprite(Background, 0, 0)
      
  DisplayTransparentSprite(Logo, 190, 250)
  
  
  FlipBuffers()
  
Until KeyboardPushed(#PB_Key_Escape)
; IDE Options = PureBasic 5.42 LTS (Windows - x86)
; CursorPosition = 17
; EnableXP