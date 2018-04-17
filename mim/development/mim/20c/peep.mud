<COND (<NOT <GASSIGNED? WIDTH-MUNG>> <FLOAD "MIMOC20DEFS.MUD">)>

<SETG DONT-HACK T>

<SETG PEEP-CHANNEL <>>

<NEWTYPE OLD-AND-USELESS VECTOR>

<NEWTYPE LOCAL-NAME FIX>

<NEWTYPE CONSTANT FIX>

<NEWTYPE CONSTANT-LABEL FIX>

<NEWTYPE REF VECTOR>

<NEWTYPE INST VECTOR>

<NEWTYPE GFRM ATOM>

<NEWTYPE SGFRM ATOM>

<DEFINE REF-PRINT (R) #DECL ((R) REF)
	<PRIN1 <1 .R>>>



;"----------------------------------------------------------------------------"

<DEFINE PPOLE (CODE-L "TUPLE" T "AUX" (PREPREV <>) (PREVIOUS <>) ZERO) 
   #DECL ((T) <PRIMTYPE VECTOR>
	  (PREVIOUS) <SPECIAL <OR FALSE REF INST OLD-AND-USELESS>>
	  (CODE-L) LIST)
   <PRINTTYPE REF ,REF-PRINT>
   <GENERATE-CIRCULAR-REFERENCES .T>
   <MAPR <>
    <FUNCTION (NEW-T "AUX" (ITM <1 .NEW-T>) BACKLIST OPP REFERENCE NXT TMP) 
	    #DECL ((NEW-T) <SPECIAL <PRIMTYPE VECTOR>> 
		   (ITM) <OR INST REF OLD-AND-USELESS> (BACKLIST) LIST)
	    <COND (<TYPE? .ITM OLD-AND-USELESS>)
		  (<TYPE? .ITM REF>		      ;"Handling of references"
		   <DELETE-ADJACENT-REFS .NEW-T>
		   <COND (<UNCONDITIONAL-BRANCH? <2 .NEW-T>>
			  <BRANCH-CHAIN .NEW-T>)>
		   <SETG CIRC-LOOP?
			 <AND <GASSIGNED? LOOPTAGS> <MEMQ <1 .ITM> ,LOOPTAGS>>>
		   <COND (.PREPREV <POST-ACCESS .ITM .NEW-T>)>
		   <COND (<AND <EMPTY? <3 .ITM>>
			       <NOT <MEMQ <1 .ITM> ,LOCATIONS>>>
			  <PUT .NEW-T 1 <CHTYPE [<1 .NEW-T>] OLD-AND-USELESS>>)
			 (<AND <NOT ,DONT-HACK>
			       <NOT <2 .ITM>>
			       <TYPE? <1 .NEW-T> REF>
			       <1? <LENGTH <3 .ITM>>>>
			  <SINGLE-PATH-OPTIMIZE .T .NEW-T>)>)
		  (<UNCONDITIONAL-BRANCH? .ITM>
		   <SKIP-MODIFY .NEW-T .PREVIOUS .PREPREV>)
		  (<CONDITIONAL-BRANCH? .ITM>
		   <COND (<AND <NOT <EMPTY? <REST .NEW-T>>>
			       <UNCONDITIONAL-BRANCH? <2 .NEW-T>>
			       <==? <NTH .ITM <LENGTH .ITM>> <3 .NEW-T>>
			       <SET OPP <GETPROP <1 .ITM> OPPOSITE>>>
			  <SET REFERENCE <2 <2 .NEW-T>>>
			  <PUT <1 .NEW-T> 1 .OPP>
			  <PUT <1 .NEW-T> 3 .REFERENCE>
			  <PUT .REFERENCE 3 (<1 .NEW-T> !<3 .REFERENCE>)>
			  <PUT .NEW-T 2 <ELIMINATE <2 .NEW-T>>>)>)
		  (<AND <NOT ,DONT-HACK> <NOT ,CIRC-LOOP?> <MOVE? .ITM>>
		   <MOVE-CHECK .NEW-T .ITM>
		   <MOVE-NEEDED? .NEW-T .ITM>)
		  (<AND <==? <1 .ITM> PUSH>
			<TYPE? <2 .ITM> ATOM>
			<SET ZERO <FINDZERO>>>
		   <PUSH-OPTIMIZE .NEW-T .ZERO <2 .ITM>>)
		  (<AND <OR <==? <1 .ITM> ADDI> <==? <1 .ITM> SUBI>>
			<==? <3 .ITM> 1>
			<==? <LENGTH .ITM> 3>
			<NOT <EMPTY? <REST .NEW-T>>>
			<TYPE? <SET NXT <2 .NEW-T>> INST>>
		   <COND (<==? <1 .NXT> JRST>
			  <NEW-INST .NEW-T
				    <COND (<==? <1 .ITM> ADDI> AOJA) (T SOJA)>
				    .ITM
				    .NXT
				    2>
			  <PUT .NEW-T 1 <CHTYPE .ITM OLD-AND-USELESS>>)
			 (<AND <SET TMP
				    <MEMQ <1 .NXT>
					  '[JUMPL
					    JUMPGE
					    JUMPLE
					    JUMPG
					    JUMPE
					    JUMPN]>>
			       <==? <2 .NXT> <2 .ITM>>>
			  <NEW-INST .NEW-T
				    <COND (<==? <1 .ITM> ADDI>
					   <NTH '[AOJN
						  AOJE
						  AOJG
						  AOJLE
						  AOJGE
						  AOJL]
						<LENGTH .TMP>>)
					  (T
					   <NTH '[SOJN
						  SOJE
						  SOJG
						  SOJLE
						  SOJGE
						  SOJL]
						<LENGTH .TMP>>)>
				    .ITM
				    .NXT
				    3>
			  <PUT .NEW-T 1 <CHTYPE .ITM OLD-AND-USELESS>>)>)>
	    <COND (<NOT <TYPE? <1 .NEW-T> OLD-AND-USELESS>>
		   <SET PREPREV .PREVIOUS>
		   <SET PREVIOUS <1 .NEW-T>>)>>
    .T>
   <UNLABEL-THIS-TUPLE .CODE-L .T>
   <PRINTTYPE REF ,PRINT>
   .CODE-L>

