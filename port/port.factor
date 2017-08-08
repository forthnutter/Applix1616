! Copyright (C) 2016 Joseph Moschini.  a.k.a. forthnutter
! See http://factorcode.org/license.txt for BSD license.
!
USING: accessors kernel math math.bitwise math.order math.parser
      freescale.binfile tools.continuations models models.memory
      prettyprint sequences freescale.68000.emulator byte-arrays
      applix.ram namespaces
      ;

IN: applix.port

TUPLE: port reset array start error ;

: port-start ( iport -- start )
    start>> ;

: port-array ( iport -- array )
    array>> ;

: port-size ( iport -- size )
    port-array length ;

: port-end ( iport -- end )
    [ port-start ] keep
    port-size + ;

: port-error ( iport -- rom )
    t >>error ;

! test the address is within rom start and end address
: port-between ( address rom -- ? )
    [ port-start ] [ port-end ] bi between? ;


: port-index ( address rom -- index )
    port-start - ;

: port-read ( n address rom -- data )
    [ port-between ] 2keep
    rot
    [
        [ dup [ + ] dip swap ] dip
        ! here we need to zero base the address to do indexing
        [ [ drop ] dip port-index ] 2keep [ port-index ] keep
        array>> subseq
    ]
    [ drop drop drop f ] if ;



M: port model-changed
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
          [ port-between ] keep swap
          [
            [ dup memory-address ] dip [ dup memory-nbytes ] 2dip
            port-read >>data drop
          ]
          [
            [ dup memory-address ] dip [ dup memory-nbytes ] 2dip
            [ start>> + ] keep port-read >>data drop
          ] if
        ] if
      ]
      [
        [ dup memory-address ] dip  ! go get that address
        [ port-between ] keep swap
        [
          ! test if memory data
          [ memory-write? ] dip swap
            [
              [ t >>data ] dip drop drop
            ]
          [
            [ dup memory-address ] dip [ dup memory-nbytes ] 2dip
            port-read >>data drop
          ] if
        ]
        [ drop drop ] if
      ] if
    ]
    [ drop drop ] if ;



: <port> ( array start -- iport )
    port new swap
    >>start  ! save start address
    swap >>array ! save the array
    t >>reset ! reset latch for rom mirror
    f >>error
;
