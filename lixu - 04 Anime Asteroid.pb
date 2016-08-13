;Lixu - Anime vertical and horizontal Sprite Sheet
IncludeFile "lixu.pbi"

InitSprite()
InitKeyboard()
InitMouse()
UsePNGImageDecoder()

OpenWindow(0, 0, 0, 800, 600, "Test", #PB_Window_SystemMenu|#PB_Window_ScreenCentered)
OpenWindowedScreen(WindowID(0), 0, 0, 800, 600)

;Load sprite
Asteroid = LoadSprite(#PB_Any, "Assets/image/asteroid1.png", #PB_Sprite_AlphaBlending)

;Create and set animation 
lixu::SpriteAddAnimation(Asteroid, "rotate", 0, 18, 72, 72, 110)
lixu::SpriteSetAnimation(Asteroid, "rotate")

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
  
  DisplayTransparentSprite(Asteroid, 400, 300)
  
  ;Play current animation
  lixu::SpriteUpdateAnimation(Asteroid)
  
  FlipBuffers()
  
Until KeyboardPushed(#PB_Key_Escape)
; IDE Options = PureBasic 5.42 LTS (Windows - x86)
; CursorPosition = 13
; EnableXP