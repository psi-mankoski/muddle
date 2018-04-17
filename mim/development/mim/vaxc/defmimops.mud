<INIT-OPERATIONS>
<DEFINE-MIMOP "FCN" ,FCN-PROCESS>
<DEFINE-MIMOP "GFCN" ,FCN-PROCESS>
<DEFINE-MIMOP "TEMP" ,TEMP-PROCESS>
<DEFINE-MIMOP "ADD" ,ADDFIX-GEN T>
<DEFINE-MIMOP "LESS?" ,LESSFIX-GEN>
<DEFINE-MIMOP "GRTR?" ,GTFIX-GEN>
<DEFINE-MIMOP "VEQUAL?" ,VEQUAL-GEN>
<DEFINE-MIMOP "EQUAL?" ,EQUAL-GEN>
<DEFINE-MIMOP "LOOP" ,LOOP-GEN>
<DEFINE-MIMOP "JUMP" ,UCBRANCH-GEN>
<DEFINE-MIMOP "SET" ,SET-GEN>
<DEFINE-MIMOP "SETLR" ,SETLR-GEN>
<DEFINE-MIMOP "SETRL" ,SETRL-GEN>
<DEFINE-MIMOP "DEAD" ,SAFE-DEAD-VAR>
<DEFINE-MIMOP "RETURN" ,RETURN-GEN>
<DEFINE-MIMOP "NTHL" ,NTH-LIST-GEN T>
<DEFINE-MIMOP "RESTL" ,REST-LIST-GEN T>
<DEFINE-MIMOP "NTHUV" ,NTH-VECTOR-GEN T>
<DEFINE-MIMOP "RESTUV" ,REST-VECTOR-GEN T>
<DEFINE-MIMOP "LENL" ,LIST-LENGTH-GEN T>
<DEFINE-MIMOP "LENUV" ,BLOCK-LENGTH-GEN T>
<DEFINE-MIMOP "LENUS" ,BLOCK-LENGTH-GEN T>
<DEFINE-MIMOP "LENUB" ,BLOCK-LENGTH-GEN T>
<DEFINE-MIMOP "LENUU" ,BLOCK-LENGTH-GEN T>
<DEFINE-MIMOP "LENU" ,BLOCK-LENGTH-GEN T>
<DEFINE-MIMOP "LENR" ,BLOCK-LENGTH-GEN>
<DEFINE-MIMOP "EMPL?" ,LIST-EMP-GEN T>
<DEFINE-MIMOP "EMPUV?" ,BLOCK-EMP-GEN>
<DEFINE-MIMOP "EMPUS?" ,BLOCK-EMP-GEN>
<DEFINE-MIMOP "EMPUB?" ,BLOCK-EMP-GEN>
<DEFINE-MIMOP "EMPUU?" ,BLOCK-EMP-GEN>
<DEFINE-MIMOP "EMPR?" ,BLOCK-EMP-GEN>
<DEFINE-MIMOP "PUTL" ,PUT-LIST-GEN T>
<DEFINE-MIMOP "PUTREST" ,PUTREST-GEN T>
<DEFINE-MIMOP "SUB" ,SUBFIX-GEN T>
<DEFINE-MIMOP "PUTUV" ,PUT-VEC-GEN T>
<DEFINE-MIMOP "TYPE?" ,TYPE-TST-GEN>
<DEFINE-MIMOP "PUSH" ,PUSH-GEN>
<DEFINE-MIMOP "FRAME" ,FRAME-GEN>
<DEFINE-MIMOP "CALL" ,CALL-GEN>
<DEFINE-MIMOP "CONS" ,CONS-GEN>
<DEFINE-MIMOP "END" ,TIME>
<DEFINE-MIMOP "GVAL" ,GVAL-GEN>
<DEFINE-MIMOP "CHTYPE" ,CHTYPE-GEN>
<DEFINE-MIMOP "SETG" ,SETG-GEN T>
<DEFINE-MIMOP "ICALL" ,ICALL-GEN>
<DEFINE-MIMOP "MUL" ,MULFIX-GEN T>
<DEFINE-MIMOP "DIV" ,DIVFIX-GEN T>
<DEFINE-MIMOP "MOD" ,MODFIX-GEN T>
<DEFINE-MIMOP "OPT-DISPATCH" ,OPDISP-GEN>
<DEFINE-MIMOP "MAKTUP" ,MAKTUP-GEN>
<DEFINE-MIMOP "FIXBIND" ,FIXBIND-GEN>
<DEFINE-MIMOP "UNBIND" ,UNBIND-GEN>
<DEFINE-MIMOP "GETS" ,GETS-GEN>
<DEFINE-MIMOP "SETS" ,SETS-GEN>
<DEFINE-MIMOP "LIST" ,LIST-GEN>
<DEFINE-MIMOP "RECORD" ,RECORD-GEN>
<DEFINE-MIMOP "NTHR" ,NTH-RECORD-GEN T>
<DEFINE-MIMOP "PUTR" ,PUTR-GEN T>
<DEFINE-MIMOP "PUTUU" ,PUT-UVECTOR-GEN T>
<DEFINE-MIMOP "PUTUS" ,PUT-STRING-GEN T>
<DEFINE-MIMOP "PUTUB" ,PUT-BYTE-GEN T>
<DEFINE-MIMOP "NTHUU" ,NTH-UVECTOR-GEN T>
<DEFINE-MIMOP "NTHUS" ,NTH-STRING-GEN T>
<DEFINE-MIMOP "NTHUB" ,NTH-BYTE-GEN T>
<DEFINE-MIMOP "RESTUU" ,REST-UVECTOR-GEN T>
<DEFINE-MIMOP "RESTUS" ,REST-STRING-GEN T>
<DEFINE-MIMOP "RESTUB" ,REST-BYTE-GEN T>
<DEFINE-MIMOP "CFRAME" ,CFRAME-GEN>
<DEFINE-MIMOP "BIND" ,BIND-GEN>
<DEFINE-MIMOP "POP" ,POP-GEN>
<DEFINE-MIMOP "UBLOCK" ,UBLOCK-GEN>
<DEFINE-MIMOP "ADDF" ,ADDF-GEN T>
<DEFINE-MIMOP "SUBF" ,SUBF-GEN T>
<DEFINE-MIMOP "MULF" ,MULF-GEN T>
'<DEFINE-MIMOP "MODF" ,MODF-GEN T>
<DEFINE-MIMOP "DIVF" ,DIVF-GEN T>
<DEFINE-MIMOP "AGAIN" ,AGAIN-GEN>
<DEFINE-MIMOP "RTUPLE" ,RTUPLE-GEN>
<DEFINE-MIMOP "ACTIVATION" ,ACTIVATION-GEN>
<DEFINE-MIMOP "RETRY" ,RETRY-GEN>
<DEFINE-MIMOP "OR" ,OR-GEN T>
<DEFINE-MIMOP "AND" ,AND-GEN T>
<DEFINE-MIMOP "LSH" ,LSH-GEN T>
<DEFINE-MIMOP "ASH" ,ASH-GEN T>
<DEFINE-MIMOP "ROT" ,ROT-GEN T>
<DEFINE-MIMOP "XOR" ,EOR-GEN T>
<DEFINE-MIMOP "EQV" ,EQV-GEN T>
<DEFINE-MIMOP "TUPLE" ,TUPLE-GEN>
<DEFINE-MIMOP "INTGO" ,INTGO-GEN>
<DEFINE-MIMOP "TYPE" ,TYPE-GEN T>
<DEFINE-MIMOP "NEWTYPE" ,NEWTYPE-GEN>
<DEFINE-MIMOP "OPEN" ,OPEN-GEN>
<DEFINE-MIMOP "CLOSE" ,CLOSE-GEN>
<DEFINE-MIMOP "READ" ,READ-GEN>
<DEFINE-MIMOP "PRINT" ,PRINT-GEN>
<DEFINE-MIMOP "SAVE" ,SAVE-GEN>
<DEFINE-MIMOP "RESTORE" ,RESTORE-GEN>
<DEFINE-MIMOP "FIX" ,FIX-GEN T>
<DEFINE-MIMOP "FLOAT" ,FLOAT-GEN T>
<DEFINE-MIMOP "RANDOM" ,RANDOM-GEN T>
<DEFINE-MIMOP "COMPERR" ,COMPERR-GEN>
<DEFINE-MIMOP "IRECORD" ,IRECORD-GEN>
<DEFINE-MIMOP "ADJ" ,ADJ-GEN>
<DEFINE-MIMOP "RFRAME" ,RETURN-GEN>
<DEFINE-MIMOP "PFRAME" ,PFRAME-GEN>
<DEFINE-MIMOP "ARGS" ,ARGS-GEN>
<DEFINE-MIMOP "NTHU" ,NTHU-GEN>
<DEFINE-MIMOP "RESTU" ,RESTU-GEN>
<DEFINE-MIMOP "PUTU" ,PUTU-GEN>
<DEFINE-MIMOP "BACKU" ,BACKU-GEN>
<DEFINE-MIMOP "TOPU" ,TOPU-GEN>
<DEFINE-MIMOP "TUPUV" ,TOPU-GEN>
<DEFINE-MIMOP "TOPUS" ,TOPU-GEN>
<DEFINE-MIMOP "TOPUB" ,TOPU-GEN>
<DEFINE-MIMOP "RESET" ,RESET-GEN>
<DEFINE-MIMOP "ATIC" ,ATIC-GEN>
<DEFINE-MIMOP "VALUE" ,VALUE-GEN T>
<DEFINE-MIMOP "NTH1" ,NTH1-GEN>
<DEFINE-MIMOP "REST1" ,REST1-GEN T>
<DEFINE-MIMOP "FGVAL" ,FGVAL-GEN>
<DEFINE-MIMOP "MONAD?" ,MONAD?-GEN T>
<DEFINE-MIMOP "EMPTY?" ,EMPTY?-GEN T>
<DEFINE-MIMOP "GASSIGNED?" ,GASSIGNED?-GEN>
<DEFINE-MIMOP "MARKL" ,MARKL-GEN>
<DEFINE-MIMOP "MARKUV" ,MARKUV-GEN>
<DEFINE-MIMOP "MARKUU" ,MARKUU-GEN>
<DEFINE-MIMOP "MARKUS" ,MARKUS-GEN>
<DEFINE-MIMOP "MARKUB" ,MARKUB-GEN>
<DEFINE-MIMOP "MARKR" ,MARKR-GEN>
<DEFINE-MIMOP "MARKL?" ,MARKL?-GEN>
<DEFINE-MIMOP "MARKUV?" ,MARKUV?-GEN>
<DEFINE-MIMOP "MARKUU?" ,MARKUU?-GEN>
<DEFINE-MIMOP "MARKUS?" ,MARKUS?-GEN>
<DEFINE-MIMOP "MARKUB?" ,MARKUB?-GEN>
<DEFINE-MIMOP "MARKR?" ,MARKR?-GEN>
<DEFINE-MIMOP "SWNEXT" ,SWNEXT-GEN>
<DEFINE-MIMOP "NEXTS" ,NEXTS-GEN>
<DEFINE-MIMOP "CONTENTS" ,CONTENTS-GEN>
<DEFINE-MIMOP "OBJECT" ,OBJECT-GEN T>
<DEFINE-MIMOP "RELL" ,RELL-GEN>
<DEFINE-MIMOP "RELR" ,RELR-GEN>
<DEFINE-MIMOP "RELU" ,RELU-GEN>
<DEFINE-MIMOP "SYSCALL" ,SYSCALL-GEN>
<DEFINE-MIMOP "QUIT" ,QUIT-GEN>
<DEFINE-MIMOP "TEMPLATE-TABLE" ,TEMPLATE-TABLE-GEN>
<DEFINE-MIMOP "SETZONE" ,SETZONE-GEN>
<DEFINE-MIMOP "LEGAL?" ,LEGAL-GEN>
<DEFINE-MIMOP "LOCATION" ,LOCATION-GEN>
<DEFINE-MIMOP "UNWCNT" ,UNWCNT-GEN>
<DEFINE-MIMOP "ALLOCR" ,ALLOCR-GEN>
<DEFINE-MIMOP "ALLOCUU" ,ALLOCUU-GEN>
<DEFINE-MIMOP "ALLOCUV" ,ALLOCUV-GEN>
<DEFINE-MIMOP "ALLOCUS" ,ALLOCUS-GEN>
<DEFINE-MIMOP "ALLOCUB" ,ALLOCUB-GEN>
<DEFINE-MIMOP "ALLOCL" ,ALLOCL-GEN>
<DEFINE-MIMOP "BLT" ,BLT-GEN>
<DEFINE-MIMOP "PUTS" ,PUTS-GEN T>
<DEFINE-MIMOP "MPAGES" ,MPAGES-GEN>
<DEFINE-MIMOP "ACALL" ,ACALL-GEN>
<DEFINE-MIMOP "RNTIME" ,RNTIME-GEN>
<DEFINE-MIMOP "SCALL" ,SCALL-GEN>
<DEFINE-MIMOP "MRETURN" ,MRETURN-GEN>
<DEFINE-MIMOP "SFRAME" ,SFRAME-GEN>
<DEFINE-MIMOP "TYPEW" ,TYPEW-GEN>
<DEFINE-MIMOP "TYPEWC" ,TYPEWC-GEN>
<DEFINE-MIMOP "SAVTTY" ,SAVTTY-GEN>
<DEFINE-MIMOP "FATAL" ,FATAL-GEN>
<DEFINE-MIMOP "GETTTY" ,GETTTY-GEN>
<DEFINE-MIMOP "GETBITS" ,GETBITS-GEN T>
<DEFINE-MIMOP "PUTBITS" ,PUTBITS-GEN T>
<DEFINE-MIMOP "DISPATCH" ,DISPATCH-GEN>
<DEFINE-MIMOP "PIPE" ,PIPE-GEN>
<DEFINE-MIMOP "CGC-UVECTOR" ,CGC-UVECTOR-GEN>
<DEFINE-MIMOP "CGC-STRING" ,CGC-STBYTE-GEN>
<DEFINE-MIMOP "CGC-BYTES" ,CGC-STBYTE-GEN>
<DEFINE-MIMOP "CGC-LIST" ,CGC-LIST-GEN>
<DEFINE-MIMOP "CGC-VECTOR" ,CGC-VECTOR-GEN>
<DEFINE-MIMOP "CGC-RECORD" ,CGC-RECORD-GEN>
<DEFINE-MIMOP "ILDB" ,ILDB-GEN T>
<DEFINE-MIMOP "IDPB" ,IDPB-GEN T>
<DEFINE-MIMOP "MOVSTK" ,MOVSTK-GEN>
<DEFINE-MIMOP "GETSTK" ,GETSTK-GEN>
<DEFINE-MIMOP "ON-STACK?" ,ON-STACK?-GEN>	; "Check for stack object"
<DEFINE-MIMOP "UUBLOCK" ,UUBLOCK-GEN>		; "Build uninitialized structure"
<DEFINE-MIMOP "SBLOCK" ,SBLOCK-GEN>
<DEFINE-MIMOP "USBLOCK" ,USBLOCK-GEN>		; "Stack structures"
<DEFINE-MIMOP "CHANNEL-OP" ,CHANNEL-OP-GEN>	; "Open-compiled channel ops"
<DEFINE-MIMOP "BBIND" ,GEN-BBIND>		; "Bind an atom"
<DEFINE-MIMOP "GEN-LVAL" ,GEN-LVAL>		; "Get a special lval"
<DEFINE-MIMOP "GEN-ASSIGNED?" ,GEN-ASSIGNED?>	; "Assigned?"
<DEFINE-MIMOP "GEN-SET" ,GEN-SET>		; "Set a special"
<DEFINE-MIMOP "MOVE-WORDS" ,MOVE-WORDS-GEN>	; "Substruc vector/uvector"
<DEFINE-MIMOP "MOVE-STRING" ,MOVE-STRING-GEN>	; "Substruc string/bytes"
<DEFINE-MIMOP "STRING-EQUAL?" ,STRING-EQUAL?-GEN>
<DEFINE-MIMOP "STRCOMP" ,STRCOMP-GEN>
<DEFINE-MIMOP "BIGSTACK" ,BIGSTACK-GEN>		; "State of stack growth"
;<DEFINE-MIMOP "DOUBLE" ,DOUBLE-GEN>            ; "Experimental."

