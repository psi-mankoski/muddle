<BLOCK (<ROOT>)> <NEWTYPE LOSE FIX><ENDBLOCK>

<GDECL (THE-BIG-LABELS PRE-NAMES PRE-OPTS) LIST>

<GDECL (STACK-DEPTH) FIX (WINNING-VICTIM) <OR FALSE FIX>>

<GDECL (COMPARERS) <VECTOR [REST ATOM]>>

<GDECL (NEXT-FLUSH CODE-LENGTH GLUE-PC) FIX>

<GDECL (TYPE-WORDS TYPE-LENGTHS) <VECTOR [REST ATOM FIX]>>

<NEWTYPE I$TERMIN WORD>

<NEWTYPE JSYS FIX>

<NEWTYPE GCAL ATOM>

<NEWTYPE GFRM ATOM>

<NEWTYPE ADECL VECTOR>

<NEWTYPE SGFRM ATOM>

<NEWTYPE SBFRM ATOM>

<NEWTYPE SBRCAL ATOM>

<NEWTYPE LAB
	 VECTOR
	 '!<<PRIMTYPE VECTOR> ATOM
			      <OR FALSE FIX>
			      <OR ATOM FALSE>
			      <LIST [REST LABSTATE]>
			      <OR FALSE LABSTATE>
			      FIX
			      LIST
			      LIST>>

<SETG LAB-NAM <OFFSET 1 LAB>>

<SETG LAB-IND <OFFSET 2 LAB>>

<SETG LAB-LOOP <OFFSET 3 LAB>>

<SETG LAB-STATE <OFFSET 4 LAB>>

<SETG LAB-FINAL-STATE <OFFSET 5 LAB>>

<SETG LAB-VISIT-MARK <OFFSET 6 LAB>>

<SETG LAB-CODE-PNTR <OFFSET 7 LAB>>

<SETG LAB-DEAD-VARS <OFFSET 8 LAB>>

<MANIFEST LAB-NAM LAB-IND LAB-LOOP LAB-STATE LAB-FINAL-STATE LAB-VISIT-MARK
	  LAB-CODE-PNTR LAB-DEAD-VARS>

<NEWTYPE ACSTATE
	 VECTOR
	 '<<PRIMTYPE VECTOR> AC
			     <OR LOCAL FALSE>
			     <OR ATOM FALSE>
			     <OR ATOM FALSE>
			     ATOM>>

<SETG ACS-AC <OFFSET 1 ACSTATE>>

<SETG ACS-LOCAL <OFFSET 2 ACSTATE>>

<SETG ACS-STORED <OFFSET 3 ACSTATE>>

<SETG ACS-TYPE <OFFSET 4 ACSTATE>>

<SETG ACS-CODE <OFFSET 5 ACSTATE>>

<MANIFEST ACS-AC ACS-LOCAL ACS-STORED ACS-TYPE ACS-CODE>

<NEWTYPE LABSTATE VECTOR '!<<PRIMTYPE VECTOR> [6 ACSTATE]>>

<NEWTYPE XGLOC ATOM>

<NEWTYPE T$UNBOUND WORD>

<NEWTYPE INST VECTOR>

<NEWTYPE REF VECTOR>

<NEWTYPE XTYPE-C ATOM>

<NEWTYPE XTYPE-W ATOM>

<NEWTYPE CHANNEL-ROUTINE LIST>

<NEWTYPE LOCAL
	 VECTOR
	 '<<PRIMTYPE VECTOR> ATOM <OR FALSE ATOM> LOCAL-NAME <OR FALSE ATOM>
			     <OR FALSE ACSTATE> <OR FALSE ACSTATE>>>

<NEWTYPE LOCAL-NAME FIX>

<NEWTYPE CONST-W-LOCAL LIST>

<NEWTYPE CONSTANT WORD>

<NEWTYPE CONSTANT-LABEL FIX>

