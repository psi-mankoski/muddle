<DEFINE GETBITS-GEN (FROM WIDTH SHIFT DEST "OPTIONAL" HINT "AUX" AC)
  <COND (<==? .DEST STACK>
	 <EMIT-PUSH <TYPE-WORD FIX> LONG>)>
  <COND (<AND <NOT <TYPE? .FROM VARTBL>>
	      <NOT <TYPE? .WIDTH VARTBL>>
	      <NOT <TYPE? .SHIFT VARTBL>>>
	 ; "Win if given all constants"
	 <EMIT-MOVE <MA-IMM <GETBITS .FROM <BITS .WIDTH .SHIFT>>>
		    <COND (<==? .DEST STACK>
			   <MA-AINC ,AC-TP>)
			  (T
			   <VAR-VALUE-ADDRESS .DEST T>)>
		    LONG>)
	(<AND <TYPE? .WIDTH FIX>
	      <TYPE? .SHIFT FIX>
	      <0? <MOD .SHIFT 8>>	; "On byte boundary"
	      <OR <==? .WIDTH 8>	; "Byte or halfword"
		  <==? .WIDTH 16>>
	      <OR <0? .SHIFT>
		  <NOT <VAR-VALUE-IN-AC? .FROM>>>>
	 ; "Make getting a halfword or byte not use EXTZV"
	 <EMIT <COND (<==? .WIDTH 8> ,INST-MOVZBL)
		     (T ,INST-MOVZWL)>	; "Depends on width"
	       <COND (<0? .SHIFT> 
		      ; "This works even if in AC"
		      <VAR-VALUE-ADDRESS .FROM>)
		     (T
		      ; "Generate bizarre stack offset"
		      <GEN-LOC .FROM <+ 4 </ .SHIFT 8>>>)>
	       <COND (<==? .DEST STACK>
		      <MA-AINC ,AC-TP>)
		     (<VAR-VALUE-ADDRESS .DEST T>)>>)
	(T
	 <EMIT ,INST-EXTZV
	       <COND (<TYPE? .SHIFT VARTBL>
		      <VAR-VALUE-ADDRESS .SHIFT>)
		     (<MA-LIT .SHIFT>)>
	       <COND (<TYPE? .WIDTH VARTBL>
		      <VAR-VALUE-ADDRESS .WIDTH>)
		     (<MA-LIT .WIDTH>)>
	       <COND (<TYPE? .FROM VARTBL>
		      <VAR-VALUE-ADDRESS .FROM>)
		     (<MA-IMM .FROM>)>
	       <COND (<==? .DEST STACK>
		      <MA-AINC ,AC-TP>)
		     (<VAR-VALUE-ADDRESS .DEST T>)>>)>
  <COND (<N==? .DEST STACK>
	 <COND (<SET AC <VAR-VALUE-IN-AC? .DEST>>
		<DEST-DECL .AC .DEST FIX>)
	       (<N==? <VARTBL-DECL .DEST> FIX>
		<INDICATE-VAR-TEMP-DECL .DEST FIX>
		<EMIT-MOVE <TYPE-CODE FIX> <VAR-TYPE-ADDRESS .DEST> LONG>)>)>
  NORMAL>

