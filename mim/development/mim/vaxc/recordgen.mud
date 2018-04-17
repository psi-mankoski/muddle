
<DEFINE PUTR-GEN (VAR NUM VAL
		  "OPTIONAL" (HINT <>) (PHINT <>)
		  "AUX" RD ETYP VAC ACN TCOFF VADDR VVAC ANYCOFF VOFF STACK? A1
			LV RHINT)
   #DECL ((VAR) ANY (NUM) <OR FIX VARTBL> (VAL) ANY)
   <COND (<NOT <TYPE? .VAR VARTBL>> <SET HINT <TYPE .VAR>>)>
   <COND (.PHINT <SET PHINT <PARSE-HINT .PHINT TYPE>>)>
   <COND
    (<OR <TYPE? .NUM VARTBL> <NOT .HINT>>
     <CALL-RTE ,IPUTR!-MIMOP CALL <> <> .VAR .NUM .VAL>
     T)
    (ELSE
     <OR <SET RD <GET-RELE-DESCRIPTOR .NUM .HINT>>
	 <ERROR "RECORD TYPE NOT FOUND" .NUM .HINT PUTR-GEN>>
     ; "This crock causes the actual contents of FR to be saved when
	bindind UNWIND, so it can be restored by the kernel.  CFRAME
	saves a pointer to the real frame, which is by no means the
	same thing when MAKTUP-FLAG is set."
     <COND (<AND ,MAKTUP-FLAG
		 <==? .NUM 2>
		 <OR <==? .VAL UNWIND>
		     <==? .VAL T$UNWIND>>
		 <AND .HINT
		      <SET RHINT <PARSE-HINT .HINT RECORD-TYPE>>
		      <OR <==? .RHINT LBIND>
			  <==? .RHINT T$LBIND>>>>
	    <EMIT-PUSH <TYPE-WORD T$FRAME> LONG>
	    <EMIT-PUSH <MA-REG ,AC-F> LONG>)> 
     <SET STACK? <GET-RSTACK? .HINT>>
     <PROTECT-VAL .VAL>
     <COND (<TYPE? .VAR VARTBL> <SET VAC <LOAD-VAR .VAR VALUE <> PREF-VAL>>)
	   (ELSE <SET VAC <GET-AC PREF-VAL T>> <MOVE-VALUE .VAR .VAC>)>
     <PROTECT .VAC>
     <SET TCOFF <MA-DISP .VAC <RED-OFFSET-TYPCNT .RD>>>
     <SET ANYCOFF <MA-DISP .VAC <+ <RED-OFFSET-TYPCNT .RD> 2>>>
     <SET VOFF <MA-DISP .VAC <RED-OFFSET-VALUE .RD>>>
     <COND
      (<==? <SET ETYP <RED-KIND .RD>> ANY>
       <COND (<OR <FIX-CONSTANT? .VAL>
		  <AND <TYPE? .VAL VARTBL>
		       <SET LV <FIND-CACHE-VAR .VAL>>
		       <NOT <AND <LINKVAR-VALUE-STORED .LV>
				 <LINKVAR-TYPE-STORED .LV>
				 <LINKVAR-COUNT-STORED .LV>>>
		       <NOT <AND <SET A1 <LINKVAR-TYPE-WORD-AC .LV>>
				 <==? <LINKVAR-VALUE-AC .LV> <NEXT-AC .A1>>>>>>
	      <MOVE-VALUE .VAL .VOFF>
	      <MOVE-TYPE .VAL .TCOFF .ANYCOFF>)
	     (<TYPE? .VAL VARTBL>
	      <EMIT ,INST-MOVQ <VAR-TYPE-ADDRESS .VAL TYPE-WORD> .TCOFF>)
	     (ELSE <EMIT ,INST-MOVQ <ADDR-TYPE-MQUOTE .VAL> .TCOFF>)>)
      (<OR <==? .ETYP SMALL-INT> <==? .ETYP SMALL-POS-INT>>
       <COND (<TYPE? .VAL FIX> <EMIT-MOVE <MA-IMM .VAL> .VOFF WORD>)
	     (<TYPE? .VAL VARTBL>
	      <COND (<SET VVAC <VAR-VALUE-IN-AC? .VAL>>
		     <EMIT-MOVE <MA-REG .VVAC> .VOFF WORD>)
		    (ELSE
		     <SET VADDR <MA-DISP ,AC-F <+ <VARTBL-LOC .VAL> 2>>>
		     <EMIT-MOVE .VADDR .VOFF WORD>)>)
	     (<ERROR "BAD ARGUMENT" PUT-RECORD>)>)
      (<OR <==? .ETYP TYPE-C> <==? .ETYP VWORD1>>
       <COND
	(<RED-SBOOL .RD>
	 <COND (<OR <==? .VAL <>>
		    <AND <TYPE? .VAL VARTBL> <==? <VARTBL-DECL .VAL> FALSE>>
		    <==? .PHINT FALSE>>
		<COND (<==? .ETYP TYPE-C> <EMIT ,INST-MCOMW <MA-IMM 0> .VOFF>)
		      (ELSE <EMIT ,INST-CLRL .VOFF>)>)
	       (<OR <NOT <TYPE? .VAL VARTBL>> <VARTBL-DECL .VAL> .PHINT>
		<COND (<==? .ETYP TYPE-C>
		       <EMIT ,INST-MOVW
			     <COND (<TYPE? .VAL VARTBL>
				    <VAR-VALUE-ADDRESS .VAL>)
				   (ELSE <MA-IMM .VAL>)>
			     .VOFF>)
		      (ELSE <MOVE-VALUE .VAL .VOFF>)>)
	       (<TYPE? .VAL VARTBL>
		<TESTSET .VAL .VOFF <> <==? .ETYP TYPE-C>>)>)
	(ELSE <MOVE-VALUE .VAL .VOFF>)>)
      (<==? .ETYP COUNTVWORD>
       <COND (<AND <RED-SBOOL .RD>
		   <OR <==? .VAL <>>
		       <==? <VARTBL-DECL .VAR> FALSE>
		       <==? .PHINT FALSE>>>
	      <EMIT ,INST-CLRL .VOFF>
	      <EMIT ,INST-CLRW .TCOFF>)
	     (<TYPE? .VAL VARTBL>
	      <COND (<OR <NOT <RED-SBOOL .RD>> .PHINT <VARTBL-DECL .VAL>>
		     <MOVE-VALUE .VAL .VOFF>
		     <COUNT-STORE-REC .VAL .TCOFF>)
		    (ELSE <TESTSET .VAL .VOFF .TCOFF>)>)
	     (ELSE
	      <MOVE-VALUE .VAL .VOFF>
	      <EMIT-MOVE <MA-IMM <LENGTH .VAL>> .TCOFF WORD>)>)
      (<==? .ETYP BYTE>
       <COND (<TYPE? .VAL FIX> <EMIT-MOVE <MA-IMM .VAL> .VOFF BYTE>)
	     (ELSE <EMIT-MOVE <VAR-VALUE-ADDRESS .VAL> .VOFF BYTE>)>)
      (<==? .ETYP BOOLEAN> <TEST-BOOL .VOFF <RED-BIT-NUMBER .RD> .VAL>)>
     <CLEAR-STATUS>)>
   NORMAL>

