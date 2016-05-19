!
USING: accessors kernel math math.bitwise math.order math.parser
      freescale.binfile tools.continuations models models.memory
      prettyprint sequences freescale.68000.emulator byte-arrays
      applix.ram namespaces
      ;

IN: applix

SYMBOL: saveram

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

    
: rom-read ( address rom -- data )
    2 dup rom-between
    [ ] [ ] if
    
    drop
    ;


M: rom model-changed
    break
    ! see if data is true to write false to read
    swap ?memory-data
    [
        [ dup reset>> ] dip swap
        [
            saveram get swap [ remove-connection ] keep
            0x30000 <byte-array> 0 <ram> memory-add drop
            drop
        ]
        [ drop drop ] if
    ]
    [
        drop drop
       ! rom-read
    ] if 
 ;


: <rom> ( array start -- rom-read )
    rom new swap
    >>start  ! save start address
    swap >>array ! save the array
    t >>reset ! reset latch for rom mirror
    f >>error
;

! lets make the program start here
: applix ( -- cpu )
    <cpu>
    "work/applix/A1616OSV045.bin" <binfile>
    [ 0 <ram> dup saveram set memory-add ] [ 0x500000 <rom> memory-add ] bi ;


!  0 swap <mblock> <cpu> [ memory>> memory-add-block ] keep ;