<DEFINE NEW-INST (NEW-T NEW-OP CINST NXTINST BASE "AUX" NEW REFQ) 
	#DECL ((NEW-T) <PRIMTYPE VECTOR> (NEW-OP) ATOM
	       (CINST NXTINST) INST (BASE) FIX)
	<COND (<G? <LENGTH .NXTINST> .BASE>			      ;"JRST @"
	       <SET NEW
		    <IVECTOR <+ <LENGTH .CINST> <- <LENGTH .NXTINST> .BASE>>>>
	       <SUBSTRUC .CINST 0 <- <LENGTH .CINST> 1> .NEW>
	       <SUBSTRUC .NXTINST
			 <- .BASE 1>
			 <- <LENGTH .NXTINST> <- .BASE 1>>
			 <REST .NEW <- <LENGTH .CINST> 1>>>
	       <2 .NEW-T <SET CINST <CHTYPE .NEW INST>>>)
	      (T <3 .CINST <NTH .NXTINST .BASE>> <2 .NEW-T .CINST>)>
	<COND (<AND <TYPE? <SET REFQ <NTH .CINST <LENGTH .CINST>>> REF>
		    <G=? <LENGTH .REFQ> 3>>
	       <MAPR <>
		     <FUNCTION (RL "AUX" (I <1 .RL>)) 
			     <COND (<==? .I .NXTINST> <PUT .RL 1 .CINST>)>>
		     <CHTYPE <3 .REFQ> LIST>>)>
	<1 .CINST .NEW-OP>>

;
" Generate-circular-references makes labels be circular objects.
   First all the tags are found and a dummy reference shell is created.
   Then for all the lines which contain references, one links up the code
   and outputs the circular lines."

<DEFINE GENERATE-CIRCULAR-REFERENCES (TUP "AUX" TAGS)
  #DECL ((TUP) <PRIMTYPE VECTOR> (TAGS) LIST)
  <SET TAGS
       <MAPF ,LIST
	     <FUNCTION (ITEM)
	       #DECL ((ITEM) LAB)
	       <MAPRET <LAB-NAM .ITEM> <CHTYPE [<LAB-NAM .ITEM> T '()] REF>>>
	     ,LABELS>>
  <MAPR <>
	<FUNCTION (CODE "AUX"
			(LINE <1 .CODE>)      ;"Current line"
			LAST                  ;"Last item in current line"
			LL                    ;"Reference list segment"
			NEW-REF)              ;"New reference"
	  #DECL ((CODE) <PRIMTYPE VECTOR> (LINE) <OR INST REF ATOM>
		 (LAST) <OR LIST REF ATOM FIX CHARACTER> (LL) <OR LIST FALSE>
		 (NEW-REF) REF)
	  <COND (<AND <TYPE? .LINE INST>
		      <OR
		       <AND <TYPE? <SET LAST <NTH .LINE <LENGTH .LINE>>> REF>
			    <SET LL <MEMQ <1 .LAST> .TAGS>>>
		       <AND <==? <1 .LINE> DISPATCH>
			    <SET LL <MEMQ <2 .LINE> .TAGS>>>
		       <AND <TYPE? <1 .LINE> GFRM SGFRM SBFRM>
			    <SET LL <MEMQ <CHTYPE <1 .LINE> ATOM> .TAGS>>>>>
		 <SET NEW-REF <2 .LL>>
		 <PUT .NEW-REF 3 (.LINE !<3 .NEW-REF>)>
		 <PUT .LINE <LENGTH .LINE> .NEW-REF>
		 <COND (<TYPE? <1 .LINE> GFRM SGFRM SBFRM>
			<PUT .LINE 1 <CHTYPE <1 .NEW-REF> <TYPE <1 .LINE>>>>)>)
		(<AND <TYPE? .LINE ATOM>
		      <SET LL <MEMQ .LINE .TAGS>>>
		 <PUT .CODE 1 <2 .LL>>)
		(<TYPE? .LINE ATOM>           ;"Reference which was deleted"
		 <PUT .CODE 1 <CHTYPE [.LINE] OLD-AND-USELESS>>)>>
	  .TUP>>

;"Delete-adjacent-refs will delete the first reference of a pair of references
  next to each other and call itself recursively."