<DEFINE TESTSET (VAR VADDR TCADDR "OPT" (HW <>) "AUX" ELAB FLAB) 
	#DECL ((VAR) VARTBL (VADDR) EFF-ADDR (TCADDR) <OR FIX FALSE EFF-ADDR>)
	<SET FLAB <MAKE-LABEL>>
	<TYPE-TST-GEN .VAR FALSE - .FLAB>
	<EMIT <COND (.HW ,INST-CLRW) (ELSE ,INST-CLRL)> .VADDR>
	<AND <TYPE? .TCADDR EFF-ADDR> <EMIT ,INST-CLRW .TCADDR>>
	<SET ELAB <MAKE-LABEL>>
	<GEN-BRANCH ,INST-BRB .ELAB <>>
	<EMIT-LABEL .FLAB <>>
	<EMIT-MOVE <VAR-VALUE-ADDRESS .VAR> .VADDR
		   <COND (.HW WORD) (ELSE LONG)>>
	<COND (<TYPE? .TCADDR EFF-ADDR>
	       <COUNT-STORE-REC .VAR .TCADDR>)>
	<EMIT-LABEL .ELAB <>>>

<DEFINE TEST-BOOL (VCADDR BITNO VAL "AUX" FLAB ELAB) 
	#DECL ((VCADDR) EFF-ADDR (BITNO) FIX (VAL) VARTBL)
	<SET FLAB <MAKE-LABEL>>
	<TYPE-TST-GEN .VAL FALSE - .FLAB>
	<EMIT ,INST-BICL2 .VCADDR <MA-IMM <CHTYPE <LSH 1 .BITNO> FIX>>>
	<SET ELAB <MAKE-LABEL>>
	<GEN-BRANCH ,INST-BRB .ELAB <>>
	<EMIT ,INST-BISL .VCADDR <MA-IMM <CHTYPE <LSH 1 .BITNO> FIX>>>
	<EMIT-LABEL .ELAB <>>>