<DEFINE PUTBITS-GEN (TO WIDTH SHIFT FROM DEST "OPTIONAL" HINT "AUX" RD
		     WIDOP SHIFTOP FROMOP (TAC <>) (ZERO? <>))
  <COND (<AND <NOT <TYPE? .TO VARTBL>>
	      <NOT <TYPE? .WIDTH VARTBL>>
	      <NOT <TYPE? .SHIFT VARTBL>>
	      <NOT <TYPE? .FROM VARTBL>>>
	 ; "Win with all constants"
	 <COND (<==? .DEST STACK>
		<EMIT-PUSH <TYPE-WORD FIX> LONG>)>
	 <EMIT-MOVE <MA-IMM <PUTBITS .TO <BITS .WIDTH .SHIFT> .FROM>>
		    <COND (<==? .DEST STACK> <MA-AINC ,AC-TP>)
			  (<VAR-VALUE-ADDRESS .DEST T>)>
		    LONG>)
	(T
	 <COND (<==? .DEST STACK>
		<EMIT-PUSH <TYPE-WORD FIX> LONG>
		<EMIT-PUSH <COND (<TYPE? .TO VARTBL>
				  <VAR-VALUE-ADDRESS .TO>)
				 (<MA-IMM .TO>)> LONG>)>
	 <COND (<AND <TYPE? .WIDTH FIX>
		     <OR <==? .WIDTH 8>
			 <==? .WIDTH 16>>
		     <TYPE? .SHIFT FIX>
		     <0? <MOD .SHIFT 8>>
		     <OR <0? .SHIFT>
			 <==? .DEST STACK>
			 <AND <NOT <VAR-VALUE-IN-AC? .DEST>>
			      ; "This only works if shift is 0 anyway"
			      <N==? .FROM .DEST>>>>
		<COND (<AND <==? .TO 0>
			    <0? .SHIFT>>
		       ; "If putbits into 0, rightmost part, just do MOVZxL"
		       <SET ZERO? T>)
		      (<==? .FROM .DEST>
		       ; "<PUTBITS FROB X X FOO = FOO>, so can't clear word
			  before doing move"
		       <SET TAC <GET-AC PREF-VAL T>>
		       <EMIT-MOVE
			<COND (<TYPE? .TO VARTBL> <VAR-VALUE-ADDRESS .TO>)
			      (T <MA-IMM .TO>)>
			<MA-REG .TAC>
			LONG>)
		      (<AND <N==? .DEST STACK>
			    <N==? .TO .DEST>>
		       <EMIT-MOVE
			<COND (<TYPE? .TO VARTBL> <VAR-VALUE-ADDRESS .TO>)
			      (T <MA-IMM .TO>)>
			<VAR-VALUE-ADDRESS .DEST T>
			LONG>)>
		<EMIT <COND (.ZERO?
			     <COND (<==? .WIDTH 8> ,INST-MOVZBL)
				   (T ,INST-MOVZWL)>)
			    (<==? .WIDTH 8> ,INST-MOVB)
			    (,INST-MOVW)>
		      <COND (<TYPE? .FROM VARTBL>
			     <VAR-VALUE-ADDRESS .FROM>)
			    (T
			     <MA-IMM .FROM>)>
		      <COND (<==? .DEST STACK>
			     <MA-DISP ,AC-TP
				      <- -4 </ .SHIFT 8>>>)
			    (.TAC
			     <MA-REG .TAC>)
			    (<VAR-VALUE-IN-AC? .DEST>
			     <VAR-VALUE-ADDRESS .DEST T>)
			    (T
			     <GEN-LOC .DEST <+ 4 </ .SHIFT 8>>>)>>
		<COND (.TAC
		       <DEST-DECL .TAC .DEST FIX>)
		      (<N==? <VARTBL-DECL .DEST> FIX>
		       <INDICATE-VAR-TEMP-DECL .DEST FIX>
		       <EMIT-MOVE <TYPE-CODE FIX> <VAR-TYPE-ADDRESS .DEST>
				  LONG>)>)
	       (T
		<COND (<TYPE? .WIDTH VARTBL>
		       <SET WIDOP <VAR-VALUE-ADDRESS .WIDTH>>)
		      (<SET WIDOP <MA-LIT .WIDTH>>)>
		<COND (<TYPE? .SHIFT VARTBL>
		       <SET SHIFTOP <VAR-VALUE-ADDRESS .SHIFT>>)
		      (<SET SHIFTOP <MA-LIT .SHIFT>>)>
		<COND (<TYPE? .FROM VARTBL>
		       <SET FROMOP <VAR-VALUE-ADDRESS .FROM>>
		       <COND (<SET RD <VAR-VALUE-IN-AC? .FROM>>
			      <PROTECT .RD>)>)
		      (T
		       <SET FROMOP <MA-IMM .FROM>>)>
		<COND (<==? .DEST STACK>
		       <SET RD <MA-BD ,AC-TP -4>>)
		      (<==? .DEST .TO>
		       <SET RD <VAR-VALUE-ADDRESS .TO>>)
		      (<AND <TYPE? .TO VARTBL>
			    <SET RD <VAR-VALUE-IN-AC? .TO>>>
		       <MUNG-AC .RD>
		       <DEST-DECL .RD .DEST FIX>
		       <SET RD <MA-REG .RD>>)
		      (<SET RD <GET-AC PREF-VAL T>>
		       <DEST-DECL .RD .DEST FIX>
		       <EMIT ,INST-MOVL
			     <COND (<TYPE? .TO VARTBL> <VAR-VALUE-ADDRESS .TO>)
				   (<MA-IMM .TO>)>
			     <SET RD <MA-REG .RD>>>)>
		<EMIT ,INST-INSV
		      .FROMOP
		      .SHIFTOP
		      .WIDOP
		      .RD>)>)>
  NORMAL>

