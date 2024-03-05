(define (make-real-metal filename outFilename outFillFilename)
  (let* 
    (
      ; Image Handler
      ( theImage 0 )
      ( width 0 )
      ( height 0 )
      ; Drawable Handler
      ( drawable1 0 )
      ( theDrawable 0 )
      ( drawableBk 0 )
      ( layername "" )
      ( imgtype 0 )
    )
    ; Get open and get Image ID of current file
    ( set! theImage
      ( car ( gimp-file-load RUN-NONINTERACTIVE 
        filename filename ) ) )
    (gimp-image-convert-rgb theImage)
    ; Get the drawable of the current file
    ( set! drawable1 (car (gimp-image-get-active-drawable theImage)))
    ; Execute the layerfx pattern overlay
    (script-fu-layerfx-pattern-overlay 
      theImage 
      drawable1 
      "Crack"
      31
      0 ; "Normal"
      0
    )
    ; Execute the layerfx bevel emboss
    ( script-fu-layerfx-bevel-emboss 
      theImage 
      drawable1 
      1 ; Inner Bevel
      2 
      0 ; Up
      2 
      0 
      85 
      30 
      0  ; Linear
      '(0 0 0)
      2  ; Multiply
      40 
      '(0 0 0)
      2  ; Multiply
      48 
      0 ; Linear
      0
      0
    )
    ; Execute the layerfx pattern overlay
    (script-fu-layerfx-stroke 
      theImage 
      drawable1 
      '(0 0 0)
      12
      15 ; "Darken Only"
      1
      0
      0
    )
    ; Get / set Drawable ID, need it for file save.
    ( set! theDrawable ( car 
      ( gimp-image-merge-visible-layers theImage 0 ) ) )
    ; Save file - gimp png format
    ( file-png-save RUN-NONINTERACTIVE
        theImage theDrawable outFilename outFilename 
        FALSE 9 FALSE FALSE FALSE FALSE FALSE )
    ; Save file with 
    ( set! width (car (gimp-image-width theImage)))
    ( set! height (car (gimp-image-height theImage)))
    ( set! drawableBk (car (gimp-layer-new theImage width height RGB-IMAGE "Bk" 100 LAYER-MODE-NORMAL-LEGACY)))
    ( gimp-context-set-background '(139 71 36) )
    ( gimp-drawable-fill drawableBk FILL-BACKGROUND )
    ;(gimp-image-insert-layer theImage theDrawable 0 0)
    (gimp-image-insert-layer theImage drawableBk 0 1)
    ( set! theDrawable ( car 
      ( gimp-image-merge-visible-layers theImage 0 ) ) )
    ; Save file - gimp extension-based format
    ( gimp-file-save RUN-NONINTERACTIVE theImage theDrawable outFillFilename "" )
    ; Cleanup
    ( gimp-image-delete theImage )
  )
)
(define (make-real-tran filename outFilename outFillFilename)
  (let* 
    (
      ; Image Handler
      ( theImage 0 )
      ( width 0 )
      ( height 0 )
      ; Drawable Handler
      ( drawable1 0 )
      ( theDrawable 0 )
      ( drawableBk 0 )
      ( layername "" )
      ( imgtype 0 )
    )
    ; Get open and get Image ID of current file
    ( set! theImage
      ( car ( gimp-file-load RUN-NONINTERACTIVE 
        filename filename ) ) )
    (gimp-image-convert-rgb theImage)
    ; Get the drawable of the current file
    ( set! drawable1 (car (gimp-image-get-active-drawable theImage)))
    ; Execute the layerfx pattern overlay
    (script-fu-layerfx-pattern-overlay 
      theImage 
      drawable1 
      "Crack"
      31
      0 ; "Normal"
      0
    )
    ; Execute the layerfx bevel emboss
    ( script-fu-layerfx-bevel-emboss 
      theImage 
      drawable1 
      1 ; Inner Bevel
      2 
      0 ; Up
      1 
      0 
      30 
      30 
      0  ; Linear
      '(0 0 0)
      2  ; Multiply
      40 
      '(0 0 0)
      2  ; Multiply
      48 
      0 ; Linear
      0
      0
    )
    ; Execute the layerfx pattern overlay
    (script-fu-layerfx-stroke 
      theImage 
      drawable1 
      '(0 0 0)
      12
      15 ; "Darken Only"
      1
      0
      0
    )
    ; Get / set Drawable ID, need it for file save.
    ( set! theDrawable ( car 
      ( gimp-image-merge-visible-layers theImage 0 ) ) )
    ; Save file - gimp png format
    ( file-png-save RUN-NONINTERACTIVE
        theImage theDrawable outFilename outFilename 
        FALSE 9 FALSE FALSE FALSE FALSE FALSE )
    ; Save file with 
    ( set! width (car (gimp-image-width theImage)))
    ( set! height (car (gimp-image-height theImage)))
    ( set! drawableBk (car (gimp-layer-new theImage width height RGB-IMAGE "Bk" 100 LAYER-MODE-NORMAL-LEGACY)))
    ( gimp-context-set-background '(139 71 36) )
    ( gimp-drawable-fill drawableBk FILL-BACKGROUND )
    ;(gimp-image-insert-layer theImage theDrawable 0 0)
    (gimp-image-insert-layer theImage drawableBk 0 1)
    ( set! theDrawable ( car 
      ( gimp-image-merge-visible-layers theImage 0 ) ) )
    ; Save file - gimp extension-based format
    ( gimp-file-save RUN-NONINTERACTIVE theImage theDrawable outFillFilename "" )
    ; Cleanup
    ( gimp-image-delete theImage )
  )
)
(define (make-real-final metFilename tranFilename outFilename)
  (let* 
    (
      ; Image Handler
      ( theImage 0 )
      ( width 0 )
      ( height 0 )
      ; Drawable Handler
      ( drawableMet 0 )
      ( drawableTran 0 )
      ( drawableBk 0 )
      ( theDrawable 0 )
    )
    ; *****
    ; Load all layers
    ( set! theImage
      ( car ( gimp-file-load RUN-NONINTERACTIVE 
        metFilename metFilename ) ) )
    ( set! width (car (gimp-image-width theImage)))
    ( set! height (car (gimp-image-height theImage)))
    ( set! drawableMet (car (gimp-image-get-active-drawable theImage)))
    ( set! drawableTran (car (gimp-file-load-layer RUN-NONINTERACTIVE theImage tranFilename)))
    ( set! drawableBk (car (gimp-layer-new theImage width height RGB-IMAGE "Bk" 100 LAYER-MODE-NORMAL-LEGACY)))
    ( gimp-context-set-background '(139 71 36) )
    ( gimp-drawable-fill drawableBk FILL-BACKGROUND )
    ; Order all layers
    ;(gimp-image-insert-layer theImage drawableMet 0 0)
    (gimp-image-insert-layer theImage drawableTran 0 1)
    (gimp-image-insert-layer theImage drawableBk 0 2)
    ; Save file - gimp png format
    ( set! theDrawable ( car 
      ( gimp-image-merge-visible-layers theImage 0 ) ) )
    ; Save file - gimp extension-based format
    ( gimp-file-save RUN-NONINTERACTIVE theImage theDrawable outFilename "" )
  )
  
)