<SETG LATM <OFFSET 1 LOCAL>>

<SETG LUPD <OFFSET 2 LOCAL>>

<SETG LNAME <OFFSET 3 LOCAL>>

<SETG LDECL <OFFSET 4 LOCAL>>

<SETG LAST-ACST <OFFSET 5 LOCAL>>

<SETG LAST-ACSV <OFFSET 6 LOCAL>>

<MANIFEST LATM LUPD LNAME LDECL LAST-ACST LAST-ACSV>

<SETG MAX-IMMEDIATE 262143>

<NEWTYPE AC
	 VECTOR
	 '<<PRIMTYPE VECTOR> ATOM
			     <OR LOSE FALSE ATOM>
			     ATOM
			     FIX
			     <OR FALSE ATOM>
			     <OR FALSE ATOM>>>

<GDECL (ACA-AC AC-BOTH) <OR AC FALSE>>

<SETG AC-NAME <OFFSET 1 AC>>

<SETG AC-ITEM <OFFSET 2 AC>>

<SETG AC-CODE <OFFSET 3 AC>>

<SETG AC-TIME <OFFSET 4 AC>>

<SETG AC-UPDATE <OFFSET 5 AC>>

<SETG AC-TYPE <OFFSET 6 AC>>

<MANIFEST AC-NAME AC-ITEM AC-CODE AC-TIME AC-UPDATE AC-TYPE>

<GDECL (AC-PAIR-TABLE AC-TABLE)
       <VECTOR [REST AC]>
       (AC-STAMP VISIT-COUNT)
       FIX
       (NULL-STATES)
       <VECTOR [REST ACSTATE]>>

<GDECL (MVECTOR FINAL-LOCALS TYPED-LOCALS LABELS CLABELS)
       LIST
       (LBLSEQ CONSTSEQ NRARGS MAX-IMMEDIATE)
       FIX
       (ICALL-TAGS CODE LOCALS ICALL-TEMPS ALL-ICALL-TEMPS ALL-TEMP-CC TEMP-CC)
       LIST
       (FREE-CONSTS CONSTANT-VECTOR) <LIST [REST CONSTANT-BUCKET]>
       (ICALL-FLAG)
       <OR FALSE FIX>>

<GDECL (ACS) <VECTOR [REST ATOM FIX]>>
<DEFMAC WIDTH-MUNG ('CHANX 'W) <FORM M-HLEN .CHANX .W>>

<SETG OUTPUT-LENGTH 1024>

<MANIFEST OUTPUT-LENGTH>

<NEWTYPE CONSTANT-BUCKET VECTOR
	 '<<PRIMTYPE VECTOR> <OR ATOM CONSTANT CONST-W-LOCAL> FIX CONSTANT-LABEL
			     FIX>>

<MSETG CB-VAL <OFFSET 1 CONSTANT-BUCKET>>

<MSETG CB-HASH <OFFSET 2 CONSTANT-BUCKET>>

<MSETG CB-LAB <OFFSET 3 CONSTANT-BUCKET>>

<MSETG CB-LOC <OFFSET 4 CONSTANT-BUCKET>>

<MSETG CONSTANT-TABLE-LENGTH 1001>

<GDECL (CONSTANT-TABLE) <VECTOR [REST <LIST [REST CONSTANT-BUCKET]>]>>

<NEWTYPE MBUCK VECTOR '<<PRIMTYPE VECTOR> ANY FIX FIX>>

<MSETG MV-VAL <OFFSET 1 MBUCK>>

<MSETG MV-HASH <OFFSET 2 MBUCK>>

<MSETG MV-LOC <OFFSET 3 MBUCK>>

<MSETG MV-TABLE-LENGTH 391>

<GDECL (MV-TABLE) <VECTOR [REST <LIST [REST MBUCK]>]> (MV-COUNT) FIX>

<NEWTYPE SUBR-INFO VECTOR>

<MSETG KNOWN-ARGS 2>