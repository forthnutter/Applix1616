! Copyright (C) 2016 Joseph Moschini. a.k.a. forthnutter
! See http://factorcode.org/license.txt for BSD license.
!

USING: accessors kernel math math.bitwise math.order math.parser
      freescale.binfile tools.continuations models models.memory models.clock
      prettyprint sequences freescale.68000.emulator byte-arrays
      applix.iport applix.ram applix.rom applix.port applix.vpa namespaces
      io freescale.68000 combinators ascii words quotations arrays ;

IN: applix

TUPLE: applix < clock mc68k memap ;


: applix-decode ( address -- quotation )
  23 20 bit-range
  {
    { [ dup 0 = ] [ drop \ ram ] }
    { [ dup 1 = ] [ drop \ ram ] }
    { [ dup 2 = ] [ drop \ ram ] }
    { [ dup 3 = ] [ drop \ ram ] }
    { [ dup 4 = ] [ drop \ ram ] }
    { [ dup 5 = ] [ drop \ rom ] }
    { [ dup 6 = ] [ drop \ port ] }
    { [ dup 7 = ] [ drop \ vpa ] }
    [ drop \ rom ]
  } cond ;



: mem-bad ( -- )
  ;


! generate the memory map here
: applix-memory ( applix -- array )
    memap>>
    [
          [ drop ] dip
          [
              >hex >upper
              "(memory-" swap append ")" append
              "applix" lookup-word 1quotation
          ] keep
          [ swap ] dip swap [ memap>> set-nth ] keep
    ] each-index drop ;

M: cpu read-byte
  break [ dup 23 20 bit-range ] dip drop drop drop ;


: <applix> ( -- applix )
    applix new-clock  ! applix has clock model
    16 [ mem-bad ] <array> >>memap
    ! now add 68000 CPU with ROM data
    <mc68k> >>mc68k dup mc68k>>
    "work/applix/A1616OSV045.bin" <binfile>
    0x500000 <rom> memory-add
    0 1byte-array 0x700081 <iport> memory-add drop ;

! just return the cpu so we can work with that
: applix-68000 ( applix -- mc68k )
    mc68k>> ;

: applix-reset ( cpu -- )
    drop ;

! display current registers
: x ( applix -- applix' )
  [ mc68k>> string-DX [ print ] each ] keep
  [ mc68k>> string-AX [ print ] each ] keep
  [ applix-68000 string-PC print ] keep ;

! execute single instruction
: s ( applix -- applix' )
    [ mc68k>> single-step ] keep ;

: sx ( applix -- applix' )
  [ s drop ] [ x ] bi ;
