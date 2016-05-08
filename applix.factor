!
USING: accessors kernel math math.bitwise math.order math.parser
      freescale.binfile tools.continuations models models.memory
      prettyprint
      ;

IN: applix


TUPLE: rom reset array start ;

M: rom model-changed
    break
    ! see if data is true to write false to read
    [ [ data>> ] keep swap ] dip swap
    [
        ! write mode t
        [ reset>> ] keep swap
    ]
    [
        
    ] if 
    . .  ;


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


