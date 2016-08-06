IncludeFile "lixu.pbi"

UseJPEGImageDecoder()

InitSprite()
InitKeyboard()

OpenWindow(0, 0, 0, 800, 600, "Scrolling Test", #PB_Window_SystemMenu|#PB_Window_ScreenCentered)
OpenWindowedScreen(WindowID(0), 0, 0, 800, 600)

;Load ScrollSprite background
Background1 = lixu::ScrollSpriteCreate(#PB_Any, "assets\image\starfield.jpg",0,0,255,1)
Background2 = lixu::ScrollSpriteCreate(#PB_Any, "assets\image\starfield.jpg",0,0,180,1)

Repeat
  Repeat
    Event = WindowEvent()
    Select Event    
      Case #PB_Event_CloseWindow
        End
    EndSelect  
  Until Event = 0
  
  ExamineKeyboard()
  
  ClearScreen(0)
  
  ;Scroll background
  lixu::ScrollSpriteUpdate(Background1, 0, 0, 0.3, -0.4)
  lixu::ScrollSpriteUpdate(Background2, 0, 0, -0.5, -0.2)
  
  FlipBuffers()
  
Until KeyboardPushed(#PB_Key_Escape)
; IDE Options = PureBasic 5.31 (Windows - x86)
; CursorPosition = 10
; EnableXP