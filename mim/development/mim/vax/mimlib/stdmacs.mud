
<DEFINITIONS "STDMACS">

<USE-WHEN <COMPILING? "STDMACS"> "BACKQUOTE">

#WORD *15174625610*
<GFCN IF ("VALUE" FORM "ARGS" ANY) STUFF8>
		    <OPT-DISPATCH 0 %<> OPT6 OPT7>
OPT6
		    <PUSH ()>
OPT7
		    <TEMP ELSE-CLAUSE10 TEMP20 TEMP18 TEMP17 RSTUFF22:LIST ITEM23>
		    <INTGO>
		    <SET TEMP20 () (TYPE LIST)>
		    <SET TEMP18 () (TYPE LIST)>
		    <SET TEMP17 STUFF8 (TYPE LIST)>
		    <DEAD STUFF8>
		    <LOOP>
MAP12
		    <INTGO>
		    <EMPL? TEMP17 + MAPAP15>
		    <SET RSTUFF22 TEMP17>
		    <NTHL RSTUFF22 1 = ITEM23>
		    <EQUAL? ITEM23 'ELSE - PHRASE25>
		    <SET ELSE-CLAUSE10 RSTUFF22>
		    <DEAD RSTUFF22>
		    <JUMP + MAPAP15>
PHRASE25
		    <CONS ITEM23 () = ITEM23 (TYPE LIST)>
		    <EMPL? TEMP20 - TAG29>
		    <SET TEMP20 ITEM23 (TYPE LIST)>
		    <JUMP + TAG30>
TAG29
		    <PUTREST TEMP18 ITEM23>
		    <DEAD TEMP18>
TAG30
		    <SET TEMP18 ITEM23 (TYPE LIST)>
		    <DEAD ITEM23>
		    <RESTL TEMP17 1 = TEMP17 (TYPE LIST)>
		    <JUMP + MAP12>
MAPAP15
		    <TYPE? ELSE-CLAUSE10 <TYPE-CODE UNBOUND> + PHRASE32>
		    <CONS ELSE-CLAUSE10 () = TEMP17>
		    <DEAD ELSE-CLAUSE10>
		    <CONS TEMP20 TEMP17 = TEMP17>
		    <DEAD TEMP20>
		    <CONS 'COND TEMP17 = TEMP17>
		    <CHTYPE TEMP17 <TYPE-CODE FORM> = TEMP17>
		    <RETURN TEMP17>
		    <DEAD TEMP17>
PHRASE32
		    <CONS TEMP20 () = ITEM23>
		    <DEAD TEMP20>
		    <CONS 'COND ITEM23 = ITEM23>
		    <CHTYPE ITEM23 <TYPE-CODE FORM> = TEMP17>
		    <DEAD ITEM23>
		    <RETURN TEMP17>
		    <DEAD TEMP17>
		    <END IF><COND (<AND <GASSIGNED? IF> <NOT <TYPE? ,IF MACRO>>> <SETG IF <CHTYPE (,IF) MACRO>>)>

#WORD *7532720407*
<GFCN WHEN ("VALUE" FORM "QUOTE" ANY "ARGS" ANY) TEST8 THINGS9>
		    <OPT-DISPATCH 1 %<> OPT6 OPT7>
OPT6
		    <PUSH ()>
OPT7
		    <TEMP TEMP12 TEMP13 TEMP14 TEMP15>
		    <INTGO>
		    <SET TEMP12 THINGS9>
		    <DEAD THINGS9>
		    <SET TEMP13 () (TYPE LIST)>
		    <EMPL? TEMP12 + TAG11>
		    <NTHL TEMP12 1 = TEMP14>
		    <CONS TEMP14 () = TEMP14>
		    <SET TEMP13 TEMP14>
		    <RESTL TEMP12 1 = TEMP12 (TYPE LIST)>
		    <EMPL? TEMP12 + TAG11>
		    <LOOP (TEMP12 VALUE) (TEMP14 VALUE)>