<DEFINE ARITH-GEN (OP-2-ARG OP-3-ARG OP1 OP2 DEST COMMUTE MUD TYP
		   "AUX" TMP (USE-3 <>) (VAC <>))
   #DECL ((OP-2-ARG OP-3-ARG) FIX (OP1 OP2) <OR FIX FLOAT VARTBL>
	  (DEST) <OR ATOM VARTBL> (COMMUTE) <OR ATOM FALSE>
	  (VAC) <OR AC FALSE>)
   <COND (<AND <TYPE? .OP1 FIX FLOAT> <TYPE? .OP2 FIX FLOAT>>
	  <SET VAC <GET-AC PREF-VAL T>>
	  <LOAD-CONSTANT .VAC <APPLY .MUD .OP1 .OP2>>)
	 (ELSE
	  <COND (<AND <TYPE? <SET TMP .OP1> FIX FLOAT> .COMMUTE>
		 <SET OP1 .OP2>
		 <SET OP2 .TMP>)>
	  <COND (<==? .DEST STACK>
		 <SET USE-3 T>
		 <EMIT-PUSH <TYPE-WORD .TYP> LONG>)
		(<TYPE? .OP1 FIX FLOAT> <SET USE-3 T>)
		(<AND <TYPE? .OP1 VARTBL>
		      <SET VAC <VAR-VALUE-IN-AC? .OP1>>
		      <OR <AND <AVAILABLE? .VAC> <PROG ()
						       <MUNG-AC .VAC>
						       1>>
			  <AND <==? .OP1 .DEST>
			       <==? <LENGTH <AC-VARS .VAC>> 1>>>>)
		(<AND <TYPE? .OP2 VARTBL>
		      <SET VAC <VAR-VALUE-IN-AC? .OP2>>
		      <AVAILABLE? .VAC>>
		 <MUNG-AC .VAC>
		 <COND (.COMMUTE <SET OP1 .OP2> <SET OP2 .TMP>)
		       (ELSE <SET USE-3 T>)>)
		(ELSE <SET VAC <>> <COND (<N==? .OP1 .DEST> <SET USE-3 T>)>)>
	  <COND (<AND <TYPE? .OP2 FIX>
		      <L? .OP2 0>
		      <G? .OP2 -64>
		      <OR <==? .OP-2-ARG ,INST-SUBL2>
			  <==? .OP-2-ARG ,INST-ADDL2>>>
		 <SET OP2 <- .OP2>>
		 <COND (<==? .OP-2-ARG ,INST-SUBL2>
			<SET OP-2-ARG ,INST-ADDL2>
			<SET OP-3-ARG ,INST-ADDL3>)
		       (ELSE
			<SET OP-2-ARG ,INST-SUBL2>
			<SET OP-3-ARG ,INST-SUBL3>)>)>
	  <COND (<AND .USE-3
		      <OR <==? .OP1 0> <==? .OP1 0.0000000> <==? .OP1 -1>>
		      <OR <AND <==? .OP-2-ARG ,INST-SUBL2>
			       <OR <AND <==? .OP1 -1>
					<SET OP-2-ARG ,INST-MCOML>>
				   <SET OP-2-ARG ,INST-MNEGL>>>
			  <AND <==? .OP-2-ARG ,INST-SUBF2>
			       <SET OP-2-ARG ,INST-MNEGF>>>>
		 <EMIT .OP-2-ARG
		       <COND (.VAC <MA-REG .VAC>)
			     (ELSE <VAR-VALUE-ADDRESS .OP2>)>
		       <COND (<==? .DEST STACK> <SET VAC <>> <MA-AINC ,AC-TP>)
			     (.VAC <MA-REG .VAC>)
			     (ELSE <MA-REG <SET VAC <GET-AC PREF-VAL T>>>)>>)
		(<AND <==? .OP2 1>
		      <OR <NOT .USE-3> <==? .DEST .OP1>>
		      <OR <AND <==? .OP-2-ARG ,INST-ADDL2>
			       <SET OP-2-ARG ,INST-INCL>>
			  <AND <==? .OP-2-ARG ,INST-SUBL2>
			       <SET OP-2-ARG ,INST-DECL>>>>
		 <COND (<AND <NOT .VAC> <SET VAC <VAR-VALUE-IN-AC? .OP1>>>
			<MUNG-AC .VAC>)>
		 <EMIT .OP-2-ARG
		       <COND (.VAC <MA-REG .VAC>)
			     (ELSE <VAR-VALUE-ADDRESS .OP1>)>>)
		(.USE-3
		 <EMIT .OP-3-ARG
		       <COND (<TYPE? .OP2 FIX> <MA-IMM .OP2>)
			     (<TYPE? .OP2 FLOAT>
			      <FLOAT-IMM <FLOATCONVERT .OP2>>)
			     (.VAC <MA-REG .VAC>)
			     (ELSE <VAR-VALUE-ADDRESS .OP2>)>
		       <COND (<TYPE? .OP1 FIX> <MA-IMM .OP1>)
			     (<TYPE? .OP1 FLOAT>
			      <FLOAT-IMM <FLOATCONVERT .OP1>>)
			     (ELSE <VAR-VALUE-ADDRESS .OP1>)>
		       <COND (<==? .DEST STACK> <SET VAC <>> <MA-AINC ,AC-TP>)
			     (.VAC <MA-REG .VAC>)
			     (ELSE <MA-REG <SET VAC <GET-AC PREF-VAL T>>>)>>)
		(ELSE
		 <COND (<AND <NOT .VAC> <SET VAC <VAR-VALUE-IN-AC? .OP1>>>
			<MUNG-AC .VAC>)>
		 <EMIT .OP-2-ARG
		       <COND (<TYPE? .OP2 FIX> <MA-IMM .OP2>)
			     (<TYPE? .OP2 FLOAT>
			      <FLOAT-IMM <FLOATCONVERT .OP2>>)
			     (ELSE <VAR-VALUE-ADDRESS .OP2>)>
		       <COND (.VAC <MA-REG .VAC>)
			     (ELSE <VAR-VALUE-ADDRESS .OP1>)>>)>)>
   <COND (.VAC <DEST-DECL .VAC .DEST .TYP>)>
   NORMAL>

<DEFINE ADDFIX-GEN (OP1 OP2 DEST "OPTIONAL" (HINT <>)) 
	#DECL ((OP1 OP2) <OR FIX VARTBL> (DEST) <OR VARTBL ATOM>)
	<ARITH-GEN ,INST-ADDL2 ,INST-ADDL3 .OP1 .OP2 .DEST T ,+ FIX>>

<DEFINE LESSFIX-GEN (VAL1 VAL2 DIR LABEL "OPT" (HINT <>) "AUX" (TYP <>)) 
	#DECL ((VAL1 VAL2) <OR VARTBL <PRIMTYPE FIX>> (DIR LABEL) ATOM)
	<COND (.HINT <SET TYP <PARSE-HINT .HINT TYPE>>)>
	<COND (<AND <NOT .TYP>
		    <NOT <AND <NOT <TYPE? .VAL1 VARTBL>>
			      <0? .VAL1>>>
		    <NOT <AND <NOT <TYPE? .VAL2 VARTBL>>
			      <0? .VAL2>>>>
	       <SET TYP FIX>)>
	<COMP-GEN .VAL1 .VAL2 .DIR .LABEL ,CLT-CODE .TYP>>

<DEFINE GTFIX-GEN (VAL1 VAL2 DIR LABEL "OPT" (HINT <>) "AUX" (TYP <>)) 
	#DECL ((VAL1 VAL2) <OR VARTBL <PRIMTYPE FIX>> (DIR LABEL) ATOM)
	<COND (.HINT <SET TYP <PARSE-HINT .HINT TYPE>>)>
	<COND (<AND <NOT .TYP>
		    <NOT <AND <NOT <TYPE? .VAL1 VARTBL>>
			      <0? .VAL1>>>
		    <NOT <AND <NOT <TYPE? .VAL2 VARTBL>>
			      <0? .VAL2>>>>
	       <SET TYP FIX>)>
	<COMP-GEN .VAL1 .VAL2 .DIR .LABEL ,CGT-CODE .TYP>>

<DEFINE VEQUAL-GEN (VAL1 VAL2 DIR LABEL "OPT" (HINT <>) "AUX" (TYP <>)) 
	#DECL ((VAL1 VAL2) ANY (DIR LABEL) ATOM)
	<COND (.HINT <SET TYP <PARSE-HINT .HINT TYPE>>)>
	<COND (<NOT .TYP> <SET TYP FIX>)>
	<COMP-GEN .VAL1 .VAL2 .DIR .LABEL ,CEQ-CODE .TYP>>

