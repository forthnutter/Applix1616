! Copyright (C) 2016 Joseph Moschini.  a.k.a. forthnutter
! See http://factorcode.org/license.txt for BSD license.
!
USING: accessors kernel math math.bitwise math.order math.parser
      freescale.binfile tools.continuations models models.memory
      prettyprint sequences freescale.68000 freescale.68000.emulator byte-arrays
      applix.ram namespaces
      ;

IN: applix.iport

TUPLE: iport reset array start error ;

: iport-start ( iport -- start )
    start>> ;

: iport-array ( iport -- array )
    array>> ;

: iport-size ( iport -- size )
    iport-array length ;

: iport-end ( iport -- end )
    [ iport-start ] keep
    iport-size + ;

: iport-error ( iport -- rom )
    t >>error ;

! test the address is within rom start and end address
: iport-between ( address rom -- ? )
    [ iport-start ] [ iport-end ] bi between? ;


: iport-index ( address rom -- index )
    iport-start - ;

: iport-read ( n address rom -- data )
    [ iport-between ] 2keep
    rot
    [
        [ dup [ + ] dip swap ] dip
        ! here we need to zero base the address to do indexing
        [ [ drop ] dip iport-index ] 2keep [ iport-index ] keep
        array>> subseq
    ]
    [ drop drop drop f ] if ;



M: iport model-changed
  break
  [ dup err>> ] dip swap   ! if err is false a memory has been read
  [
    [ reset>> ] keep swap
    [
      ! see if data is true to write false to read
      [ ?memory-data ] dip swap
      [
        drop drop
        ]
        [
          [ memory-address ] dip
          [ iport-between ] keep swap
          [
            [ memory-address ] dip [ memory-nbytes ] 2dip
            iport-read >>data drop
          ]
          [
            [ memory-address ] dip [ memory-nbytes ] 2dip
            [ start>> + ] keep iport-read >>data drop
          ] if
        ] if
      ]
      [
        [ memory-address ] dip  ! go get that address
        [ iport-between ] keep swap
        [
          ! test if memory data
          [ ?memory-data ] dip swap
            [
              [ t >>data ] dip drop drop
            ]
          [
            [ memory-address ] dip [ memory-nbytes ] 2dip
            iport-read >>data drop
          ] if
        ]
        [ drop drop ] if
      ] if
    ]
    [ drop drop ] if ;



: <iport> ( array start -- iport )
    iport new swap
    >>start  ! save start address
    swap >>array ! save the array
    t >>reset ! reset latch for rom mirror
    f >>error
;