TAG10
		    <NTHL TEMP12 1 = TEMP15>
		    <CONS TEMP15 () = TEMP15>
		    <PUTREST TEMP14 TEMP15>
		    <DEAD TEMP14>
		    <SET TEMP14 TEMP15>
		    <DEAD TEMP15>
		    <RESTL TEMP12 1 = TEMP12 (TYPE LIST)>
		    <EMPL? TEMP12 - TAG10>
TAG11
		    <CONS TEST8 TEMP13 = TEMP12>
		    <DEAD TEST8 TEMP13>
		    <CONS TEMP12 () = TEMP12>
		    <CONS 'COND TEMP12 = TEMP12>
		    <CHTYPE TEMP12 <TYPE-CODE FORM> = TEMP12>
		    <RETURN TEMP12>
		    <DEAD TEMP12>
		    <END WHEN><COND (<AND <GASSIGNED? WHEN> <NOT <TYPE? ,WHEN MACRO>>> <SETG WHEN <CHTYPE (,WHEN) MACRO>>)>

#WORD *740777035*
<GFCN UNLESS ("VALUE" FORM "QUOTE" ANY "ARGS" ANY) TEST8 THINGS9>
		    <OPT-DISPATCH 1 %<> OPT6 OPT7>
OPT6
		    <PUSH ()>
OPT7
		    <TEMP TEMP12 TEMP13 TEMP14 TEMP15>
		    <INTGO>
		    <SET TEMP12 THINGS9>
		    <DEAD THINGS9>
		    <SET TEMP13 () (TYPE LIST)>
		    <EMPL? TEMP12 + TAG11>
		    <NTHL TEMP12 1 = TEMP14>
		    <CONS TEMP14 () = TEMP14>
		    <SET TEMP13 TEMP14>
		    <RESTL TEMP12 1 = TEMP12 (TYPE LIST)>
		    <EMPL? TEMP12 + TAG11>
		    <LOOP (TEMP12 VALUE) (TEMP14 VALUE)>
TAG10
		    <NTHL TEMP12 1 = TEMP15>
		    <CONS TEMP15 () = TEMP15>
		    <PUTREST TEMP14 TEMP15>
		    <DEAD TEMP14>
		    <SET TEMP14 TEMP15>
		    <DEAD TEMP15>
		    <RESTL TEMP12 1 = TEMP12 (TYPE LIST)>
		    <EMPL? TEMP12 - TAG10>
TAG11
		    <CONS TEST8 () = TEMP12>
		    <DEAD TEST8>
		    <CONS 'NOT TEMP12 = TEMP12>
		    <CHTYPE TEMP12 <TYPE-CODE FORM> = TEMP12>
		    <CONS TEMP12 TEMP13 = TEMP13>
		    <DEAD TEMP12>
		    <CONS TEMP13 () = TEMP13>
		    <CONS 'COND TEMP13 = TEMP13>
		    <CHTYPE TEMP13 <TYPE-CODE FORM> = TEMP13>
		    <RETURN TEMP13>
		    <DEAD TEMP13>
		    <END UNLESS>
<COND (<AND <GASSIGNED? UNLESS> <NOT <TYPE? ,UNLESS MACRO>>> <SETG UNLESS <CHTYPE (,UNLESS) MACRO>>)>

#WORD *6065057625*
<GFCN WHILE ("VALUE" FORM "QUOTE" ANY "ARGS" ANY) TEST8 THINGS9>
		    <OPT-DISPATCH 1 %<> OPT6 OPT7>
OPT6
		    <PUSH ()>