<DEFINE DELETE-ADJACENT-REFS (TUP "AUX" (ITM <1 .TUP>) (NXT <2 .TUP>) USELESS)
  #DECL ((TUP) <PRIMTYPE VECTOR> (NXT) <OR OLD-AND-USELESS REF INST> (ITM) REF)
  <REPEAT ()
	  <COND (<TYPE? .NXT REF>;"Deletes adjacent ref"
		 <MAPF <>
		       <FUNCTION (INS)
			    #DECL ((INS) INST)
			    <PUT .ITM 3 (.INS !<3 .ITM>)>
			    <COND (<TYPE? <1 .INS> GFRM SGFRM SBFRM>
				   <PUT .INS 1
					<CHTYPE <1 .ITM> <TYPE <1 .INS>>>>)>
			    <PUT .INS <LENGTH .INS> .ITM>>
		       <CHTYPE <3 .NXT> LIST>>
		 <PUT .TUP 2 .ITM>
		 <PUT .TUP 1 <CHTYPE [<1 .NXT>] OLD-AND-USELESS>>
		 <COND (<EMPTY? <SET TUP <REST .TUP>>> <RETURN>)>
		 <SET NXT <2 .TUP>>)
		(ELSE
		 <RETURN>)>>>

<DEFINE PUSH-OPTIMIZE (NEW-T ZERO AC "AUX" (COUNT 0)(AC2 T*))
	#DECL ((COUNT) FIX (AC AC2) ATOM (NEW-T) <PRIMTYPE VECTOR>)
	<COND (<==? .AC .AC2><SET AC2 B1*>)>
	<MAPR <>
	      <FUNCTION (TUP "AUX" (LINE <1 .TUP>) C)
		   #DECL ((TUP) <PRIMTYPE VECTOR>
			  (LINE) <OR INST OLD-AND-USELESS REF>)
		   <COND (<AND <==? <1 .LINE> PUSH>
			       <==? <2 .LINE> .AC>
			       <TYPE? <SET C <3 .LINE>> REF>
			       <==? <1 .C> .ZERO>>
			  <SET COUNT <+ .COUNT 1>>)
			 (ELSE <MAPLEAVE>)>>
	      .NEW-T>
  <COND (<G=? .COUNT 5>
	 <PUT .NEW-T 1 <CHTYPE [XMOVEI .AC2 2  (.AC)] INST>>
	 <PUT .NEW-T 2 <CHTYPE [ADJSP  .AC   .COUNT] INST>>
	 <PUT .NEW-T 3 <CHTYPE [SETZM   -1    (.AC2)] INST>>
	 <PUT .NEW-T 4 <CHTYPE [HRLI   .AC2 -1 (.AC2)] INST>>
	 <PUT .NEW-T 5 <CHTYPE [BLT    .AC2    (.AC)] INST>>
	 <REPEAT ((CNT <- .COUNT 4>)
		  (TUP <REST .NEW-T 5>))
	   #DECL ((CNT) FIX (TUP) <PRIMTYPE VECTOR> (ZRO) OLD-AND-USELESS)
	   <COND (<0? <SET CNT <- .CNT 1>>><RETURN>)
		 (ELSE <PUT .TUP 1 <ELIMINATE <1 .TUP>>>
		       <SET TUP <REST .TUP>>)>>)>>
		 
<DEFINE SKIP-MODIFY (NEW-T PREVIOUS PREPREV
		     "AUX" (ITM <1 .NEW-T>)
			   (NEXTLINE
			    <AND <NOT <EMPTY? <REST .NEW-T>>> <2 .NEW-T>>) OPP
			   FOO)
	#DECL ((NEW-T) <PRIMTYPE VECTOR> (ITM) INST
	       (PREVIOUS NEXTLINE) <OR OLD-AND-USELESS INST REF FALSE>)
	<COND (<AND .NEXTLINE
		    .PREVIOUS
		    <NOT <EMPTY? <REST .NEW-T 2>>>
		    <NOT <TYPE? .ITM OLD-AND-USELESS>>
		    <OR <==? <SET FOO <NTH .ITM <LENGTH .ITM>>> <3 .NEW-T>>
			<==? .FOO .NEXTLINE>>>
	       <COND (<AND <CONDITIONAL-SKIP? .PREVIOUS>
			   <UNCONDITIONAL-BRANCH? .NEXTLINE>
			   <OR <NOT .PREPREV>
			       <NOT <CONDITIONAL-SKIP? .PREPREV>>>
			   <SET OPP <GETPROP <1 .PREVIOUS> OPPOSITE>>>
		      <PUT .PREVIOUS 1 .OPP>
		      <PUT .NEW-T 1 <ELIMINATE <1 .NEW-T>>>)
		     (<TYPE? .NEXTLINE REF OLD-AND-USELESS>
		      <PUT .NEW-T 1 <ELIMINATE .ITM>>)
		     (ELSE <PUT .NEW-T 1 <CHTYPE [CAIA A1* A1*] INST>>)>)>>

