!
USING: accessors kernel math math.bitwise math.order math.parser
      freescale.binfile tools.continuations models models.memory
      prettyprint sequences
      ;

IN: applix


TUPLE: rom reset array start ;

: rom-start ( rom -- rom start )
    [  start>> ] keep swap ;

: rom-array ( rom -- rom array )
    [ array>> ] keep swap ;

: rom-size ( rom -- rom size )
    rom-array length ;

: rom-end ( rom -- rom end )
    rom-start
    [ rom-size ] dip + ;

M: rom model-changed
    break
    ! see if data is true to write false to read
    swap ?memory-data
    [
        ! write mode t
        [ reset>> ] keep swap
    ]
    [
        ! read mode
        swap [ memory-address ] dip swap
        [ rom-start ] dip swap
        [ rom-end ] dip swap
        [ between? ] dip
        
    ] if 
    . . . ;


: <rom> ( array start -- rom )
    rom new swap
    >>start  ! save start address
    swap >>array ! save the array
    f >>reset ! reset latch for rom mirror

;

! lets make the program start here
: applix ( -- cpu )
  "work/applix/A1616OSV045.bin" <binfile> 0 <rom> <memory> ;


!  0 swap <mblock> <cpu> [ memory>> memory-add-block ] keep ;


