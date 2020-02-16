! Copyright (C) 2016 Joseph Moschini.  a.k.a. forthnutter
! See http://factorcode.org/license.txt for BSD license.
!
USING: accessors kernel math math.bitwise math.order math.parser
      freescale.binfile tools.continuations models
      prettyprint sequences freescale.68000.emulator byte-arrays
      applix.ram namespaces
      ;

IN: applix.riport

TUPLE: riport data ;





: riport-read ( iport -- data )
  data>> ;



: <riport> ( -- iport )
    riport new
    0x80 >>data ;