OPT7
		    <TEMP TEMP12 TEMP13 TEMP14 TEMP15>
		    <INTGO>
		    <SET TEMP12 THINGS9>
		    <DEAD THINGS9>
		    <SET TEMP13 () (TYPE LIST)>
		    <EMPL? TEMP12 + TAG11>
		    <NTHL TEMP12 1 = TEMP14>
		    <CONS TEMP14 () = TEMP14>
		    <SET TEMP13 TEMP14>
		    <RESTL TEMP12 1 = TEMP12 (TYPE LIST)>
		    <EMPL? TEMP12 + TAG11>
		    <LOOP (TEMP12 VALUE) (TEMP14 VALUE)>
TAG10
		    <NTHL TEMP12 1 = TEMP15>
		    <CONS TEMP15 () = TEMP15>
		    <PUTREST TEMP14 TEMP15>
		    <DEAD TEMP14>
		    <SET TEMP14 TEMP15>
		    <DEAD TEMP15>
		    <RESTL TEMP12 1 = TEMP12 (TYPE LIST)>
		    <EMPL? TEMP12 - TAG10>
TAG11
		    <CONS TEST8 () = TEMP12>
		    <DEAD TEST8>
		    <CONS 'NOT TEMP12 = TEMP12>
		    <CHTYPE TEMP12 <TYPE-CODE FORM> = TEMP12>
		    <CONS TEMP12 (<RETURN>) = TEMP12>
		    <CONS TEMP12 () = TEMP12>
		    <CONS 'COND TEMP12 = TEMP12>
		    <CHTYPE TEMP12 <TYPE-CODE FORM> = TEMP12>
		    <CONS TEMP12 TEMP13 = TEMP13>
		    <DEAD TEMP12>
		    <CONS () TEMP13 = TEMP13>
		    <CONS 'REPEAT TEMP13 = TEMP13>
		    <CHTYPE TEMP13 <TYPE-CODE FORM> = TEMP13>
		    <RETURN TEMP13>
		    <DEAD TEMP13>
		    <END WHILE><COND (<AND <GASSIGNED? WHILE> <NOT <TYPE? ,WHILE MACRO>>> <SETG WHILE <CHTYPE (,WHILE) MACRO>>)>

#WORD *15727324110*
<GFCN UNTIL ("VALUE" FORM "QUOTE" ANY "ARGS" ANY) TEST8 THINGS9>
		    <OPT-DISPATCH 1 %<> OPT6 OPT7>
OPT6
		    <PUSH ()>
OPT7
		    <TEMP TEMP12 TEMP13 TEMP14 TEMP15>
		    <INTGO>
		    <SET TEMP12 THINGS9>
		    <DEAD THINGS9>
		    <SET TEMP13 () (TYPE LIST)>
		    <EMPL? TEMP12 + TAG11>
		    <NTHL TEMP12 1 = TEMP14>
		    <CONS TEMP14 () = TEMP14>
		    <SET TEMP13 TEMP14>
		    <RESTL TEMP12 1 = TEMP12 (TYPE LIST)>
		    <EMPL? TEMP12 + TAG11>
		    <LOOP (TEMP12 VALUE) (TEMP14 VALUE)>
TAG10
		    <NTHL TEMP12 1 = TEMP15>
		    <CONS TEMP15 () = TEMP15>
		    <PUTREST TEMP14 TEMP15>
		    <DEAD TEMP14>
		    <SET TEMP14 TEMP15>
		    <DEAD TEMP15>
		    <RESTL TEMP12 1 = TEMP12 (TYPE LIST)>
		    <EMPL? TEMP12 - TAG10>
TAG11
		    <CONS TEST8 (<RETURN>) = TEMP12>
		    <DEAD TEST8>
		    <CONS TEMP12 () = TEMP12>
		    <CONS 'COND TEMP12 = TEMP12>
		    <CHTYPE TEMP12 <TYPE-CODE FORM> = TEMP12>
		    <CONS TEMP12 TEMP13 = TEMP13>
		    <DEAD TEMP12>
		    <CONS () TEMP13 = TEMP13>
		    <CONS 'REPEAT TEMP13 = TEMP13>
		    <CHTYPE TEMP13 <TYPE-CODE FORM> = TEMP13>
		    <RETURN TEMP13>
		    <DEAD TEMP13>
		    <END UNTIL><COND (<AND <GASSIGNED? UNTIL> <NOT <TYPE? ,UNTIL MACRO>>> <SETG UNTIL <CHTYPE (,UNTIL) MACRO>>)>

