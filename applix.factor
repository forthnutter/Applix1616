! Copyright (C) 2016 Joseph Moschini. a.k.a. forthnutter
! See http://factorcode.org/license.txt for BSD license.
!

USING: accessors kernel math math.bitwise math.order math.parser
      freescale.binfile tools.continuations models models.memory models.clock
      prettyprint sequences freescale.68000 freescale.68000.emulator byte-arrays
      applix.ram applix.rom namespaces
      ;

IN: applix

SYMBOL: saveram

TUPLE: applix < clock cpu ;

: <applix> ( -- applix )
    applix new-clock  ! applix has clock model
    ! now add 68000 CPU with ROM data
    <cpu> "work/applix/A1616OSV045.bin" <binfile> dup
    [ 0 <rom> memory-add ] dip 0x500000 <rom> memory-add >>cpu ;
    

! just return the cpu so we can work with that
: applix-cpu ( applix -- cpu )
    cpu>> ;



: applix-reset ( cpu -- )
    drop ;

    
! execute single instruction
: applix-single ( applix -- applix' )
    [ cpu>> execute-cycle ] keep ;
    

! lets make the program start here
: applix1616 ( -- cpu )
    <cpu>
    "work/applix/A1616OSV045.bin" <binfile> dup
    [ 0 <rom> memory-add ] dip 0x500000 <rom> memory-add ;


