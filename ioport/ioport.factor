! Copyright (C) 2016 Joseph Moschini.  a.k.a. forthnutter
! See http://factorcode.org/license.txt for BSD license.
!
USING: accessors kernel math math.bitwise math.order math.parser
      freescale.binfile tools.continuations models arrays
      sequences freescale.68000.emulator byte-arrays quotations
      applix.centronics applix.pallette namespaces ascii words
      applix.ioport.dac applix.ioport.vlatch ;

IN: applix.ioport

! IO decoder
! $0060 0000 PALLETTE (WO) Pallette 0
! $0060 0020 PALLETTE (WO) Pallette 1
! $0060 0040 PALLETTE (WO) Pallette 2
! $0060 0060 PALLETTE (WO) Pallette 3
! $0060 0001 CENTRONICS (WO)
! $0060 0081 DAC (WO)
! $0060 0101 VIDLATCH (WO)
! $0060 0181 AMUX  (WO)

TUPLE: ioport reset readmap writemap riport dac pallette cent vlatch ;

!
: (ioread-0) ( n address ioport -- array )
  break
  [ dup 0 bit? ] dip swap ! test A0 odd or even
  [ centronics-read ] [ pallette>> pallette-read ] if ;

!
: (ioread-1) ( n address ioport -- array )
  break
  drop drop drop { 1 } ;

!
: (ioread-2) ( n address ioport -- array )
  break
  drop drop drop { 2 } ;

!
: (ioread-3) ( n address ioport -- array )
  break
  drop drop drop { 3 } ;

: (ioread-bad) ( n address ioport -- array )
  drop drop drop { 4 } ;

! generate the read map for vpa
: ioport-readmap ( vpa -- array )
  readmap>> dup
  [
    [ drop ] dip
    [
      >hex >upper
      "(ioread-" swap append ")" append
      "applix.ioport" lookup-word 1quotation
    ] keep
    [ swap ] dip swap [ set-nth ] keep
  ] each-index ;

! $00600000 PALETTE and $00600001 CENTRONICS
: (iowrite-0) ( seq address ioport -- )
  break [ dup 0 bit? ] dip swap ! get A0 to see if we are even or odd.
  [ centronics-write ] [ pallette>> pallette-write ] if ;

! $00600081 DAC
: (iowrite-1) ( seq address ioport -- )
  break [ first ] 2dip [ drop ] dip dac>> dac-write ;

! $00600101 VIDLATCH
: (iowrite-2) ( seq address ioport -- )
  break
  drop drop drop ;

! $00600181 AMUX
: (iowrite-3) ( seq address ioport -- )
  break
  drop drop drop ;

: (iowrite-bad) ( seq address port -- )
  drop drop drop ;

! generate the write map for VPA
: ioport-writemap ( ioport -- array )
  writemap>> dup
  [
    [ drop ] dip
    [
      >hex >upper
      "(iowrite-" swap append ")" append
      "applix.ioport" lookup-word 1quotation
    ] keep
    [ swap ] dip swap [ set-nth ] keep
  ] each-index ;


: ioport-read ( n address ioport -- data )
  break [ [ 6 0 bit-range ] [ 8 7 bit-range ] bi ] dip
  [ readmap>> nth ] keep swap
  call( n address applix -- seq ) ;

: ioport-write ( seq address ioport -- )
  break [ [ 6 0 bit-range ] [ 8 7 bit-range ] bi ] dip
  [ writemap>> nth ] keep swap
  call( n aaddress applix -- ) ;

: <ioport> ( -- ioport )
  ioport new
  4 [ (ioread-bad) ] <array> >>readmap
  [ ioport-readmap ] keep swap >>readmap
  4 [ (iowrite-bad) ] <array> >>writemap
  [ ioport-writemap ] keep swap >>writemap
  0 >>riport
  0 <dac> >>dac
  <pallette> >>pallette
  0 <vlatch> >>vlatch ;
