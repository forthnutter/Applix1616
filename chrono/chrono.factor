! Chrono is system clock for emulation
!

USING: models accessors kernel ui.gadgets.button.private ;

IN: applix.chrono

TUPLE: chrono < model rising falling ;

GENERIC: low ( chrono -- )
GENERIC: high ( chrono -- )

! chrono value is set low and infrom the others
M: chrono low (  chrono -- )
  f swap ?set-model ;

! chrono value is set high and informa others
M: chrono high ( chrono -- )
  t swap ?set-model ;

: toggle-rising ( madel -- )
  rising>> [ not ] change-model ;

: toggle-falling ( model -- )
  falling>> [ not ] change-model ;

M: chrono model-changed
  [ value>> ] keep [ rising>> value>> xor ] keep swap
  [
    [ rising>> toggle-model ] keep
  ] unless
  [ value>> ] keep [ falling>> value>> xor ] keep swap
  [
    [ falling>> toggle-model ] keep
  ] unless drop ;

: <chrono> ( -- chrono )
  f chrono new-model
  f model new-model >>rising
  f model new-model >>falling
  [ dup rising>> swap add-connection ] keep
  [ dup falling>> swap add-connection ] keep
  ;
