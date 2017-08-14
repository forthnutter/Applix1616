! Copyright (C) 2016 Joseph Moschini. a.k.a. forthnutter
! See http://factorcode.org/license.txt for BSD license.
!

USING: accessors kernel math math.bitwise math.order math.parser
      freescale.binfile tools.continuations models models.memory models.clock
      prettyprint sequences freescale.68000.emulator byte-arrays
      applix.iport applix.ram applix.rom applix.port applix.vpa namespaces
      io freescale.68000 combinators ascii words quotations arrays ;

IN: applix

TUPLE: applix < clock mc68k rom ram memap ;


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

: (memory-0) ( -- )
  ;

: (memory-1) ( -- )
  ;

: (memory-2) ( -- )
  ;

: (memory-3) ( -- )
  ;

: (memory-4) ( -- )
  ;

: (memory-5) ( -- )
  ;

: (memory-6) ( -- )
  ;

: (memory-7) ( -- )
  ;

: (memory-8) ( -- )
  ;

: (memory-9) ( -- )
  ;

: (memory-A) ( -- )
  ;

: (memory-B) ( -- )
  ;

: (memory-C) ( -- )
  ;

: (memory-D) ( -- )
  ;

: (memory-E) ( -- )
  ;

: (memory-F) ( -- )
  ;


! generate the memory map here
: applix-memory ( applix -- array )
    memap>> dup
    [
          [ drop ] dip
          [
              >hex >upper
              "(memory-" swap append ")" append
              "applix" lookup-word 1quotation
          ] keep
          [ swap ] dip swap [ set-nth ] keep
    ] each-index ;

M: cpu read-byte
  break [ dup 23 20 bit-range ] dip drop drop drop ;


: <applix> ( -- applix )
    applix new-clock  ! applix has clock model
    ! memap is memory decoder
    16 [ mem-bad ] <array> >>memap
    [ applix-memory ] keep swap >>memap
    ! now add 68000 CPU
    <mc68k> >>mc68k
    ! build ROM with rom data
    "work/applix/A1616OSV045.bin" <binfile>
    <rom> >>rom ;
    ! 0 1byte-array 0x700081 <iport> memory-add drop ;

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
