! this the MC6845 ctrc from Motora
! we are attempting to emulate this device.

USING: kernel accessors sequences arrays ;

IN: applix.vpa.mc6845

TUPLE: mc6845 address data ;

GENERIC: reset ( mc6845 --  )
GENERIC: read ( n adrress mc6845 -- data )

! reset all registers a reset signal has happend
M: mc6845 reset
  [ data>> ] keep swap
  [ drop 0 ] map data<<
;


! read will allways return 1 byte in an array
M: mc6845 read
  ;


! Create the tuple
: <mc6845> ( -- mc6845 )
  mc6845 new
  17 <array> >>data ;
