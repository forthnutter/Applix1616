! Copyright (C) 2016 Joseph Moschini.  a.k.a. forthnutter
! See http://factorcode.org/license.txt for BSD license.
! ***************************************
! simulate the Digital to Analog Latch on the applix

USING: accessors kernel math math.bitwise math.order math.parser
      freescale.binfile tools.continuations arrays
      sequences freescale.68000.emulator byte-arrays quotations
      namespaces ascii words models ;

IN: applix.ioport.dac

TUPLE: dac < model ;


: dac-write ( seq adress dac -- )
  [ drop ] dip [ dac? ] keep swap
  [ [ first ] dip set-model ] [ drop drop ] if ;

: dac-read ( dac -- seq )
  [ dac? ] keep swap
  [ value>> 1array ] [ drop 0 ] if ;


: <dac> ( value -- dac )
  dac new-model ;