<DEFINE UNLABEL-THIS-TUPLE (L T "AUX" RF)
  #DECL ((T) <PRIMTYPE VECTOR> (RF) ANY (L) LIST)
  <AND ,PEEP-CHANNEL <CRLF ,PEEP-CHANNEL>>
  <MAPF <>
	<FUNCTION (STATEMENT)
	     #DECL ((STATEMENT) <OR INST REF OLD-AND-USELESS>)
	     <COND (<TYPE? .STATEMENT REF>
		    <COND (,PEEP-CHANNEL <PRINT <1 .STATEMENT> ,PEEP-CHANNEL>)>
		    <PUT <SET L <REST .L>> 1 <1 .STATEMENT>>)
		   (<TYPE? .STATEMENT OLD-AND-USELESS>
		    <COND (,PEEP-CHANNEL <PRINT .STATEMENT ,PEEP-CHANNEL>)>)
		   (<AND <TYPE? .STATEMENT INST>
			 <==? <1 .STATEMENT> DISPATCH>
			 <TYPE? <SET RF <2 .STATEMENT>> REF>>
		    <PUT .STATEMENT 2 <1 .RF>>
		    <COND (,PEEP-CHANNEL <PRINT .STATEMENT ,PEEP-CHANNEL>)>
		    <PUT <SET L <REST .L>> 1 .STATEMENT>)
		   (<AND <TYPE? .STATEMENT INST>
			 <TYPE?
			  <SET RF <NTH .STATEMENT <LENGTH .STATEMENT>>>
			  REF>>
		     <COND (<TYPE? <1 .STATEMENT> SGFRM GFRM SBFRM>
			    <PUT .STATEMENT <LENGTH .STATEMENT> T>)
			   (ELSE
			    <PUT .STATEMENT <LENGTH .STATEMENT>
				 <CHTYPE [<1 .RF>] REF>>)>
		     <COND (,PEEP-CHANNEL
			   <PRINT .STATEMENT ,PEEP-CHANNEL>)>
		    <PUT <SET L <REST .L>> 1 .STATEMENT>)
		   (ELSE
		    <COND (,PEEP-CHANNEL <PRINT .STATEMENT ,PEEP-CHANNEL>)>
		    <PUT <SET L <REST .L>> 1 .STATEMENT>)>>
	.T>
  <PUTREST .L ()>>

<DEFINE POST-ACCESS (BACK0 TUP "AUX" (BACK1 <1 <SET TUP <BACK .TUP>>>)
			             (BACK2 <1 <BACK .TUP>>))
  #DECL ((TUP) <PRIMTYPE VECTOR>
	 (BACK0 BACK1 BACK2) <OR FALSE INST REF OLD-AND-USELESS>)
  <COND (<TYPE? .BACK0 OLD-AND-USELESS>
	 <POST-ACCESS .BACK0 <BACK .TUP>>)
	(<OR <NOT <UNCONDITIONAL-BRANCH? .BACK1>>
	     <CONDITIONAL-SKIP? .BACK2>
	     <UNCONDITIONAL-SKIP? .BACK2>
	     <AND <OR <CONDITIONAL-BRANCH? .BACK2>
		      <UNCONDITIONAL-BRANCH? .BACK2>>
		  <==? .BACK0 <NTH .BACK2 <LENGTH .BACK2>>>>>)
	(ELSE <PUT .BACK0 2 <>>)>>

<DEFINE CONDITIONAL-BRANCH? (ITEM)
  #DECL ((ITEM) <OR OLD-AND-USELESS INST REF>)
  <MEMQ <1 .ITEM> ,CJ-JUMP-LIST>>

<DEFINE CONDITIONAL-SKIP? (ITEM)
  #DECL ((ITEM) <OR OLD-AND-USELESS INST REF>)  
  <MEMQ <1 .ITEM> ,CS-JUMP-LIST>>

<DEFINE UNCONDITIONAL-BRANCH? (ITEM "AUX" LBL)
  #DECL ((ITEM) <OR OLD-AND-USELESS INST REF>)  
  <AND <MEMQ <1 .ITEM> ,UJ-JUMP-LIST>
       <TYPE? <SET LBL <NTH .ITEM <LENGTH .ITEM>>> REF>
       <N==? <1 .LBL> COMPERR>>>

<DEFINE UNCONDITIONAL-SKIP? (ITEM)
  #DECL ((ITEM) <OR OLD-AND-USELESS INST REF>)  
  <==? <1 .ITEM> CAIA>>

<DEFINE JUMP? (INSTR)
  #DECL ((INSTR) <OR OLD-AND-USELESS INST REF>)  
  <OR <CONDITIONAL-BRANCH? .INSTR>
      <CONDITIONAL-SKIP? .INSTR>
      <UNCONDITIONAL-BRANCH? .INSTR>
      <UNCONDITIONAL-SKIP? .INSTR>>>

<GDECL (UJ-JUMP-LIST US-JUMP-LIST CJ-JUMP-LIST CS-JUMP-LIST)
       <LIST [REST ATOM]>
       (JUMP-LIST)
       !<LIST [4 <LIST [REST ATOM]>]>>

<SETG JUMP-LIST
      (<SETG UJ-JUMP-LIST '(JUMPA AOJA SOJA JRST PUSHJ JSP UJ)>
       <SETG US-JUMP-LIST '(CAIA SKIPA AOSA SOSA US)>
       <SETG CJ-JUMP-LIST
	     '(JUMPL
	       JUMPGE
	       JUMPE
	       JUMPN
	       JUMPLE
	       JUMPG
	       SOJL
	       SOJGE
	       SOJE
	       SOJN
	       SOJLE
	       SOJG
	       CJ)>
       <SETG CS-JUMP-LIST
	     '(CAIL
	       CAIGE
	       CAIE
	       CAIN
	       CAILE
	       CAIG
	       CAML
	       CAMGE
	       CAME
	       CAMN
	       CAMLE
	       CAMG
	       SOSL
	       SOSGE
	       SOSE
	       SOSN
	       SOSLE
	       SOSG
	       AOSL
	       AOSGE
	       AOSE
	       AOSN
	       AOSLE
	       AOSG
	       SKIPL
	       SKIPGE
	       SKIPE
	       SKIPN
	       SKIPLE
	       SKIPG
	       TRNE
	       TRNN
	       TLNN
	       TLNE
	       CS)>)>

