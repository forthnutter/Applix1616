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
  value>> [ not ] change-model ;

M: model toggle-falling ( model -- )
  value>> [ not ] change-model ;

M: chrono model-changed
  break
  [ value>> ] keep [ rising>> value>> xor ] keep swap
  [
    [ rising>> toggle-rising ] keep
  ] unless
  [ value>> ] keep [ falling>> value>> xor ] keep swap
  [
    [ falling>> toggle-falling ] keep
  ] unless drop ;

: <chrono> ( -- chrono )
  f chrono new-model
  f model new-model >>rising
  f model new-model >>falling
  [ dup add-connection ] keep
!  [ dup rising>> swap add-connection ] keep
!  [ dup falling>> swap add-connection ] keep
  ;
