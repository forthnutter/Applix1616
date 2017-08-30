! Copyright (C) 2016 Joseph Moschini.  a.k.a. forthnutter
! See http://factorcode.org/license.txt for BSD license.
!
USING: accessors kernel math math.bitwise math.order math.parser
      freescale.binfile tools.continuations models
      sequences freescale.68000.emulator byte-arrays
      applix.ram namespaces
      ;

IN: applix.ioport

TUPLE: ioport reset iomap ;

: ioport-read ( n address rom -- data )
  drop drop drop { 0 } ;


: <ioport> ( array -- ioport )
    ioport new ;
