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


: palette-read ( n address rom -- data )
    [ port-between ] 2keep
    rot
    [
        [ dup [ + ] dip swap ] dip
        ! here we need to zero base the address to do indexing
        [ [ drop ] dip port-index ] 2keep [ port-index ] keep
        array>> subseq
    ]
    [ drop drop drop f ] if ;


: <palette> ( -- palette )
    centronics new ;
