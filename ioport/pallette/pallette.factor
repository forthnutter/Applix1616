! Copyright (C) 2016 Joseph Moschini.  a.k.a. forthnutter
! See http://factorcode.org/license.txt for BSD license.
!
! The Applix 1616 has a 74LS670 Addressable Resister Two Bit read Address
! and Two bir writre address.
! Could called a very small memory.
! The 68000 has the ability to write to registers but cannot read data back.

USING: accessors kernel math math.bitwise math.order math.parser
      freescale.binfile tools.continuations models
      prettyprint sequences freescale.68000.emulator byte-arrays
      applix.ram namespaces arrays
      ;

IN: applix.ioport.pallette

TUPLE: pallette array ;


: pallette-read ( address paletter -- seq )
  [ 6 5 bit-range ] dip array>> nth 1array ;


: pallette-write ( seq address palette -- )
  [
    6 5 bit-range
    [ first 4 bits ] dip
  ] dip array>> set-nth ;

: <pallette> ( -- palette )
    pallette new
    { 0 1 2 3 } >>array ;
