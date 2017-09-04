! Copyright (C) 2016 Joseph Moschini.  a.k.a. forthnutter
! See http://factorcode.org/license.txt for BSD license.
!
USING: accessors kernel math math.bitwise math.order math.parser
      freescale.binfile tools.continuations models models.memory
      prettyprint sequences freescale.68000.emulator byte-arrays
      applix.ram namespaces
      ;

IN: applix.centronics

TUPLE: centronics data ;


: centronics-read ( n address centronics -- data )
  drop drop drop { 0 } ;

: centronics-write ( n address centronics -- )
  drop drop drop ;

: <centronics> ( -- centronics )
    centronics new ;