<DEFINE EQUAL-GEN (VAL1 VAL2 DIR LABEL
		   "AUX" FVAL DCL VAC ELABEL MOFF TAC DCL1 TY-AD TMP)
	#DECL ((VAL1) VARTBL (VAL2) ANY (DIR LABEL) ATOM)
	<SET ELABEL <MAKE-LABEL T>>
	<COND (<TYPE? .VAL2 VARTBL>
	       <COND (<AND <SET DCL <VARTBL-DECL .VAL1>>
			   <SET DCL1 <VARTBL-DECL .VAL2>>
			   <==? <CLEAN-DECL .DCL> <CLEAN-DECL .DCL1>>>
		      ; "no type comparison needed"
		      <VEQUAL-GEN .VAL1 .VAL2 .DIR .LABEL>)
		     (ELSE <VAR-EQUAL-GEN .VAL1 .VAL2 .DIR .LABEL .ELABEL>)>)
	      (<SET DCL <VARTBL-DECL .VAL1>>
	       <COND (<AND <==? <CLEAN-DECL .DCL> <TYPE .VAL2>>
			   <NOT <SAFE-TYPE-WORD? .VAL1>>>
		      ; "No type comparison"
		      <VEQUAL-GEN .VAL1 .VAL2 .DIR .LABEL>)
		     (<ERROR "NOT EQUAL" EQUAL-GEN>)>)
	      (<SET FVAL <FIX-CONSTANT? .VAL2>>
	       <GEN-COMP-INST <VAR-VALUE-ADDRESS .VAL1> <MA-IMM .FVAL> LONG>
	       <SET TY-AD <VAR-TYPE-ADDRESS .VAL1>>
	       <COND (<==? .DIR -> <GEN-BRANCH ,INST-BNEQ .LABEL <>>)
		     (<GEN-BRANCH ,INST-BNEQ .ELABEL <>>)>
	       <GEN-COMP-INST .TY-AD <TYPE-CODE <TYPE .VAL2> WORD> WORD>
	       <COND (<==? .DIR -> <GEN-BRANCH ,INST-BNEQ .LABEL <>>)
		     (<GEN-BRANCH ,INST-BEQL .LABEL <>>)>
	       <GEN-LABEL .ELABEL NORMAL>)
	      (ELSE
	       ; "Compare with structured constant"
	       <SET VAC <VAR-VALUE-IN-AC? .VAL1>>
	       <SET TAC <VAR-TYPE-WORD-IN-AC? .VAL1>>
	       <GEN-COMP-INST <VAR-TYPE-ADDRESS .VAL1>
			      <TYPE-CODE <TYPE .VAL2> WORD>
			      WORD>
	       <SET TY-AD <VAR-VALUE-ADDRESS .VAL1>>
	       <COND (<==? .DIR -> <GEN-BRANCH ,INST-BNEQ .LABEL <>>)
		     (<GEN-BRANCH ,INST-BNEQ .ELABEL <>>)>
	       <GEN-COMP-INST .TY-AD
			      <ADDR-VALUE-MQUOTE .VAL2>
			      LONG>
	       <COND (<==? .DIR -> <GEN-BRANCH ,INST-BNEQ .LABEL <>>)
		     (<GEN-BRANCH ,INST-BEQL .LABEL <>>)>
	       <GEN-LABEL .ELABEL NORMAL>)>
	<CLEAR-STATUS>
	NORMAL>

<DEFINE VAR-EQUAL-GEN (VAR1 VAR2 DIR LABEL ELABEL
		       "AUX" (DCL <VARTBL-DECL .VAR2>) TVAR
			     (DCL1 <VARTBL-DECL .VAR1>) TAC CAC VAC
			     OK1? OK2?)
	#DECL ((VAR1 VAR2) VARTBL (DIR LABEL) ATOM (ELABEL) ATOM)
	<COND (.DCL
	       <AND .DCL1
		    <N==? <CLEAN-DECL .DCL> <CLEAN-DECL .DCL1>>
		    <ERROR "NOT EQUAL" VAR-EQUAL-GEN>>
	       <SET TVAR .VAR2>
	       <SET VAR2 .VAR1>
	       <SET VAR1 .TVAR>
	       <SET TVAR .DCL>
	       <SET DCL .DCL1>
	       <SET DCL1 .TVAR>)>
	<SET VAC <VAR-VALUE-IN-AC? .VAR1>>
	<SET TAC <VAR-TYPE-WORD-IN-AC? .VAR1>>
	<SET OK1? <>>
	<SET OK2? <>>
	<COND (<SET OK1? <FRIENDLY-VAR? .VAR1 .TAC .VAC>>
	       <COND (<==? .OK1? AC> <SET OK1? <MA-REG .TAC>>)
		     (<SET OK1? <ADDR-VAR-TYPE .VAR1>>)>)>
	<SET TAC <VAR-TYPE-WORD-IN-AC? .VAR2>>
	<SET VAC <VAR-VALUE-IN-AC? .VAR2>>
	<GEN-COMP-INST <VAR-VALUE-ADDRESS .VAR1>
		       <VAR-VALUE-ADDRESS .VAR2>
		       LONG>
	<COND (<==? .DIR -> <GEN-BRANCH ,INST-BNEQ .LABEL <> <> <> T>)
	      (ELSE <GEN-BRANCH ,INST-BNEQ .ELABEL <> <> <> T>)>
	<COND (<AND ,GC-MODE <OR <NOT .DCL> <NOT .DCL1>>>
	       <EMIT ,INST-XORW3
		     <COND (.DCL <TYPE-CODE .DCL>)
			   (ELSE <VAR-TYPE-ADDRESS .VAR2>)>
		     <COND (.DCL1 <TYPE-CODE .DCL1>)
			   (ELSE <VAR-TYPE-ADDRESS .VAR1>)>
		     <MA-REG <SET TAC <GET-AC PREF-TYPE T>>>>
	       <EMIT ,INST-BICW2 <MA-WORD-IMM ,SHORT-TYPE-MASK>
		     <MA-REG .TAC>>)
	      (<OR <NOT .DCL> <NOT .DCL1>>
	       <GEN-COMP-INST
		<COND (.DCL1 <TYPE-CODE .DCL1>)
		      (ELSE <VAR-TYPE-ADDRESS .VAR1>)>
		<COND (.DCL <TYPE-CODE .DCL>)
		      (ELSE <VAR-TYPE-ADDRESS .VAR2>)>
		WORD>)>
	<COND (<==? .DIR -> <GEN-BRANCH ,INST-BNEQ .LABEL <>>)
	      (<GEN-BRANCH ,INST-BEQL .LABEL <>>)>
	<GEN-LABEL .ELABEL NORMAL>
	T>

