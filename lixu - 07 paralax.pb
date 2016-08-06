IncludeFile "lixu.pbi"

Global BirdX.f = 300, BackGroundX.f

UsePNGImageDecoder()
UseJPEGImageDecoder()

InitSprite()
InitKeyboard()

OpenWindow(0, 0, 0, 800, 600, "Paralax Test", #PB_Window_SystemMenu|#PB_Window_ScreenCentered)
OpenWindowedScreen(WindowID(0), 0, 0, 800, 600)

;Load SpriteScrollBackground & ground
Background = lixu::ScrollSpriteCreate(#PB_Any, "assets\image\background.jpg")
Ground = lixu::ScrollSpriteCreate(#PB_Any, "assets\image\ground.jpg")

;Load Sprite Bird
Bird = LoadSprite(#PB_Any, "assets\image\bird.png", #PB_Sprite_AlphaBlending)

;Add animation
lixu::SpriteAddAnimation(Bird, "left", 0, 3, 64, 64, 130)
lixu::SpriteAddAnimation(Bird, "right", 4, 6, 64, 64, 130)
lixu::SpriteAddAnimation(Bird, "wait", 12, 15, 64, 64, 130)

Repeat
  Repeat
    Event = WindowEvent()
    If Event = #PB_Event_CloseWindow : Quit = #True : EndIf
  Until Event = 0
  
  BackGroundX = 0
  
  ExamineKeyboard()
  
  ClearScreen(RGB(8,63,70)) ; sky darkblue, to use with the spriteblending of the background ;)
  
  If KeyboardPushed(#PB_Key_Left)
    lixu::SpriteSetAnimation(Bird, "left")
    BirdX - 2
    If BirdX < 300
      BirdX + 2
      BackGroundX = -0.4
    EndIf            
    
  ElseIf  KeyboardPushed(#PB_Key_Right)
    lixu::SpriteSetAnimation(Bird, "right")
    BirdX + 2
    If BirdX > 500
      BirdX - 2
      BackGroundX = 0.4
    EndIf    
    
  Else
    lixu::SpriteSetAnimation(Bird, "wait")    
  EndIf
   
  ;Scroll (Paralax)
  lixu::ScrollSpriteUpdate(Background, 0, 0, BackGroundX, 0)
  lixu::ScrollSpriteUpdate(Ground, 0, 550, BackGroundX * 5, 0)
  
  ;Show Bird
  lixu::SpriteUpdateAnimation(Bird)
  DisplayTransparentSprite(Bird, BirdX, 300)
  
  FlipBuffers() 
  
Until Quit
; IDE Options = PureBasic 5.31 (Windows - x86)
; CursorPosition = 63
; FirstLine = 21
; Folding = -
; EnableXP