<DEFINE NTH-RECORD-GEN (VAR OFF RES
			"OPTIONAL" (HINT1 <>) (HINT2 <>)
			"AUX" RD (BRANCH? <>) VAC ACN TCOFF ANYCOFF VOFF TYP
			      NTYP DAC ETYP STACK? AC-LOADED)
   #DECL ((VAR) ANY (OFF) <OR VARTBL FIX> (HINT2) <OR FALSE HINT>
	  (RES) <OR ATOM VARTBL>)
   <COND (<NOT <TYPE? .VAR VARTBL>> <SET HINT1 <TYPE .VAR>>)>
   <COND (<OR <NOT .HINT1> <TYPE? .OFF VARTBL>>
	  <CALL-RTE ,INTHR!-MIMOP CALL .RES <> .VAR .OFF>)
	 (ELSE
	  <OR <SET RD <GET-RELE-DESCRIPTOR .OFF .HINT1>>
	      <ERROR "RECORD TYPE NOT FOUND" .HINT1 .OFF NTH-RECORD-GEN>>
	  <SET STACK? <GET-RSTACK? .HINT1>>
	  <SET TYP <RED-OBJTYP .RD>>
	  <SET NTYP <AND .HINT2 <PARSE-HINT .HINT2 TYPE>>>
	  <COND (<N==? .RES STACK> <SET BRANCH? <GET-RELE-BRANCH? .HINT2>>)>
	  <COND (<TYPE? .VAR VARTBL>
		 <SET VAC <LOAD-VAR .VAR VALUE <> PREF-VAL>>)
		(ELSE <SET VAC <GET-AC VALUE T>> <MOVE-VALUE .VAR .VAC>)>
	  <PROTECT .VAC>
	  <SET TCOFF <MA-DISP .VAC <RED-OFFSET-TYPCNT .RD>>>
	  <SET ANYCOFF <MA-DISP .VAC <+ <RED-OFFSET-TYPCNT .RD> 2>>>
	  <SET VOFF <MA-DISP .VAC <RED-OFFSET-VALUE .RD>>>
	  <COND (<==? .VAR .RES>
		 <DEAD-VAR .VAR>)>
	  <COND (<==? <SET ETYP <RED-KIND .RD>> ANY>
		 <RANY-OFF .RES .TCOFF .VOFF .VAC>)
		(<AND <OR <==? .ETYP VWORD1> <==? .ETYP COUNTVWORD>> .BRANCH?>
		 <SET AC-LOADED <BRANCH-VALUE .VOFF .BRANCH? <RED-LENGTH .RD>>>
		 <GEN-NTH .VOFF
			  .TYP
			  .VAC
			  .RES
			  <RED-LENGTH .RD>
			  <>
			  <COND (<RED-LENGTH .RD> .AC-LOADED)>
			  <COND (<RED-LENGTH .RD> <NEXT-AC .AC-LOADED>)
				(ELSE .AC-LOADED)>>)
		(<AND <==? .ETYP TYPE-C> .BRANCH?>
		 <SET AC-LOADED <BRANCH-HW .VOFF .BRANCH?>>
		 <GEN-NTH .VOFF
			  .TYP
			  .VAC
			  .RES
			  <RED-LENGTH .RD>
			  T
			  <>
			  .AC-LOADED>)
		(<OR <==? .ETYP VWORD1> <==? .ETYP TYPE-C>>
		 <COND (<RED-SBOOL .RD>
			<TEST-NTH .VOFF
				  .TYP
				  .VAC
				  .RES
				  <RED-LENGTH .RD>
				  .NTYP
				  <==? .ETYP TYPE-C>>)
		       (<GEN-NTH .VOFF
				 .TYP
				 .VAC
				 .RES
				 <RED-LENGTH .RD>
				 <==? .ETYP TYPE-C>>)>)
		(<==? .ETYP COUNTVWORD>
		 <COND (<RED-SBOOL .RD>
			<TEST-NTH .VOFF .TYP .VAC .RES .TCOFF .NTYP>)
		       (<GEN-NTH .VOFF .TYP .VAC .RES .TCOFF>)>)
		(<==? .ETYP SMALL-FR-OFFSET>
		 <PROTECT <SET DAC <GET-AC PREF-VAL T>>>
		 <EMIT ,INST-CVTWL .VOFF <MA-REG .DAC>>
		 <EMIT ,INST-ADDL2 <MA-REG .VAC> <MA-REG .DAC>>
		 <DEST-DECL .DAC .RES T$LBIND>)
		(<OR <==? .ETYP SMALL-INT> <==? .ETYP SMALL-POS-INT>>
		 <PROTECT <SET DAC <GET-AC PREF-VAL T>>>
		 <COND (<==? .ETYP SMALL-INT>
			<EMIT ,INST-CVTWL .VOFF <MA-REG .DAC>>)
		       (ELSE <EMIT ,INST-MOVZWL .VOFF <MA-REG .DAC>>)>
		 <DEST-DECL .DAC .RES FIX>)
		(<==? .ETYP BYTE>
		 <PROTECT <SET DAC <GET-AC PREF-VAL T>>>
		 <EMIT ,INST-MOVZBL .VOFF <MA-REG .DAC>>
		 <DEST-DECL .DAC .RES FIX>)
		(<==? .ETYP BOOLEAN>
		 <COND (.BRANCH?
			<BOOL-NTH-BRANCH .VOFF <RED-BIT-NUMBER .RD> .BRANCH?>)
		       (<BOOL-NTH .VOFF <RED-BIT-NUMBER .RD> .RES>)>)>)>
   NORMAL>

