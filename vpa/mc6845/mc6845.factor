! this the MC6845 ctrc from Motora
! we are attempting to emulate this device.

USING: kernel accessors sequences arrays ;

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
  address>> 1 <byte-array> ;

M: mc6845 write-address
  address<< ;

M: mc6845 read-data
[ address>> ] keep
data>> nth ;

M: mc6845 write-data
[ address>> ] keep
data>> set-nth ;



! read will allways return 1 byte in an array
! address bit 0 = 0 is data bit 0 = 1 is address register.
M: mc6845 read
  [ 0 bit? ] dip swap
  [ read-address  ]
  [ read-data ] if
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
