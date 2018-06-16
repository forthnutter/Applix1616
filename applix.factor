! Copyright (C) 2016 Joseph Moschini. a.k.a. forthnutter
! See http://factorcode.org/license.txt for BSD license.
!

USING: accessors kernel math math.bitwise math.order math.parser
      freescale.binfile tools.continuations models prettyprint
      sequences freescale.68000.emulator byte-arrays
      applix.ioport applix.ram applix.rom namespaces
      io freescale.68000 freescale.68000.disassembler combinators
      ascii words quotations arrays applix.vpa ;

IN: applix

! TUPLE: applix < cpu rom ram readmap writemap boot vpa ioport ;

TUPLE: applix < M68000 rom ram readmap writemap boot vpa ioport ;

: mem-bad ( -- )
  ;

: (read-0) ( n address applix -- seq )
  dup boot>>
  [ rom>> rom-read ]
  [ ram>> ram-read ] if ;

: (read-1) ( n address applix -- seq )
  drop drop drop { 1 } ;

: (read-2) ( n address applix -- seq )
  drop drop drop { 2 } ;

: (read-3) ( n address applix -- seq )
  drop drop drop { 3 } ;

: (read-4) ( n address applix -- seq )
  drop drop drop { 4 } ;

: (read-5) ( n address applix -- seq )
  rom>> rom-read ;

: (read-6) ( n address applix -- seq )
  ioport>> ioport-read ;

: (read-7) ( n address applix -- seq )
  vpa>> vpa-read ;

: (read-8) ( n address applix -- seq )
  drop drop drop { 8 } ;

: (read-9) ( n address applix -- seq )
  drop drop drop { 9 } ;

: (read-A) ( n address applix -- seq )
  drop drop drop { 10 } ;

: (read-B) ( n address applix -- seq )
  drop drop drop { 11 } ;

: (read-C) ( n address applix -- seq )
  drop drop drop { 12 } ;

: (read-D) ( n address applix -- seq )
  drop drop drop { 13 } ;

: (read-E) ( n address applix -- seq )
  drop drop drop { 14 } ;

: (read-F) ( n address applix -- seq )
  drop drop drop { 15 } ;


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

! at zero we allways write to ram
: (write-0) ( seq address applix -- )
  ram>> ram-write ;

: (write-1) ( seq address applix -- )
  drop drop drop ;

: (write-2) ( seq address applix -- )
  drop drop drop ;

: (write-3) ( seq address applix -- )
  drop drop drop ;

: (write-4) ( seq address applix -- )
  drop drop drop ;

! writing to ROM clears the boot flag so we can read ram
: (write-5) ( seq address applix -- )
  f >>boot drop drop drop ;

: (write-6) ( seq address applix -- )
  ioport>> ioport-write ;

: (write-7) ( seq address applix -- )
  vpa>> vpa-write ;

: (write-8) ( seq address applix -- )
  drop drop drop ;

: (write-9) ( seq address applix -- )
  drop drop drop ;

: (write-A) ( seq address applix -- )
  drop drop drop ;

: (write-B) ( seq address applix -- )
  drop drop drop ;

: (write-C) ( seq address applix -- )
  drop drop drop ;

: (write-D) ( seq address applix -- )
  drop drop drop ;

: (write-E) ( seq address applix -- )
  drop drop drop ;

: (write-F) ( seq address applix -- )
  drop drop drop ;

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
    applix new-68000 ! create the tuple for applix
    ! memap is memory decoder
    16 [ mem-bad ] <array> >>readmap
    [ applix-readmap ] keep swap >>readmap
    16 [ mem-bad ] <array> >>writemap
    [ applix-writemap ] keep swap >>writemap
    t >>boot    ! boot flag is used to indicate hard reset
    ! <disassembler> >>mnemo
    ! build ROM with rom data
    "work/applix/A1616OSV045.bin" <binfile>
    <rom> >>rom
    512 <byte-array> >>ram  ! add some ram
    <vpa> >>vpa ! vpa decoder
    <ioport> >>ioport ;


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

! list off instruction
: l ( applix address -- applix' )
  [ dup 16 swap ] dip swap list-mnemonic-dump
  [ print ] each ;

! help list
: h ( -- )
  V{ } clone
  [ "l ( applix address -- applix ) list 16 lines instructions" swap push ] keep
  [ "s ( applix -- applix ) Single Step" swap push ] keep
  [ "sx ( applix -- applix ) Single Step and Display Registers" swap push ] keep
  [ "x ( applix -- applix ) Display all registers" swap push ] keep
  [ print ] each
  ;
