! this the MC6845 ctrc from Motora
! we are attempting to emulate this device.

USING: kernel accessors sequences arrays ;

IN: applix.vpa.mc6845

TUPLE: mc6845 address data ;

GENERIC: reset ( mc6845 --  )
GENERIC: read ( n adrress mc6845 -- data )
GENERIC: read-address ( mc6845 -- address )
GENERIC: read-data ( mc6845 -- data )

! reset all registers a reset signal has happend
M: mc6845 reset
  0 >>address
  [ data>> ] keep swap
  [ drop 0 ] map data<<
;

M: mc6845 read-address
  address>> 1 <byte-array> ;


! read will allways return 1 byte in an array
! address bit 0 = 0 is data bit 0 = 1 is address register.
M: mc6845 read
  [ 0 bit? ] dip swap
  [ read-address  ]
  [ read-data ] if
  ;


! Create the tuple
: <mc6845> ( -- mc6845 )
  mc6845 new
  0 >>address
  17 <array> >>data ;
