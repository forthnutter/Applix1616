! Chrono is system clock for emulation
!

USING: models accessors kernel ;

IN: applix.chrono

TUPLE: chrono < model rising falling ;

GENERIC: low ( chrono -- )

! chrono value is set low and infrom the others
M: chrono low (  chrono -- )
  f swap ?set-model ;

: <chrono> ( -- chrono )
  f chrono new-model
  f model new-model >>rising
  f model new-model >>falling
  [ dup rising>> swap add-connection ] keep
  [ dup falling>> swap add-connection ] keep
  ;



! chrono value is set high and informa others
M: chrono high ( chrono -- )
  t swap ?set-model ;
