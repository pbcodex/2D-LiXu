;Lixu - Flip Sprite

IncludeFile "lixu.pbi"

UseModule lixu

InitSprite()
InitKeyboard()
InitMouse()
UseJPEGImageDecoder()
UsePNGImageDecoder()

OpenWindow(0, 0, 0, 800, 600, "Test", #PB_Window_SystemMenu|#PB_Window_ScreenCentered)
OpenWindowedScreen(WindowID(0), 0, 0, 800, 600)

;Load Background
Background = LoadSprite(#PB_Any, "Assets/image/blur1.jpg", #PB_Sprite_AlphaBlending)
ZoomSprite(Background, 800, 600)

;Load Danil
Danil = LoadSprite(#PB_Any, "Assets/image/danil_base.png", #PB_Sprite_AlphaBlending)

;Danil Add animations
lixu::SpriteAddAnimation(Danil, "walk", 0, 11, 102, 135, 100)
lixu::SpriteAddAnimation(Danil, "wait", 14, 14, 102, 135, 100)

;Danil Shadow
DanilMirror = CopySprite(Danil, #PB_Any)
SpriteFlipHorizontal(DanilMirror)
lixu::SpriteColorFadeOut(DanilMirror, 10, 2)

;DanilMirror Add animations
lixu::SpriteAddAnimation(DanilMirror, "walk", 0, 11, 102, 135, 100)
lixu::SpriteAddAnimation(DanilMirror, "wait", 14, 14, 102, 135, 100)

DudeSpeed = 10

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
  
  ;Set animations
  If KeyboardPushed(#PB_Key_Left)
    lixu::SpriteSetAnimation(Danil, "walk")    
    lixu::SpriteSetAnimation(DanilMirror, "walk")
    DudeSpeed - 2
    
  ElseIf KeyboardPushed(#PB_Key_Right)
    lixu::SpriteSetAnimation(Danil, "walk")    
    lixu::SpriteSetAnimation(DanilMirror, "walk")
    DudeSpeed + 2
    
  Else
    lixu::SpriteSetAnimation(Danil, "wait")
    lixu::SpriteSetAnimation(DanilMirror, "wait")
  EndIf
  
  ;Play current animation
  lixu::SpriteUpdateAnimation(Danil)
  lixu::SpriteUpdateAnimation(DanilMirror)
  
  DisplayTransparentSprite(Danil, DudeSpeed, 300)
  DisplayTransparentSprite(DanilMirror, DudeSpeed, 440, 128)
  
  
  FlipBuffers()
  
Until KeyboardPushed(#PB_Key_Escape)
; IDE Options = PureBasic 5.42 LTS (Windows - x86)
; CursorPosition = 23
; FirstLine = 12
; Folding = -
; EnableXP