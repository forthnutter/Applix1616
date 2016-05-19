!
USING: accessors kernel math math.bitwise math.order math.parser
      freescale.binfile tools.continuations models models.memory
      prettyprint sequences freescale.68000.emulator
      ;

IN: applix

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

: rom-write ( d address rom -- )
    drop drop drop ;

M: rom model-changed
    break
    ! see if data is true to write false to read
    swap ?memory-data
    [
       ! 0 0  rom-write
    ]
    [
       ! rom-read
    ] if 
    drop drop
 ;


: <rom> ( array start -- rom-read )
    rom new swap
    >>start  ! save start address
    swap >>array ! save the array
    f >>reset ! reset latch for rom mirror
    f >>error
;

! lets make the program start here
: applix ( -- cpu )
    <cpu>
    "work/applix/A1616OSV045.bin" <binfile> 0 <rom> memory-add ;


!  0 swap <mblock> <cpu> [ memory>> memory-add-block ] keep ;