<SETG PASS-OPS <UVECTOR ,TEMP!-MIMOP ,MAKTUP!-MIMOP ,OPT-DISPATCH!-MIMOP
		 ,FCN!-MIMOP ,GFCN!-MIMOP ,LOOP!-MIMOP>>

<SETG MIM-PREDS [,LESS?!-MIMOP
		 ,GRTR?!-MIMOP
		 ,VEQUAL?!-MIMOP
		 ,EQUAL?!-MIMOP
		 ,JUMP!-MIMOP
		 ,EMPL?!-MIMOP
		 ,EMPUV?!-MIMOP
		 ,EMPR?!-MIMOP
		 ,EMPUU?!-MIMOP
		 ,TYPE?!-MIMOP
		 ,EMPTY?!-MIMOP
		 ,GASSIGNED?!-MIMOP
		 ,MARKL?!-MIMOP
		 ,MARKUU?!-MIMOP
		 ,MARKUV?!-MIMOP
		 ,MARKR?!-MIMOP
		 ,GEN-ASSIGNED?!-MIMOP
		 ,STRING-EQUAL?!-MIMOP]>

<MSETG SPSTO-LOC <- *17777777777* <* 12 512> 19>>
<MSETG BINDID-LOC <- *17777777777* <* 12 512> 15>>
<MSETG STKTOP-LOC <- *17777777777* <* 12 512> 11>>
<MSETG STKBOT-LOC <- *17777777777* <* 12 512> 7>>
<MSETG INTFLG-LOC <- *17777777777* <* 12 512> 3>>
<MSETG DISPATCH-TABLE-START 8>