<DEFINE BRANCH-VALUE (VADDR BRANCH? TWO? "AUX" AC) 
	#DECL ((VADDR) EFF-ADDR (BRANCH?) <LIST ATOM ATOM>)
	<SET AC <GET-AC <COND (.TWO? DOUBLE)(ELSE PREF-VAL)> T>>
	<EMIT ,INST-MOVL .VADDR
	      <MA-REG <COND (.TWO? <NEXT-AC .AC>)(ELSE .AC)>>>
	<COND (<==? <1 .BRANCH?> ->
	       <GEN-BRANCH ,INST-BNEQ <2 .BRANCH?> <>>)
	      (ELSE
	       <GEN-BRANCH ,INST-BEQL <2 .BRANCH?> <>>)>
	.AC>

<DEFINE BRANCH-HW (VADDR BRANCH? "AUX" (AC <GET-AC PREF-VAL T>)) 
	#DECL ((VADDR) EFF-ADDR (BRANCH?) <LIST ATOM ATOM>)
	<EMIT ,INST-CVTWL .VADDR <MA-REG .AC>>
	<COND (<==? <1 .BRANCH?> ->
	       <GEN-BRANCH ,INST-BGEQ <2 .BRANCH?> <>>)
	      (ELSE
	       <GEN-BRANCH ,INST-BLSS <2 .BRANCH?> <>>)>
	.AC>

