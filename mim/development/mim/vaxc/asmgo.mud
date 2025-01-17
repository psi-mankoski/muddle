
<DEFINE PROCESS-BRANCH-1 (INST BYTEOFF CODEPTR
			  "AUX" PTR LREF (XREF <>) ROFF CDV)
	#DECL ((INSC EAT CODEPTR INST BYTEOFF PTR INITLEN) FIX (LREF) LABEL-REF
	       (XREF) <OR FALSE XREF-INFO> (CDV) <OR FALSE CODEVEC>)
	<SET PTR <CHTYPE <ANDB .INST 65535> FIX>>
	<SET LREF <NTH ,LABEL-TABLE .PTR>>
	<MAPF <>
	      <FUNCTION (TREF) 
		      <COND (<==? <XREF-INFO-POINT .TREF> .CODEPTR>
			     <SET XREF .TREF>
			     <MAPLEAVE>)>>
	      <LABEL-REF-XREFS .LREF>>
	<OR .XREF
	    <ERROR "JUMP NOT FOUND" .LREF .CODEPTR .BYTEOFF PROCESS-BRANCH>>
	<SET CDV <XREF-INFO-STACK-SAVE-CODE .XREF>>
	<AND .CDV
	     <NOT <EMPTY? .CDV>>
	     <SET BYTEOFF <SCAN-PASS .BYTEOFF () .CDV <> <+ <LENGTH .CDV> 1>>>>
	.BYTEOFF>

<DEFINE PROCESS-BRANCH-2 (INST BYTEOFF CODEPTR INSC EAT
			  "AUX" PTR LREF (XREF <>) ROFF CDV)
	#DECL ((INSC EAT CODEPTR INST BYTEOFF PTR INITLEN) FIX (LREF) LABEL-REF
	       (XREF) <OR FALSE XREF-INFO> (CDV) <OR FALSE CODEVEC>)
	<SET PTR <CHTYPE <ANDB .INST 65535> FIX>>
	<SET LREF <NTH ,LABEL-TABLE .PTR>>
	<MAPF <>
	      <FUNCTION (TREF) 
		      <COND (<==? <XREF-INFO-POINT .TREF> .CODEPTR>
			     <SET XREF .TREF>
			     <MAPLEAVE>)>>
	      <LABEL-REF-XREFS .LREF>>
	<OR .XREF
	    <ERROR "JUMP NOT FOUND" .LREF .CODEPTR .BYTEOFF PROCESS-BRANCH>>
	<SET PTR <LABEL-REF-REL-ADDR .LREF>>
	<COND (<==? .EAT ,OP-BW> <SET BYTEOFF <+ .BYTEOFF 2>>)
	      (ELSE
	       <SET ROFF <- .PTR .BYTEOFF 1>>
	       <COND (<OR <L? .PTR 0>
			  <G? .ROFF 127>
			  <L? .ROFF -127>
			  <XREF-INFO-FORCE-LONG .XREF>>
		      <PUT .XREF ,XREF-INFO-SHORT <>>
		      <COND (<==? .INSC ,INST-BRB>
			     <SET BYTEOFF <+ .BYTEOFF 2>>)
			    (<OR <==? .INSC ,INST-SOBGEQ>
				 <==? .INSC ,INST-SOBGTR>>
			     <SET BYTEOFF <+ .BYTEOFF 5>>)
			    (<OR <==? .INSC ,INST-AOBLSS>
				 <==? .INSC ,INST-AOBLEQ>>
			     <SET BYTEOFF <+ .BYTEOFF 6>>)
			    (ELSE <SET BYTEOFF <+ .BYTEOFF 4>>)>)
		     (ELSE
		      <PUT .XREF ,XREF-INFO-SHORT T>
		      <SET BYTEOFF <+ .BYTEOFF 1>>)>)>
	.BYTEOFF>

<DEFINE AGEN-BRANCH-1 (INST BYTEOFF CODEPTR INSCODE
		       "AUX" PTR LREF XREF (SAVED-POINT 0) CDV ROFF)
	#DECL ((CODEPTR INST BYTEOFF INSCODE) FIX)
	<SET PTR <CHTYPE <ANDB .INST 65535> FIX>>
	<SET LREF <NTH ,LABEL-TABLE .PTR>>
	<SET PTR <LABEL-REF-REL-ADDR .LREF>>
	<MAPF <>
	      <FUNCTION (TREF) 
		      <COND (<==? <XREF-INFO-POINT .TREF> .CODEPTR>
			     <SET XREF .TREF>
			     <MAPLEAVE>)>>
	      <LABEL-REF-XREFS .LREF>>
	<SET CDV <XREF-INFO-STACK-SAVE-CODE .XREF>>
	<AND .CDV
	     <NOT <EMPTY? .CDV>>
	     <SET BYTEOFF
		  <OUTPUT-PASS .BYTEOFF () .CDV <+ <LENGTH .CDV> 1> <>>>>
	.BYTEOFF>