<INIT-CALL-DISPATCH>

<CREATE-CALL-DESC "FINIS" <> <>>
<CREATE-CALL-DESC "IFRAME"  <> <>>
<CREATE-CALL-DESC "MCALL" T 
		  <CREATE-DATUM <> AC-0 AC-1>
		  <RTE-ARGS VALUE <> AC-0>
		  <RTE-ARGS VALUE <> AC-1>>
<CREATE-CALL-DESC "ICONS" T
		  <CREATE-DATUM LIST <> AC-1>
		  <RTE-ARGS VALUE <> AC-3>
		  <RTE-ARGS TYPE-VALUE-PAIR AC-0 AC-1>>
<CREATE-CALL-DESC "INCALL" T <>>
<CREATE-CALL-DESC "IGETS" <>
		  <CREATE-DATUM <> AC-0 AC-1>
		  <RTE-ARGS VALUE <> AC-1>>
<CREATE-CALL-DESC "ISETS" <> <>
		  <RTE-ARGS TYPE-VALUE-PAIR AC-0 AC-1>
		  <RTE-ARGS VALUE <> AC-3>>
<CREATE-CALL-DESC "IFIXBND" <> <>>
<CREATE-CALL-DESC "IUNBIND" T <> <RTE-ARGS VALUE <> AC-1>>
<CREATE-CALL-DESC "BRECORD" T <CREATE-DATUM <> AC-0 AC-1>
		  <RTE-ARGS VALUE <> AC-0>
		  <RTE-ARGS VALUE <> AC-1>> 