#WORD *26267644360*
<GFCN BUILD ("VALUE" ANY ATOM "ARGS" <LIST [REST ATOM ANY]>) NTYPE8 FILLER9>
		    <OPT-DISPATCH 1 %<> OPT6 OPT7>
OPT6
		    <PUSH ()>
OPT7
		    <TEMP TEMP12 STUFF15 TEMP20:FIX SLOTS19 TEMP23 INITED21 ATM16:ATOM I18:FIX>
		    <INTGO>
		    <NTHR NTYPE8 5 = TEMP12 (RECORD-TYPE ATOM) (BRANCH-FALSE + PHRASE11)>
		    <TYPE? TEMP12 <TYPE-CODE FALSE> + PHRASE11>
		    <DEAD TEMP12>
		    <SET STUFF15 FILLER9>
		    <LENL FILLER9 = TEMP20 (TYPE FIX)>
		    <DEAD FILLER9>
		    <LSH TEMP20 -1 = TEMP20 (TYPE FIX)>
		    <USBLOCK <TYPE-CODE VECTOR> TEMP20 = SLOTS19 (TYPE VECTOR)>
		    <LSH TEMP20 1 = TEMP20>
		    <SUB 0 TEMP20 = TEMP20>
		    <LENUV SLOTS19 = TEMP12 (TYPE FIX)>
		    <USBLOCK <TYPE-CODE VECTOR> TEMP12 = INITED21>
		    <SET TEMP23 INITED21>
		    <LOOP (TEMP23 VALUE LENGTH)>
ISTR24
		    <EMPUV? TEMP23 + ISTRE25>
		    <PUTUV TEMP23 1 %<>>
		    <RESTUV TEMP23 1 = TEMP23>
		    <JUMP + ISTR24>
ISTRE25
		    <LSH TEMP12 1 = TEMP12>
		    <SUB TEMP20 TEMP12 = TEMP20>
		    <DEAD TEMP12>
		    <LOOP>
AGAIN26
		    <INTGO>
		    <EMPL? STUFF15 - PHRASE28 (TYPE LIST)>
		    <CONS 'CHTYPE () = TEMP12>
		    <FRAME 'TYPEPRIM>
		    <PUSH NTYPE8>
		    <CALL 'TYPEPRIM 1 = TEMP23>
		    <CONS TEMP23 () = TEMP23>
		    <SET STUFF15 SLOTS19>
		    <DEAD SLOTS19>
		    <SET SLOTS19 TEMP23>
		    <EMPUV? STUFF15 + TAG31>
		    <LOOP (STUFF15 VALUE LENGTH) (SLOTS19 VALUE)>
TAG30
		    <NTHUV STUFF15 1 = INITED21>
		    <CONS INITED21 () = INITED21>
		    <PUTREST SLOTS19 INITED21>
		    <DEAD SLOTS19>
		    <SET SLOTS19 INITED21>
		    <DEAD INITED21>
		    <RESTUV STUFF15 1 = STUFF15 (TYPE VECTOR)>
		    <EMPUV? STUFF15 - TAG30>
TAG31
		    <PUTREST SLOTS19 ()>
		    <DEAD SLOTS19>
		    <CHTYPE TEMP23 <TYPE-CODE FORM> = SLOTS19>
		    <DEAD TEMP23>
		    <CONS SLOTS19 () = SLOTS19>
		    <PUTREST TEMP12 SLOTS19>
		    <CONS NTYPE8 () = STUFF15>
		    <DEAD NTYPE8>
		    <PUTREST SLOTS19 STUFF15>
		    <DEAD SLOTS19>
		    <PUTREST STUFF15 ()>
		    <DEAD STUFF15>
		    <CHTYPE TEMP12 <TYPE-CODE FORM> = TEMP12>
		    <JUMP + EXIT13>