<DEFINE AGEN-BRANCH-2 (INST BYTEOFF CODEPTR INSCODE WHERE EAT
		       "AUX" PTR LREF XREF ROFF SAVED-P)
	#DECL ((BYTEOFF INSCODE WHERE EAT ROFF PTR) FIX)
	<SET PTR <CHTYPE <ANDB .INST 65535> FIX>>
	<SET LREF <NTH ,LABEL-TABLE .PTR>>
	<SET PTR <LABEL-REF-REL-ADDR .LREF>>
	<MAPF <>
	      <FUNCTION (TREF) 
		      <COND (<==? <XREF-INFO-POINT .TREF> .CODEPTR>
			     <SET XREF .TREF>
			     <MAPLEAVE>)>>
	      <LABEL-REF-XREFS .LREF>>
	<SET BYTEOFF <+ .BYTEOFF 1>>
	<SET ROFF <- .PTR .BYTEOFF>>
	<SET SAVED-P ,FBYTE-OFFSET>
	<COND (<XREF-INFO-SHORT .XREF>
	       <ADD-BYTE-TO-FCODE <CHTYPE <ANDB .ROFF 255> FIX>>
	       <PUT .XREF ,XREF-INFO-SHORT T>)
	      (<==? .EAT ,OP-BW>
	       <SET ROFF <- .ROFF 1>>
	       <ADD-BYTE-TO-FCODE <CHTYPE <ANDB .ROFF 255> FIX>>
	       <ADD-BYTE-TO-FCODE <CHTYPE <ANDB <LSH .ROFF -8> 255> FIX>>
	       <SET BYTEOFF <+ .BYTEOFF 1>>
	       <PUT .XREF ,XREF-INFO-SHORT <>>)
	      (<OR <==? .INSCODE ,INST-SOBGEQ> <==? .INSCODE ,INST-SOBGTR>>
	       <PUT-FCODE .WHERE ,INST-DECL>
	       <ADD-BYTE-TO-FCODE <COND (<==? .INSCODE ,IST-SOBGEQ> ,INST-BGEQ)
					(ELSE ,INST-BGTR)>>
	       <ADD-BYTE-TO-FCODE 3>
	       <ADD-BYTE-TO-FCODE ,INST-BRW>
	       <SET SAVED-P ,FBYTE-OFFSET>
	       <SET BYTEOFF <+ .BYTEOFF 4>>
	       <SET ROFF <- .ROFF 4>>
	       <ADD-BYTE-TO-FCODE <CHTYPE <ANDB .ROFF 255> FIX>>
	       <ADD-BYTE-TO-FCODE <CHTYPE <ANDB <LSH .ROFF -8> 255> FIX>>
	       <PUT .XREF ,XREF-INFO-SHORT <>>)
	      (<OR <==? .INSCODE ,INST-SOBGEQ> <==? .INSCODE ,INST-AOBLSS>>
	       <SET ROFF <- .ROFF 5>>
	       <ADD-BYTE-TO-FCODE 2>
	       <ADD-BYTE-TO-FCODE ,INST-BRB>
	       <ADD-BYTE-TO-FCODE 3>
	       <ADD-BYTE-TO-FCODE ,INST-BRW>
	       <SET SAVED-P ,FBYTE-OFFSET>
	       <ADD-BYTE-TO-FCODE <CHTYPE <ANDB .ROFF 255> FIX>>
	       <ADD-BYTE-TO-FCODE <CHTYPE <ANDB <LSH .ROFF -8> 255> FIX>>
	       <SET BYTEOFF <+ .BYTEOFF 5>>
	       <PUT .XREF ,XREF-INFO-SHORT <>>)
	      (<N==? .INSCODE ,INST-BRB>
	       <PUT-FCODE .WHERE <INS-INVERT .INSCODE>>
	       <SET ROFF <- .ROFF 3>>
	       <ADD-BYTE-TO-FCODE 3>
	       <ADD-BYTE-TO-FCODE ,INST-BRW>
	       <SET SAVED-P ,FBYTE-OFFSET>
	       <ADD-BYTE-TO-FCODE <CHTYPE <ANDB .ROFF 255> FIX>>
	       <ADD-BYTE-TO-FCODE <CHTYPE <ANDB <LSH .ROFF -8> 255> FIX>>
	       <SET BYTEOFF <+ .BYTEOFF 3>>
	       <PUT .XREF ,XREF-INFO-SHORT <>>)
	      (ELSE
	       <PUT-FCODE .WHERE ,INST-BRW>
	       <SET BYTEOFF <+ .BYTEOFF 1>>
	       <SET ROFF <- .ROFF 1>>
	       <ADD-BYTE-TO-FCODE <CHTYPE <ANDB .ROFF 255> FIX>>
	       <ADD-BYTE-TO-FCODE <CHTYPE <ANDB <LSH .ROFF -8> 255> FIX>>
	       <PUT .XREF ,XREF-INFO-SHORT <>>)>
	<PUT .XREF ,XREF-INFO-ADDR .BYTEOFF>
	<PUT .XREF ,XREF-INFO-POINT .SAVED-P>
	.BYTEOFF>

<DEFINE INS-INVERT (INS) #DECL ((INS) FIX)
	<CHTYPE <XORB .INS 1> FIX>>

"PASS TO FIXUP THE LABELS IN THE FINAL CODE"

<DEFINE FIXUP-PASS ("AUX" (LABELS ,LABEL-TABLE) POINT ADDR) 
	<MAPF <>
	 <FCN (LREF)
	      <SET ADDR <LABEL-REF-REL-ADDR .LREF>>
	      <MAPF <>
		    <FCN (XREF "AUX" DADDR)
			 <SET POINT <XREF-INFO-POINT .XREF>>
			 <SET DADDR <- .ADDR <XREF-INFO-ADDR .XREF>>>
			 <AND <XREF-INFO-SHORT .XREF>
			      <G? <ABS .DADDR> 127>
			      <ERROR "CANT FIT OFFSET" FIXUP-PASS>>
			 <COND (<XREF-INFO-SHORT .XREF>
				<PUT-FCODE .POINT
					   <CHTYPE <ANDB .DADDR 255> FIX>>)
			       (ELSE
				<PUT-FCODE .POINT
					   <CHTYPE <ANDB .DADDR 255> FIX>>
				<PUT-FCODE <+ .POINT 1>
					   <CHTYPE <ANDB <LSH .DADDR -8> 255>
						   FIX>>)>>
		    <LABEL-REF-XREFS .LREF>>
	      <COND (<SET POINT <LABEL-REF-PUSH-POINTER .LREF>>
		     <PUT-FCODE .POINT <CHTYPE <ANDB .ADDR 255> FIX>>
		     <PUT-FCODE <+ .POINT 1> <CHTYPE <ANDB <LSH .ADDR -8> 255>
						     FIX>>
		     <PUT-FCODE <+ .POINT 2> <CHTYPE <ANDB <LSH .ADDR -16> 255>
						     FIX>>
		     <PUT-FCODE <+ .POINT 3> <CHTYPE <ANDB <LSH .ADDR -24> 255>
						     FIX>>)>>
	 .LABELS>>

<DEFINE CLEAR-CONSTANT-TABLE-FOR-SCAN () 
	<REPEAT ((PTR ,CONSTANT-TABLE) (MCNT ,CONSTANT-POINTER))
		<COND (<==? <2 .PTR> -1> <PUT .PTR 2 0>)>
		<COND (<L=? <SET MCNT <- .MCNT 2>> 0> <RETURN>)>
		<SET PTR <REST .PTR 2>>>>