<DEFINE RANY-OFF (RES TCOFF VOFF VAC "AUX" TAC) 
	#DECL ((RES) <OR ATOM VARTBL> (TCADDR VADDR) EFF-ADDR (VAC) AC)
	<COND (<==? .RES STACK> <EMIT-PUSH .TCOFF DOUBLE>)
	      (ELSE
	       <COND (<AND <N==? .VAC ,AC-0>
			   <NOT <AC-PROT <SET TAC <PREV-AC .VAC>>>>
			   <OR <ALL-DEAD? .TAC> <ALL-STORED? .TAC>>>
		      <MUNG-AC .VAC>
		      <GET-AC .TAC T>
		      <EMIT ,INST-MOVQ .TCOFF <MA-REG .TAC>>)
		     (ELSE
		      <PROTECT <SET TAC <GET-AC DOUBLE T>>>
		      <EMIT ,INST-MOVQ .TCOFF <MA-REG .TAC>>
		      <SET VAC <NEXT-AC .TAC>>)>
	       <DEST-PAIR .VAC .TAC .RES>)>>

<DEFINE TEST-NTH (VADDR TYP VAC RES CADDR HTYP
		  "OPT" (HW <>)
		  "AUX" FLAB ELAB RVAC RTAC VPUSH (TYPV <>))
   #DECL ((VADDR) EFF-ADDR (TYP) ATOM (VAC) AC (RES) <OR ATOM VARTBL>
	  (CADDR) <OR EFF-ADDR FALSE FIX> (HTYP) <OR FALSE ATOM>)
   <COND (<AND .TYP <SET TYPV <MEMQ .TYP ,TYPE-WORDS>>> <SET TYPV <2 .TYPV>>)>
   <COND (<TYPE? .RES VARTBL>
	  <COND (<OR <NOT .HTYP> .CADDR>
		 <SET RTAC <GET-AC DOUBLE T>>
		 <SET RVAC <NEXT-AC .RTAC>>
		 <PROTECT .RTAC>)
		(ELSE <SET RVAC <FIND-APP-AC .VAC .TYP>>)>
	  <PROTECT .RVAC>)>
   <SET ELAB <MAKE-LABEL>>
   <SET FLAB <MAKE-LABEL>>
   <COND (<NOT .HTYP>
	  <EMIT <COND (.HW ,INST-TSTW) (ELSE ,INST-TSTL)> .VADDR>
	  <GEN-BRANCH <COND (.HW ,INST-BGEQ) (ELSE ,INST-BNEQ)> .FLAB <>>
	  <COND (<==? .RES STACK>
		 <EMIT-PUSH <TYPE-WORD FALSE> LONG>
		 <CLEAR-PUSH>)
		(ELSE <MOVE-TYPE <> .RTAC> <MOVE-VALUE <> .RVAC>)>
	  <GEN-BRANCH ,INST-BRB .ELAB <>>
	  <EMIT-LABEL .FLAB <>>)>
   <COND
    (<==? .RES STACK>
     <COND (.CADDR
	    <COND (<TYPE? .CADDR FIX>
		   <COND (.TYPV
			  <SET VPUSH <CHTYPE <ORB .TYPV <LSH .CADDR 16>> FIX>>
			  <EMIT-PUSH <MA-IMM .VPUSH> LONG>)
			 (ELSE
			  <EMIT-PUSH <TYPE-CODE .TYP> WORD>
			  <EMIT-PUSH <MA-IMM .CADDR> WORD>)>)
		  (ELSE
		   <EMIT-PUSH <TYPE-CODE .TYP> WORD>
		   <EMIT-PUSH .CADDR WORD>)>)
	   (<EMIT-PUSH <TYPE-WORD .TYP> LONG>)>
     <COND (.HW <EMIT ,INST-MOVZWL .VADDR <MA-AINC ,AC-TP>>)
	   (ELSE <EMIT-PUSH .VADDR LONG>)>)
    (ELSE
     <COND
      (<NOT .HTYP>
       <COND
	(<AND <TYPE? .CADDR FIX> <TYPE? .TYPV FIX>>
	 <SET VPUSH <CHTYPE <ORB .TYPV <LSH .CADDR 16>> FIX>>
	 <LOAD-CONSTANT .RTAC .VPUSH>)
	(ELSE
	 <COND
	  (.CADDR
	   <COND (<TYPE? .CADDR FIX>
		  <LOAD-CONSTANT .RTAC <MA-IMM <CHTYPE <LSH .CADDR 16> FIX>>>
		  <EMIT ,INST-MOVW <TYPE-CODE .TYP> <MA-REG .RTAC>>)
		 (ELSE <EMIT ,INST-MOVL .CADDR <MA-REG .RTAC>>)>)
	  (ELSE <EMIT ,INST-MOVL <TYPE-WORD .TYP> <MA-REG .RTAC>>)>
	 <USE-AC .RTAC>)>)
      (ELSE
       <COND (<TYPE? .CADDR FIX> <LOAD-CONSTANT .RTAC .CADDR>)
	     (.CADDR <MOVE-TO-AC .RTAC .CADDR WORD>)>)>
     <COND (.HW <EMIT ,INST-MOVZWL .VADDR <MA-REG .RVAC>>)
	   (ELSE <EMIT-MOVE .VADDR <MA-REG .RVAC> LONG>)>)>
   <COND (<NOT .HTYP>
	  <EMIT-LABEL .ELAB <>>
	  <AND <TYPE? .RES VARTBL> <DEST-PAIR .RVAC .RTAC .RES>>)
	 (<TYPE? .RES VARTBL>
	  <COND (.CADDR <DEST-COUNT-DECL .RVAC .RTAC .RES .TYP>)
		(ELSE <DEST-DECL .RVAC .RES .TYP>)>)>>

