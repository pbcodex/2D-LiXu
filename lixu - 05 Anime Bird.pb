;lixu - Anime bird

IncludeFile "lixu.pbi"

InitSprite()
InitKeyboard()
InitMouse()
UsePNGImageDecoder()

OpenWindow(0, 0, 0, 800, 600, "Test", #PB_Window_SystemMenu|#PB_Window_ScreenCentered)
OpenWindowedScreen(WindowID(0), 0, 0, 800, 600)

;Create sprite
Bird = LoadSprite(#PB_Any, "Assets/image/bird.png", #PB_Sprite_AlphaBlending)

;Add animations
lixu::SpriteAddAnimation(Bird, "left", 0, 3, 64, 64, 130)
lixu::SpriteAddAnimation(Bird, "right", 4, 7, 64, 64, 130)
lixu::SpriteAddAnimation(Bird, "face", 12, 15, 64, 64, 130)

Repeat  
  Repeat
    Event = WindowEvent()
     
    Select Event    
      Case #PB_Event_CloseWindow
        End
    EndSelect  
  Until Event=0
    
  ClearScreen(RGB(135, 206, 235))
  ExamineKeyboard()
  
  ;Set animations
  If KeyboardPushed(#PB_Key_Left)
    lixu::SpriteSetAnimation(Bird, "left")    
    
  ElseIf KeyboardPushed(#PB_Key_Right)
    lixu::SpriteSetAnimation(Bird, "right")    
    
  Else
    lixu::SpriteSetAnimation(Bird, "face")
    
  EndIf
  
  ;Play current animation
  lixu::SpriteUpdateAnimation(Bird)

  DisplayTransparentSprite(Bird, 400, 300)
  
  FlipBuffers()
Until KeyboardPushed(#PB_Key_Escape)
; IDE Options = PureBasic 5.42 LTS (Windows - x86)
; CursorPosition = 12
; Folding = -
; EnableXP