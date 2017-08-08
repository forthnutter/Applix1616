! Copyright (C) 2016 Joseph Moschini.  a.k.a. forthnutter
! See http://factorcode.org/license.txt for BSD license.
!
USING: accessors kernel math math.bitwise math.order math.parser
      freescale.binfile tools.continuations models models.memory
      prettyprint sequences freescale.68000.emulator byte-arrays
      applix.ram namespaces
      ;

IN: applix.vpa

TUPLE: vpa reset array start error ;

: vpa-start ( iport -- start )
    start>> ;

: vpa-array ( iport -- array )
    array>> ;

: vpa-size ( iport -- size )
    vpa-array length ;

: vpa-end ( iport -- end )
    [ vpa-start ] keep
    vpa-size + ;

: vpa-error ( iport -- rom )
    t >>error ;

! test the address is within rom start and end address
: vpa-between ( address rom -- ? )
    [ vpa-start ] [ vpa-end ] bi between? ;


: vpa-index ( address rom -- index )
    vpa-start - ;

: vpa-read ( n address rom -- data )
    [ vpa-between ] 2keep
    rot
    [
        [ dup [ + ] dip swap ] dip
        ! here we need to zero base the address to do indexing
        [ [ drop ] dip vpa-index ] 2keep [ vpa-index ] keep
        array>> subseq
    ]
    [ drop drop drop f ] if ;



M: vpa model-changed
  [ dup err>> ] dip swap   ! if err is false a memory has been read
  [
    [ reset>> ] keep swap
    [
      ! see if data is true to write false to read
      [ memory-write? ] dip swap
      [
        drop drop
        ]
        [
          [ dup memory-address ] dip
          [ vpa-between ] keep swap
          [
            [ dup memory-address ] dip [ dup memory-nbytes ] 2dip
            vpa-read >>data drop
          ]
          [
            [ dup memory-address ] dip [ dup memory-nbytes ] 2dip
            [ start>> + ] keep vpa-read >>data drop
          ] if
        ] if
      ]
      [
        [ dup memory-address ] dip  ! go get that address
        [ vpa-between ] keep swap
        [
          ! test if memory data
          [ memory-write? ] dip swap
            [
              [ t >>data ] dip drop drop
            ]
          [
            [ dup memory-address ] dip [ dup memory-nbytes ] 2dip
            vpa-read >>data drop
          ] if
        ]
        [ drop drop ] if
      ] if
    ]
    [ drop drop ] if ;



: <vpa> ( array start -- iport )
    vpa new swap
    >>start  ! save start address
    swap >>array ! save the array
    t >>reset ! reset latch for rom mirror
    f >>error
;
