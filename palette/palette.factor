! Copyright (C) 2016 Joseph Moschini.  a.k.a. forthnutter
! See http://factorcode.org/license.txt for BSD license.
!
USING: accessors kernel math math.bitwise math.order math.parser
      freescale.binfile tools.continuations models models.memory
      prettyprint sequences freescale.68000.emulator byte-arrays
      applix.ram namespaces
      ;

IN: applix.palette

TUPLE: palette array ;


: palette-read ( n address paletter -- seq )
    drop drop drop { 0 } ;


: palette-write ( seq address palette -- )
  drop drop drop ;

: <palette> ( -- palette )
    palette new ;
