! Copyright (C) 2016 Joseph Moschini.  a.k.a. forthnutter
! See http://factorcode.org/license.txt for BSD license.
! ***************************************
! simulate the Digital to Analog Latch on the applix

USING: accessors kernel math math.bitwise math.order math.parser
      freescale.binfile tools.continuations models arrays
      sequences freescale.68000.emulator byte-arrays quotations
      namespaces ascii words models ;

IN: applix.ioport.vlatch

TUPLE: vlatch < model ;


: vlatch-write ( value dac -- )

  [ vlatch? ] keep swap
  [ set-model ] [ drop drop ] if ;

: vlatch-read ( dac -- value )
  [ vlatch? ] keep swap
  [ value>> ] [ drop 0 ] if ;


: <vlatch> ( value -- dac )
  vlatch new-model ;
