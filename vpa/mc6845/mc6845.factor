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


TUPLE: m6845-gadget < gadget cpu quit? windowed? ;

: <m6845-gadget> ( cpu -- gadget )
  m6845-gadget new
  swap >>cpu
  f >>quit? ;
  