<CREATE-CALL-DESC "BVECTOR" T <CREATE-DATUM VECTOR AC-0 AC-1>>
<CREATE-CALL-DESC "BLIST" T <CREATE-DATUM LIST <> AC-1>
		  <RTE-ARGS VALUE <> AC-1>>
<CREATE-CALL-DESC "IBIND" <> <CREATE-DATUM T$LBIND <> AC-1>>
<CREATE-CALL-DESC "IBLOCK" T <CREATE-DATUM VECTOR AC-0 AC-1>
		  <RTE-ARGS VALUE <> AC-1>>
<CREATE-CALL-DESC "IACTIVATION" T <>>
<CREATE-CALL-DESC "IAGAIN" <> <> <RTE-ARGS VALUE <> AC-1>>
<CREATE-CALL-DESC "IRETRY" <> <> <RTE-ARGS VALUE <> AC-1>>
<CREATE-CALL-DESC "IRTUPLE" <> <> 
		  <RTE-ARGS VALUE <> AC-1>
		  <RTE-ARGS VALUE <> AC-2>>
<CREATE-CALL-DESC "ITUPLE" T <CREATE-DATUM TUPLE AC-0 AC-1>
		  <RTE-ARGS VALUE <> AC-1>>
<CREATE-CALL-DESC "LCKINT" <> <>>
<CREATE-CALL-DESC "INEWTYPE" T <CREATE-DATUM FIX <> AC-1>
		  <RTE-ARGS VALUE <> AC-1>>
