! Chrono is system clock for emulation
!

USES: models ;

IN: applix.chrono

TUPLE: chrono < model rising falling ;


<chrono> ( -- chrono )
  f chrono new-model
  0 >> rising
  0 >> falling ;

! chrono value is set low and infrom the others
M: low (  chrono -- )
  f swap ?set-model ;

! chrono value is set high and informa others
M: high ( chrono -- )
  t swap ?set-model ;
