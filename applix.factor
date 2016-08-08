!
USING: accessors kernel math math.bitwise math.order math.parser
      freescale.binfile tools.continuations models models.memory
      prettyprint sequences freescale.68000 freescale.68000.emulator byte-arrays
      applix.ram applix.rom namespaces
      ;

IN: applix

SYMBOL: saveram

TUPLE: applix cpu ;




: applix-reset ( cpu -- )
    drop ;


! lets make the program start here
: applix ( -- cpu )
    <cpu>
    "work/applix/A1616OSV045.bin" <binfile>
    0 <rom> memory-add ;


!  0 swap <mblock> <cpu> [ memory>> memory-add-block ] keep ;