<DEFINE CHECK-CONSTANT-TABLE (PTR BYTEOFF "AUX" (TAB ,CONSTANT-TABLE)) 
	#DECL ((PTR BYTEOFF) FIX)
	<SET PTR <+ .PTR 1>>
	<COND (<0? <NTH .TAB .PTR>> <PUT .TAB .PTR -1> T)
	      (<==? <NTH .TAB .PTR> -1> <>)
	      (ELSE
	       <SET BYTEOFF <- .BYTEOFF <NTH .TAB .PTR>>>
	       <COND (<G? .BYTEOFF ,JUMP-EXTENT> <PUT .TAB .PTR -1> T)
		     (ELSE <>)>)>>

<DEFINE ASSEMBLE-CODE (SBYTEOFF FNAME "AUX" EBYTEOFF CE) 
	#DECL ((SBYTEOFF EBYTEOFF) FIX (FNAME) ATOM)
	<PROG ((LBYTEOFF <>))
	      <INIT-LABEL-CHECK>
	      <CLEAR-CONSTANT-TABLE-FOR-SCAN>
	      <SET EBYTEOFF <SCAN-PASS .SBYTEOFF>>
	      <COND (<AND <NOT .LBYTEOFF> ,GLUE>
		     <SET LBYTEOFF
			  <CHECK-UNRESOLVED-CALLS .EBYTEOFF .SBYTEOFF>>
		     <COND (<N==? .LBYTEOFF .SBYTEOFF>
			    <SET SBYTEOFF .LBYTEOFF>
			    <AGAIN>)>)>>
	<REPEAT (NEBYTEOFF (NPASSES ,MAX-NUMBER-PASSES))
		<COND (<0? .NPASSES> <RETURN>)>
		<CLEAR-CONSTANT-TABLE-FOR-SCAN>
		<INIT-LABEL-CHECK>
		<SET NEBYTEOFF <SCAN-PASS .SBYTEOFF>>
		<COND (<0? <- .NEBYTEOFF .EBYTEOFF>> <RETURN>)>
		<SET EBYTEOFF .NEBYTEOFF>
		<SET NPASSES <- .NPASSES 1>>>
	<CLEAR-CONSTANT-TABLE-FOR-SCAN>
	<INIT-LABEL-CHECK>
	<SET EBYTEOFF <OUTPUT-PASS .SBYTEOFF>>
	<FIXUP-PASS>
	<COND (,GLUE
	       <SET CE <UPDATE-CALL-ENTRY-TABLE .FNAME>>
	       <ADD-UNRESOLVED-CALLS>
	       <FIXUP-UNRESOLVED-CALLS .CE>)>
	(.SBYTEOFF .EBYTEOFF)>