<DEFINE MAKE-OPPOSITES (ITEM-1 ITEM-2)
  #DECL ((ITEM-1 ITEM-2) ATOM)
  <PUTPROP .ITEM-1 OPPOSITE .ITEM-2>
  <PUTPROP .ITEM-2 OPPOSITE .ITEM-1>>

<DEFINE SINGLE-PATH-OPTIMIZE (TOP-OF-TUP NEW-T 
			      "AUX" (BACKREG-LIST '())
				    (LBL <1 .NEW-T>)
				    (ACS '(A1* A2* B1* B2* C1*
					       C2* T*  X*  O*)))
  #DECL ((BACKREG-LIST ACS) LIST (TOP-OF-TUP NEW-T) <PRIMTYPE VECTOR>
	 (LBL) <OR INST OLD-AND-USELESS REF>)
  <REPEAT ((STATEMENT <1 <3 .LBL>>)(NTUP <MEMQ .STATEMENT .TOP-OF-TUP>) ACC?)
    #DECL ((STATEMENT) <OR INST REF OLD-AND-USELESS>
	   (NTUP) <OR FALSE <PRIMTYPE VECTOR>> (ACC?) <OR REF ATOM FIX LIST>)
    <COND (<OR <TYPE? .STATEMENT REF>
	       <AND <TYPE? .STATEMENT INST>
		    <OR <==? <1 .STATEMENT> PUSHJ>
			<==? <1 .STATEMENT> JSP>>>>
	   <RETURN>)
	  (<AND <MOVE? .STATEMENT>
		<MEMQ <SET ACC? <2 .STATEMENT>> .ACS>
		<NOT <MEMQ .ACC? .BACKREG-LIST>>>
	   <SET ACS <MAPR ,LIST
			  <FUNCTION (ACLIST "AUX" (AC <1 .ACLIST>))
			    #DECL ((ACLIST) LIST (AC) ATOM)
			    <COND (<==? .ACC? .AC><MAPSTOP !<REST .ACLIST>>)
				  (ELSE <MAPRET .AC>)>>
			  .ACS>>
	   <SET BACKREG-LIST (.ACC? .STATEMENT !.BACKREG-LIST)>)
	  (<AND <G? <LENGTH .STATEMENT> 1>
	        <TYPE? <SET ACC? <2 .STATEMENT>> ATOM>
		<MEMQ .ACC? .ACS>>
	   <SET ACS <MAPR ,LIST
			  <FUNCTION (ACLIST "AUX" (AC <1 .ACLIST>))
			    #DECL ((ACLIST) LIST (AC) ATOM)
			    <COND (<==? .ACC? .AC><MAPSTOP !<REST .ACLIST>>)
				  (ELSE <MAPRET .AC>)>>
			  .ACS>>)>
    <COND (<OR <NOT .NTUP> <==? .NTUP .TOP-OF-TUP>><RETURN>)
	  (ELSE <SET STATEMENT <1 <SET NTUP <BACK .NTUP>>>>)>>
  <SET ACS '()>
  <MAPR <>
	<FUNCTION (NTUP "AUX" (STATEMENT <1 .NTUP>) STM)
	  #DECL ((NTUP) <PRIMTYPE VECTOR>
		 (STATEMENT) <OR INST OLD-AND-USELESS REF>)
	  <COND (<JUMP? .STATEMENT><MAPLEAVE>)
		(<TYPE? .STATEMENT REF><MAPLEAVE>)
		(<AND <MOVE? .STATEMENT>
		      <NOT <MEMQ <2 .STATEMENT> .ACS>>
		      <SET STM <MEMQ .STATEMENT .BACKREG-LIST>>>
		 <SET ACS (<2 .STATEMENT> !.ACS)>
		 <PUT .STM 1 <ELIMINATE <1 .STM>>>
		 <PUT .NTUP 1 <ELIMINATE <1 .NTUP>>>)
		(<MOVE? .STATEMENT>
		 <SET ACS (<2 .STATEMENT> !.ACS)>)>>
	<REST .NEW-T>>>

<DEFINE MOVE? (ITM)
  #DECL ((ITM) <OR INST REF OLD-AND-USELESS>)
  <AND <TYPE? .ITM INST>
       <MEMQ <1 .ITM> '[MOVE DMOVE MOVSI MOVEI MOVNI]>
       <IS-REAL-AC? <2 .ITM>>>>

<DEFINE FINDZERO ()
  <REPEAT ((NCV ,CONSTANT-VECTOR))
    #DECL ((NCV) LIST)
    <COND (<EMPTY? .NCV><RETURN <>>)
	  (<==? <CB-VAL <1 .NCV>> #CONSTANT *000000000000*>
	   <RETURN <1 .NCV>>)
	  (ELSE <SET NCV <REST .NCV>>)>>>

