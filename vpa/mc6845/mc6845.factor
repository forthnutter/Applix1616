! this the MC6845 ctrc from Motora
! we are attempting to emulate this device.

USING: kernel accessors sequences arrays byte-arrays math ;

IN: applix.vpa.mc6845

TUPLE: mc6845 address data ;

GENERIC: reset ( mc6845 --  )
GENERIC: read ( n adrress mc6845 -- data )
GENERIC: read-address ( mc6845 -- address )
GENERIC: read-data ( mc6845 -- data )
GENERIC: write ( n address mc6845 -- )
GENERIC: write-address ( data mc6845 -- )
GENERIC: write-data ( data mc6845 -- )


! reset all registers a reset signal has happend
M: mc6845 reset
  0 >>address
  [ data>> ] keep swap
  [ drop 0 ] map data<<
;

M: mc6845 read-address
  address>> 1byte-array ;

M: mc6845 write-address
  address<< ;

M: mc6845 read-data
[ address>> ] keep
data>> nth 1byte-array ;

M: mc6845 write-data
[ address>> ] keep
data>> set-nth ;



! read will allways return 1 byte in an array
! address bit 0 = 0 is data bit 0 = 1 is address register.
M: mc6845 read
  [ drop ] 2dip   ! we don't use the n parameters
  [ 0 bit? ] dip swap  ! test to see if bit 0 of the address
  [ read-address ]   ! if addrees bit 0 is set just read address register
  [ read-data ] if      ! if bit is clear read the data from data register
  ;

M: mc6845 write
  [ 0 bit? ] dip swap
  [ write-address ]
  [ write-address ] if ;


! Create the tuple
: <mc6845> ( -- mc6845 )
  mc6845 new
  0 >>address
  17 <array> >>data ;


TUPLE: mc6845-gadget < gadget cpu quit? windowed? ;

! create the gui stuff
: <mc6845-gadget> ( cpu -- gadget )
  mc6845-gadget new
  swap >>cpu
  f >>quit? ;

! diamensions of the display
: mc6845-gadget pre-dim* drop { 640 480 } ;

! draw pixels to the screen
: mc6845-gadget draw-gadget*
  0 0 glRasterPos2i
  1.0 -1.0 glPixelZoom
  [ 640 480 GL_RGB GL_UNSIGNED_BYTE ] dip
  cpu>> bitmap>> glDrawPixels ;

CONSTANT: black {   0   0   0 }
CONSTANT: white { 255 255 255 }
CONSTANT: green {   0 255   0 }
CONSTANT: red   { 255   0   0 }
CONSTANT: blue  {   0   0 255 }


: addr>xy ( addr -- point )
  ! Convert video RAM address to base X Y value. point is a {x y}.
  0x2400 - ! n
  dup 0x1f bitand 8 * 255 swap - ! n y
  swap -5 shift swap 2array ;

: plot-bitmap-pixel ( bitmap point color -- )
  ! point is a {x y}. color is a {r g b}.
  set-bitmap-pixel ;

: get-point-color ( point -- color )
  ! Return the color to use for the given x/y position.
  first2
  {
    { [ dup 184 238 between? pick 0 223 between? and ] [ 2drop green ] }
    { [ dup 240 247 between? pick 16 133 between? and ] [ 2drop green ] }
    { [ dup 247 215 - 247 184 - between? pick 0 223 between? and ] [ 2drop red ] }
    [ 2drop white ]
  } cond ;

: plot-bitmap-bits ( bitmap point byte bit -- )
  ! point is a {x y}.
  [ first2 ] 2dip
  dup swapd -1 * shift 1 bitand 0 =
  [ - 2array ] dip
  [ black ] [ dup get-point-color ] if
  plot-bitmap-pixel ;

: do-bitmap-update ( bitmap value addr -- )
  addr>xy swap 8 <iota> [ plot-bitmap-bits ] with with with each ;


M: mc6845 update-video
  over 0x2400 >=
  [
      bitmap>> -rot do-bitmap-update
  ]
  [
      3drop
  ] if ;

: sync-frame ( micros -- micros )
  ! Sleep until the time for the next frame arrives.
  16,667 + system:nano-count - dup 0 >
  [ 1,000 * threads:sleep ] [ drop threads:yield ] if
  system:nano-count ;

: mc6845-process ( micros gadget -- )
  ! Run a space invaders gadget inside a
  ! concurrent process. Messages can be sent to
  ! signal key presses, etc.
  dup quit?>>
  [
    exit-openal 2drop
  ]
  [
    [ sync-frame ] dip
    {
      [ cpu>> gui-frame ]
      [ relayout-1 ]
      [ invaders-process ]
    } cleave
  ] if ;

M: mc6845-gadget graft*
      dup cpu>> init-sounds
      f >>quit?
      [ system:nano-count swap invaders-process ] curry
      "MC6845" threads:spawn drop ;

M: mc6845-gadget ungraft*
      t swap quit?<< ;
