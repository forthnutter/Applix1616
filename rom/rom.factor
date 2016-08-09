!
USING: accessors kernel math math.bitwise math.order math.parser
      freescale.binfile tools.continuations models models.memory
      prettyprint sequences freescale.68000 freescale.68000.emulator byte-arrays
      applix.ram namespaces
      ;

IN: applix.rom

TUPLE: rom reset array start error ;

: rom-start ( rom -- start )
    start>> ;

: rom-array ( rom -- array )
    array>> ;

: rom-size ( rom -- size )
    rom-array length ;

: rom-end ( rom -- end )
    [ rom-start ] keep
    rom-size + ;

: rom-error ( rom -- rom )
    t >>error ;

! test the address is within rom start and end address
: rom-between ( address rom -- ? )
    [ rom-start ] [ rom-end ] bi between? ;

    
: rom-read ( n address rom -- data )
    [ rom-between ] 2keep
    rot
    [
        [ dup [ + ] dip swap ] dip
        array>> subseq
    ]
    [ drop drop drop f ] if ;



M: rom model-changed
    break
    [ memory-address ] dip ! go get that address
    [ rom-between ] keep swap
    [
        ! see if data is true to write false to read
        swap ?memory-data
        [
            break
            ! write to memory
            [ dup reset>> ] dip swap
            [
                [ f >>reset ] dip ! reset function complete
                [ 0x50000 >>start drop ] dip ! change rom address
                t >>data  ! if was ok 
                0x30000 <byte-array> 0 <ram> memory-add drop
            ]
            [
                drop drop
            ] if
        ]
        [
            swap [ memory-nbytes ] dip [ swap memory-address [ swap ] dip ] dip
            rom-read >>data drop
        ] if 
    ]
    [ drop drop ] if
 ;



: <rom> ( array start -- rom-read )
    rom new swap
    >>start  ! save start address
    swap >>array ! save the array
    t >>reset ! reset latch for rom mirror
    f >>error
;