<DEFINE SCAN-PASS (BYTEOFF
		   "OPTIONAL" (CL ,CODE-LIST) (CV <1 .CL>) (CLABELS T)
			      (MAXPTR ,CODE-COUNT))
   #DECL ((BYTEOFF VALUE MAXPTR) FIX (CL) LIST (CV) CODEVEC)
   <OR <EMPTY? .CL> <SET CL <REST .CL>>>
   <REPEAT ((PTR 1) INS INSCODE EAT AFLG OP-INF NUM-OPS (IN-CASE? <>)
	    CB)
     #DECL ((CB PTR INS INSCODE EAT NUM-OPS) FIX
	    (OP-INF) <UVECTOR [REST FIX]>
	    (IN-CASE?) <OR FALSE FIX>)
     <SET AFLG T>
     <COND (.CLABELS <CHECK-LABEL .BYTEOFF .PTR>)>
     <SET INS <1 .CV>>
     <SET INSCODE <CHTYPE <LSH .INS -24> FIX>>
     <COND (<EMPTY? <SET CV <REST .CV>>>
	    <COND (<EMPTY? .CL> <SET AFLG <>>)
		  (ELSE <SET CV <1 .CL>> <SET CL <REST .CL>>)>)>
     <SET PTR <+ .PTR 1>>
     <COND (.IN-CASE?
	    <COND (<L? <SET IN-CASE? <- .IN-CASE? 1>> 0>
		   <SET IN-CASE? <>>)>
	    <SET BYTEOFF <+ .BYTEOFF 2>>
	    <AGAIN>)>
     <SET OP-INF <GET-INST-INFO .INSCODE>>
     <SET NUM-OPS <CHTYPE <LSH <2 .OP-INF> <- ,INIT-SHIFT>> FIX>>
     <COND
      (<MEMQ .INSCODE ,SPECIAL-OPS>
       <SET BYTEOFF <SCAN-SPECIAL-CODE .INS .BYTEOFF>>)
      (ELSE
       <COND (<MEMQ .INSCODE ,BRANCH-INS>
	      <SET BYTEOFF <PROCESS-BRANCH-1 .INS .BYTEOFF <- .PTR 1>>>)>
       <COND (<MEMQ .INSCODE ,CASE-INS> <SET IN-CASE? 0>)>
       <SET BYTEOFF <+ .BYTEOFF 1>>
       <COND
	(<NOT <0? .NUM-OPS>>
	 <REPEAT ((SHFT -24) (FNUM 1) EAC R-OR-L ADR (SIZ 1) (DO-IMM <>))
	   #DECL ((DO-IMM) <OR FIX FALSE>)
	   <COND (<L? <SET NUM-OPS <- .NUM-OPS 1>> 0> <SET SIZ <- .SIZ 1>>)>
	   <REPEAT ((CNT -8))
		   <COND (<L? <SET SIZ <- .SIZ 1>> 0>
			  <COND (<AND .IN-CASE? .DO-IMM>
				 <COND (<L=? .NUM-OPS 0>
					<SET IN-CASE? .DO-IMM>)
				       (<1? .NUM-OPS>
					<SET CB .DO-IMM>)>)>
			  <SET DO-IMM <>>
			  <RETURN>)>
		   <COND
		    (<G? <SET SHFT <+ .SHFT 8>> 0>
		     <SET SHFT -24>
		     <SET PTR <+ .PTR 1>>
		     <OR .AFLG <ERROR ACCESS-BEYOND-END-OF-CODE!-ERRORS>>
		     <SET INS <1 .CV>>
		     <COND (<EMPTY? <SET CV <REST .CV>>>
			    <COND (<EMPTY? .CL> <SET AFLG <>>)
				  (ELSE
				   <SET CV <1 .CL>>
				   <SET CL <REST .CL>>)>)>)>
		   <SET CNT <+ .CNT 8>>
		   <SET ADR <CHTYPE <ANDB <LSH .INS .SHFT> 255> FIX>>
		   <COND (.DO-IMM
			  <SET DO-IMM <ORB .DO-IMM <LSH .ADR .CNT>>>)>>
	   <COND (<L? .NUM-OPS 0> <RETURN>)>
	   <SET EAC <CHTYPE <ANDB .ADR 240> FIX>>
	   <SET R-OR-L <CHTYPE <ANDB .ADR 15> FIX>>
	   <SET SIZ
		<CHTYPE <ANDB <SET EAT <GET-OP-INFO .FNUM .OP-INF>> 7> FIX>>
	   <SET FNUM <+ .FNUM 1>>
	   <COND (<OR <==? .EAT ,OP-BB> <==? .EAT ,OP-BW>>
		  <SET BYTEOFF
		       <PROCESS-BRANCH-2 .INS
					 .BYTEOFF
					 <- .PTR 1>
					 .INSCODE
					 .EAT>>
		  <SET SIZ 1>)
		 (<L? .EAC ,AM-INX>
		  <SET SIZ 1>
		  <SET BYTEOFF <+ .BYTEOFF 1>>
		  <COND (.IN-CASE?
			 <COND (<0? .NUM-OPS> <SET IN-CASE? .R-OR-L>)
			       (<1? .NUM-OPS> <SET CB .R-OR-L>)>)>)
		 (<==? .EAC ,AM-INX>
		  <SET FNUM <- .FNUM 1>>
		  <SET NUM-OPS <+ .NUM-OPS 1>>
		  <SET BYTEOFF <+ .BYTEOFF 1>>
		  <SET SIZ 1>)
		 (<OR <==? .EAC ,AM-REG>
		      <==? .EAC ,AM-REGD>
		      <==? .EAC ,AM-ADEC>>
		  <SET SIZ 1>
		  <SET BYTEOFF <+ .BYTEOFF 1>>)
		 (<OR <==? .EAC ,AM-AINC> <==? .EAC ,AM-AINCD>>
		  <COND (<==? .R-OR-L ,NAC-PC>
			 <COND (<==? .EAC ,AM-AINCD> <SET SIZ 5>)
			       (<OR <==? .SIZ ,SZ-L> <==? .SIZ ,SZ-F>>
				<SET SIZ 5>)
			       (<==? .SIZ ,SZ-W> <SET SIZ 3>)
			       (ELSE <SET SIZ 2>)>
			 <COND (<AND .IN-CASE? <L=? .NUM-OPS 1>>
				<SET DO-IMM 0>)>
			 <SET BYTEOFF <+ .BYTEOFF .SIZ>>)
			(ELSE <SET BYTEOFF <+ .BYTEOFF 1>> <SET SIZ 1>)>)
		 (ELSE
		  <COND (<OR <==? .EAC ,AM-BDD> <==? .EAC ,AM-BD>> <SET SIZ 2>)
			(<OR <==? .EAC ,AM-WDD> <==? .EAC ,AM-WD>> <SET SIZ 3>)
			(<OR <==? .EAC ,AM-LDD> <==? .EAC ,AM-LD>>
			 <SET SIZ 5>)>
		  <SET BYTEOFF <+ .BYTEOFF .SIZ>>)>>)>)>
     <OR .AFLG <RETURN .BYTEOFF>>
     <COND (<EMPTY? .CV>
	    <COND (<EMPTY? .CL> <RETURN .BYTEOFF>)>
	    <SET CV <1 .CL>>
	    <SET CL <REST .CL>>)>
     <COND (<G=? .PTR .MAXPTR> <RETURN .BYTEOFF>)>>>

<DEFINE SCAN-SPECIAL-CODE (INST BYTEOFF
			   "AUX" (OFFS
				  <CHTYPE <ANDB .INST 65535> FIX>)
				 (CODE <CHTYPE <LSH .INST -24> FIX>) PSAVE
				 PATCH)
	#DECL ((BYTEOFF INST) FIX)
	<COND (<==? .CODE ,INST-PATCH>
	       <COND (<NOT <0? .OFFS>>
		      <SET PATCH <PATCH-CODE <GET-PATCH .OFFS>>>
		      <OR <EMPTY? .PATCH>
			  <SET BYTEOFF
			       <SCAN-PASS .BYTEOFF
					  ()
					  .PATCH
					  <>
					  <+ <LENGTH .PATCH> 1>>>>)>)
	      (<==? .CODE ,INST-PSTORE>
	       <SET PSAVE <GET-PTNS .OFFS>>
	       <COND (<PTNS-USE .PSAVE>
		      <SET PATCH <PTNS-CODE .PSAVE>>
		      <OR <EMPTY? .PATCH>
			  <SET BYTEOFF
			       <SCAN-PASS .BYTEOFF
					  ()
					  .PATCH
					  <>
					  <+ <LENGTH .PATCH> 1>>>>)>)
	      (<==? .CODE ,INST-CALL> <SET BYTEOFF <SCAN-CALL .OFFS .BYTEOFF>>)
	      (<==? .CODE ,INST-PUSHLAB> <SET BYTEOFF <+ .BYTEOFF 7>>)
	      (<==? .CODE ,INST-MOVELAB> <SET BYTEOFF <+ .BYTEOFF 7>>)>
	.BYTEOFF>

<DEFINE SCAN-CALL (OFF BYTEOFF "AUX" REF CBOFF) 
	#DECL ((OFF BYTEOFF) FIX (CBOFF) <OR FALSE FIX>)
	<SET REF <NTH ,CALL-TABLE .OFF>>
	<COND (<SET CBOFF
		    <FIND-CALL-POINT <UC-NAME .REF> <UC-NUMBER-ARGS .REF>>>
	       <COND (<G? <ABS <- <+ .BYTEOFF 2> .CBOFF>> ,JUMP-EXTENT>
		      <SET BYTEOFF <+ .BYTEOFF 6>>)
		     (<SET BYTEOFF <+ .BYTEOFF 3>>)>)
	      (<SET BYTEOFF <+ .BYTEOFF 3>>)>
	.BYTEOFF>

