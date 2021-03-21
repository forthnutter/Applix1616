! functions to handle reset 
! make this the central reset function
! that signal all other devices to reset



USING: models ;



IN: applix.reset

TUPLE: reset < model ;



: reset-add ( reset - )

;


: <reset> ( -- reset )
    new-model

;
