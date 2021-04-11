! Copyright (C) 2016 Joseph Moschini.  a.k.a. forthnutter
! See http://factorcode.org/license.txt for BSD license.
!
USING: accessors kernel math math.bitwise math.order math.parser
      freescale.binfile tools.continuations models
      prettyprint sequences freescale.68000.emulator byte-arrays
      namespaces ascii words quotations arrays applix applix.riport
      applix.vpa.mc6845 applix.reset ;

IN: applix.vpa

! VPA decoder
! $0070 0000 SCC
! $0070 0081 RIPORT
! $0070 0100 VIA Base
! $0070 0180 CRT Address Register

TUPLE: vpa readmap writemap riport m6845 ;

GENERIC: vpa ( applix -- )


! lets tell the ports to RESET
M: reset vpa
  drop ;



! SCC
: (vparead-0) ( n address cpu -- array )
  break
  drop drop drop { 0 } ;

! RIPORT
: (vparead-1) ( n address vpa -- array )
  break
  [ drop ] 2dip       ! do not need n
  [ 1 = ] dip swap    ! test addres for value of 1
  [ riport>> riport-read 1byte-array ] [ drop f ] if ;

! VIA
: (vparead-2) ( n address cpu -- array )
  break
  drop drop drop { 2 } ;

! CRT
: (vparead-3) ( n address cpu -- array )
  m6845>> read ;

: (vparead-bad) ( n address cpu -- array )
  drop drop drop { 4 } ;

! generate the read map for vpa
: vpa-readmap ( vpa -- array )
  readmap>> dup
  [
    [ drop ] dip
    [
      >hex >upper
      "(vparead-" swap append ")" append
      "applix.vpa" lookup-word 1quotation
    ] keep
    [ swap ] dip swap [ set-nth ] keep
  ] each-index ;

! SCC
: (vpawrite-0) ( seq address cpu -- )
  break
  drop drop drop ;

! RIPORT
: (vpawrite-1) ( seq address cpu -- )
  break
  drop drop drop ;

! VIA
: (vpawrite-2) ( seq address cpu -- )
  break
  drop drop drop ;

! CRT
: (vpawrite-3) ( seq address cpu -- )
  break
  drop drop drop ;

: (vpawrite-bad) ( seq address cpu -- )
  drop drop drop ;

! generate the write map for VPA
: vpa-writemap ( vpa -- array )
  writemap>> dup
  [
    [ drop ] dip
    [
      >hex >upper
      "(vpawrite-" swap append ")" append
      "applix.vpa" lookup-word 1quotation
    ] keep
    [ swap ] dip swap [ set-nth ] keep
  ] each-index ;


: vpa-read ( n address vpa -- data )
  [ [ 6 0 bit-range ] [ 8 7 bit-range ] bi ] dip
  [ readmap>> nth ] keep swap
  call( n address applix -- seq ) ;

: vpa-write ( seq address cpu -- )
  drop drop drop ;

: <vpa> ( -- vpa )
  vpa new
  4 [ (vparead-bad) ] <array> >>readmap
  [ vpa-readmap ] keep swap >>readmap
  4 [ (vpawrite-bad) ] <array> >>writemap
  [ vpa-writemap ] keep swap >>writemap
  <riport> >>riport ;