<DEFINE MOVE-CHECK (NEW-T LINE
		    "AUX" (LABEL <1 .LINE>) (DESTINATION <2 .LINE>)
			  DESTINATION2
			  (SOURCE <AND <TYPE? <3 .LINE> ATOM> <3 .LINE>>)
			  SOURCE2 USEFUL-CODE)
   #DECL ((LINE) INST (LABEL) ATOM (NEW-T) <PRIMTYPE VECTOR>
	  (DESTINATION SOURCE) <OR ATOM FIX FALSE LIST>
	  (SOURCE2 DESTINATION2) <OR FALSE ATOM> (USEFUL-CODE) LIST)
   <COND
    (<AND <IS-REAL-AC? .DESTINATION> .SOURCE <IS-REAL-AC? .SOURCE>>
     <SET USEFUL-CODE
	  <MAPR ,LIST
		<FUNCTION (NEW-TUP "AUX" (LINE <1 .NEW-TUP>)) 
			#DECL ((LINE) <OR INST REF OLD-AND-USELESS>)
			<COND (<TYPE? .LINE REF>
			       <COND (<L-LOOP? .NEW-TUP> <MAPLEAVE '()>)
				     (ELSE <MAPSTOP>)>)
			      (<CONDITIONAL-BRANCH? .LINE>
			       <MAPLEAVE ()>)
			      (<UNCONDITIONAL-BRANCH? .LINE>
			       <MAPSTOP .LINE>)
			      (<OR <AND <==? <1 .LINE> JRST> <==? <2 .LINE> @>>
				   <==? <1 .LINE> PUSHJ>
				   <==? <1 .LINE> JSP>>
			       <MAPLEAVE '()>)
			      (ELSE <MAPRET .LINE>)>>
		<REST .NEW-T>>>
     <COND (<EMPTY? .USEFUL-CODE>)
	   (<AND <==? .LABEL MOVE>
		 <NOT <IS-THIS-AC-USED? .SOURCE .USEFUL-CODE .DESTINATION>>>
	    <REPLACE-ACS .SOURCE .DESTINATION .USEFUL-CODE>
	    <PUT .NEW-T 1 <ELIMINATE <1 .NEW-T>>>)
	   (<AND <==? .LABEL DMOVE>
		 <SET SOURCE2 <GETPROP .SOURCE AC-PAIR>>
		 <SET DESTINATION2 <GETPROP .DESTINATION AC-PAIR>>
		 <NOT <IS-THIS-AC-USED? .SOURCE .USEFUL-CODE .DESTINATION>>
		 <NOT <IS-THIS-AC-USED? .SOURCE2 .USEFUL-CODE .DESTINATION2>>>
	    <REPLACE-ACS .SOURCE .DESTINATION .USEFUL-CODE>
	    <REPLACE-ACS .SOURCE2 .DESTINATION2 .USEFUL-CODE>
	    <PUT .NEW-T 1 <ELIMINATE <1 .NEW-T>>>)>)>>

<DEFINE REPLACE-ACS (AC1 AC2 CODE "AUX" (LAC1 (.AC1)) (LAC2 (.AC2))) 
	#DECL ((AC1 AC2) ATOM (LAC1 LAC2) LIST (CODE) LIST)
	<MAPF <>
	      <FUNCTION (LINE "AUX" SUBSET) 
		      #DECL ((LINE SUBSET)
			     <OR VECTOR INST REF OLD-AND-USELESS FALSE>)
		      <COND (<SET SUBSET <MEMBER .LAC2 .LINE>>
			     <PUT .SUBSET 1 .LAC1>)
			    (<MEMQ <1 .LINE> '[MOVE DMOVE]>)
			    (<SET SUBSET <MEMQ .AC2 .LINE>>
			     <PUT .SUBSET 1 .AC1>)>>
	      .CODE>>

<DEFINE IS-THIS-AC-USED? (ACCUM CODE DEST
				"AUX" (ACCUM2 <GETPROP .ACCUM AC-PAIR>)(MOVED? <>)
			        (LDEST (.DEST))
				(DEST2 <GETPROP .DEST AC-PAIR>)
				(LDEST2 <AND .DEST2 (.DEST2)>)
				(SRC-USED <>) (DST-USED <>) R)
  #DECL ((ACCUM) ATOM (CODE) LIST)
  <MAPF <>
	<FUNCTION (LINE)
	  #DECL ((LINE) <OR INST REF OLD-AND-USELESS>)
	  <COND (.MOVED?
		 <COND (<OR <MEMQ .DEST .LINE>
			    <MEMQ .LDEST .LINE>>
			<MAPLEAVE T>)
		       (<AND .DEST2
			     <MEMQ .DEST2 .LINE>
			     <MEMQ .LDEST .LINE>>
			<MAPLEAVE T>)
		       (ELSE <>)>)
		(<AND <OR <MEMQ .ACCUM .LINE>
			  <AND .ACCUM2
			       <MEMQ .ACCUM2 .LINE>>>
		      <MEMQ <1 .LINE> '[DMOVEM MOVEM]>>
		 <COND (.DST-USED <MAPLEAVE T>) (ELSE <>)>)
		(<AND <OR <MEMQ .DEST .LINE>
			  <AND .DEST2
			       <MEMQ .DEST2 .LINE>>>
		      <MEMQ <1 .LINE> '[DMOVEM MOVEM]>>
		 <COND (.SRC-USED <MAPLEAVE T>) (ELSE <>)>)
		(<AND <OR <MEMQ .ACCUM .LINE>
			  <AND .ACCUM2
			       <MEMQ .ACCUM2 .LINE>>>
		      <MEMQ <1 .LINE> '[DMOVE MOVE MOVSI MOVEI MOVNI]>
		      <NOT <AND <TYPE? <SET R <NTH .LINE <LENGTH .LINE>>> LIST>
				<OR <==? <1 .R> .ACCUM>
				    <==? <1 .R> .ACCUM2>>>>>
		 <SET MOVED? T>
		 <>)
		(<OR <MEMQ .ACCUM .LINE>
		     <AND .ACCUM2 <MEMQ .ACCUM2 .LINE>>>
		 <COND (.DST-USED <MAPLEAVE T>)
		       (ELSE <SET SRC-USED T> <>)>)
		(<OR <MEMQ .DEST .LINE>
		     <AND .DEST2 <MEMQ .DEST2 .LINE>>>
		 <COND (.SRC-USED <MAPLEAVE T>)
		       (ELSE <SET DST-USED T> <>)>)
		(ELSE <>)>>
	.CODE>>

<DEFINE IS-REAL-AC? (ITEM)
  #DECL ((ITEM) ATOM)
  <MEMQ .ITEM '[A1* A2* B1* B2* C1* C2* X* T*]>>

<DEFINE MOVE-NEEDED? (NEW-T ITM
		      "AUX" (BOTH? <==? <1 .ITM> DMOVE>) (REG <2 .ITM>)
			    (INDEX (.REG)) AFT-SKIP
			    (REG2 <AND .BOTH? <GETPROP .REG AC-PAIR>>)
			    (INDEX2 <AND .BOTH? (.REG2)>))
   #DECL ((ITM) INST (BOTH) <OR FALSE T> (REG) ATOM (REG2) <OR FALSE ATOM>
	  (INDEX2) <OR LIST FALSE> (NEW-T) <PRIMTYPE VECTOR>)
   <MAPR <>
    <FUNCTION (TT "AUX" (LINE <1 .TT>) (OP <1 .LINE>) F) 
	    #DECL ((TT) <PRIMTYPE VECTOR> (LINE) <OR INST REF OLD-AND-USELESS>
		   (F) ANY)
	    <COND (<TYPE? .LINE REF>
		   <COND (<L-LOOP? .TT>)
			 (ELSE <PUT .NEW-T 1 <ELIMINATE <1 .NEW-T>>>)>
		   <MAPLEAVE>)
		  (<OR <==? .OP PUSHJ>
		       <==? .OP JSP>
		       <AND <==? .OP JRST> <==? <2 .LINE> @>>
		       <AND <==? .OP LDB>
			    <LDB-REGISTER-USED? .LINE .REG .REG2>>>
		   <MAPLEAVE>)
		  (<AND <MEMQ <1 .LINE> [DMOVE MOVE MOVNI MOVSI MOVEI]>
			<==? <2 .LINE> .REG>
			<=? .LINE .ITM>
			<OR <NOT <TYPE? <SET F <NTH .LINE <LENGTH .LINE>>>
					LIST>>
			    <N==? <1 .F> .REG>>>
		   <SET AFT-SKIP <>>
		   <PUT .TT 1 <ELIMINATE <1 .TT>>>)
		  (<MEMBER .INDEX .LINE> <MAPLEAVE>)
		  (<AND <==? .OP MOVEM> <MEMQ .REG .LINE>>
		   <COND (<AND <TYPE? <3 .LINE> LOCAL-NAME>
			       <=? <REST .LINE 2> <REST .ITM 2>>>
			  <PUT .NEW-T 1 <ELIMINATE <1 .NEW-T>>>
			  <PUT .TT 1 <ELIMINATE <1 .TT>>>)>
		   <MAPLEAVE>)
		  (<AND <==? .OP DMOVEM>
			<SET REG2 <GETPROP .REG AC-PAIR>>
			<MEMQ .REG2 .LINE>>
		   <MAPLEAVE>)
		  (<AND <UNCONDITIONAL-BRANCH? .LINE>
			<NOT .AFT-SKIP>>
		   <PUT .NEW-T 1 <ELIMINATE <1 .NEW-T>>>
		   <MAPLEAVE>)
		  (<OR <AND .BOTH?
			    <OR <MEMQ .REG2 .LINE> <MEMBER .INDEX2 .LINE>>>
		       <MEMQ .REG .LINE>>
		   <MAPLEAVE>)
		  (<OR <CONDITIONAL-SKIP? .LINE>
		       <UNCONDITIONAL-SKIP? .LINE>>
		   <SET AFT-SKIP T>)
		  (ELSE
		   <SET AFT-SKIP <>>)>>
    <REST .NEW-T>>>