<DEFINE FRIENDLY-VAR? (VAR TAC VAC)
  #DECL ((VAR) VARTBL (TAC VAC) <OR AC FALSE>)
  <COND (<AND <NOT .VAC> <NOT .TAC>>)
	(<AND .TAC .VAC <==? .VAC <NEXT-AC .TAC>>>
	 AC)
	(<AND <NOT .TAC> <AC-VAR-STORED? .VAR .VAC>>
	 T)
	(<AND <NOT .VAC> <AC-VAR-STORED? .VAR .TAC>>
	 T)>>

<DEFINE COMP-GEN (VAL1 VAL2 DIR LABEL MODE "OPT" (TYP FIX) "AUX" BRANCH-CODE) 
	#DECL ((VAL1 VAL2) ANY (DIR LABEL) ATOM (MODE) FIX
	       (TYP) <OR FALSE ATOM>)
	<SET BRANCH-CODE <COMPUTE-DIRECTION .DIR .MODE>>
	<COND (<NOT <TYPE? .VAL1 VARTBL>>
	       <CONST-COMP-GEN .VAL1 .VAL2 .LABEL <REVERSE-BC .BRANCH-CODE>
			       .TYP>)
	      (<NOT <TYPE? .VAL2 VARTBL>>
	       <CONST-COMP-GEN .VAL2 .VAL1 .LABEL .BRANCH-CODE .TYP>)
	      (<VAR-COMP-GEN .VAL1 .VAL2 .LABEL .BRANCH-CODE .TYP>)>
	<CLEAR-STATUS>
	NORMAL>

<DEFINE CONST-COMP-GEN (CONST VAR LABEL DIRCODE "OPT"  (TYP FIX)
			"AUX" FIXCONST VAC CADDR) 
	#DECL ((CONST) ANY (VAR) VARTBL (LABEL) ATOM (DIRCODE) FIX
	       (TYP) <OR FALSE ATOM>)
	<COND (<SET FIXCONST <FIX-CONSTANT? .CONST>>
	       <COND (<0? .FIXCONST> <ZERO-TEST-GEN .VAR .DIRCODE .LABEL .TYP>)
		     (<SET VAC <VAR-VALUE-IN-AC? .VAR>>
		      <GEN-COMP-INST <MA-REG .VAC>
				     <COND (<TYPE? .CONST FLOAT>
					    <FLOAT-IMM <FLOATCONVERT .CONST>>)
					   (ELSE <MA-IMM .FIXCONST>)> LONG
				     .TYP>
		      <GEN-TEST-INST .DIRCODE .LABEL <>>)
		     (ELSE
		      <GEN-COMP-INST <ADDR-VAR-VALUE .VAR>
				     <COND (<TYPE? .CONST FLOAT>
					    <FLOAT-IMM <FLOATCONVERT .CONST>>)
					   (ELSE <MA-IMM .FIXCONST>)>
				     LONG .TYP>
		      <GEN-TEST-INST .DIRCODE .LABEL <>>)>)
	      (ELSE
	       <GEN-COMP-INST <VAR-VALUE-ADDRESS .VAR>
			      <ADDR-VALUE-MQUOTE .CONST> LONG
			      .TYP>
	       <GEN-TEST-INST .DIRCODE .LABEL <>>)>>

<SETG COMP-TABLE <UVECTOR ,COND-CODE-LT ,COND-CODE-EQ ,COND-CODE-GT>>

<SETG NCOMP-TABLE <UVECTOR ,COND-CODE-GE ,COND-CODE-NE ,COND-CODE-LE>>

<COND (<NOT <GASSIGNED? REVERSE-TABLE>><SETG REVERSE-TABLE <IUVECTOR 15 0>>)>

<DEFINE MAKE-REVERSE (CODE REV-CODE) <PUT ,REVERSE-TABLE .CODE .REV-CODE>>

<COND (<NOT <GASSIGNED? BRANCHES>><SETG BRANCHES <IUVECTOR 16 0>>)>

<GDECL (BRANCHES) <UVECTOR [REST FIX]>>

<DEFINE INIT-BRANCH-TABLES ("AUX" (B ,BRANCHES)) 
	#DECL ((B) <UVECTOR [REST FIX]>)
	<MAKE-REVERSE ,COND-CODE-EQ ,COND-CODE-EQ>
	<MAKE-REVERSE ,COND-CODE-NE ,COND-CODE-NE>
	<MAKE-REVERSE ,COND-CODE-LE ,COND-CODE-GE>
	<MAKE-REVERSE ,COND-CODE-LT ,COND-CODE-GT>
	<MAKE-REVERSE ,COND-CODE-GE ,COND-CODE-LE>
	<MAKE-REVERSE ,COND-CODE-GT ,COND-CODE-LT>
	<MAPF <>
	      <FUNCTION (L) 
		      #DECL ((L) <LIST FIX FIX>)
		      <PUT .B <+ <1 .L> 1> <2 .L>>>
	      ((,COND-CODE-EQ ,INST-BEQL)
	       (,COND-CODE-NE ,INST-BNEQ)
	       (,COND-CODE-LE ,INST-BLEQ)
	       (,COND-CODE-LT ,INST-BLSS)
	       (,COND-CODE-GT ,INST-BGTR)
	       (,COND-CODE-GE ,INST-BGEQ)
	       (,COND-CODE-ALWAYS ,INST-BRB))>>