<DEFINE OUTPUT-CALL (BYTEOFF OFF "AUX" REF CBOFF AINST PNT) 
   #DECL ((OFF BYTEOFF) FIX)
   <SET REF <NTH ,CALL-TABLE .OFF>>
   <COND
    (<SET CBOFF <FIND-CALL-POINT <UC-NAME .REF> <UC-NUMBER-ARGS .REF>>>
     <PUT .REF ,UC-CODE-PTR -1>
     <COND (<G? <ABS <SET OFF <- <+ .BYTEOFF 3> .CBOFF>>> ,JUMP-EXTENT>
	    <SET OFF <+ .OFF 3>>
	    <ADD-BYTE-TO-FCODE ,INST-JMP>
	    <ADD-BYTE-TO-FCODE <CHTYPE <ORB ,AM-LD <AC-NUMBER ,AC-PC>> FIX>>
	    <ADD-BYTE-TO-FCODE <CHTYPE <ANDB <SET OFF <- .OFF>> 255> FIX>>
	    <ADD-BYTE-TO-FCODE <CHTYPE <ANDB <LSH .OFF -8> 255> FIX>>
	    <ADD-BYTE-TO-FCODE <CHTYPE <ANDB <LSH .OFF -16> 255> FIX>>
	    <ADD-BYTE-TO-FCODE <CHTYPE <ANDB <LSH .OFF -24> 255> FIX>>
	    <SET BYTEOFF <+ .BYTEOFF 6>>)
	   (ELSE
	    <ADD-BYTE-TO-FCODE ,INST-BRW>
	    <ADD-BYTE-TO-FCODE <CHTYPE <ANDB <SET OFF <- .OFF>> 255> FIX>>
	    <ADD-BYTE-TO-FCODE <CHTYPE <ANDB <LSH .OFF -8> 255> FIX>>
	    <SET BYTEOFF <+ .BYTEOFF 3>>)>)
    (ELSE
     <SET PNT <ADD-BYTE-TO-FCODE ,INST-BRW>>
     <PUT .REF ,UC-CALL-BYTEOFF <+ .BYTEOFF 3>>
     <PUT .REF ,UC-CODE-PTR <+ .PNT 1>>
     <ADD-BYTE-TO-FCODE 0>
     <ADD-BYTE-TO-FCODE 0>
     <SET BYTEOFF <+ .BYTEOFF 3>>)>
   .BYTEOFF>

<DEFINE GEN-SPECIAL-CODE (INST BYTEOFF
			  "AUX" (OFFS <CHTYPE <ANDB .INST 65535> FIX>)
				(CODE <CHTYPE <LSH .INST -24> FIX>) PSAVE
				PATCH)
	#DECL ((BYTEOFF INST) FIX)
	<COND (<==? .CODE ,INST-PATCH>
	       <COND (<NOT <0? .OFFS>>
		      <SET PATCH <PATCH-CODE <GET-PATCH .OFFS>>>
		      <OR <EMPTY? .PATCH>
			  <SET BYTEOFF
			       <OUTPUT-PASS
				.BYTEOFF
				()
				.PATCH
				<+ <LENGTH .PATCH> 1>
				<>>>>)>)
	      (<==? .CODE ,INST-PSTORE>
	       <SET PSAVE <GET-PTNS .OFFS>>
	       <COND (<PTNS-USE .PSAVE>
		      <SET PATCH <PTNS-CODE .PSAVE>>
		      <OR <EMPTY? .PATCH>
			  <SET BYTEOFF
			       <OUTPUT-PASS
				.BYTEOFF
				()
				.PATCH
				<+ <LENGTH .PATCH> 1>
				<>>>>)>)
	      (<==? .CODE ,INST-CALL>
	       <SET BYTEOFF <OUTPUT-CALL .BYTEOFF .OFFS>>)
	      (<==? .CODE ,INST-PUSHLAB>
	       <OUTPUT-PUSHLAB .OFFS .BYTEOFF>
	       <SET BYTEOFF <+ .BYTEOFF 7>>)
	      (<==? .CODE ,INST-MOVELAB>
	       <OUTPUT-MOVELAB .INST .OFFS .BYTEOFF>
	       <SET BYTEOFF <+ .BYTEOFF 7>>)>
	.BYTEOFF>

<DEFINE OUTPUT-PUSHLAB (OFF BYTEOFF "AUX" AINST LREF) 
	#DECL ((OFF) FIX)
	<SET LREF <NTH ,PUSH-LABEL-TABLE .OFF>>
	<ADD-BYTE-TO-FCODE ,INST-MOVL>
	<ADD-BYTE-TO-FCODE <CHTYPE <LSH <MA-AINC ,AC-PC> -24> FIX>>
	<SET AINST <ADD-BYTE-TO-FCODE 0>>
	<ADD-BYTE-TO-FCODE 0>
	<ADD-BYTE-TO-FCODE 0>
	<ADD-BYTE-TO-FCODE 0>
	<ADD-BYTE-TO-FCODE <CHTYPE <LSH <MA-AINC ,AC-TP> -24> FIX>>
	<PUT .LREF ,LABEL-REF-PUSH-POINTER .AINST>>

<DEFINE OUTPUT-MOVELAB (INST OFF BYTEOFF "AUX" LREF AINST) 
	#DECL ((OFF) FIX)
	<SET LREF <NTH ,MOVE-LABEL-TABLE .OFF>>
	<ADD-BYTE-TO-FCODE ,INST-MOVL>
	<ADD-BYTE-TO-FCODE <CHTYPE <LSH <MA-AINC ,AC-PC> -24> FIX>>
	<SET AINST <ADD-BYTE-TO-FCODE 0>>
	<ADD-BYTE-TO-FCODE 0>
	<ADD-BYTE-TO-FCODE 0>
	<ADD-BYTE-TO-FCODE 0>
	<ADD-BYTE-TO-FCODE <CHTYPE <ANDB <LSH .INST -16> 255> FIX>>
	<PUT .LREF ,LABEL-REF-PUSH-POINTER .AINST>>

