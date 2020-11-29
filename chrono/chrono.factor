! Chrono is system clock for emulation
!

USING: models accessors kernel models ;

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

M: chrono toggle-rising ( madel -- )
  rising>> [ not ] change-model ;

M: chrono toggle-falling ( model -- )
  falling>> [ not ] change-model ;

M: chrono model-changed
  [ value>> ] keep [ rising>> value>> xor ] keep swap
  [
    [ toggle-rising ] keep
  ] unless
  [ value>> ] keep [ falling>> value>> xor ] keep swap
  [
    [ toggle-falling ] keep
  ] unless drop ;

: <chrono> ( -- chrono )
  f chrono new-model
  f model new-model >>rising
  f model new-model >>falling
  [ dup rising>> swap add-connection ] keep
  [ dup falling>> swap add-connection ] keep
  ;
