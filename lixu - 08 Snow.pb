;Lixu - Snow (Test Emiter & Scrolling)

IncludeFile "lixu.pbi"

UsePNGImageDecoder()

InitSprite()
InitKeyboard()

OpenWindow(0, 0, 0, 800, 600, "Snow Test", #PB_Window_SystemMenu|#PB_Window_ScreenCentered)
OpenWindowedScreen(WindowID(0), 0, 0, 800, 600)

;Load SpriteScroll :Background (Background1, Background2)  & foreground (Background3)
Background1 = lixu::ScrollSpriteCreate(#PB_Any, "assets/image/parallax13.png") 
Background2 = lixu::ScrollSpriteCreate(#PB_Any, "assets/image/parallax12.png",0,0,255,0,0,2,0)
Background3 = lixu::ScrollSpriteCreate(#PB_Any, "assets/image/parallax0.png",0,0,255,0,0,2,0)

;Load Sprite Player
Player = LoadSprite(#PB_Any, "assets/image/dude.png", #PB_Sprite_AlphaBlending)

;Player Add animations
lixu::SpriteAddAnimation(Player, "Left", 0, 3, 32, 48, 100)
lixu::SpriteAddAnimation(Player, "Wait", 4, 4, 32, 48, 0)
lixu::SpriteAddAnimation(Player, "Right", 5, 8, 32, 48, 100)
lixu::SpriteSetAnimation(Player, "Wait")

;Load particle image
Flake = LoadSprite(#PB_Any, "assets/image/star_particle.png", #PB_Sprite_AlphaBlending )

;Create emitter
lixu::EmitterCreate("snow", #PB_Particle_Box, Flake, 1600, 600)
lixu::ParticleSpeedRange("snow", 0, 1, 0, 5)
lixu::ParticleSizeRange("snow", 2, 32)
lixu::ParticleRotateRange("snow", -2, 2) 
lixu::ParticleColorsRange("snow", RGB(255, 255, 255), RGB(220, 220, 220), 20)
lixu::ParticleRate("snow", 150)
lixu::ParticleTimeToLife("snow", 300) 

BackGround1X.f = 0
BackGround2X.f = 0
BackGround3X.f = 0

Quit = #False  
PlayerX = 500

Repeat
  Repeat
    Event = WindowEvent()
    If Event = #PB_Event_CloseWindow : Quit = #True : EndIf
  Until Event = 0
  
  ExamineKeyboard()
  
  ClearScreen(RGB(0,0,0))
  
  BackGround1X = 0
  BackGround2X = 0
  BackGround3X = 0
  
  If KeyboardPushed(#PB_Key_Left)
    lixu::SpriteSetAnimation(Player, "Left")
    PlayerX - 2
    If PlayerX < 200
      PlayerX + 2
      lixu::EmitterScroll("snow", 2, 0)
      BackGround1X = -0.8
      BackGround2X = -1
      BackGround3X = -1.4
    EndIf
    
        
  ElseIf  KeyboardPushed(#PB_Key_Right)
    lixu::SpriteSetAnimation(Player, "Right")
    PlayerX + 2
    If PlayerX > 600
      PlayerX - 2
      lixu::EmitterScroll("snow", -2, 0)
      BackGround1X = 0.8
      BackGround2X = 1
      BackGround3X = 1.4
    EndIf
        
  Else
    lixu::SpriteSetAnimation(Player, "Wait")
    
  EndIf
  
  ;Scroll background
  lixu::ScrollSpriteUpdate(Background1, 0, 0, BackGround1X, 0)
  lixu::ScrollSpriteUpdate(Background2, 0, 280, BackGround2X, 0)
  
  ;Display player
  DisplayTransparentSprite(Player, PlayerX, 500)
  lixu::SpriteUpdateAnimation(Player)
  
  ;Scroll foreground
  lixu::ScrollSpriteUpdate(Background3, 0, WindowHeight(0)-SpriteHeight(Background3), BackGround3X, 0)
    
  ;Play emitter
  lixu::EmitterPlay("snow", -200, 0)
  
  FlipBuffers()

Until Quit
; IDE Options = PureBasic 5.42 LTS (Windows - x86)
; CursorPosition = 27
; Folding = -
; EnableXP