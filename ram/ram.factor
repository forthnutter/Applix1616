USING: accessors kernel math math.bitwise math.order math.parser
      freescale.binfile tools.continuations models models.memory
      prettyprint sequences
      ;

IN: applix.ram

TUPLE: ram array start error ;

: ram-start ( ram -- start )
    start>> ;

: ram-array ( ram -- array )
    array>> ;

: ram-size ( ram -- size )
    ram-array length ;

: ram-end ( ram -- end )
    [ ram-start ] keep
    ram-size + ;

: ram-error ( ram -- ram )
    t >>error ;

! test the address is within rom start and end address
: ram-between ( address ram -- ? )
    [ ram-start ] [ ram-end ] bi between? ;


! read number of bytes at address from ram
: ram-read ( n address ram -- data )
    [ ram-between ] 2keep
    rot
    [
        [ swap ] dip [ dup + ] 2dip
        array>> subseq
    ]
    [ drop drop drop f ] if ;


M: ram model-changed
    [ dup memory-address ] dip ! get the focus address
    [ ram-between ] keep swap
    [
        ! see if data is true to write false to read
        [ memory-write? ] dip swap
        [
            [ dup memory-address ] dip [ dup memory-nbytes ] 2dip
            ram-read ! >>data
            drop drop
        ]
        [
            [ dup memory-address ] dip [ dup memory-nbytes ] 2dip
            ram-read >>data drop
        ] if
    ]
    [
        drop drop
    ] if
 ;



: <ram> ( array start -- ram )
    ram new swap
    >>start  ! save start address
    swap >>array ! save the array
    f >>error
;