<DEFINE FIND-APP-AC (VAC TYP "OPTIONAL" (RES <>)) 
	#DECL ((VAC) AC (TYP) <OR FALSE ATOM>)
	<COND (<OR <NOT .TYP> <STRUCTURED-TYPE? .TYP>>
	       <COND (<FREE-VALUE-AC? STORED> <GET-AC PREF-VAL T>)
		     (ELSE <MUNG-AC .VAC> .VAC)>)
	      (<GET-AC PREF-VAL T>)>>

<DEFINE GEN-NTH (VADDR TYP VAC RES CADDR
		 "OPT" (HW <>) (RTAC <>) (RVAC <>)
		 "AUX" VPUSH (NO-LOAD <>))
	#DECL ((VADDR) EFF-ADDR (TYP) ATOM (VAC) AC (RES) <OR ATOM VARTBL>
	       (CADDR) <OR EFF-ADDR FALSE FIX>)
	<COND (<==? .RES STACK>
	       <COND (<AND <TYPE? .CADDR FIX> <MEMQ .TYP ,TYPE-WORDS>>
		      <SET VPUSH
			   <CHTYPE <ORB <TYPE-CODE .TYP VALUE> <LSH .CADDR 16>>
				   FIX>>
		      <EMIT-PUSH <MA-IMM .VPUSH> LONG>)
		     (.CADDR
		      <EMIT-PUSH <TYPE-CODE .TYP> WORD>
		      <EMIT-PUSH .CADDR WORD>)
		     (<EMIT-PUSH <TYPE-WORD .TYP> LONG>)>
	       <COND (.HW <EMIT ,INST-MOVZWL .VADDR <MA-AINC ,AC-TP>>)
		     (ELSE <EMIT-PUSH .VADDR LONG>)>)
	      (ELSE
	       <COND (<AND <NOT .RTAC> .CADDR>
		      <SET RTAC <GET-AC DOUBLE T>>
		      <PROTECT <SET RVAC <NEXT-AC .RTAC>>>)
		     (<NOT .RVAC> <PROTECT <SET RVAC <FIND-APP-AC .VAC .TYP>>>)
		     (ELSE <SET NO-LOAD T>)>
	       <COND (.CADDR
		      <COND (<TYPE? .CADDR FIX> <LOAD-CONSTANT .RTAC .CADDR>)
			    (ELSE <EMIT ,INST-MOVZWL .CADDR <MA-REG .RTAC>>)>
		      <COND (<NOT .NO-LOAD>
			     <EMIT-MOVE .VADDR <MA-REG .RVAC> LONG>)>
		      <DEST-COUNT-DECL .RVAC .RTAC .RES .TYP>)
		     (<NOT .NO-LOAD>
		      <COND (.HW <EMIT ,INST-MOVZWL .VADDR <MA-REG .RVAC>>)
			    (ELSE
			     <EMIT-MOVE .VADDR <MA-REG .RVAC> LONG>)>
		      <DEST-DECL .RVAC .RES .TYP>)
		     (ELSE
		      <DEST-DECL .RVAC .RES .TYP>)>
	       <LOAD-AC .RVAC .VADDR>)>>

