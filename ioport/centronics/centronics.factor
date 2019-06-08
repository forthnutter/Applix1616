! Copyright (C) 2016 Joseph Moschini.  a.k.a. forthnutter
! See http://factorcode.org/license.txt for BSD license.
!
USING: accessors kernel math math.bitwise math.order math.parser
      freescale.binfile tools.continuations models models.memory
      prettyprint sequences freescale.68000.emulator byte-arrays
      applix.ram namespaces arrays
      ;

IN: applix.ioport.centronics

TUPLE: centronics < model ;


: centronics-read ( address centronics -- seq )
  break [ drop ] dip value>> 1array ;

: centronics-write ( seq address centronics -- )
  break [ drop first ] dip set-model ;

: <centronics> ( value -- centronics )
  centronics new-model ;