<CREATE-CALL-DESC "IOPEN" T <CREATE-DATUM <> AC-0 AC-1>
		  <RTE-ARGS VALUE <> AC-3>
		  <RTE-ARGS VALUE <> AC-5>
		  <RTE-ARGS TYPE-VALUE-PAIR AC-0 AC-1>>
<CREATE-CALL-DESC "ICLOSE" T <>
		  <RTE-ARGS VALUE <> AC-1>>
<CREATE-CALL-DESC "IREAD" T <CREATE-DATUM FIX <> AC-1>
		  <RTE-ARGS VALUE <> AC-5>
		  <RTE-ARGS TYPE-VALUE-PAIR AC-0 AC-1>
		  <RTE-ARGS VALUE <> AC-3>
		  <RTE-ARGS VALUE <> AC-7>>
<CREATE-CALL-DESC "IPRINT" T <>
		 <RTE-ARGS VALUE <> AC-5>
		 <RTE-ARGS TYPE-VALUE-PAIR AC-0 AC-1>
		 <RTE-ARGS VALUE <> AC-3>>
<CREATE-CALL-DESC "ISAVE" T <CREATE-DATUM TYPE-VALUE-PAIR AC-0 AC-1>
		  <RTE-ARGS VALUE <> AC-1>
		  <RTE-ARGS VALUE <> AC-2>
		  <RTE-ARGS VALUE <> AC-3>>
