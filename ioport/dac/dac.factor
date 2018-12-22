! Copyright (C) 2016 Joseph Moschini.  a.k.a. forthnutter
! See http://factorcode.org/license.txt for BSD license.
! ***************************************
! simulate the Digital to Analog Latch on the applix

USING: accessors kernel math math.bitwise math.order math.parser
      freescale.binfile tools.continuations models arrays
      sequences freescale.68000.emulator byte-arrays quotations
      namespaces ascii words models ;

IN: applix.ioport.dac

TUPLE: dac < model ;


: dac-write ( value dac -- )

  [ dac? ] keep swap
  [ set-model ] [ drop drop ] if ;

: dac-read ( dac -- value )
  [ dac? ] keep swap
  [ value>> ] [ drop 0 ] if ;


: <dac> ( value -- dac )
  dac new-model ;
