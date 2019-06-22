!
! The Applix 1616 has a 74LS374 8 bit latch
! D0 - D7
! D0 - U10 4051 A
! D1 - U10 4051 B
! D2 - U10 4051 C
! D3 - spare
! D4 - U23 4052 A
! D5 - U23 4052 B
! D6 - U23 4052 X-Y
! D7 - Casette Motor relay

USING: accessors kernel math math.bitwise math.order math.parser
      freescale.binfile tools.continuations models
      prettyprint sequences freescale.68000.emulator byte-arrays
      applix.ram namespaces arrays
      ;

IN: applix.ioport.amux

TUPLE: amux < model ;


: amux-read ( address amux -- seq )
  break [ drop ] dip value>> 1array ;


: amux-write ( seq address amux -- )
  [ drop first ] dip set-model ;

: <amux> ( value -- amux )
    amux new-model ;