<DEFINE COMPUTE-DIRECTION (DIR MODE) 
	#DECL ((DIR) ATOM (MODE) FIX)
	<COND (<==? .DIR +> <NTH ,COMP-TABLE .MODE>)
	      (<==? .DIR -> <NTH ,NCOMP-TABLE .MODE>)
	      (<ERROR "BAD DIRECTION" .DIR COMPUTE-DIRECTION>)>>

<DEFINE REVERSE-BC (MODE) #DECL ((MODE) FIX) <NTH ,REVERSE-TABLE .MODE>>

<DEFINE ZERO-TEST-GEN (VAR DIRCODE LABEL "OPT" (TYP FIX)
		       "AUX" STATUS? (VADDR <VAR-VALUE-ADDRESS .VAR>) VAC
			     B1 B2 TAC)
	#DECL ((VAR) VARTBL (DIRCODE) FIX (LABEL) ATOM (TYP) <OR ATOM FALSE>)
	<COND (<NOT .TYP> <SET TYP <VARTBL-DECL .VAR>>)>
	<COND (<OR <NOT <SET STATUS? <STATUS? .VAR VALUE>>> <NOT .TYP>>
	       <COND (.TYP
		      <EMIT <COND (<==? .TYP FIX> ,INST-TSTL)
				  (ELSE ,INST-TSTF)> .VADDR>
		      <GEN-TEST-INST .DIRCODE .LABEL .STATUS?>)
		     (ELSE
		      <COND (<OR <SET TAC <VAR-TYPE-IN-AC? .VAR>>
				 <SET TAC <VAR-TYPE-WORD-IN-AC? .VAR>>
				 ,GC-MODE>
			     <COND (<NOT .TAC>
				    <SET TAC <LOAD-VAR .VAR TYPE <> TYPE>>)>
			     <GEN-COMP-INST <MA-REG .TAC>
					    <TYPE-CODE FIX FIX>
					    WORD>)
			    (ELSE
			     <EMIT ,INST-CMPW <VAR-TYPE-ADDRESS .VAR>
				   <TYPE-CODE FIX FIX>>
			     <CLEAR-STATUS>)>
		      <GEN-BRANCH ,INST-BEQL <SET B1 <MAKE-LABEL T>> <>
				  <> <> T>
		      <EMIT ,INST-TSTF .VADDR>
		      <GEN-TEST-INST .DIRCODE .LABEL .STATUS?>
		      <GEN-BRANCH ,INST-BRB <SET B2 <MAKE-LABEL T>> <>
				  <> <> T>
		      <GEN-LABEL .B1 NORMAL>
		      <EMIT ,INST-TSTL .VADDR>
		      <GEN-TEST-INST .DIRCODE .LABEL .STATUS?>
		      <GEN-LABEL .B2 NORMAL>)>)
              (ELSE
               <GEN-TEST-INST .DIRCODE .LABEL .STATUS?>)>>

<DEFINE GEN-TEST-INST (DIRCODE LABEL STATUS?) 
	#DECL ((DIRCODE) FIX (LABEL) ATOM (STATUS?) ANY)
	<GEN-BRANCH <NTH ,BRANCHES <+ .DIRCODE 1>> .LABEL .STATUS?>>

<DEFINE GEN-COMP-INST (VAR ADDR "OPT" (SZ LONG) (TYP FIX) "AUX" VADDR) 
	#DECL ((VAC) AC (SZ) ATOM)
	<EMIT <COND (<==? .SZ LONG>
		     <COND (<==? .TYP FIX> ,INST-CMPL)
			   (ELSE ,INST-CMPF)>)
		    (<==? .SZ WORD> ,INST-CMPW)
		    (<==? .SZ BYTE> ,INST-CMPB)
		    (ELSE <ERROR "BAD SIZE" .SZ>)>
	      .VAR
	      .ADDR>>

<DEFINE VAR-COMP-GEN (VAR1 VAR2 LABEL DIR "OPT" (TYP FIX) "AUX" VAC) 
	#DECL ((VAR1 VAR2) VARTBL (LABEL) ATOM (DIR) FIX)
	<COND (<SET VAC <VAR-VALUE-IN-AC? .VAR1>>
	       <VAR-AC-COMP .VAR2 .VAC .LABEL .DIR .TYP>)
	      (<SET VAC <VAR-VALUE-IN-AC? .VAR2>>
	       <VAR-AC-COMP .VAR1 .VAC .LABEL <REVERSE-BC .DIR> .TYP>)
	      (ELSE
	       <EMIT <COND (<==? .TYP FIX> ,INST-CMPL)(ELSE ,INST-CMPF)>
		     <VAR-VALUE-ADDRESS .VAR1>
		     <VAR-VALUE-ADDRESS .VAR2>>
	       <GEN-TEST-INST .DIR .LABEL <>>)>>

<DEFINE VAR-AC-COMP (VAR AC LABEL DIR "OPT" (TYP FIX)
		     "AUX" (VADDR <VAR-VALUE-ADDRESS .VAR>)) 
	#DECL ((VAR) VARTBL (AC) AC (LABEL) ATOM (DIR) FIX)
	<GEN-COMP-INST <MA-REG .AC> .VADDR LONG .TYP>
	<GEN-TEST-INST .DIR .LABEL <>>>

<MSETG 32MIN 2147483647>

<MSETG 32MAX <CHTYPE #WORD *020000000001* FIX>>

<DEFINE FIX-CONSTANT? (CONST) 
	#DECL ((CONST) ANY)
	<COND (<TYPE? .CONST FLOAT> <FLOATCONVERT .CONST>)
	      (<==? <TYPEPRIM <TYPE .CONST>> FIX>
	       <SET CONST <CHTYPE .CONST FIX>>
	       <COND (<==? .CONST <CHTYPE <MIN> FIX>> ,32MIN)
		     (<==? .CONST <CHTYPE <MAX> FIX>> ,32MAX)
		     (.CONST)>)
	      (<AND <==? <TYPEPRIM <TYPE .CONST>> LIST> <EMPTY? .CONST>> 0)>>

