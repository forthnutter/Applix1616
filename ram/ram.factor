USING: accessors kernel math math.bitwise math.order math.parser
      freescale.binfile tools.continuations models models.memory
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


: <ram> ( array -- ram )
    ram new
    swap >>array ! save the array
    f >>error ;