PHRASE28
		    <NTHL STUFF15 1 = ATM16 (TYPE ATOM)>
		    <NTHR ATM16 1 = TEMP12 (RECORD-TYPE ATOM) (BRANCH-FALSE + BOOL36)>
		    <TYPE? TEMP12 <TYPE-CODE FALSE> + BOOL36>
		    <NTHR TEMP12 1 = TEMP12 (RECORD-TYPE GBIND)>
		    <TYPE? TEMP12 <TYPE-CODE UNBOUND> + BOOL36>
		    <DEAD TEMP12>
		    <GVAL ATM16 = TEMP23>
		    <TYPE? TEMP23 <TYPE-CODE OFFSET> - BOOL36>
		    <NTHUV TEMP23 1 = I18>
		    <LENUV SLOTS19 = TEMP12 (TYPE FIX)>
		    <GRTR? I18 TEMP12 + BOOL36 (TYPE FIX)>
		    <DEAD TEMP12>
		    <NTHUV TEMP23 2 = TEMP12>
		    <EQUAL? TEMP12 NTYPE8 + PHRASE35>
		    <DEAD TEMP12>
BOOL36
		    <FRAME 'ERROR>
		    <PUSH 'BAD-SLOT-NAME>
		    <PUSH ATM16>
		    <DEAD ATM16>
		    <PUSH NTYPE8>
		    <DEAD NTYPE8>
		    <PUSH 'BUILD>
		    <CALL 'ERROR 4 = TEMP12>
		    <JUMP + EXIT13>
PHRASE35
		    <RESTL STUFF15 1 = STUFF15 (TYPE LIST)>
		    <EMPL? STUFF15 - PHRASE38 (TYPE LIST)>
		    <FRAME 'ERROR>
		    <PUSH 'MISSING-SLOT-VALUE!-ERRORS>
		    <PUSH TEMP23>
		    <DEAD TEMP23>
		    <PUSH 'BUILD>
		    <CALL 'ERROR 3 = TEMP12>
		    <JUMP + EXIT13>
PHRASE38
		    <NTHL STUFF15 1 = TEMP12>
		    <PUTUV SLOTS19 I18 TEMP12>
		    <DEAD TEMP12>
		    <NTHUV INITED21 I18 = TEMP12>
		    <TYPE? TEMP12 <TYPE-CODE FALSE> + PHRASE42>
		    <DEAD TEMP12>
		    <FRAME 'ERROR>
		    <PUSH 'SLOT-INITIALIZED-TWICE!-ERRORS>
		    <PUSH TEMP23>
		    <DEAD TEMP23>
		    <PUSH 'BUILD>
		    <CALL 'ERROR 3 = TEMP12>
		    <JUMP + EXIT13>
PHRASE42
		    <PUTUV INITED21 I18 'T>
		    <DEAD I18>
		    <RESTL STUFF15 1 = STUFF15 (TYPE LIST)>
		    <JUMP + AGAIN26>
EXIT13
		    <SUB TEMP20 4 = TEMP20 (TYPE FIX)>
		    <ADJ TEMP20>
		    <DEAD TEMP20>
		    <RETURN TEMP12>
		    <DEAD TEMP12>
PHRASE11
		    <FRAME 'ERROR>
		    <PUSH 'BAD-TYPE-NAME!-ERRORS>
		    <PUSH NTYPE8>
		    <DEAD NTYPE8>
		    <PUSH 'BUILD>
		    <CALL 'ERROR 3 = TEMP12>
		    <RETURN TEMP12>
		    <DEAD TEMP12>
		    <END BUILD><COND (<AND <GASSIGNED? BUILD> <NOT <TYPE? ,BUILD MACRO>>> <SETG BUILD <CHTYPE (,BUILD) MACRO>>)>

