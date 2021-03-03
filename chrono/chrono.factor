! Chrono is system clock for emulation
!

USING: models accessors kernel tools.continuations ;

IN: applix.chrono

TUPLE: chrono < model rising falling ;

GENERIC: low ( chrono -- )
GENERIC: high ( chrono -- )
GENERIC: toggle-rising ( chrono -- )
GENERIC: toggle-falling ( chrono -- )


! chrono value is set low and infrom the others
M: chrono low (  chrono -- )
  f swap ?set-model ;

! chrono value is set high and informa others
M: chrono high ( chrono -- )
  t swap ?set-model ;

M: model toggle-rising ( madel -- )
  [ value>> not ] keep ?set-model ;

M: model toggle-falling ( model -- )
  [ value>> not ] keep ?set-model ;

M: chrono model-changed
  break

  [ value>> ] keep swap
  [
    [ t swap rising>> ?set-model ] keep
    f swap falling>> ?set-model
  ]
  [
    [ f swap rising>> ?set-model ] keep
    t swap falling>> ?set-model
  ] if drop ;

: toggle-chrono ( chrono -- )
  [ not ] change-model ;

: <chrono> ( -- chrono )
  t chrono new-model
  f model new-model >>rising
  t model new-model >>falling
  [ dup add-connection ] keep
!  [ dup rising>> swap add-connection ] keep
!  [ dup falling>> swap add-connection ] keep
  ;