<DEFINE BRANCH-CHAIN (NEW-T "AUX" (TAG1 <1 .NEW-T>)(JUMP1 <2 .NEW-T>)
				  (TAG2 <NTH .JUMP1 <LENGTH .JUMP1>>)
				  (FLUSHIT T))
  #DECL ((NEW-T) <PRIMTYPE VECTOR> (TAG1 TAG2) REF (JUMP1) INST)
  <MAPF <>
	<FUNCTION (LINE) #DECL ((LINE) INST)
	  <COND (<TYPE? <1 .LINE> SGFRM>
		 <SET FLUSHIT <>>)
		(ELSE
		 <COND (<TYPE? <1 .LINE> GFRM SBFRM>
			<PUT .LINE 1 <CHTYPE <1 .TAG2> <TYPE <1 .LINE>>>>)>
		 <PUT .LINE <LENGTH .LINE> .TAG2>
		 <PUT .TAG2 3 (.LINE !<3 .TAG2>)>)>>
	<3 .TAG1>>
  <COND (.FLUSHIT
	 <PUT .NEW-T 1 <CHTYPE [<1 .TAG1>] OLD-AND-USELESS>>
	 <COND (<AND <UNCONDITIONAL-BRANCH? <1 <BACK .NEW-T>>>
		     <NOT <CONDITIONAL-SKIP? <1 <BACK .NEW-T 2>>>>>
		<PUT .NEW-T 2 <ELIMINATE <2 .NEW-T>>>)>)>>