<CREATE-CALL-DESC "IRESTORE" T <>
		  <RTE-ARGS VALUE <> AC-1>>
<CREATE-CALL-DESC "IRANDOM" <> <CREATE-DATUM FIX <> AC-1>
		  <RTE-ARGS VALUE <> AC-1>>
<CREATE-CALL-DESC "ICOMPERR" T <>>
<CREATE-CALL-DESC "BIREC"  T <CREATE-DATUM <> AC-0 AC-1>
		  <RTE-ARGS VALUE <> AC-1>
		  <RTE-ARGS VALUE <> AC-3>
		  <RTE-ARGS VALUE <> AC-5>>
<CREATE-CALL-DESC "INTHU" <> <CREATE-DATUM <> AC-0 AC-1>
		  <RTE-ARGS TYPE-VALUE-PAIR AC-0 AC-1>
		  <RTE-ARGS VALUE <> AC-3>>
<CREATE-CALL-DESC "IRESTU" <> <CREATE-DATUM <> AC-0 AC-1>
		  <RTE-ARGS TYPE-VALUE-PAIR AC-0 AC-1>
		  <RTE-ARGS VALUE <> AC-3>>
<CREATE-CALL-DESC "IPUTU" <> <>
		  <RTE-ARGS TYPE-VALUE-PAIR AC-0 AC-1>
		  <RTE-ARGS VALUE <> AC-3>
		  <RTE-ARGS TYPE-VALUE-PAIR AC-4 AC-5>>
<CREATE-CALL-DESC "INTHR" <> <CREATE-DATUM <> AC-0 AC-1>
		  <RTE-ARGS TYPE-VALUE-PAIR AC-0 AC-1>
		  <RTE-ARGS VALUE <> AC-3>>
<CREATE-CALL-DESC "IPUTR" <> <>
		  <RTE-ARGS TYPE-VALUE-PAIR AC-0 AC-1>
		  <RTE-ARGS VALUE <> AC-3>
		  <RTE-ARGS TYPE-VALUE-PAIR AC-4 AC-5>>
<CREATE-CALL-DESC "IBACKU" <> <CREATE-DATUM <> AC-0 AC-1>
		  <RTE-ARGS TYPE-VALUE-PAIR AC-0 AC-1>
		  <RTE-ARGS VALUE <> AC-3>>
<CREATE-CALL-DESC "ITOPU" <> <CREATE-DATUM <> AC-0 AC-1>
		  <RTE-ARGS TYPE-VALUE-PAIR AC-0 AC-1>>
<CREATE-CALL-DESC "IRESET" T <> <RTE-ARGS VALUE <> AC-1>>
<CREATE-CALL-DESC "IATIC" T <CREATE-DATUM <> AC-0 AC-1>
		  <RTE-ARGS TYPE-VALUE-PAIR AC-0 AC-1>>
<CREATE-CALL-DESC "IARGS" T <CREATE-DATUM <> AC-0 AC-1>
		  <RTE-ARGS VALUE <> AC-1>>
<CREATE-CALL-DESC "CIEMP" <> <> <RTE-ARGS TYPE-VALUE-PAIR AC-0 AC-1>>
<CREATE-CALL-DESC "CINTH" <> <CREATE-DATUM <> AC-0 AC-1>
		  <RTE-ARGS TYPE-VALUE-PAIR AC-0 AC-1>>