<DEFINE BOOL-NTH (VADDR BNO RES "AUX" ELAB FLAB RVAC RTAC) 
	#DECL ((VADDR) EFF-ADDR (BNO) FIX (RES) <OR ATOM VARTBL>
	       (BRANCH?) <OR LIST FALSE>)
	<SET ELAB <MAKE-LABEL>>
	<SET FLAB <MAKE-LABEL>>
	<COND (<TYPE? .RES VARTBL>
	       <SET RTAC <GET-AC PREF-TYPE>>
	       <SET RVAC <GET-AC PREF-VAL>>
	       <DEST-PAIR .RVAC .RTAC .RES>)>
	<GEN-BRANCH ,INST-BBC <MA-IMM .BNO> .VADDR  .FLAB <>>
	<COND (<==? .RES STACK>
	       <EMIT-PUSH <ADDR-TYPE-MQUOTE T> LONG>
	       <EMIT-PUSH <ADDR-VALUE-MQUOTE T> LONG>)
	      (ELSE <MOVE-TYPE T .RTAC> <MOVE-VALUE T .RVAC>)>
	<GEN-BRANCH ,INST-BRB .ELAB <>>
	<EMIT-LABEL .FLAB <>>
	<COND (<==? .RES STACK>
	       <EMIT-PUSH <TYPE-WORD FALSE> LONG>
	       <CLEAR-PUSH>)
	      (ELSE <MOVE-TYPE <> .RTAC> <MOVE-VALUE <> .RVAC>)>
	<EMIT-LABEL .ELAB <>>>

<DEFINE BOOL-NTH-BRANCH (VADDR BNO BRANCH) 
	#DECL ((VADDR) EFF-ADDR (BNO) FIX (BRANCH) <LIST ATOM ATOM>)
	<EMIT ,INST-BTST NO-SIZE-WORD .VADDR <EXTWORD-DATA .BNO>>
	<COND (<==? <1 .BRANCH> ->
	       <GEN-BRANCH ,INST-BBC <MA-IMM .BNO> .VADDR <2 .BRANCH> <>>)
	      (ELSE
	       <GEN-BRANCH ,INST-BBS <MA-IMM .BNO> .VADDR <2 .BRANCH> <>>)>>

<DEFINE COUNT-STORE-REC (VAL TCADDR "AUX" (LV <FIND-CACHE-VAR .VAL>) AC)
	#DECL ((VAL) VARTBL)
	<COND (<OR <NOT .LV>
		   <LINKVAR-COUNT-STORED .LV>
		   <LINKVAR-COUNT-AC .LV>>
	       <EMIT-MOVE <VAR-COUNT-ADDRESS .VAL> .TCADDR WORD>)
	      (<SET AC <LINKVAR-TYPE-WORD-AC .LV>>
	       <EMIT ,INST-ROTL <MA-BYTE-IMM 16> <MA-REG .AC>
		     <MA-REG <SET AC <GET-AC ANY-AC T>>>>
	       <EMIT-MOVE <MA-REG .AC> .TCADDR WORD>)>>
	       