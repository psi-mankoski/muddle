<GC-MON T>
;<BLOAT 100000 0 0 2000 50>

<DEFINE PFLOAD (S "AUX" ER) <PRINC .S> <PRINC " ">
	<COND (<MEMQ !\. .S> <FLOAD .S>)
	      (<SET ER <GROUP-LOAD .S>>) (ELSE <ERROR .ER>)> >

<SETG NCT-SAVE ,NEW-CHANNEL-TYPE>

<PFLOAD "ROOT-STUFF">
<PFLOAD "FILE-INDEX.MSUBR">
<PFLOAD "INIT.MSUBR">
<PFLOAD "OPDEFVAX.MSUBR">
<INIT-OP-DEFS>
<PFLOAD "DEFVAX">
<PFLOAD "MSYSDEFS">
<PFLOAD "ASMDEFS">
<PFLOAD "MIMAC.MSUBR">
<PFLOAD "MIMGEN.MSUBR">
<INIT-BRANCH-TABLES>
<PFLOAD "MIMMISC.MSUBR">
<PFLOAD "TOPLEV.MSUBR">
<PFLOAD "ASSEM.MSUBR">
<PFLOAD "INTERFACE.MSUBR">
<PFLOAD "CHMKS.MSUBR">
<PFLOAD "LOOKAHEAD.MSUBR">
<INITIALIZE-ACS>
<PFLOAD "DEFMIMOPS">
<INIT-CODE>
<INIT-CONSTANTS>
<INIT-REC-DEFS>
<INIT-FINAL-CODE>

<PFLOAD "POSTLOAD">

<SETG GLUE <>>
<SETG INT-MODE T>
<SETG WARN-PRINT T>
<SETG GC-MODE <>>
<SETG BOOT-MODE <>>
<INIT-REC-DEFS>
<SETG AC-STORE-OPT <>>

<SETG NCT-NEW ,NEW-CHANNEL-TYPE>
<SETG NEW-CHANNEL-TYPE ,NCT-SAVE>

<FLOAD "/USR/MIMC/NBOOT.COMPIL">
<LINK '<ERRET T> "" <ROOT>>
<FLOAD "ASK.MSUBR">
<FEATURES "COMPILER" ("SUBSYSTEM" "MIMOC") ("TARGET-MACHINE" "VAX")>
<COPY-GC>
<GC-MON <>>