#WORD *1526753766*
<GFCN PRIMTYPE? ("VALUE" ANY "QUOTE" ANY "ARGS" ANY) OBJECT8 TYPES9>
		    <OPT-DISPATCH 1 %<> OPT6 OPT7>
OPT6
		    <PUSH ()>
OPT7
		    <TEMP TEMP13 TEMP16 TEMP26 X30>
		    <INTGO>
		    <EMPL? TYPES9 - PHRASE11 (TYPE LIST)>
		    <FRAME 'ERROR>
		    <PUSH 'TOO-FEW-ARGUMENTS-SUPPLIED!-ERRORS>
		    <PUSH 'PRIMTYPE?>
		    <CALL 'ERROR 2 = TEMP13>
		    <RETURN TEMP13>
		    <DEAD TEMP13>
PHRASE11
		    <RESTL TYPES9 1 = TEMP13 (TYPE LIST)>
		    <EMPL? TEMP13 - PHRASE14 (TYPE LIST)>
		    <DEAD TEMP13>
		    <NTHL TYPES9 1 = TEMP13>
		    <DEAD TYPES9>
		    <CONS TEMP13 () = TEMP13>
		    <CONS OBJECT8 () = TEMP16>
		    <DEAD OBJECT8>
		    <CONS 'PRIMTYPE TEMP16 = TEMP16>
		    <CHTYPE TEMP16 <TYPE-CODE FORM> = TEMP16>
		    <CONS TEMP16 TEMP13 = TEMP13>
		    <DEAD TEMP16>
		    <CONS '==? TEMP13 = TEMP13>
		    <CHTYPE TEMP13 <TYPE-CODE FORM> = TEMP13>
		    <RETURN TEMP13>
		    <DEAD TEMP13>
PHRASE14
		    <SET TEMP13 () (TYPE LIST)>
		    <SET TEMP26 () (TYPE LIST)>
		    <SET TEMP16 TYPES9 (TYPE LIST)>
		    <DEAD TYPES9>
		    <LOOP>
MAP21
		    <INTGO>
		    <EMPL? TEMP16 + MAPAP24>
		    <NTHL TEMP16 1 = X30>
		    <CONS X30 () = X30>
		    <CONS .O X30 = X30>
		    <CONS '==? X30 = X30>
		    <CHTYPE X30 <TYPE-CODE FORM> = X30>
		    <CONS X30 () = X30 (TYPE LIST)>
		    <EMPL? TEMP13 - TAG32>
		    <SET TEMP13 X30 (TYPE LIST)>
		    <JUMP + TAG33>
TAG32
		    <PUTREST TEMP26 X30>
		    <DEAD TEMP26>
TAG33
		    <SET TEMP26 X30 (TYPE LIST)>
		    <DEAD X30>
		    <RESTL TEMP16 1 = TEMP16 (TYPE LIST)>
		    <JUMP + MAP21>
MAPAP24
		    <SET TEMP16 () (TYPE LIST)>
		    <EMPL? TEMP13 + TAG19>
		    <NTHL TEMP13 1 = X30>
		    <CONS X30 () = X30>
		    <SET TEMP16 X30>
		    <RESTL TEMP13 1 = TEMP13 (TYPE LIST)>
		    <EMPL? TEMP13 + TAG19>
		    <LOOP (TEMP13 VALUE) (X30 VALUE)>
TAG18
		    <NTHL TEMP13 1 = TEMP26>
		    <CONS TEMP26 () = TEMP26>
		    <PUTREST X30 TEMP26>
		    <DEAD X30>
		    <SET X30 TEMP26>
		    <DEAD TEMP26>
		    <RESTL TEMP13 1 = TEMP13 (TYPE LIST)>
		    <EMPL? TEMP13 - TAG18>