<DEFINE FLOATCONVERT (CNS "AUX" RES) 
	#DECL ((CNS) <OR FIX FLOAT>)
	<COND (<==? .CNS 0.0000000> 0)
	      (ELSE
	       <IFSYS
		("VAX"
		 <CHTYPE .CNS FIX>)
		("TOPS20"
		 <COND
		  (<G? .CNS 1E38>
		   ; "Biggest possible VAX float"
		   *37777677777*)
		  (<L? .CNS -1E38>
		   ; "Smallest possible VAX float"
		   *37777777777*)
		  (T
		   <SET RES
		    <COND (<L? .CNS 0.0000000> <PUTBITS 0 <BITS 1 15> 1>)
			  (ELSE 0)>>
		   <SET CNS <CHTYPE <ABS .CNS> FIX>>
		   <COND (<NOT <0? <CHTYPE <ANDB .CNS 4> FIX>>>
			  <SET CNS <+ .CNS 8>>)>
		   <SET RES
		    <PUTBITS .RES <BITS 8 7> <GET-FIELD .CNS <BITS 8 27>>>>
		   <SET RES <PUTBITS .RES <BITS 16 16>
				     <GET-FIELD .CNS <BITS 16 2>>>>
		   <CHTYPE <PUTBITS .RES <BITS 7> <GET-FIELD .CNS <BITS 7 19>>>
			   FIX>)>)>)>>

<DEFINE FLOAT-IMM (X) #DECL ((X) FIX)
	<COND (<AND <0? <CHTYPE <ANDB .X *777777736017*> FIX>>
		    <NOT <0? <CHTYPE <ANDB .X *40000*> FIX>>>>
	       <MA-IMM <CHTYPE <GETBITS .X <BITS 6 4>> FIX>>)
	      (ELSE <MA-IMM .X>)>>

<DEFINE SUBFIX-GEN (OP1 OP2 DEST "OPTIONAL" (HINT <>)) 
	#DECL ((OP1 OP2) <OR FIX VARTBL> (DEST) <OR VARTBL ATOM>)
	<ARITH-GEN ,INST-SUBL2 ,INST-SUBL3 .OP1 .OP2 .DEST <> ,- FIX>>

<DEFINE TYPE-TST-GEN (VAR TNAME DIR DEST "AUX" TAC DCL) 
   #DECL ((VAR) VARTBL (DIR) ATOM (LABEL) <OR ATOM SPEC-LABEL>
	  (TNAME) <OR ATOM VARTBL>)
   <COND
    (<AND <SET DCL <VARTBL-DECL .VAR>>
	  <NOT <==? <CLEAN-DECL .TNAME> UNBOUND>>
	  <NOT <==? .TNAME T$UNBOUND>>
	  <NOT <SAFE-TYPE-WORD? .VAR>>>
     <ERROR "WARNING: TYPE KNOWN" <VARTBL-NAME .VAR>>
     <COND (<AND <==? .TNAME .DCL> <==? .DIR +>>
	    <GEN-BRANCH ,INST-BBR .DEST <>>)
	   (<AND <N==? .TNAME .DCL> <==? .DIR ->>
	    <GEN-BRANCH ,INST-BBR .DEST <>>)>)
    (ELSE
     <COND (<OR <SET TAC <VAR-TYPE-IN-AC? .VAR>>
		<SET TAC <VAR-TYPE-WORD-IN-AC? .VAR>>
		<NOT <MEMQ .TNAME ,TYPE-WORDS>>
		,GC-MODE>
	    <COND (<NOT .TAC>
		   <SET TAC <LOAD-VAR .VAR TYPE <> TYPE>>)>
	    <COND (<TYPE? .TNAME VARTBL>
		   <GEN-COMP-INST <MA-REG .TAC>
				  <VAR-VALUE-ADDRESS .TNAME>
				  WORD>)
		  (<GEN-COMP-INST <MA-REG .TAC>
				  <TYPE-CODE .TNAME FIX>
				  WORD>)>)
	   (<OR <==? .TNAME T$UNBOUND> <==? <CLEAN-DECL .TNAME> UNBOUND>>
	    <EMIT ,INST-TSTW <VAR-TYPE-ADDRESS .VAR>>
	    <CLEAR-STATUS>)
	   (ELSE
	    <EMIT ,INST-CMPW <VAR-TYPE-ADDRESS .VAR> <TYPE-CODE .TNAME FIX>>
	    <CLEAR-STATUS>)>
     <COND (<==? .DIR +> <GEN-BRANCH ,INST-BEQL .DEST <>>)
	   (<GEN-BRANCH ,INST-BNEQ .DEST <>>)>)>
   NORMAL>

<DEFINE MULFIX-GEN (OP1 OP2 DEST "OPTIONAL" (HINT <>)) 
	#DECL ((OP1 OP2) <OR FIX VARTBL> (DEST) <OR VARTBL ATOM>)
	<ARITH-GEN ,INST-MULL2 ,INST-MULL3 .OP1 .OP2 .DEST T ,* FIX>>

<DEFINE PWR2? (X) 
	#DECL ((X) FIX)
	<COND (<L? .X 0> <SET X <- .X>>)>
	<REPEAT ((Y 2) (CNT 1))
		<COND (<==? .Y .X> <RETURN .CNT>)
		      (<G? .Y .X> <RETURN <>>)
		      (<G? <SET CNT <+ .CNT 1>> 31> <RETURN <>>)>
		<SET Y <* .Y 2>>>>

<DEFINE DIVFIX-GEN (OP1 OP2 DEST "OPTIONAL" (HINT <>)) 
	#DECL ((OP1 OP2) <OR FIX VARTBL> (DEST) <OR VARTBL ATOM>)
	<ARITH-GEN ,INST-DIVL2 ,INST-DIVL3 .OP1 .OP2 .DEST <> ,/ FIX>>