<DEFINE INIT-LABEL-CHECK ("AUX" (LREF <1 ,LABEL-TABLE>)) 
	<SETG LABEL-POINTER ,LABEL-TABLE>
	<SETG LABEL-OFFSET <LABEL-REF-CODE-PTR .LREF>>>

<DEFINE CHECK-LABEL (BYTEOFF PTR "AUX" LABEL RPTR) 
	#DECL ((BYTEOFF PTR) FIX (LABEL) LABEL-REF)
	<PROG ()
	      <COND (<==? .PTR ,LABEL-OFFSET>
		     <SET RPTR ,LABEL-POINTER>
		     <SET LABEL <1 .RPTR>>
		     <PUT .LABEL ,LABEL-REF-REL-ADDR .BYTEOFF>
		     <COND (<EMPTY? <SET RPTR <REST .RPTR>>>
			    <SETG LABEL-POINTER .RPTR>
			    <SETG LABEL-OFFSET -1>)
			   (ELSE
			    <SETG LABEL-OFFSET <LABEL-REF-CODE-PTR <1 .RPTR>>>
			    <SETG LABEL-POINTER .RPTR>
			    <AGAIN>)>)>>>

<DEFINE OUTPUT-PASS (BYTEOFF
		     "OPTIONAL" (CL ,CODE-LIST) (CV <1 .CL>)
				(MAXPTR ,CODE-COUNT) (CLABELS T))
   #DECL ((BYTEOFF VALUE MAXPTR) FIX (CL) LIST (CV) CODEVEC)
   <OR <EMPTY? .CL> <SET CL <REST .CL>>>
   <REPEAT ((PTR 1) INSCODE SAVED-CV INS AFLG OP-INF NUM-OPS EAT XREF
	    LREF LB (IN-CASE? <>) START-CASE)
     #DECL ((LB PTR INSCODE INS NUM-OPS EAT) FIX (OP-INF) UVECTOR
	    (IN-CASE?) <OR FALSE FIX>)
     <SET AFLG T>
     <COND (.CLABELS <CHECK-LABEL .BYTEOFF .PTR>)>
     <SET INS <1 .CV>>
     <SET INSCODE <CHTYPE <LSH .INS -24> FIX>>
     <COND (<EMPTY? <SET CV <REST .CV>>>
	    <COND (<EMPTY? .CL> <SET AFLG <>>)
		  (ELSE <SET CV <1 .CL>> <SET CL <REST .CL>>)>)>
     <SET PTR <+ .PTR 1>>
     <COND (.IN-CASE?
	    <SET BYTEOFF <+ .BYTEOFF 2>>
	    <SET INSCODE
		 <LABEL-REF-REL-ADDR
		  <SET LREF <NTH ,LABEL-TABLE <CHTYPE .INS FIX>>>>>
	    <MAPF <>
		  <FUNCTION (TREF) 
			  <COND (<==? <XREF-INFO-POINT .TREF> <- .PTR 1>>
				 <SET XREF .TREF>
				 <MAPLEAVE>)>>
		  <LABEL-REF-XREFS .LREF>>
	    <PUT .XREF ,XREF-INFO-ADDR .START-CASE>
	    <PUT .XREF ,XREF-INFO-POINT ,FBYTE-OFFSET>
	    <SET INSCODE <- .INSCODE .START-CASE>>
	    <ADD-BYTE-TO-FCODE <CHTYPE <ANDB .INSCODE 255> FIX>>
	    <ADD-BYTE-TO-FCODE <CHTYPE <ANDB <LSH .INSCODE -8> 255> FIX>>
	    <COND (<L? <SET IN-CASE? <- .IN-CASE? 1>> 0> <SET IN-CASE? <>>)>
	    <AGAIN>)>
     <SET OP-INF <GET-INST-INFO .INSCODE>>
     <SET NUM-OPS <CHTYPE <LSH <2 .OP-INF> <- ,INIT-SHIFT>> FIX>>
     <COND
      (<MEMQ .INSCODE ,SPECIAL-OPS>
       <SET BYTEOFF <GEN-SPECIAL-CODE .INS .BYTEOFF>>)
      (ELSE
       <COND (<MEMQ .INSCODE ,CASE-INS> <SET IN-CASE? 0>)>
       <COND (<MEMQ .INSCODE ,BRANCH-INS>
	      <SET BYTEOFF <AGEN-BRANCH-1 .INS .BYTEOFF <- .PTR 1> .INSCODE>>)>
       <SET SAVED-CV <ADD-BYTE-TO-FCODE .INSCODE>>
       <SET BYTEOFF <+ .BYTEOFF 1>>
       <COND
	(<NOT <0? .NUM-OPS>>
	 <REPEAT ((SHFT -24) (FNUM 1) EAC R-OR-L ADR SIZ)
	   #DECL ((SHFT FNUM EAC R-OR-L ADR SIZ) FIX)
	   <COND (<L? <SET NUM-OPS <- .NUM-OPS 1>> 0> <RETURN>)>
	   <COND (<G? <SET SHFT <+ .SHFT 8>> 0>
		  <SET SHFT -24>
		  <SET PTR <+ .PTR 1>>
		  <OR .AFLG <ERROR ACCESS-BEYOND-END-OF-CODE!-ERRORS>>
		  <SET INS <1 .CV>>
		  <COND (<EMPTY? <SET CV <REST .CV>>>
			 <COND (<EMPTY? .CL> <SET AFLG <>>)
			       (ELSE <SET CV <1 .CL>> <SET CL <REST .CL>>)>)>)>
	   <SET ADR <CHTYPE <ANDB <LSH .INS .SHFT> 255> FIX>>
	   <SET EAC <CHTYPE <ANDB .ADR 240> FIX>>
	   <SET R-OR-L <CHTYPE <ANDB .ADR 15> FIX>>
	   <SET SIZ
		<CHTYPE <ANDB <SET EAT <GET-OP-INFO .FNUM .OP-INF>> 7> FIX>>
	   <SET FNUM <+ .FNUM 1>>
	   <COND
	    (<OR <==? .EAT ,OP-BB> <==? .EAT ,OP-BW>>
	     <SET BYTEOFF
		  <AGEN-BRANCH-2 .INS
				 .BYTEOFF
				 <- .PTR 1>
				 .INSCODE
				 .SAVED-CV
				 .EAT>>)
	    (<L? .EAC ,AM-INX>
	     <ADD-BYTE-TO-FCODE .ADR>
	     <SET BYTEOFF <+ .BYTEOFF 1>>
	     <COND (.IN-CASE?
		    <COND (<0? .NUM-OPS> <SET IN-CASE? .ADR>)
			  (<1? .NUM-OPS> <SET LB .ADR>)>)>)
	    (<==? .EAC ,AM-INX>
	     <SET FNUM <- .FNUM 1>>
	     <SET NUM-OPS <+ .NUM-OPS 1>>
	     <ADD-BYTE-TO-FCODE .ADR>
	     <SET BYTEOFF <+ .BYTEOFF 1>>)
	    (<OR <==? .EAC ,AM-REG> <==? .EAC ,AM-REGD> <==? .EAC ,AM-ADEC>>
	     <ADD-BYTE-TO-FCODE .ADR>
	     <SET BYTEOFF <+ .BYTEOFF 1>>)
	    (<OR <==? .EAC ,AM-AINC> <==? .EAC ,AM-AINCD>>
	     <COND
	      (<==? .R-OR-L ,NAC-PC>
	       <ADD-BYTE-TO-FCODE .ADR>
	       <SET BYTEOFF <+ .BYTEOFF 1>>
	       <COND (<==? .EAC ,AM-AINCD> <SET SIZ 4>)
		     (<OR <==? .SIZ ,SZ-L> <==? .SIZ ,SZ-F>> <SET SIZ 4>)
		     (<==? .SIZ ,SZ-W> <SET SIZ 2>)
		     (ELSE <SET SIZ 1>)>
	       <REPEAT ((CNT -8) (IMM 0))
		 <COND (<L? <SET SIZ <- .SIZ 1>> 0>
			<COND (.IN-CASE?
			       <COND (<L=? .NUM-OPS 0>
				      <SET IN-CASE? .IMM>)
				     (<1? .NUM-OPS> <SET LB .IMM>)>)>
			<RETURN>)>
		 <COND (<G? <SET SHFT <+ .SHFT 8>> 0>
			<SET SHFT -24>
			<SET PTR <+ .PTR 1>>
			<OR .AFLG <ERROR ACCESS-BEYOND-END-OF-CODE!-ERRORS>>
			<SET INS <1 .CV>>
			<COND (<EMPTY? <SET CV <REST .CV>>>
			       <COND (<EMPTY? .CL> <SET AFLG <>>)
				     (ELSE
				      <SET CV <1 .CL>>
				      <SET CL <REST .CL>>)>)>)>
		 <SET CNT <+ .CNT 8>>
		 <SET ADR <CHTYPE <ANDB <LSH .INS .SHFT> 255> FIX>>
		 <SET IMM <ORB .IMM <LSH .ADR .CNT>>>
		 <ADD-BYTE-TO-FCODE .ADR>
		 <SET BYTEOFF <+ .BYTEOFF 1>>>)
	      (ELSE <ADD-BYTE-TO-FCODE .ADR> <SET BYTEOFF <+ .BYTEOFF 1>>)>)
	    (ELSE
	     <ADD-BYTE-TO-FCODE .ADR>
	     <SET BYTEOFF <+ .BYTEOFF 1>>
	     <COND (<OR <==? .EAC ,AM-BDD> <==? .EAC ,AM-BD>> <SET SIZ 1>)
		   (<OR <==? .EAC ,AM-WDD> <==? .EAC ,AM-WD>> <SET SIZ 2>)
		   (<OR <==? .EAC ,AM-LDD> <==? .EAC ,AM-LD>> <SET SIZ 4>)>
	     <REPEAT ()
	       <COND (<L? <SET SIZ <- .SIZ 1>> 0> <RETURN>)>
	       <COND (<G? <SET SHFT <+ .SHFT 8>> 0>
		      <SET SHFT -24>
		      <SET PTR <+ .PTR 1>>
		      <OR .AFLG <ERROR ACCESS-BEYOND-END-OF-CODE!-ERRORS>>
		      <SET INS <1 .CV>>
		      <COND (<EMPTY? <SET CV <REST .CV>>>
			     <COND (<EMPTY? .CL> <SET AFLG <>>)
				   (ELSE
				    <SET CV <1 .CL>>
				    <SET CL <REST .CL>>)>)>)>
	       <SET ADR <CHTYPE <ANDB <LSH .INS .SHFT> 255> FIX>>
	       <ADD-BYTE-TO-FCODE .ADR>
	       <SET BYTEOFF <+ .BYTEOFF 1>>>)>>)>)>
     <COND (.IN-CASE? <SET START-CASE .BYTEOFF>)>
     <OR .AFLG <RETURN .BYTEOFF>>
     <COND (<EMPTY? .CV>
	    <COND (<EMPTY? .CL> <RETURN .BYTEOFF>)>
	    <SET CV <1 .CL>>
	    <SET CL <REST .CL>>)>
     <COND (<G=? .PTR .MAXPTR> <RETURN .BYTEOFF>)>>
   <COND (.CLABELS <+ .BYTEOFF <FORCE-OUT-FCODE>>) (.BYTEOFF)>>