<DEFINE LDB-REGISTER-USED? (ITM REG1 REG2 "AUX" (CNST <AND <TYPE? <3 .ITM> REF>
							   <1 <3 .ITM>>>)
			    CONSTANT FIELD1 FIELD2 CONSTANT-THING)
  #DECL ((ITM) INST (REG1) ATOM (REG2) <OR FALSE ATOM>
	 (CNST) <OR CONSTANT-LABEL FALSE>
	 (CONSTANT CONSTANT-THING) ANY (FIELD1 FIELD2) FIX)
  <COND (<AND <SET CONSTANT <MEMQ .CNST ,CONSTANT-VECTOR>>
	      <SET CONSTANT-THING <2 .CONSTANT>>
	      <TYPE? .CONSTANT-THING CONSTANT>
	      <SET FIELD1 <CHTYPE <GETBITS .CONSTANT-THING <BITS 4 18>> FIX>>
	      <SET FIELD2 <CHTYPE <GETBITS .CONSTANT-THING <BITS 14 0>> FIX>>>
	 <OR <==? .FIELD1 <2 <MEMQ .REG1 ,ACS>>>
	     <AND .REG2 <==? .FIELD1 <2 <MEMQ .REG2 ,ACS>>>>
	     <AND <0? .FIELD1>
		  <L? .FIELD2 16>>>)
		
	(ELSE T)>>

<PUTPROP A1* AC-PAIR A2*>

<PUTPROP A2* AC-PAIR A1*>

<PUTPROP B1* AC-PAIR B2*>

<PUTPROP B2* AC-PAIR B1*>

<PUTPROP C1* AC-PAIR C2*>

<PUTPROP C2* AC-PAIR C1*>

<DEFINE L-LOOP? (TUP "AUX" (LAB <1 .TUP>))
  #DECL ((TUP) <PRIMTYPE VECTOR>)
  <MAPR <>
	<FUNCTION (NEWTUP "AUX" (LINE <1 .NEWTUP>))
	  <COND (<TYPE? .LINE REF>
		 <MAPLEAVE <>>)
		(<MEMQ .LAB .LINE>
		 <MAPLEAVE T>)>>
	<REST .TUP>>>

<SETG CIRC-LOOP? <>>

<DEFINE ELIMINATE (STATEMENT "AUX" LAST) 
	<COND (<AND <TYPE? .PREVIOUS INST>
		    <CONDITIONAL-SKIP? .PREVIOUS>
		    <MOVE? .STATEMENT>>
	       <PUT .PREVIOUS 1 MOVE>)>
	<COND (<TYPE? .STATEMENT REF>
	       <PUT .STATEMENT 3 '()>
	       <CHTYPE [<1 .STATEMENT>] OLD-AND-USELESS>)
	      (<AND <TYPE? .STATEMENT INST>
		    <TYPE? <SET LAST <NTH .STATEMENT <LENGTH .STATEMENT>>> REF>
		    <==? <LENGTH .LAST> 3>
		    <TYPE? <3 .LAST> LIST>>
	       <PUT .LAST
		    3
		    <MAPF ,LIST
			  <FUNCTION (LINE) 
				  <COND (<==? .LINE .STATEMENT> <MAPRET>)
					(ELSE <MAPRET .LINE>)>>
			  <3 .LAST>>>
	       <PUT .STATEMENT <LENGTH .STATEMENT> <CHTYPE [<1 .LAST>] REF>>
	       <CHTYPE .STATEMENT OLD-AND-USELESS>)
	      (ELSE <CHTYPE .STATEMENT OLD-AND-USELESS>)>>


<PROG ()
      <MAKE-OPPOSITES CAIGE CAIL>
      <MAKE-OPPOSITES CAIN CAIE>
      <MAKE-OPPOSITES CAIG CAILE>
      <MAKE-OPPOSITES CAMGE CAML>
      <MAKE-OPPOSITES CAMN CAME>
      <MAKE-OPPOSITES CAMG CAMLE>
      <MAKE-OPPOSITES SKIPLE SKIPG>
      <MAKE-OPPOSITES SKIPGE SKIPL>
      <MAKE-OPPOSITES SKIPN SKIPE>
      <MAKE-OPPOSITES TRNN TRNE>
      <MAKE-OPPOSITES TLNN TLNE>
      <MAKE-OPPOSITES JUMPGE JUMPL>
      <MAKE-OPPOSITES JUMPN JUMPE>
      <MAKE-OPPOSITES JUMPG JUMPLE>
      <MAKE-OPPOSITES SOJG SOJLE>
      <MAKE-OPPOSITES SOJL SOJGE>
      <MAKE-OPPOSITES SOJE SOJN>>