<DEFINE MODFIX-GEN (ITM1 ITM2 RES "OPTIONAL" HINT "AUX" VAC (AC <>)
		    (LAB1 <MAKE-LABEL>) (LAB2 <MAKE-LABEL>)) 
	#DECL ((ITM1 ITM2) <OR VARTBL FIX> (RES) <OR ATOM VARTBL>)
	<SET VAC <GET-AC DOUBLE T>>
	<COND (<AND <TYPE? .ITM1 FIX>
		    <G=? .ITM1 0>
		    <L=? .ITM1 *77*>>
	       <EMIT ,INST-MOVQ <MA-IMM .ITM1> <MA-REG .VAC>>)
	      (<TYPE? .ITM1 FIX>
	       <EMIT ,INST-CLRL <MA-REG <NEXT-AC .VAC>>>
	       <LOAD-CONSTANT .VAC .ITM1>
	       <GEN-BRANCH ,INST-BGEQ .LAB1 <>>
	       <EMIT ,INST-MCOML <MA-LIT 0> <MA-REG <NEXT-AC .VAC>>>
	       <EMIT-LABEL .LAB1 T>)
	      (ELSE
	       <EMIT ,INST-CLRL <MA-REG <NEXT-AC .VAC>>>
	       <LOAD-VAR .ITM1 JUST-VALUE T .VAC>
	       <GEN-BRANCH ,INST-BGEQ .LAB1 <>>
	       <EMIT ,INST-MCOML <MA-LIT 0> <MA-REG <NEXT-AC .VAC>>>
	       <EMIT-LABEL .LAB1 T>)>
	<EMIT ,INST-EDIV
	      <COND (<TYPE? .ITM2 FIX> <MA-IMM .ITM2>)
		    (<SET AC <VAR-VALUE-IN-AC? .ITM2>> <MA-REG .AC>)
		    (ELSE <VAR-VALUE-ADDRESS .ITM2>)>	; "Divisor"
	      <MA-REG .VAC>		; "Dividend"
	      <MA-REG .VAC>		; "Quotient"
	      <MA-REG <NEXT-AC .VAC>>	; "Remainder">
	<EMIT ,INST-TSTL <MA-REG <NEXT-AC .VAC>>>
	<GEN-BRANCH ,INST-BGEQ .LAB2 <>>
	<EMIT ,INST-ADDL2 <COND (<TYPE? .ITM2 FIX> <MA-IMM .ITM2>)
				(.AC <MA-REG .AC>)
				(T <VAR-VALUE-ADDRESS .ITM2>)>
	      <MA-REG <NEXT-AC .VAC>>>
	<EMIT-LABEL .LAB2 T>
	<DEST-DECL <NEXT-AC .VAC> .RES FIX>
	NORMAL>

<DEFINE ADDF-GEN (OP1 OP2 DEST "OPTIONAL" (HINT <>)) 
	#DECL ((OP1 OP2) <OR FLOAT FIX VARTBL> (DEST) <OR VARTBL ATOM>)
	<ARITH-GEN ,INST-ADDF2 ,INST-ADDF3 .OP1 .OP2 .DEST T ,+ FLOAT>>

<DEFINE SUBF-GEN (OP1 OP2 DEST "OPTIONAL" (HINT <>)) 
	#DECL ((OP1 OP2) <OR FLOAT FIX VARTBL> (DEST) <OR VARTBL ATOM>)
	<ARITH-GEN ,INST-SUBF2 ,INST-SUBF3 .OP1 .OP2 .DEST <> ,- FLOAT>>

<DEFINE MULF-GEN (OP1 OP2 DEST "OPTIONAL" (HINT <>)) 
	#DECL ((OP1 OP2) <OR FLOAT FIX VARTBL> (DEST) <OR VARTBL ATOM>)
	<ARITH-GEN ,INST-MULF2 ,INST-MULF3 .OP1 .OP2 .DEST T ,* FLOAT>>

<DEFINE DIVF-GEN (OP1 OP2 DEST "OPTIONAL" (HINT <>)) 
	#DECL ((OP1 OP2) <OR FLOAT FIX VARTBL> (DEST) <OR VARTBL ATOM>)
	<ARITH-GEN ,INST-DIVF2 ,INST-DIVF3 .OP1 .OP2 .DEST <> ,/ FLOAT>>

<DEFINE FIX-GEN (VAL1 RES "OPTIONAL" HINT "AUX" VAC) 
	#DECL ((VAL1) VARTBL (RES) <OR ATOM VARTBL>)
	<COND (<AND <SET VAC <VAR-VALUE-IN-AC? .VAL1>> <AVAILABLE? .VAC>>
	       <EMIT ,INST-CVTFL <MA-REG .VAC> <MA-REG .VAC>>)
	      (ELSE
	       <EMIT ,INST-CVTFL
		     <COND (.VAC <MA-REG .VAC>)
			   (ELSE <VAR-VALUE-ADDRESS .VAL1>)>
		     <MA-REG <SET VAC <GET-AC PREF-VAL T>>>>)>
	<DEST-DECL .VAC .RES FIX>>

<DEFINE FLOAT-GEN (VAL1 RES "OPTIONAL" HINT "AUX" VAC) 
	#DECL ((VAL1) VARTBL (RES) <OR ATOM VARTBL>)
	<COND (<AND <SET VAC <VAR-VALUE-IN-AC? .VAL1>> <AVAILABLE? .VAC>>
	       <EMIT ,INST-CVTLF <MA-REG .VAC> <MA-REG .VAC>>)
	      (ELSE
	       <EMIT ,INST-CVTLF
		     <COND (.VAC <MA-REG .VAC>)
			   (ELSE <VAR-VALUE-ADDRESS .VAL1>)>
		     <MA-REG <SET VAC <GET-AC PREF-VAL T>>>>)>
	<DEST-DECL .VAC .RES FLOAT>>

<DEFINE RANDOM-GEN (VAL1 RES "OPTIONAL" HINT) 
	#DECL ((VAL1) VARTBL (RES) <OR ATOM VARTBL>)
	<CALL-RTE ,IRANDOM!-MIMOP CALL .RES FLOAT .VAL1>>