TAG19
		    <CONS 'OR TEMP16 = TEMP16>
		    <CHTYPE TEMP16 <TYPE-CODE FORM> = TEMP16>
		    <CONS TEMP16 (.O) = TEMP16>
		    <CONS TEMP16 () = TEMP16>
		    <CONS 'COND TEMP16 = TEMP16>
		    <CHTYPE TEMP16 <TYPE-CODE FORM> = TEMP16>
		    <CONS TEMP16 () = TEMP16>
		    <CONS OBJECT8 () = X30>
		    <DEAD OBJECT8>
		    <CONS 'PRIMTYPE X30 = X30>
		    <CHTYPE X30 <TYPE-CODE FORM> = X30>
		    <CONS X30 () = X30>
		    <CONS O:ATOM X30 = X30>
		    <CONS X30 () = X30>
		    <CONS X30 TEMP16 = TEMP16>
		    <DEAD X30>
		    <CONS 'BIND TEMP16 = TEMP16>
		    <CHTYPE TEMP16 <TYPE-CODE FORM> = TEMP13>
		    <DEAD TEMP16>
		    <RETURN TEMP13>
		    <DEAD TEMP13>
		    <END PRIMTYPE?><COND (<AND <GASSIGNED? PRIMTYPE?> <NOT <TYPE? ,PRIMTYPE? MACRO>>> <SETG PRIMTYPE? <CHTYPE (,PRIMTYPE?) MACRO>>)>

#WORD *7617522500*
		    <GFCN MULTI-SET ("VALUE" FORM "QUOTE" ANY "ARGS" ANY) B\8 STUFF9>
		    <OPT-DISPATCH 1 %<> OPT6 OPT7>
OPT6
		    <PUSH ()>
OPT7
		    <TEMP CNT13 TEMP27 TEMP25 TEMP29 ATM32 TEMP33 TEMP34 TEMP35 TEMP36>
		    <INTGO>
		    <SET CNT13 0 (TYPE FIX)>
		    <SET TEMP27 () (TYPE LIST)>
		    <SET TEMP25 () (TYPE LIST)>
		    <GEN-LVAL 'ATOMS = TEMP29>
		    <LOOP>
MAP19
		    <INTGO>
		    <EMPTY? TEMP29 + MAPAP22>
		    <NTH1 TEMP29 = ATM32>
		    <CONS 'COND () = TEMP33>
		    <CONS 'G=? () = TEMP34>
		    <CONS .LEN () = TEMP35>
		    <PUTREST TEMP34 TEMP35>
		    <ADD CNT13 1 = CNT13 (TYPE FIX)>
		    <CONS CNT13 () = TEMP36>
		    <PUTREST TEMP35 TEMP36>
		    <DEAD TEMP35>
		    <PUTREST TEMP36 ()>
		    <DEAD TEMP36>
		    <CHTYPE TEMP34 <TYPE-CODE FORM> = TEMP34>
		    <CONS TEMP34 () = TEMP36>
		    <DEAD TEMP34>
		    <CONS CNT13 (.THINGS) = TEMP35>
		    <CHTYPE TEMP35 <TYPE-CODE FORM> = TEMP35>
		    <CONS TEMP35 () = TEMP35>
		    <CONS ATM32 TEMP35 = TEMP35>
		    <DEAD ATM32>
		    <CONS 'SET TEMP35 = TEMP35>
		    <CHTYPE TEMP35 <TYPE-CODE FORM> = TEMP35>
		    <CONS TEMP35 () = TEMP35>
		    <PUTREST TEMP36 TEMP35>
		    <PUTREST TEMP35 ()>
		    <DEAD TEMP35>
		    <CONS TEMP36 () = TEMP36>
		    <PUTREST TEMP33 TEMP36>
		    <PUTREST TEMP36 ()>
		    <DEAD TEMP36>
		    <CHTYPE TEMP33 <TYPE-CODE FORM> = TEMP33>
		    <CONS TEMP33 () = TEMP33 (TYPE LIST)>
		    <EMPL? TEMP27 - TAG37>
		    <SET TEMP27 TEMP33 (TYPE LIST)>
		    <JUMP + TAG38>