<CREATE-CALL-DESC "CIMON" <> <> <RTE-ARGS TYPE-VALUE-PAIR AC-0 AC-1>>
<CREATE-CALL-DESC "CIRST" <> <CREATE-DATUM <> AC-0 AC-1>
		  <RTE-ARGS TYPE-VALUE-PAIR AC-0 AC-1>>
<CREATE-CALL-DESC "CIGAS" <> <CREATE-DATUM <> AC-0 AC-1>
		  <RTE-ARGS TYPE-VALUE-PAIR AC-0 AC-1>>
<CREATE-CALL-DESC "CIGVL" <> <CREATE-DATUM <> AC-0 AC-1>
		  <RTE-ARGS TYPE-VALUE-PAIR AC-0 AC-1>>
<CREATE-CALL-DESC "ISWNEXT" <> <CREATE-DATUM <> AC-0 AC-1>
		  <RTE-ARGS TYPE-VALUE-PAIR AC-0 AC-1>
		  <RTE-ARGS VALUE <> AC-2>>
<CREATE-CALL-DESC "INEXTS" <> <CREATE-DATUM FIX <> AC-1>
		  <RTE-ARGS VALUE <> AC-1>>
<CREATE-CALL-DESC "IRELU" <> <>
		  <RTE-ARGS TYPE-VALUE-PAIR AC-0 AC-1>>
<CREATE-CALL-DESC "IRELR" <> <>
		  <RTE-ARGS TYPE-VALUE-PAIR AC-0 AC-1>>
<CREATE-CALL-DESC "IRELL" <> <> <RTE-ARGS VALUE <> AC-1>>
<CREATE-CALL-DESC "ICONTENTS" <> <CREATE-DATUM <> AC-0 AC-1>
		  <RTE-ARGS VALUE <> AC-1>>
<CREATE-CALL-DESC "IMARKR" <> <>
		  <RTE-ARGS TYPE-VALUE-PAIR AC-0 AC-1>
		  <RTE-ARGS VALUE <> AC-3>>
<CREATE-CALL-DESC "IMARKR?" <> <CREATE-DATUM <> AC-0 AC-1>
		  <RTE-ARGS TYPE-VALUE-PAIR AC-0 AC-1>>
<CREATE-CALL-DESC "ISYSCALL" T <CREATE-DATUM <> AC-0 AC-1>
		  <RTE-ARGS VALUE <> AC-1>
		  <RTE-ARGS VALUE <> AC-3>>
<CREATE-CALL-DESC "IQUIT" T <>
		  <RTE-ARGS VALUE <> AC-1>> 
<CREATE-CALL-DESC "ITTABLE" <> <> <RTE-ARGS VALUE <> AC-1>
		  <RTE-ARGS TYPE-VALUE-PAIR AC-2 AC-3>>
<CREATE-CALL-DESC "ISETZONE" <> <CREATE-DATUM <> AC-0 AC-1>
		  <RTE-ARGS VALUE <> AC-1>>
<CREATE-CALL-DESC "ILEGAL?" <> <CREATE-DATUM <> AC-0 AC-1>
		  <RTE-ARGS TYPE-VALUE-PAIR AC-0 AC-1>>
<CREATE-CALL-DESC "IUNWCNT" T <>>
<CREATE-CALL-DESC "IMPAGES" T <CREATE-DATUM <> AC-0 AC-1>
		  <RTE-ARGS VALUE <> AC-1>>
<CREATE-CALL-DESC "IPUTS" <> <> <RTE-ARGS VALUE <> AC-1>
		  	        <RTE-ARGS TYPE-VALUE-PAIR AC-2 AC-3>>

<CREATE-CALL-DESC "IACALL" T 
		  <CREATE-DATUM <> AC-0 AC-1>
		  <RTE-ARGS TYPE-VALUE-PAIR AC-0 AC-1>
		  <RTE-ARGS VALUE <> AC-3>>
<CREATE-CALL-DESC "ISYSCALL" T <CREATE-DATUM <> AC-0 AC-1>
		  <RTE-ARGS VALUE <> AC-0>
		  <RTE-ARGS VALUE <> AC-1>>
<CREATE-CALL-DESC "IRNTIME" T
		  <CREATE-DATUM FLOAT AC-0 AC-1>>
