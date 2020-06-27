USING: accessors kernel math math.bitwise math.order math.parser
      freescale.binfile tools.continuations models
      prettyprint sequences
      ;

IN: applix.ram

TUPLE: ram array error ;

: ram-array ( ram -- array )
    array>> ;

: ram-size ( ram -- size )
    ram-array length ;

: ram-error ( ram -- ram )
    t >>error ;


! read number of bytes at address from ram
: ram-read ( n address ram -- data )
    [ swap [ dup ] dip + ] dip
    array>> subseq ;

: ram-write ( seq address ram -- )
  [ dup length ] 2dip ! seq len address ram
  [ swap ] dip ! seq address len ram
  [ dup ] 2dip ! seq address address len ram
  [ + ] dip ! seq address aend ram
  [ array>> replace-slice ] keep array<< ;

: <ram> ( array -- ram )
    ram new
    swap >>array ! save the array
    f >>error ;