TAG37
		    <PUTREST TEMP25 TEMP33>
		    <DEAD TEMP25>
TAG38
		    <SET TEMP25 TEMP33 (TYPE LIST)>
		    <DEAD TEMP33>
		    <REST1 TEMP29 = TEMP29>
		    <JUMP + MAP19>
MAPAP22
		    <SET TEMP29 () (TYPE LIST)>
		    <EMPL? TEMP27 + TAG16>
		    <NTHL TEMP27 1 = TEMP33>
		    <CONS TEMP33 () = TEMP36>
		    <DEAD TEMP33>
		    <SET TEMP29 TEMP36>
		    <RESTL TEMP27 1 = TEMP27 (TYPE LIST)>
		    <EMPL? TEMP27 + TAG16>
		    <LOOP (TEMP27 VALUE) (TEMP36 VALUE)>
TAG15
		    <NTHL TEMP27 1 = TEMP33>
		    <CONS TEMP33 () = TEMP33>
		    <PUTREST TEMP36 TEMP33>
		    <DEAD TEMP36>
		    <SET TEMP36 TEMP33>
		    <DEAD TEMP33>
		    <RESTL TEMP27 1 = TEMP27 (TYPE LIST)>
		    <EMPL? TEMP27 - TAG15>
TAG16
		    <SET TEMP36 STUFF9>
		    <DEAD STUFF9>
		    <SET TEMP27 () (TYPE LIST)>
		    <EMPL? TEMP36 + TAG40>
		    <NTHL TEMP36 1 = TEMP33>
		    <CONS TEMP33 () = TEMP33>
		    <SET TEMP27 TEMP33>
		    <RESTL TEMP36 1 = TEMP36 (TYPE LIST)>
		    <EMPL? TEMP36 + TAG40>
		    <LOOP (TEMP36 VALUE) (TEMP33 VALUE)>
TAG39
		    <NTHL TEMP36 1 = TEMP35>
		    <CONS TEMP35 () = TEMP35>
		    <PUTREST TEMP33 TEMP35>
		    <DEAD TEMP33>
		    <SET TEMP33 TEMP35>
		    <DEAD TEMP35>
		    <RESTL TEMP36 1 = TEMP36 (TYPE LIST)>
		    <EMPL? TEMP36 - TAG39>
TAG40
		    <CONS 'VECTOR TEMP27 = TEMP27>
		    <CHTYPE TEMP27 <TYPE-CODE FORM> = TEMP27>
		    <CONS TEMP27 () = TEMP27>
		    <CONS 'STACK TEMP27 = TEMP27>
		    <CHTYPE TEMP27 <TYPE-CODE FORM> = TEMP27>
		    <CONS TEMP27 () = TEMP27>
		    <CONS 'THINGS TEMP27 = TEMP27>
		    <CONS TEMP27 ((LEN:FIX <LENGTH .THINGS>)) = TEMP27>
		    <CONS TEMP27 TEMP29 = TEMP29>
		    <DEAD TEMP27>
		    <CONS 'BIND TEMP29 = TEMP29>
		    <CHTYPE TEMP29 <TYPE-CODE FORM> = CNT13>
		    <DEAD TEMP29>
		    <RETURN CNT13>
		    <DEAD CNT13>
		    <END MULTI-SET>
<COND (<AND <GASSIGNED? MULTI-SET> <NOT <TYPE? ,MULTI-SET MACRO>>> <SETG MULTI-SET <CHTYPE (,MULTI-SET) MACRO>>)>

<END-DEFINITIONS>
