! Copyright (C) 2016 Joseph Moschini.  a.k.a. forthnutter
! See http://factorcode.org/license.txt for BSD license.
!
USING: accessors kernel math math.bitwise math.order math.parser
      freescale.binfile tools.continuations models models.memory
      prettyprint sequences freescale.68000 freescale.68000.emulator byte-arrays
      applix.ram namespaces
      ;

IN: applix.rom

TUPLE: rom reset array start error ;

: rom-start ( rom -- start )
    start>> ;

: rom-array ( rom -- array )
    array>> ;

: rom-size ( rom -- size )
    rom-array length ;

: rom-end ( rom -- end )
    [ rom-start ] keep
    rom-size + ;

: rom-error ( rom -- rom )
    t >>error ;

! test the address is within rom start and end address
: rom-between ( address rom -- ? )
    [ rom-start ] [ rom-end ] bi between? ;


: rom-index ( address rom -- index )
    rom-start - ;

: rom-read ( n address rom -- data )
    [ rom-between ] 2keep
    rot
    [
        [ dup [ + ] dip swap ] dip
        ! here we need to zero base the address to do indexing
        [ [ drop ] dip rom-index ] 2keep [ rom-index ] keep
        array>> subseq
    ]
    [ drop drop drop f ] if ;

: rom-reset-mode ( cpu rom -- )
  [ memory-write? ] dip swap
  [
    ! write to memory
    f >>reset   ! rom does not need reset anymore
    [ t >>data ] dip
    [ 0x30000 <byte-array> 0 <ram> memory-add ] dip
    drop drop
  ]
  [
    [ dup memory-address ] dip
    [ rom-between ] keep swap
    [
      [ dup memory-nbytes-address ] dip
      ! [ memory-address ] dip [ memory-nbytes ] 2dip
      rom-read >>data memory-ok
    ]
    [
      [ dup memory-nbytes-address ] dip
      ! [ memory-address ] dip [ memory-nbytes ] 2dip
      [ start>> + ] keep rom-read >>data memory-ok
    ] if
  ] if ;

M: rom model-changed
  break
  [ dup err>> ] dip swap
  [
    [ reset>> ] keep swap
    [ rom-reset-mode ]
    [
      [ dup memory-address ] dip  ! go get that address
      [ rom-between ] keep swap
      [
        ! test if memory data
        [ memory-write? ] dip swap
        [ drop t >>data memory-ok ]  ! write does nothing
        [
          [ dup memory-nbytes-address ] dip
          rom-read >>data memory-ok
        ] if
      ]
      [ drop drop ] if
    ] if
  ]
  [ drop drop ] if ;



: <rom> ( array start -- rom-read )
    rom new swap
    >>start  ! save start address
    swap >>array ! save the array
    t >>reset ! reset latch for rom mirror
    f >>error
;
