! Copyright (C) 2016 Joseph Moschini.  a.k.a. forthnutter
! See http://factorcode.org/license.txt for BSD license.
!
USING: accessors kernel math math.bitwise math.order math.parser
      freescale.binfile tools.continuations models models.memory
      prettyprint sequences freescale.68000.emulator byte-arrays
      applix.ram namespaces arrays
      ;

IN: applix.vidlatch

TUPLE: vidlatch < model ;


: vidlatch-read ( address vidlatch -- data )
  break [ drop ] dip value>> 1array ;

: vidlatch-write ( n address vidlatch -- )
  break [ drop ] dip set-model ;

: <vidlatch> ( value -- vidlatch )
  vidlatch new-model ;