<CREATE-CALL-DESC "ISFRAME" <> <>>
<CREATE-CALL-DESC "IMRETURN" <> <>>
<CREATE-CALL-DESC "ITYPEW" <> <CREATE-DATUM TYPE-W AC-0 AC-1>
		  <RTE-ARGS VALUE <> AC-0>
		  <RTE-ARGS VALUE <> AC-1>>
<CREATE-CALL-DESC "ITYPEWC" <> <CREATE-DATUM TYPE-C AC-0 AC-1>
		  <RTE-ARGS VALUE <> AC-1>>
<CREATE-CALL-DESC "ISAVTTY" <> <>
		  <RTE-ARGS VALUE <> AC-0>
		  <RTE-ARGS VALUE <> AC-1>>
<CREATE-CALL-DESC "IFATAL" <> <>
		  <RTE-ARGS TYPE-VALUE-PAIR AC-0 AC-1>>
<CREATE-CALL-DESC "IGETTTY" <> <CREATE-DATUM <> AC-0 AC-1>
		  <RTE-ARGS TYPE-VALUE-PAIR AC-0 AC-1>>
<CREATE-CALL-DESC "IPIPE" T <CREATE-DATUM <> AC-0 AC-1>
		  <RTE-ARGS TYPE-VALUE-PAIR AC-0 AC-1>>
<CREATE-CALL-DESC "IGVERR" T <>
		  <RTE-ARGS TYPE-VALUE-PAIR AC-0 AC-1>>
<CREATE-CALL-DESC "IMOVSTK" T <>
		  <RTE-ARGS VALUE <> AC-0>>
<CREATE-CALL-DESC "IGETSTK" <> <CREATE-DATUM UVECTOR AC-0 AC-1>
		  <RTE-ARGS TYPE-VALUE-PAIR AC-0 AC-1>>
<CREATE-CALL-DESC "UIBLOCK" T <CREATE-DATUM VECTOR AC-0 AC-1>
		  <RTE-ARGS VALUE <> AC-1>>
<CREATE-CALL-DESC "ISBLOCK" <> <CREATE-DATUM VECTOR AC-0 AC-1>
		  <RTE-ARGS VALUE <> AC-1>>
<CREATE-CALL-DESC "UISBLOCK" <> <CREATE-DATUM VECTOR AC-0 AC-1>
		  <RTE-ARGS VALUE <> AC-1>>
<CREATE-CALL-DESC "IASSQ" <> <CREATE-DATUM LBIND <> AC-1>
		  <RTE-ARGS VALUE <> AC-0>>
<CREATE-CALL-DESC "ILVAL" T <CREATE-DATUM TYPE-VALUE-PAIR AC-0 AC-1>
		  <RTE-ARGS VALUE <> AC-0>>
<CREATE-CALL-DESC "ISET" T <>
		  <RTE-ARGS VALUE <> AC-0>
		  <RTE-ARGS TYPE-VALUE-PAIR AC-2 AC-3>>
<CREATE-CALL-DESC "IBIGSTK" <> <CREATE-DATUM FIX <> AC-1>
		  <RTE-ARGS VALUE <> AC-1>>

<SETG CASE-ENTRY-TABLE <VECTOR <CREATE-CASE-ENTRY ARGS 1 FIX>
			       <CREATE-CASE-ENTRY OBLIST 2 OBLIST>
			       <CREATE-CASE-ENTRY BIND 3 T$LBIND>
			       <CREATE-CASE-ENTRY ECALL 4 ATOM>
			       <CREATE-CASE-ENTRY NCALL 5 ATOM>
			       <CREATE-CASE-ENTRY UWATM 6 ATOM>
			       <CREATE-CASE-ENTRY PAGPTR 7 T$PAGET>
			       <CREATE-CASE-ENTRY MINF 8 T$MINF>
			       <CREATE-CASE-ENTRY ICALL 9 ATOM>
			       <CREATE-CASE-ENTRY MAPPER 10 ATOM>
			       <CREATE-CASE-ENTRY ENVIR 11 VECTOR>
			       <CREATE-CASE-ENTRY ARGV 12 VECTOR>
			       <CREATE-CASE-ENTRY HOMSTR 13 STRING>
			       <CREATE-CASE-ENTRY RUNINT 14 FIX>
			       <CREATE-CASE-ENTRY TBIND 15 T$LBIND>
			       <CREATE-CASE-ENTRY INGC 16 FIX>>>
