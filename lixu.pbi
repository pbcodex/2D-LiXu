;EnableExplicit

; Lixu 1.6
;
; Creator      : falsam
; Contributors : Blendman, Rings
; Create       : 01 Jun 2015
; Update       : 01 Jul 2015

DeclareModule Lixu  
    
  Enumeration ; blendmode
    #BM_Normal
    #BM_Multiply
    #BM_Add
  EndEnumeration
  
  
  Declare FPS()
  ;Sprite
  Declare SceneAddSprite(sprite,file$,CenterX=0,CenterY=0,alpha=255,BM=0,color=$FFFFFF)
  Declare SpriteSetXY(sprite, x, y)
  Declare SpriteDraw(sprite, x=0, y=0)
  Declare SpriteFlipHorizontal(Sprite)
  Declare SpriteFlipVertical(Sprite)
  Declare SpriteColorGrayScale(Sprite)
  Declare SpriteColorFadeOut(Sprite, Offset.b, Intensity.b)
  
  ; Animation
  Declare SetSpriteSheet(Sprite, x, y, Width, Height)
  Declare SpriteAddAnimation(Sprite, Animation.s, FirstImage, LastImage, FrameWidth, FrameHeight, FrameRate)
  Declare SpriteSetAnimation(Sprite, Animation.s)
  Declare SpriteUpdateAnimation(Sprite)
  
  ;Particule
  Declare EmitterCreate(Emitter.s, Type = #PB_Particle_Box, Sprite = #PB_Ignore, Width=#PB_Ignore, Height=#PB_Ignore)
  Declare ParticleSpeedRange(Emitter.s, vx1.f, vy1.f, vx2.f=#PB_Ignore, vy2.f=#PB_Ignore)
  Declare ParticleRate(Emitter.s, Rate)
  Declare ParticleTimeToLife(Emitter.s, LifeTime)
  Declare ParticleSizeRange(Emitter.s, Minimum.f, Maximum.f = #PB_Ignore)
  Declare ParticleRotateRange(Emitter.s, Minimum.f, Maximum.f = #PB_Ignore)
  Declare ParticleColorsRange(ParticleEmitter.s, Color1, Color2=#PB_Ignore, NumberOfcolor=1)
  Declare EmitterPlay(Emitter.s, x = 0, y = 0, Loop = #True)
  Declare EmitterScroll(Emitter.s, x, y)
  Declare EmitterActif(Emitter.s, Flag.b = #False) ;(Not operationel)
  
  ;Camera
  Declare CameraMove(x.f, y.f) ;(Not operationel)
  
  ;Scrolling
  Declare ScrollSpriteCreate(Sprite, File$, CenterX=0, CenterY=0, Alpha=255, BM=0, Color=0, RepeatX=2,RepeatY=2)
  Declare ScrollSpriteUpdate(Sprite, x, y, StepX.f, StepY.f, Opacity=255)
    
EndDeclareModule

Module lixu
  ;- Private   
  
  ; Sprite
  Structure Sprite
    
    Sprite.i 
    ; Position and size
    Width.i
    Height.i
    PositionX.f
    PositionY.f
    
    ; Center (hotspot)
    CenterX.w
    CenterY.w
    
    ; blendmode
    BM.a
    blend1.a
    blend2.a
    
    ; Color & alpha
    Alpha.a
    Color.i
    
    ;Camera
    CameraFollow.b
    
  EndStructure
  
  ;Animation - Animation Structure
  Structure Animation
    Sprite.i
    Name.s
    
    ClipX.i
    ClipY.i
    ClipWidth.i    
    ClipHeight.i   

    FirstImage.i
    LastImage.i
    FrameWidth.i               
    FrameHeight.i
    FrameRate.i     
            
    ;HFlip.b
  EndStructure

  ;-Animation - Setup
  Structure NewSprite Extends Sprite
    
    Map Animations.Animation()
    
    CurrentAnimation.s
    CurrentFrame.i
    FrameTimeLife.i
    
  EndStructure 
  
  Global NewMap Sprites.NewSprite()
  
  
  ;Particle - Particle Structure     
  Structure NewParticle
    Actif.i 
    Sprite.i
    x.f  
    y.f
    vx.f
    vy.f
        
    Size.i
    Rotate.f
    
    Color.i
        
    Opacity.i
    LifeTime.i
    
  EndStructure
  
  ;Particle - Colorset 
  Structure NewColorSet
    Color.i
  EndStructure
  
  ;Particle - Range 
  Structure NewRange
    Minimum.f
    Maximum.f
  EndStructure

  ;-Particle - Emitter setup
  Structure NewEmitter    
    Actif.b
    
    Sprite.i
    Type.i ;#PB_Particle_Box ou #PB_Particle_Point
    
    x.i
    y.i
    
    Width.i
    Height.i
    
    Rate.i
    LifeTime.i
    
    vx.NewRange
    vy.NewRange
    
    Size.NewRange
    
    Rotate.NewRange
    
    Color.NewRange
    
    List ColorSet.NewColorSet()
    
    List Particle.Newparticle()
    
    Loop.b ;Not operational
  EndStructure
  
  Global NewMap Emitters.NewEmitter()
  
  
  ;-Scrolling - Setup
  Structure Scrolling Extends Sprite
    RepeatX.a
    RepeatY.a
  EndStructure
  Global NewMap Scrolling.Scrolling()
  
  
  Procedure RandomSign()
    ProcedureReturn Random(1)*2-1
  EndProcedure
  
  Procedure.f RandomFloat(Maximum.f, Minimum.f)
    If Maximum < Minimum
      Swap Maximum, Minimum
    EndIf
  
    ProcedureReturn (Minimum+ValF("0."+Str(Random(999)))*(Abs(Maximum-Minimum)))  
  EndProcedure  
   
  Procedure UpdateEmitter(Emitter.s, Rate)
    Protected n, NumberOfcolor.i
    
    NumberOfcolor = ListSize(Emitters()\ColorSet())
    
    ClearList(Emitters()\Particle())
    
    With Emitters()\Particle()
      For n=0 To Rate
        AddElement(Emitters()\Particle())
        
        \Sprite = CopySprite(Emitters()\Sprite, #PB_Any)
        
        If Emitters()\Type = #PB_Particle_Box
          \x = 0 
          \y = 0 
        Else
          \x = #PB_Ignore
          \y = #PB_Ignore 
        EndIf
        
        \vx = RandomFloat(Emitters()\vx\Maximum, Emitters()\vx\Minimum)
        \vy = RandomFloat(Emitters()\vy\Maximum, Emitters()\vy\Minimum)
        \Size = Random(Emitters()\Size\Maximum, Emitters()\Size\Minimum)
        \Rotate = RandomFloat(Emitters()\Rotate\Maximum, Emitters()\Rotate\Minimum)
        
        ;Color random
        SelectElement(Emitters()\ColorSet(), Random(NumberOfcolor-1))
        
        ;Particle color
        \Color = Emitters()\ColorSet()\Color 
        
        ;Reset Lifetime of the particle
        \LifeTime = 0 
        
        \Opacity = 255
        
        \Actif = #True
      Next
    EndWith 
  EndProcedure
  
  ;-
  ;-Public 
  ;-
  
  ;-Public FPS
  Procedure FPS()
    Shared s, fps
    ss=Second(Date())
  
    fps+1
  
    If s<>ss
      s=ss
      fps=0
    EndIf
    ProcedureReturn fps
  EndProcedure

 
  ;-Public Sprite
  Procedure SceneAddSprite(Sprite, File$, CenterX=0, CenterY=0, Alpha=255, BM=0, Color=$FFFFFF)
      
    If sprite = #PB_Any
      Sprite = LoadSprite(#PB_Any, file$, #PB_Sprite_AlphaBlending)
      sp = Sprite
    Else
      sp = LoadSprite(Sprite, File$, #PB_Sprite_AlphaBlending)
    EndIf
    
    If sp = 0
      MessageRequester("Error","Unable to load the sprite, the image exist ? "+ File$)
      End
    EndIf
       
    If Not FindMapElement(Sprites(), Str(Sprite))
      AddMapElement(Sprites(), Str(Sprite))
      
      With Sprites()
        
        \Sprite = Sprite
        \Alpha = Alpha
        \BM = BM
        Select BM
          Case #Bm_normal
            \blend1 = #PB_Sprite_BlendSourceAlpha 
            \blend2 = #PB_Sprite_BlendInvertSourceAlpha
          Case #BM_Add
            \blend1 = 1
            \blend2 = 1
          Case #BM_Multiply
            \blend1 = 4
            \blend2 = 0            
        EndSelect
        
        \CenterX = CenterX
        \CenterY = CenterY
        
        \Width  = SpriteWidth(Sprite)
        \Height = SpriteHeight(Sprite)
        \color = Color
        \CameraFollow = #True
      EndWith
    EndIf
    
    ProcedureReturn Sprite
  EndProcedure
  
  Procedure SpriteSetXY(sprite, x, y)
    
    If FindMapElement(Sprites(), Str(Sprite))      
      With Sprites()
        \PositionX = x
        \PositionY = y     
      EndWith
    EndIf

  EndProcedure
  
  Procedure SpriteDraw(Sprite, x=0, y=0)
    
    If FindMapElement(Sprites(), Str(Sprite))
      With Sprites()        
        SpriteBlendingMode(\blend1,\blend2)
        DisplayTransparentSprite(\Sprite,\PositionX+x+\CenterX, \PositionY+y+\CenterY,\Alpha)
        SpriteBlendingMode(#PB_Sprite_BlendSourceAlpha, #PB_Sprite_BlendInvertSourceAlpha)
      EndWith
    EndIf    
    
  EndProcedure
  
  
  Procedure SpriteFlipHorizontal(Sprite)
    Protected IW, IH, Buffer, Pitch, *pxData1.long, *pxData2.long, lines, mem
    StartDrawing(SpriteOutput(Sprite))
    IW = SpriteWidth(Sprite)
    IH = SpriteHeight(Sprite)
    Buffer = DrawingBuffer()             ; Get the start address of the screen buffer
    Pitch  = DrawingBufferPitch()        ; Get the length (in byte) took by one horizontal line
 
    *pxData1 = Buffer
    *pxData2 = *pxData1 + (IH-1)*Pitch

    mem = AllocateMemory(Pitch)
    For lines=0 To IH/2-1
      CopyMemory(*pxData1, mem,pitch)
      CopyMemory(*pxData2, *pxData1, pitch)
      CopyMemory(mem, *pxData2, pitch)
      *pxData1 + pitch
      *pxData2 - pitch
    Next
    StopDrawing()
    If mem: FreeMemory(mem):EndIf
  EndProcedure
  
  Procedure SpriteFlipVertical(Sprite) 
    Protected IW, IH, Buffer, Pitch, *pxData1.long, *pxData2.long, PixelFormat, ByteOffset, lines, t, m
    
    StartDrawing(SpriteOutput(Sprite))
    IW = SpriteWidth(Sprite)
    IH = SpriteHeight(Sprite)
    Buffer = DrawingBuffer()             ; Get the start address of the screen buffer
    Pitch  = DrawingBufferPitch()        ; Get the length (in byte) took by one horizontal line
 
    *pxData1 = Buffer
    *pxData2 = *pxData1 + (IH-1)*Pitch
    PixelFormat=DrawingBufferPixelFormat()
    ByteOffset=4
    Select PixelFormat
      Case   #PB_PixelFormat_8Bits     ; 1 Byte pro Pixel, mit Palette ("palettized")
        ByteOffset=1
      Case #PB_PixelFormat_15Bits      ; 2 Byte pro Pixel
        ByteOffset=2
      Case #PB_PixelFormat_16Bits      ; 2 Byte pro Pixel
        ByteOffset=2
      Case #PB_PixelFormat_24Bits_RGB  ; 3 Byte pro Pixel (RRGGBB)
        ByteOffset=3
      Case #PB_PixelFormat_24Bits_BGR  ; 3 Byte pro Pixel (BBGGRR)
        ByteOffset=3
      Case #PB_PixelFormat_32Bits_RGB  ; 4 Byte pro Pixel (RRGGBB)
        ByteOffset=4
      Case #PB_PixelFormat_32Bits_BGR  ; 4 Byte pro Pixel (BBGGRR)
        ByteOffset=4
    EndSelect

    For Lines=0 To IH-1
      *pxData1 = Buffer + (Lines*pitch)
      *pxData2 = *pxData1 + pitch-4
      For t=0 To (IW/2)-1
        m=*pxData1\l
        *pxData1\l=*pxData2\l
        *pxData2\l=m
        *pxData1 + ByteOffset
        *pxData2 - ByteOffset
       Next
    Next
    StopDrawing()
 
  EndProcedure
  
  
  Procedure SpriteColorFadeOut(Sprite, Offset.b, Intensity.b)
  
    Protected IW, IH, Buffer, Pitch, *pxData1.long, *pxData2.long, PixelFormat, ByteOffset, f, lines, t, m, p, r, g, b
  
    StartDrawing(SpriteOutput(Sprite))
    IW = SpriteWidth(Sprite)
    IH = SpriteHeight(Sprite)
  
    Buffer      = DrawingBuffer()             ; Get the start address of the screen buffer
    Pitch       = DrawingBufferPitch()        ; Get the length (in byte) took by one horizontal line
    PixelFormat = DrawingBufferPixelFormat()
  
    *pxData1 = Buffer
    *pxData2 = *pxData1 + (IH-1) * Pitch
    
    Select PixelFormat
      Case #PB_PixelFormat_8Bits       ; 1 Byte pro Pixel, mit Palette ("palettized")
        ByteOffset=1
      Case #PB_PixelFormat_15Bits      ; 2 Byte pro Pixel
        ByteOffset=2
      Case #PB_PixelFormat_16Bits      ; 2 Byte pro Pixel
        ByteOffset=2
      Case #PB_PixelFormat_24Bits_RGB  ; 3 Byte pro Pixel (RRGGBB)
        ByteOffset=3
      Case #PB_PixelFormat_24Bits_BGR  ; 3 Byte pro Pixel (BBGGRR)
        ByteOffset=3
      Case #PB_PixelFormat_32Bits_RGB  ; 4 Byte pro Pixel (RRGGBB)
        ByteOffset=4
      Case #PB_PixelFormat_32Bits_BGR  ; 4 Byte pro Pixel (BBGGRR)
        ByteOffset=4
      Default
        ByteOffset=4
    EndSelect
  
    f = Offset
  
    For Lines=0 To IH-1
      *pxData1 = Buffer + (Lines*pitch)
      f + Intensity
    
      For t=0 To IW-1
        m = *pxData1\l
      
        Select Pixelformat
          Case #PB_PixelFormat_16Bits
            Debug "Geht noch nicht"
          
          Case #PB_PixelFormat_24Bits_BGR,#PB_PixelFormat_32Bits_BGR  ; 4 Byte pro Pixel (BBGGRR)
          
            p=m >> 24 & $FF ;the additive alpha
            r= m >> 16 & $FF
            g= m >> 8 & $FF
            b= m  & $FF
          
            If r > f : r - f : Else : r = 0 : EndIf
            If g > f : g - f : Else : g = 0 : EndIf
            If b > f : b - f : Else : b = 0 : EndIf
          
            ;gray=((r*29)+(g*58)+(b*11))/100
            m=   b | g << 8 | r << 16 | p << 24
          
          Case #PB_PixelFormat_24Bits_RGB,#PB_PixelFormat_32Bits_RGB
            p=m >> 24 & $FF ;the additive alpha
            b= m >> 16 & $FF
            g= m >> 8 & $FF
            r= m  & $FF
          
            If r > f : r - f : Else : r = 0 : EndIf
            If g > f : g - f : Else : g = 0 : EndIf
            If b > f : b - f : Else : b = 0 : EndIf
        
            ;gray=((r*29)+(g*58)+(b*11))/100
            m=  r | g << 8 | b << 16 | p << 24
          
        EndSelect
      
        *pxData1\l=m
        *pxData1 + ByteOffset
      Next
    Next
    StopDrawing()
  
  EndProcedure
  
  Procedure SpriteColorGrayScale(Sprite)
    Protected IW, IH, Buffer, Pitch, *pxData1.long, PixelFormat, ByteOffset, lines, t, m, p, r, g, b
    
    If IsSprite(Sprite)=0:ProcedureReturn 0:EndIf
    
      StartDrawing(SpriteOutput(Sprite))
      IW = SpriteWidth(Sprite)
      IH = SpriteHeight(Sprite)
      Buffer      = DrawingBuffer()             ; Get the start address of the screen buffer
      Pitch       = DrawingBufferPitch()        ; Get the length (in byte) took by one horizontal line
      *pxData1.LONG 
      PixelFormat=DrawingBufferPixelFormat() 
 
      Select PixelFormat  
        Case   #PB_PixelFormat_8Bits       ; 1 Byte pro Pixel, mit Palette ("palettized")
          ByteOffset=1
        Case #PB_PixelFormat_15Bits      ; 2 Byte pro Pixel
          ByteOffset=2
        Case #PB_PixelFormat_16Bits      ; 2 Byte pro Pixel
          ByteOffset=2
        Case #PB_PixelFormat_24Bits_RGB  ; 3 Byte pro Pixel (RRGGBB)
          ByteOffset=3
        Case #PB_PixelFormat_24Bits_BGR  ; 3 Byte pro Pixel (BBGGRR)
          ByteOffset=3
        Case #PB_PixelFormat_32Bits_RGB  ; 4 Byte pro Pixel (RRGGBB)
          ByteOffset=4
        Case #PB_PixelFormat_32Bits_BGR  ; 4 Byte pro Pixel (BBGGRR)
          ByteOffset=4
      EndSelect

      For Lines=0 To IH-1
        *pxData1 = Buffer + (Lines*pitch)
        For t=0 To IW-1
        m=*pxData1\l
  
        Select Pixelformat  
          Case #PB_PixelFormat_16Bits

          Case #PB_PixelFormat_24Bits_BGR,#PB_PixelFormat_32Bits_BGR  ; 4 Byte pro Pixel (BBGGRR)
            p=m >> 24 & $FF ;the additive alpha
            r= m >> 16 & $FF
            g= m >> 8 & $FF
            b= m  & $FF 
            gray=((r*29)+(g*58)+(b*11))/100
            m=gray | gray << 8 | gray << 16 | p << 24

          Case #PB_PixelFormat_24Bits_RGB,#PB_PixelFormat_32Bits_RGB
            p=m >> 24 & $FF ;the additive alpha
            b= m >> 16 & $FF
            g= m >> 8 & $FF
            r= m  & $FF 
            gray=((r*29)+(g*58)+(b*11))/100
            m= gray | gray << 8 | gray << 16 | p << 24

        EndSelect
     
        *pxData1\l=m
        *pxData1 + ByteOffset
        Next
      Next
      StopDrawing()
  EndProcedure  
  
  
  ;-
  ;-Public Sprite Animation
  Procedure SetSpriteSheet(Sprite, x, y, Width, Height)
    If FindMapElement(Sprites(), Str(Sprite))
      Sprites()\Animations()\ClipX = x
      Sprites()\Animations()\ClipY = y
      Sprites()\Animations()\ClipWidth = Width
      Sprites()\Animations()\ClipHeight = Height
    EndIf
  EndProcedure
  
  Procedure SpriteAddAnimation(Sprite, Animation.s, FirstImage, LastImage, FrameWidth, FrameHeight, FrameRate)
    
    If Not FindMapElement(Sprites(), Str(Sprite))
      AddMapElement(Sprites(), Str(Sprite))
      Sprites()\Sprite = Sprite
    EndIf
    
    AddMapElement(Sprites()\Animations(), Animation)
    With Sprites()\Animations()
      \Sprite = Sprite           
      \Name = Animation
      \FirstImage = FirstImage
      \LastImage = LastImage
      \FrameWidth = FrameWidth
      \FrameHeight = FrameHeight
      \FrameRate = FrameRate
      \ClipWidth = SpriteWidth(Sprite)
      \ClipHeight = SpriteHeight(Sprite)
    EndWith
  EndProcedure
    
  Procedure SpriteSetAnimation(Sprite, Animation.s)
    If FindMapElement(Sprites(), Str(Sprite))
    
      If Sprites()\CurrentAnimation <> Animation
        FindMapElement(Sprites()\Animations(), Animation)      
            
        Sprites()\CurrentAnimation = Animation
        Sprites()\CurrentFrame = Sprites()\Animations()\FirstImage
      
        Sprites()\FrameTimeLife = 0
      EndIf 
    EndIf
  EndProcedure  
    
  Procedure SpriteUpdateAnimation(Sprite)
    Protected x, y
    Protected ipr ;Images per row
        
    If FindMapElement(Sprites(), Str(Sprite))
      
      If ElapsedMilliseconds() - Sprites()\FrameTimeLife >= Sprites()\Animations()\FrameRate 
        
        Sprites()\FrameTimeLife = ElapsedMilliseconds()
        
        FindMapElement(Sprites()\Animations(), Sprites()\CurrentAnimation)
                
                
        ;Number of images per row
        ipr = Sprites()\Animations()\ClipWidth / Sprites()\Animations()\FrameWidth
        
        ;Clipping start position
        x = Sprites()\CurrentFrame * Sprites()\Animations()\FrameWidth - Sprites()\Animations()\ClipWidth * Round(Sprites()\CurrentFrame / ipr, #PB_Round_Down)
        y = Sprites()\CurrentFrame / ipr * Sprites()\Animations()\FrameHeight  
                
        ClipSprite(Sprites()\Sprite,                    ;Num sprite 
                   x + Sprites()\Animations()\ClipX,    ;Clip X 
                   y + Sprites()\Animations()\ClipY,    ;Clip y
                   Sprites()\Animations()\FrameWidth,   ;Frame Width
                   Sprites()\Animations()\FrameHeight)  ;Frame height  
        
        ;Next image
        Sprites()\CurrentFrame + 1
        
        If Sprites()\CurrentFrame > Sprites()\Animations()\LastImage
          Sprites()\CurrentFrame = Sprites()\Animations()\FirstImage
        EndIf
                  
      EndIf
    EndIf 
  EndProcedure
  
  ;-
  ;-Public Particle
  Procedure EmitterCreate(Emitter.s, Type = #PB_Particle_Box, Sprite = #PB_Ignore, Width=#PB_Ignore, Height=#PB_Ignore)
    Protected n
    
    ;Creating the default sprite if inexistent
    If Sprite = #PB_Ignore
      Sprite = CreateSprite(#PB_Any, 30, 30, #PB_Sprite_AlphaBlending)
      StartDrawing(SpriteOutput(Sprite))
      DrawingMode(8)
      Box(0,0,32,32,RGBA(0,0,0,0))
      DrawingMode(16)
      Circle(16,16,5,RGBA(255,255,255,80))
      Circle(16,16,2,RGBA(255,255,255,255))
      StopDrawing()
    EndIf
    
    If Width = #PB_Ignore
      Width = ScreenWidth() 
    EndIf
    
    If Height = #PB_Ignore
      Height = ScreenHeight()
    EndIf
    
    ;Add emitter
    AddMapElement(Emitters(), Emitter)
    With Emitters()
      \Sprite = Sprite
      \Type = Type ;#PB_Particle_Box or #PB_Particle_Point or #PB_Ignore
      \x = 0
      \y = 0
      \Size\Minimum = 15 
      \Size\Maximum = 15
      \Width = Width
      \Height = Height
      \Rate = 50
      \LifeTime = 50
      If \type = #PB_Particle_Box Or #PB_Ignore
        \vy\Minimum = Random(10, 5)
        \vy\Maximum = Random(10, 5)
      Else
        \vy\Minimum = Random(10, 5) * -1
        \vy\Maximum = Random(10, 5) * -1    
      EndIf
      
      \Color\Minimum = RGB(255, 0, 0)
      \Color\Maximum = RGB(255, 0, 0)
           
      ;Create ColorsSet
      AddElement(\ColorSet())
      \ColorSet()\Color = RGB(255, 0, 0)
      
      ;Update emitter
      UpdateEmitter(Emitter, \Rate)
      
      \Actif = #True
    EndWith
    
  EndProcedure
    
  Procedure ParticleRate(Emitter.s, Rate)    
    FindMapElement(Emitters(), Emitter)
    Emitters()\Rate = Rate
    UpdateEmitter(Emitter, Rate)
  EndProcedure
    
  Procedure ParticleTimeToLife(Emitter.s, LifeTime)
    FindMapElement(Emitters(), Emitter)
    Emitters()\LifeTime = LifeTime
    UpdateEmitter(Emitter, Emitters()\Rate)    
  EndProcedure
      
  Procedure ParticleSpeedRange(Emitter.s, vx1.f, vy1.f, vx2.f=#PB_Ignore, vy2.f=#PB_Ignore)
    If vx2 = #PB_Ignore
      vx2 = vx1
    EndIf
    
    If vy2 = #PB_Ignore
      vy2 = vy1
    EndIf
    
    FindMapElement(Emitters(), Emitter)
    
    Emitters()\vx\Minimum = vx1
    Emitters()\vx\Maximum = vx2
    
    Emitters()\vy\Minimum = vy1
    Emitters()\vy\Maximum = vy2
    
    ForEach Emitters()\Particle()      
      Emitters()\Particle()\vx = RandomFloat(Emitters()\vx\Maximum, Emitters()\vx\Minimum)
      Emitters()\Particle()\vy = RandomFloat(Emitters()\vy\Maximum, Emitters()\vy\Minimum)
    Next
  EndProcedure  
  
  Procedure ParticleSizeRange(Emitter.s, Minimum.f, Maximum.f = #PB_Ignore)
    If Maximum = #PB_Ignore
      Maximum = Minimum
    EndIf
    
    FindMapElement(Emitters(), Emitter)
    Emitters()\Size\Maximum = Maximum
    Emitters()\Size\Minimum = Minimum
    
    ForEach Emitters()\Particle()
      Emitters()\Particle()\Size = Random(Emitters()\Size\Maximum, Emitters()\Size\Minimum)
    Next    
  EndProcedure
  
  Procedure ParticleRotateRange(Emitter.s, Minimum.f, Maximum.f = #PB_Ignore)
    If Maximum = #PB_Ignore
      Maximum = Minimum
    EndIf
    
    FindMapElement(Emitters(), Emitter)
    Emitters()\Rotate\Minimum = Minimum
    Emitters()\Rotate\Maximum = Maximum
        
    ForEach Emitters()\Particle()
      Emitters()\Particle()\Rotate = RandomFloat(Emitters()\Rotate\Maximum, Emitters()\Rotate\Minimum)
    Next    
 
  EndProcedure
  
  ;Changes the particles color range for the particle emitter
  Procedure ParticleColorsRange(ParticleEmitter.s, Color1, Color2=#PB_Ignore, NumberOfcolor=1)
    Protected r1, g1, b1
    Protected r2, g2, b2
    Protected dr, dg, db
    
    If Color2 = #PB_Ignore 
      Color2 = Color1
    EndIf
        
    ;Start color
    r1 = Red(Color1)
    g1 = Green(Color1)
    b1 = Blue(Color1)
    
    ;Finish color
    r2 = Red(Color2)
    g2 = Green(Color2)
    b2 = Blue(Color2)
    
    ;For each channel, calculating the differenciated between each hue (NumberOfColor is the number of tones).
    dr = Int((r2 - r1) / NumberOfcolor)
    dg = Int((g2 - g1) / NumberOfcolor)
    db = Int((b2 - b1) / NumberOfcolor)
    
    ;Creation of the color spectrum
    FindMapElement(Emitters(), ParticleEmitter)
    
    ;Stores the minimum and maximum colors
    Emitters()\Color\Minimum = Color1
    Emitters()\Color\Maximum = Color2
    
    ClearList(Emitters()\ColorSet())
    For i = 0 To NumberOfcolor - 1
      r2 = r2 - dr
      g2 = g2 - dg
      b2 = b2 - db
      
      AddElement(Emitters()\ColorSet())
      Emitters()\ColorSet()\Color = RGB(r2, g2, b2)
    Next   
    
    ;For each particle, assign a color
    ForEach Emitters()\Particle()
      SelectElement(Emitters()\ColorSet(), Random(NumberOfcolor-1))
      Emitters()\Particle()\Color = Emitters()\ColorSet()\Color
    Next    

  EndProcedure
    
  Procedure EmitterPlay(Emitter.s, x = 0, y = 0, Loop = #True)
    Protected Actif = #False
    
    If FindMapElement(Emitters(), Emitter)
      
      ForEach Emitters()\Particle()
      
        With Emitters()\Particle()        
          If \LifeTime <= 0 And \Actif = #True
            If Loop = #False
              \Actif = #False
            EndIf
            
            \LifeTime = Random(Emitters()\LifeTime) 
            \Opacity = 255
            
            If Emitters()\Type = #PB_Particle_Box
              \x = Random(Emitters()\Width) + x
              \y = y 
              
            ElseIf Emitters()\Type = #PB_Particle_Point
              \x = x
              \y = y 
              
            Else              
              \x = Random(Emitters()\Width) - Random(Emitters()\Width) 
              \y = Random(Emitters()\Height) - Random(Emitters()\Height)
            EndIf
          EndIf
        
          \x + \vx
          \y + \vy 
        
          If \LifeTime > 0
            Actif = #True
            
            If \LifetIme < 30 And \Opacity > 0
              \Opacity - 1
            EndIf
            
            ZoomSprite(\Sprite, \Size, \Size)
            RotateSprite(\Sprite, \Rotate, #PB_Relative)
            DisplayTransparentSprite(\Sprite, \x , \y , \Opacity, \Color)
          EndIf 
        
          \LifeTime - 1
        
        EndWith
      Next
      
      Emitters()\Actif = Actif
    EndIf  
  EndProcedure
  
  Procedure EmitterScroll(Emitter.s, x, y)
    If FindMapElement(Emitters(), Emitter)
      ForEach(Emitters()\Particle())
        With Emitters()\Particle()
          \x + x
          \y + y
        EndWith
      Next
    EndIf
  EndProcedure
    
  Procedure EmitterActif(Emitter.s, Flag.b = #False) ;(Not operationel)
    If FindMapElement(Emitters(), Emitter)
      If Flag = #True
        ForEach Emitters()\Particle()
          With Emitters()\Particle()
            \Actif = #True
          EndWith
        Next
        Emitters()\Actif = #True
      EndIf
    EndIf
    ProcedureReturn Emitters()\Actif
  EndProcedure
  
  ;-
  ;- Public Camera (Not operationel)
  Procedure CameraMove(x.f, y.f) 
    ForEach(Emitters())
      With Emitters()
        If \Type = #PB_Particle_Point
          \x = x
          \y = y
          
          ForEach(\Particle())
            \Particle()\x + x
            \Particle()\y + y
          Next
        Else
          ForEach(\Particle())
            \Particle()\x + x
            \Particle()\y + y
          Next  
        EndIf
      EndWith
    Next
    
    ForEach(Sprites())
      With Sprites()
        If \CameraFollow = #True
          \PositionX + x
          \PositionY + y
        EndIf
      EndWith
    Next  
  EndProcedure
  
  ;-  
  ;-Public - Scrolling
  Procedure ScrollSpriteCreate(Sprite, File$, CenterX=0, CenterY=0, Alpha=255, BM=0,color=0, RepeatX=2, RepeatY=2)
    
    If sprite = #PB_Any
      Sprite = LoadSprite(#PB_Any, File$, #PB_Sprite_AlphaBlending)
      sp = sprite
    Else
      sp = LoadSprite(sprite, File$, #PB_Sprite_AlphaBlending)
    EndIf
    
    If sp = 0
      MessageRequester("Error","Unable to load the sprite, the image exist ? "+file$)
      End
    EndIf
    
    If Not FindMapElement(Scrolling(), Str(Sprite))
      AddMapElement(Scrolling(), Str(Sprite))
      With Scrolling()
        \Sprite  = Sprite
        \Width   = SpriteWidth(Sprite)
        \Height  = SpriteHeight(Sprite)
        \Alpha   = Alpha
        \RepeatX = RepeatX
        \RepeatY = RepeatY
        \BM = BM
        Select Bm 
          Case 0; #Bm_normal
            \blend1 = #PB_Sprite_BlendSourceAlpha 
            \blend2 = #PB_Sprite_BlendInvertSourceAlpha
          Case 1; #BM_Add
            \blend1 = 1
            \blend2 = 1
          Case 2; #BM_Multiply
            \blend1 = 4
            \blend2 = 0            
        EndSelect
        
        \CenterX = CenterX
        \CenterY = CenterY      
        \color   = Color
      EndWith
    EndIf
    
    ProcedureReturn sprite 
  EndProcedure
  
  
  Procedure ScrollSpriteUpdate(Sprite, x, y, StepX.f, StepY.f, Opacity=255)
    
    Protected sx, sy
    
    FindMapElement(Scrolling(), Str(Sprite))
    
    Scrolling()\PositionX + StepX
    Scrolling()\PositionY + StepY
  
    If Scrolling()\PositionX > Scrolling()\Width
      Scrolling()\PositionX = 0
    EndIf
  
    If Scrolling()\PositionX < 0 
      Scrolling()\PositionX = Scrolling()\Width
    EndIf
  
    If Scrolling()\PositionY > Scrolling()\Height
      Scrolling()\PositionY = 0
    EndIf
  
    If Scrolling()\PositionY < 0
      Scrolling()\PositionY = Scrolling()\Height
    EndIf
    
    For sx=0 To Scrolling()\RepeatX
      For sy=0 To Scrolling()\RepeatY
        SpriteBlendingMode(Scrolling()\blend1,Scrolling()\blend2)
        DisplayTransparentSprite(Scrolling()\Sprite, x + Scrolling()\Width * sx - Scrolling()\PositionX, y + Scrolling()\Height * sy - Scrolling()\PositionY, Opacity)
        SpriteBlendingMode(#PB_Sprite_BlendSourceAlpha, #PB_Sprite_BlendInvertSourceAlpha)
      Next
    Next
    
  EndProcedure 
  
EndModule
; IDE Options = PureBasic 5.42 LTS (Windows - x86)
; CursorPosition = 266
; FirstLine = 263
; Folding = --------------
; EnableXP