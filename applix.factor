! Copyright (C) 2016 Joseph Moschini. a.k.a. forthnutter
! See http://factorcode.org/license.txt for BSD license.
!

USING: accessors kernel math math.bitwise math.order math.parser
      freescale.binfile tools.continuations models prettyprint
      sequences freescale.68000.emulator byte-arrays
      applix.iport applix.ram applix.rom applix.port applix.vpa namespaces
      io freescale.68000 freescale.68000.disassembler combinators
      ascii words quotations arrays ;

IN: applix

TUPLE: applix < cpu rom ram readmap writemap boot mnemo ;

: mem-bad ( -- )
  ;

: (read-0) ( n address applix -- seq )
  break dup boot>>
  [ rom>> rom-read ]
  [ ram>> ram-read ] if
  ;

: (read-1) ( -- )
  ;

: (read-2) ( -- )
  ;

: (read-3) ( -- )
  ;

: (read-4) ( -- )
  ;

: (read-5) ( n address applix -- seq )
  rom>> rom-read
  ;

: (read-6) ( -- )
  ;

: (read-7) ( -- )
  ;

: (read-8) ( -- )
  ;

: (read-9) ( -- )
  ;

: (read-A) ( -- )
  ;

: (read-B) ( -- )
  ;

: (read-C) ( -- )
  ;

: (read-D) ( -- )
  ;

: (read-E) ( -- )
  ;

: (read-F) ( -- )
  ;


! generate the memory map here
: applix-readmap ( applix -- array )
    readmap>> dup
    [
          [ drop ] dip
          [
              >hex >upper
              "(read-" swap append ")" append
              "applix" lookup-word 1quotation
          ] keep
          [ swap ] dip swap [ set-nth ] keep
    ] each-index ;

M: applix read-bytes
  [ [ 19 0 bit-range ] [ 23 20 bit-range ] bi ] dip
  [ readmap>> nth ] keep swap
  call( n address applix -- seq ) ;



! generate the memory map here
: applix-writemap ( applix -- array )
    writemap>> dup
    [
          [ drop ] dip
          [
              >hex >upper
              "(write-" swap append ")" append
              "applix" lookup-word 1quotation
          ] keep
          [ swap ] dip swap [ set-nth ] keep
    ] each-index ;

M: applix write-bytes
  [ [ 19 0 bit-range ] [ 23 20 bit-range ] bi ] dip
  [ writemap>> nth ] keep swap
  call( seq address applix -- ) ;



: <applix> ( -- applix )
    applix new-cpu ! create the tuple for applix
    ! memap is memory decoder
    16 [ mem-bad ] <array> >>readmap
    [ applix-readmap ] keep swap >>readmap
    16 [ mem-bad ] <array> >>writemap
    t >>boot    ! boot flag is used to indicate hard reset
    ! now add 68000 CPU
    <disassembler> >>mnemo
    ! build ROM with rom data
    "work/applix/A1616OSV045.bin" <binfile>
    <rom> >>rom
    512 <byte-array> >>ram
    ! 0 1byte-array 0x700081 <iport> memory-add drop
    ;


: applix-reset ( cpu -- )
    drop ;

! display current registers
: x ( applix -- applix' )
  [ string-DX [ print ] each ] keep
  [ string-AX [ print ] each ] keep
  [ string-PC print ] keep ;

! execute single instruction
: s ( applix -- applix' )
    [ single-step ] keep ;

: sx ( applix -- applix' )
  [ s drop ] [ x ] bi ;