<DEFINE SWAP-MODE (MODEA "AUX" LOW HIGH) 
	#DECL ((MODEA) FIX)
	<SET LOW <GETBITS .MODEA <BITS 3 0>>>
	<SET HIGH <GET-FIELD .MODEA <BITS 3 3>>>
	<PUTBITS .HIGH <BITS 3 3> .LOW>>

<DEFINE GENEA (EA BYTEOFF DISP SZ "AUX" WD AMODE (RES .EA) TAB) 
	#DECL ((DISP EA SZ BYTEOFF) FIX (VALUE) FIX)
	<COND (<AND <==? .EA ,ADDRESS-IMM> <==? .SZ ,LENGTH-LONG>>
	       <SET TAB ,CONSTANT-TABLE>
	       <COND (<0? <SET WD <NTH .TAB <+ .DISP 1>>>>
		      <SET WD <NTH .TAB .DISP>>
		      <PUT .TAB <+ .DISP 1> .BYTEOFF>
		      <ADD-WORD-TO-FCODE <LHW .WD>>
		      <ADD-WORD-TO-FCODE .WD>
		      <SET BYTEOFF <+ .BYTEOFF 4>>)
		     (ELSE
		      <SET RES ,ADDRESS-PCDISP>
		      <ADD-WORD-TO-FCODE <- .WD .BYTEOFF>>
		      <SET BYTEOFF <+ .BYTEOFF 2>>)>)
	      (ELSE
	       <SET AMODE <GET-FIELD .EA <BITS 3 3>>>
	       <COND (<G? .AMODE 4>
		      <SET BYTEOFF <+ .BYTEOFF 2>>
		      <ADD-WORD-TO-FCODE .DISP>)>)>
	<PUT-LHW .RES .BYTEOFF>>

