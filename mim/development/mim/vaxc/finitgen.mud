<GC-MON T>
<BLOAT 100000 0 0 2000 50>

<DEFINE PFLOAD (S) <PRINC .S> <PRINC " "> <FLOAD .S>>

<PFLOAD "INIT">
<PFLOAD "OPCODE68000.NBIN">
<PFLOAD "DEF68000">
<PFLOAD "MSYSDEFS">
<PFLOAD "ASMDEFS">

<PFLOAD "SMIM:MIMGEN.FBIN">
<PFLOAD "SMIM:INTERFACE.FBIN">
<PFLOAD "SMIM:ASMGO.FBIN">



<CONSTRUCT-DISPATCH-TABLE>
<INITIALIZE-ACS>
<PFLOAD "DEFMIMOPS">
<INIT-CODE>
<INIT-FINAL-CODE>
<INIT-CONSTANTS>
<INIT-REC-DEFS>

<PFLOAD "POSTLOAD">

<SETG GLUE <>>
<SETG INT-MODE T>
<SETG WARN-PRINT T>
<SETG GC-MODE <>>
<SETG BOOT-MODE <>>
<SETG MAX-BUFFERS 5>
<INIT-REC-DEFS>
<SETG AC-STORE-OPT <>>

<FLOAD "PS:<MUM.BOOT>BOOT.COMPIL">
<GC 0 T 15>