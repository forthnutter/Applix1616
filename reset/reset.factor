! functions to handle reset 
! make this the central reset function
! that signal all other devices to reset



USING: kernel models ;



IN: applix.reset

TUPLE: reset < model ;

: reset-toggle ( reset -- )
    [ not ] change-model ;


: reset-add ( observer reset -- )
    add-connection
;


: <reset> ( -- reset )
    new-model

;
