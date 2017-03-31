! Copyright (C) 2016 Joseph Moschini. a.k.a. forthnutter
! See http://factorcode.org/license.txt for BSD license.
!

USING: accessors kernel math math.bitwise math.order math.parser
      freescale.binfile tools.continuations models models.memory models.clock
      prettyprint sequences freescale.68000.emulator byte-arrays
      applix.iport applix.ram applix.rom namespaces io freescale.68000 ;

IN: applix

TUPLE: applix < clock mc68k ;

: <applix> ( -- applix )
    applix new-clock  ! applix has clock model
    ! now add 68000 CPU with ROM data
    <mc68k> >>mc68k dup mc68k>> mc68k-emu
    "work/applix/A1616OSV045.bin" <binfile>
    0x500000 <rom> memory-add
    0 1byte-array 0x700081 <iport> memory-add drop ;

! just return the cpu so we can work with that
: applix-cpu ( applix -- cpu )
    cpu>> ;

: applix-reset ( cpu -- )
    drop ;

! display current registers
: x ( applix -- applix' )
  [ cpu>> string-DX [ print ] each ] keep
  [ cpu>> string-AX [ print ] each ] keep ;

! execute single instruction
: s ( applix -- applix' )
    [ cpu>> execute-cycle ] keep ;