<DEFINE EXTEND (X) 
	#DECL ((X) FIX)
	<COND (<1? <GET-FIELD .X <BITS 1 15>>> <ORB .X <LSH -1 16>>)
	      (.X)>>

<DEFINE EXTEND-BYTE (X) 
	#DECL ((X) FIX)
	<COND (<1? <GET-FIELD .X <BITS 1 7>>> <ORB .X <LSH -1 8>>)
	      (.X)>>

<DEFINE FORCE-OUT-FCODE ("AUX" (SHFT ,FSHIFT)) 
	#DECL ((SHFT) FIX)
	<REPEAT ((I 0))
		<COND (<L=? <SET SHFT <- .SHFT 8>> 0> <RETURN .I>)>
		<ADD-BYTE-TO-FCODE 0>
		<SET I <+ .I 1>>>>

<DEFINE INIT-UNRESOLVED-CALLS () <SETG UNRESOLVED-CALLS-TABLE ()>>

<DEFINE CHECK-UNRESOLVED-CALLS (EBYTEOFF SBYTEOFF) 
	#DECL ((SBYTEOFF EBYTEOFF) FIX)
	<MAPF <>
	      <FCN (UCALL "AUX" NPTR TEM)
		   <COND (<G? <- .EBYTEOFF <UC-CALL-BYTEOFF .UCALL>>
			      ,JUMP-EXTENT>
			  <COND (<G?
				  <SET TEM <- .SBYTEOFF <UC-CALL-BYTEOFF .UCALL>>>
				  ,JUMP-EXTENT>
				 <ERROR CANT-JUMP-FAR-ENOUGH
					.UCALL .SBYTEOFF .EBYTEOFF
					CHECK-UNRESOLVED-CALLS>)>
			  <PUT-FCODE <UC-CODE-PTR .UCALL>
				     <CHTYPE <ANDB .TEM 255> FIX>>
			  <PUT-FCODE <+ <UC-CODE-PTR .UCALL> 1>
				     <CHTYPE <ANDB <LSH .TEM -8> 255> FIX>>
			  <PUT .UCALL ,UC-CALL-BYTEOFF <+ .SBYTEOFF 3>>
			  <ADD-BYTE-TO-FCODE ,INST-BRW>
			  <SET NPTR <ADD-BYTE-TO-FCODE 0>>
			  <ADD-BYTE-TO-FCODE 0>
			  <PUT .UCALL ,UC-CODE-PTR .NPTR>
			  <SET SBYTEOFF <+ .SBYTEOFF 3>>)>>
	      ,UNRESOLVED-CALLS-TABLE>
	.SBYTEOFF>

<DEFINE ADD-UNRESOLVED-CALLS ("AUX" (TAB ,UNRESOLVED-CALLS-TABLE)) 
	<MAPF <>
	      <FCN (UCALL)
		   <OR .UCALL <MAPLEAVE>>
		   <COND (<G? <UC-CODE-PTR .UCALL> 0>
			  <COND (<EMPTY? .TAB>
				 <SET TAB (.UCALL)>)
				(T
				 ; "Try a little harder to keep calls in the
				    right order, avoiding fencepost death
				    in check-unresolved-calls"
				 <PUTREST <REST .TAB <- <LENGTH .TAB> 1>>
					  (.UCALL)>)>)>>
	      ,CALL-TABLE>
	<SETG UNRESOLVED-CALLS-TABLE .TAB>>

<DEFINE FIXUP-UNRESOLVED-CALLS (CE "AUX" (NAME <CET-MSUBR-NAME .CE>)) 
   #DECL ((CE) CALL-ENTRY)
   <REPEAT ((PTR ,UNRESOLVED-CALLS-TABLE) (PPTR .PTR) UCALL OFF)
	   #DECL ((OFF) <OR FALSE FIX>)
	   <COND (<EMPTY? .PTR> <RETURN>)>
	   <SET UCALL <1 .PTR>>
	   <COND (<SAME-NAME? <UC-NAME .UCALL> .NAME>
		  <OR <SET OFF <FIND-ENTRY-LOC .CE <UC-NUMBER-ARGS .UCALL>>>
		      <ERROR "CANT JUMP" FIXUP-UNRESOLVED-CALLS>>
		  <SET OFF <- .OFF <UC-CALL-BYTEOFF .UCALL>>>
		  <AND <G? <ABS .OFF> ,JUMP-EXTENT>
		       <ERROR "CANT JUMP" FIXUP-UNRESOLVED-CALLS>>
		  <PUT-FCODE <UC-CODE-PTR .UCALL> <CHTYPE <ANDB .OFF 255> FIX>>
		  <PUT-FCODE <+ <UC-CODE-PTR .UCALL> 1>
			     <CHTYPE <ANDB <LSH .OFF -8> 255> FIX>>
		  <COND (<==? .PTR .PPTR>
			 <SETG UNRESOLVED-CALLS-TABLE <REST .PTR>>
			 <SET PPTR <REST .PTR>>)
			(<PUTREST .PPTR <REST .PTR>>)>)
		 (<SET PPTR .PTR>)>
	   <SET PTR <REST .PTR>>>>
