! Copyright (C) 2016 Joseph Moschini.  a.k.a. forthnutter
! See http://factorcode.org/license.txt for BSD license.
!
USING: accessors kernel math math.bitwise math.order math.parser
      freescale.binfile tools.continuations
      prettyprint sequences freescale.68000.emulator byte-arrays
      namespaces ;

IN: applix.rom

TUPLE: rom array error ;

: rom-array ( rom -- array )
    array>> ;

: rom-size ( rom -- size )
    rom-array length ;

: rom-error ( rom -- rom )
    t >>error ;

: rom-read ( n address rom -- data )
    [ swap [ dup ] dip + ] dip
    array>> subseq ;



: <rom> ( array -- rom )
    rom new
    swap >>array ! save the array
    ;
