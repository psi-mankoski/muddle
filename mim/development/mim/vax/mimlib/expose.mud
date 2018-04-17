<PACKAGE "EXPOSE">

<INCLUDE-WHEN <COMPILING? "EXPOSE"> "EXPOSE-DEFS">

<INCLUDE "EXPOSE-DATA">

<ENTRY EXPOSE VAX-NOVICE>

<GDECL (KERNEL-TABLE) <<PRIMTYPE VECTOR> [REST LIST]>>

<GDECL (REGISTER-NAMES) <VECTOR STRING>>

<DEFINE EXPOSE (MSB "OPT" (OUTCHAN .OUTCHAN))
   #DECL ((MSB) MSUBR (OUTCHAN) <SPECIAL CHANNEL>)
   <PRINTSTRING "Exposing ">
   <PRINTSTRING <SPNAME <2 .MSB>>>
   <CRLF> <CRLF>
   <BIND ((IMSB-ATM <1 .MSB>)
	  (IMSB ,.IMSB-ATM)
	  (START <4 .MSB>)
	  (END <FIND-END .MSB>)
	  (LABEL-TABLE <STACK <IVECTOR ,LABEL-TABLE-LENGTH ()>>))
      <PARSE-CODE .IMSB .START .END .LABEL-TABLE>
      <PRINT-CODE .IMSB .START .END .LABEL-TABLE>>
   <CRLF>
   T>

<SETG VAX-NOVICE %<>>

<DEFINE PARSE-CODE (IMSB START END LABEL-TABLE "AUX" (CODE <1 .IMSB>))
   #DECL ((START END) FIX (IMSB) IMSUBR 
	  (LABEL-TABLE) <<PRIMTYPE VECTOR> [REST LIST]>
	  (CODE) <<PRIMTYPE UVECTOR> [REST FIX]>)
   <SETG TAG-COUNT 0>
   <SETG LOOP-COUNT 0>
   <REPEAT ((I .START) NUM OP)
      #DECL ((NUM I) FIX (OP) <OR FALSE VECTOR OPCODE-TABLE>)
      <COND (<G=? .I .END> <RETURN>)>
      <REPEAT ()
	 <SET NUM <GET-BYTE .CODE .I>>
	 <SET I <+ .I 1>>
	 <SET OP <NTH ,OPCODE-TABLE <+ .NUM 1>>>
	 <COND (<NOT <TYPE? .OP OPCODE-TABLE>> <RETURN>)>>
      <COND (.OP
	     <MAPF %<>
		   <FUNCTION (LEN)
		      <SET I <PARSE-OPERAND .CODE .I .LEN .LABEL-TABLE 
					    .START .END>>>
		   <2 .OP>:<VECTOR [REST FIX]>>)>>>

<DEFINE PRINT-CODE (IMSB START END LABEL-TABLE "AUX" NUM 
		    (CODE <1 .IMSB>)
		    (COMMENTS <STACK <IVECTOR 10>>))
   #DECL ((IMSB) IMSUBR (START END NUM) FIX 
	  (LABEL-TABLE) <<PRIMTYPE VECTOR> [REST LIST]>)
   <REPEAT ((I .START) FIRST OP)
      #DECL ((I) FIX (OP) <OR FALSE OPCODE-TABLE VECTOR>)
      <COND (<G=? .I .END> <RETURN>)>
      <1 .COMMENTS 1>	;"reset number of comments to 'zero'"
      <COND (<PRINT-LABEL .LABEL-TABLE .I> <PRINTSTRING ":">)>
      <REPEAT ()
	 <SET NUM <GET-BYTE .CODE .I>>
	 <SET I <+ .I 1>>
	 <SET OP <NTH ,OPCODE-TABLE <+ .NUM 1>>>
	 <COND (<NOT <TYPE? .OP OPCODE-TABLE>>
		<RETURN>)>>
      <INDENT-TO ,OP-COLUMN>
      <COND (.OP
	     <PRINTSTRING <1 .OP>>
	     <INDENT-TO ,ARG-COLUMN>
	     <SET FIRST T>
	     <MAPF %<>
		   <FUNCTION (LEN)
		      <COND (.FIRST <SET FIRST %<>>)
			    (ELSE <PRINTSTRING ",">)>
		      <SET I <PRINT-OPERAND .IMSB .I .LEN .LABEL-TABLE 
					    .COMMENTS>>>
		   <2 .OP>:<VECTOR [REST FIX]>>
	     <COND (,VAX-NOVICE
		    <INDENT-TO ,COMMENT-COLUMN>
		    <PRINTSTRING ";">
		    <PRINTSTRING <3 .OP>>)>
	     <PRINT-COMMENTS .COMMENTS ,VAX-NOVICE>)
	    (ELSE
	     <PRINTSTRING ".byte">
	     <INDENT-TO ,ARG-COLUMN>
	     <PRINT-BYTE .NUM>)>
      <CRLF>>>

<DEFINE PARSE-OPERAND (MCODE I ORIGINAL-LEN LABEL-TABLE START END
		       "AUX" (LEN <ANDB .ORIGINAL-LEN ,LENGTH-MASK>)
		       ONE REG NUM VAL)
   #DECL ((MCODE) <<PRIMTYPE UVECTOR> [REST FIX]> (I ORIGINAL-LEN ONE REG) FIX)
   <COND (<BRANCH? .ORIGINAL-LEN>
	  <SET NUM <SIGN-EXT <GET-N-BYTES .MCODE .I .LEN> .LEN>>
	  <SET I <+ .I .LEN>>
	  <ADD-LABEL .LABEL-TABLE .I .NUM .START .END>)
	 (<CASE? .ORIGINAL-LEN>
	  <SET ONE <GET-BYTE .MCODE .I>>
	  <SET I <+ .I 1>>
	  <SET VAL <+ <ANDB .ONE 63> 1>>
	  <PARSE-WORDS .MCODE .I .VAL .LABEL-TABLE .START .END>
	  <SET I <+ .I <* 2 .VAL>>>)
	 (ELSE
	  <SET ONE <GET-BYTE .MCODE .I>>
	  <SET I <+ .I 1>>
	  <SET REG <ANDB .ONE 15>>
	  <CASE ,==? <LSH .ONE -4>
		(4
		 <SET I 
		      <PARSE-OPERAND .MCODE .I .LEN .LABEL-TABLE .START .END>>)
		(8
		 <COND (<==? .REG 15>
			<SET I <+ .I .LEN>>)>)
		(9
		 <COND (<==? .REG 15>
			<SET I <+ .I 4>>)>)
		(10
		 <SET I <+ .I 1>>)
		(11
		 <SET I <+ .I 1>>)
		(12
		 <SET I <+ .I 2>>)
		(13
		 <SET I <+ .I 2>>)
		(14
		 <SET I <+ .I 4>>)
		(15
		 <SET I <+ .I 4>>)>)>
   .I>

<DEFINE PRINT-OPERAND (IMSB I LEN-CODE LABEL-TABLE COMMENTS
		       "AUX" 
		       (LEN <ANDB .LEN-CODE ,LENGTH-MASK>)
		       (CODE <1 .IMSB>)
		       ONE REG NUM VAL)
   #DECL ((CODE) <<PRIMTYPE UVECTOR> [REST FIX]> (IMSB) IMSUBR
	  (I LEN-CODE ONE REG NUM VAL) FIX)
   <COND (<BRANCH? .LEN-CODE>
	  <SET NUM <SIGN-EXT <GET-N-BYTES .CODE .I .LEN> .LEN>>
	  <SET I <+ .I .LEN>>
	  <COND (<NOT <PRINT-LABEL .LABEL-TABLE <+ .I .NUM>>>
		 <PRINTSTRING "#">
		 <PRINT-HEX .NUM .LEN>)>)
	 (<CASE? .LEN-CODE>
	  <SET ONE <GET-BYTE .CODE .I>>
	  <SET I <+ .I 1>>
	  <SET VAL <+ <ANDB .ONE 63> 1>>
	  <PRINTSTRING "S^#">
	  <PRINT-BYTE .VAL>
	  <PRINT-WORDS .CODE .I .VAL .LABEL-TABLE>
	  <SET I <+ .I <* 2 .VAL>>>)
	 (ELSE
	  <SET ONE <GET-BYTE .CODE .I>>
	  <SET I <+ .I 1>>
	  <SET REG <ANDB .ONE 15>>
	  <CASE ,==? <LSH .ONE -4>
		(4
		 <SET I <PRINT-OPERAND .IMSB .I .LEN .LABEL-TABLE 
				       .COMMENTS>>
		 <PRINTSTRING "[">
		 <PRINT-REGISTER .REG>
		 <PRINTSTRING "]">)
		(5 
		 <PRINT-REGISTER .REG>)
		(6
		 <PRINTSTRING "(">
		 <PRINT-REGISTER .REG>
		 <PRINTSTRING ")">)
		(7
		 <PRINTSTRING "-(">
		 <PRINT-REGISTER .REG>
		 <PRINTSTRING ")">)
		(8
		 <COND (<==? .REG 15>
			<SET NUM <GET-N-BYTES .CODE .I .LEN>>
			<SET I <+ .I .LEN>>
			<PRINTSTRING "#">
			<PRINT-HEX .NUM .LEN>)
		       (ELSE
			<PRINTSTRING "(">
			<PRINT-REGISTER .REG>
			<PRINTSTRING ")+">)>)
		(9
		 <COND (<==? .REG 15>
			<PRINTSTRING "@">
			<SET VAL <GET-LONG .CODE .I>>
			<SET I <+ .I 4>>
			<COND (<NOT <PRINT-KERNEL-LOCATION .VAL>>
			       <PRINTSTRING "#">
			       <PRINT-LONG .VAL>)>)
		       (ELSE
			<PRINTSTRING "@(">
			<PRINT-REGISTER .REG>
			<PRINTSTRING ")+">)>)
		(10
		 <SET VAL <SIGN-EXT-BYTE <GET-BYTE .CODE .I>>>
		 <PRINT-BYTE .VAL>
		 <SET I <+ .I 1>>
		 <COND (<N==? .REG 15>
			<PRINTSTRING "(">
			<PRINT-REGISTER .REG>
			<PRINTSTRING ")">)>
		 <COND (<==? .REG 11>
			<ADD-COMMENT .COMMENTS 
				     <NTH .IMSB <+ </ .VAL 8> 1>>>)>)
		(11
		 <SET VAL <SIGN-EXT-BYTE <GET-BYTE .CODE .I>>>
		 <SET I <+ .I 1>>
		 <PRINTSTRING "@">
		 <PRINT-BYTE .VAL>
		 <COND (<N==? .REG 15>
			<PRINTSTRING "(">
			<PRINT-REGISTER .REG>
			<PRINTSTRING ")">)>
		 <COND (<==? .REG 11>
			<ADD-COMMENT .COMMENTS 
				     <NTH .IMSB <+ </ .VAL 8> 1>>>)>)
		(12
		 <SET VAL <SIGN-EXT-WORD <GET-WORD .CODE .I>>>
		 <SET I <+ .I 2>>
		 <PRINT-WORD .VAL>
		 <COND (<N==? .REG 15>
			<PRINTSTRING "(">
			<PRINT-REGISTER .REG>
			<PRINTSTRING ")">)>
		 <COND (<==? .REG 11>
			<ADD-COMMENT .COMMENTS 
				     <NTH .IMSB <+ </ .VAL 8> 1>>>)>)
		(13
		 <SET VAL <SIGN-EXT-WORD <GET-WORD .CODE .I>>>
		 <SET I <+ .I 2>>
		 <PRINTSTRING "@">
		 <PRINT-WORD .VAL>
		 <COND (<N==? .REG 15>
			<PRINTSTRING "(">
			<PRINT-REGISTER .REG>
			<PRINTSTRING ")">)>
		 <COND (<==? .REG 11>
			<ADD-COMMENT .COMMENTS 
				     <NTH .IMSB <+ </ .VAL 8> 1>>>)>)
		(14
		 <SET VAL <GET-LONG .CODE .I>>
		 <SET I <+ .I 4>>
		 <PRINT-LONG .VAL>
		 <COND (<N==? .REG 15>
			<PRINTSTRING "(">
			<PRINT-REGISTER .REG>
			<PRINTSTRING ")">)>
		 <COND (<==? .REG 11>
			<ADD-COMMENT .COMMENTS 
				     <NTH .IMSB <+ </ .VAL 8> 1>>>)>)
		(15
		 <SET VAL <GET-LONG .CODE .I>>
		 <PRINTSTRING "@">
		 <SET I <+ .I 4>>
		 <PRINT-LONG .VAL>
		 <COND (<N==? .REG 15>
			<PRINTSTRING "(">
			<PRINT-REGISTER .REG>
			<PRINTSTRING ")">)>
		 <COND (<==? .REG 11>
			<ADD-COMMENT .COMMENTS 
				     <NTH .IMSB <+ </ .VAL 8> 1>>>)>)
		DEFAULT
		(<PRINTSTRING "S^#">
		 <PRINT-BYTE <ANDB .ONE 63>>)>)>
   .I>

<DEFINE PARSE-WORDS (CODE ORIGINAL-I N LABEL-TABLE START END
		     "AUX" (I .ORIGINAL-I) NUM)
   #DECL ((CODE) <<PRIMTYPE UVECTOR> [REST FIX]> (I N NUM) FIX)
   <REPEAT ()
      <COND (<0? .N> <RETURN>)>
      <SET NUM <SIGN-EXT-WORD <GET-WORD .CODE .I>>>
      <SET I <+ .I 2>>
      <ADD-LABEL .LABEL-TABLE .ORIGINAL-I .NUM .START .END>
      <SET N <- .N 1>>>
   .I>

<DEFINE PRINT-WORDS (CODE ORIGINAL-I N LABEL-TABLE "AUX" (I .ORIGINAL-I)
		     NUM (OUTCHAN .OUTCHAN))
   #DECL ((CODE) <<PRIMTYPE UVECTOR> [REST FIX]> (I N NUM) FIX)
   <REPEAT ()
      <COND (<0? .N> <RETURN>)>
      <CRLF>
      <INDENT-TO ,OP-COLUMN>
      <PRINTSTRING ".word">
      <INDENT-TO ,ARG-COLUMN>
      <SET NUM <SIGN-EXT-WORD <GET-WORD .CODE .I>>>
      <SET I <+ .I 2>>
      <COND (<NOT <PRINT-LABEL .LABEL-TABLE <+ .ORIGINAL-I .NUM>>>
	     <PRINT-WORD .NUM>)>
      <SET N <- .N 1>>>
   .I>

<DEFINE PRINT-BYTE (NUM "AUX" (ANUM <ABS .NUM>) (STR <STACK <ISTRING 3 !\->>))
   #DECL ((NUM) FIX (STR) STRING)
   <2 .STR <HEX-CHAR <LSH .ANUM -4>>>
   <3 .STR <HEX-CHAR .ANUM>>
   <COND (<L? .NUM 0> <PRINTSTRING .STR>)
	 (ELSE <PRINTSTRING <REST .STR>>)>>

<DEFINE PRINT-WORD (NUM "AUX" (ANUM <ABS .NUM>) (STR <STACK <ISTRING 5 !\->>))
   #DECL ((NUM) FIX (STR) STRING)
   <2 .STR <HEX-CHAR <LSH .ANUM -12>>>
   <3 .STR <HEX-CHAR <LSH .ANUM -8>>>
   <4 .STR <HEX-CHAR <LSH .ANUM -4>>>
   <5 .STR <HEX-CHAR .ANUM>>
   <COND (<L? .NUM 0> <PRINTSTRING .STR>)
	 (ELSE <PRINTSTRING <REST .STR>>)>>

<DEFINE PRINT-TRIBYTE (NUM "AUX" (ANUM <ABS .NUM>) 
			 (STR <STACK <ISTRING 7 !\->>))
   #DECL ((NUM) FIX (STR) STRING)
   <2 .STR <HEX-CHAR <LSH .ANUM -20>>>
   <3 .STR <HEX-CHAR <LSH .ANUM -16>>>
   <4 .STR <HEX-CHAR <LSH .ANUM -12>>>
   <5 .STR <HEX-CHAR <LSH .ANUM -8>>>
   <6 .STR <HEX-CHAR <LSH .ANUM -4>>>
   <7 .STR <HEX-CHAR .ANUM>>
   <COND (<L? .NUM 0> <PRINTSTRING .STR>)
	 (ELSE <PRINTSTRING <REST .STR>>)>>

<DEFINE PRINT-LONG (NUM "AUX" (ANUM <ABS .NUM>) (STR <ISTRING 9 !\->))
   #DECL ((NUM) FIX (STR) STRING)
   <2 .STR <HEX-CHAR <LSH .ANUM -28>>>
   <3 .STR <HEX-CHAR <LSH .ANUM -24>>>
   <4 .STR <HEX-CHAR <LSH .ANUM -20>>>
   <5 .STR <HEX-CHAR <LSH .ANUM -16>>>
   <6 .STR <HEX-CHAR <LSH .ANUM -12>>>
   <7 .STR <HEX-CHAR <LSH .ANUM -8>>>
   <8 .STR <HEX-CHAR <LSH .ANUM -4>>>
   <9 .STR <HEX-CHAR .ANUM>>
   <COND (<L? .NUM 0> <PRINTSTRING .STR>)
	 (ELSE <PRINTSTRING <REST .STR>>)>>

<DEFINE SIGN-EXT (NUM LEN)
   <COND (<==? .LEN 1> <SIGN-EXT-BYTE .NUM>)
	 (<==? .LEN 2> <SIGN-EXT-WORD .NUM>)
	 (<==? .LEN 4> .NUM)
	 (ELSE <ERROR BAD-LENGTH!-ERRORS .LEN SIGN-EXT>)>>

<DEFINE PRINT-HEX (NUM LEN)
   <CASE ,==? .LEN
	 (1 <PRINT-BYTE .NUM>)
	 (2 <PRINT-WORD .NUM>)
	 (3 <PRINT-TRIBYTE .NUM>)
	 (4 <PRINT-LONG .NUM>)
	 DEFAULT
	 (<ERROR BAD-LENGTH!-ERRORS .LEN PRINT-HEX>)>>

<DEFINE GET-BYTE (MCODE I)
   #DECL ((MCODE) <<PRIMTYPE UVECTOR> [REST FIX]> (I) FIX)
   <GETBITS <NTH .MCODE <+ </ .I 4> 1>>
	    <BITS 8 <* <MOD .I 4> 8>>>>

<DEFINE GET-WORD (MCODE I)
   #DECL ((MCODE) <<PRIMTYPE UVECTOR> [REST FIX]> (I) FIX)
   <ORB <GET-BYTE .MCODE .I>
	<LSH <GET-BYTE .MCODE <+ .I 1>> 8>>>

<DEFINE GET-LONG (MCODE I)
   #DECL ((MCODE) <<PRIMTYPE UVECTOR> [REST FIX]> (I) FIX)
   <ORB <GET-WORD .MCODE .I>
	<LSH <GET-WORD .MCODE <+ .I 2>> 16>>>

<DEFINE GET-N-BYTES (MCODE I N)
   #DECL ((MCODE) <<PRIMTYPE UVECTOR> [REST FIX]> (I N) FIX)
   <REPEAT ((RES 0) (LSH-AMT 0))
      <COND (<==? .N 0> <RETURN .RES>)>
      <SET RES <ORB .RES <LSH <GET-BYTE .MCODE .I> .LSH-AMT>>>
      <SET I <+ .I 1>>
      <SET N <- .N 1>>
      <SET LSH-AMT <+ .LSH-AMT 8>>>>

<DEFINE SIGN-EXT-BYTE (NUM)
   <COND (<0? <ANDB .NUM %<LSH 1 7>>>
	  .NUM)
	 (ELSE
	  <- <ANDB .NUM %<LSH -1 <- 7 32>>> %<LSH 1 7>>)>>

<DEFINE SIGN-EXT-WORD (NUM)
   <COND (<0? <ANDB .NUM %<LSH 1 15>>>
	  .NUM)
	 (ELSE
	  <- <ANDB .NUM %<LSH -1 <- 15 32>>> %<LSH 1 15>>)>>

<DEFINE ADD-COMMENT (COMMENTS OBJ "AUX" PLACE)
   #DECL ((COMMENTS) <<PRIMTYPE VECTOR> FIX> (PLACE) FIX)
   <1 .COMMENTS <SET PLACE <+ <1 .COMMENTS> 1>>>
   <PUT .COMMENTS .PLACE .OBJ>>

<DEFINE PRINT-COMMENTS (COMMENTS ALREADY-ONE "AUX" (PLACE <1 .COMMENTS>)
			(OUTCHAN .OUTCHAN))
   #DECL ((COMMENTS) <<PRIMTYPE VECTOR> FIX> (PLACE) FIX)
   <REPEAT ((N 2))
      #DECL ((N) FIX)
      <COND (<G? .N .PLACE> <RETURN>)>
      <COND (.ALREADY-ONE <CRLF>)>
      <INDENT-TO ,COMMENT-COLUMN>
      <PRINTSTRING ";">
      <&1 <NTH .COMMENTS .N>>
      <SET ALREADY-ONE T>
      <SET N <+ .N 1>>>>

;"These numbers keep track of the last label used.  TAG-COUNT counts up."
;"LOOP-COUNT counts down."

<SETG TAG-COUNT 0>
<SETG LOOP-COUNT 0>
<GDECL (TAG-COUNT LOOP-COUNT) FIX>

<DEFINE FIND-LABEL (LABEL-TABLE I "AUX" BKTNUM)
   #DECL ((LABEL-TABLE) <<PRIMTYPE VECTOR> [REST LIST]> (I BKTNUM) FIX)
   <SET BKTNUM <+ <MOD .I ,LABEL-TABLE-LENGTH> 1>>
   <REPEAT ((BKT <NTH .LABEL-TABLE .BKTNUM>))
      #DECL ((BKT) <LIST [REST FIX]>)
      <COND (<EMPTY? .BKT> <RETURN %<>>)>
      <COND (<==? .I <1 .BKT>> <RETURN <2 .BKT>>)>
      <SET BKT <REST .BKT 2>>>>

<DEFINE ADD-LABEL (LABEL-TABLE:<<PRIMTYPE VECTOR> [REST LIST]>
		   I:FIX NUM:FIX START:FIX END:FIX
		   "AUX" BKTNUM BKT (SUM <+ .I .NUM>))
   #DECL ((BKTNUM SUM) FIX (BKT) <LIST [REST FIX]>)
   <COND (<G=? .NUM 0>
	  <COND (<L? .SUM .END>
		 <SET BKTNUM <+ <MOD .SUM ,LABEL-TABLE-LENGTH> 1>>
		 <SET BKT <NTH .LABEL-TABLE .BKTNUM>>
		 <REPEAT ((B .BKT))
		    <COND (<EMPTY? .B>
			   <PUT .LABEL-TABLE .BKTNUM 
				(.SUM
				 <SETG TAG-COUNT <+ ,TAG-COUNT 1>>
				 !.BKT)>
			   <RETURN>)>
		    <COND (<==? .SUM <1 .B>> <RETURN>)>
		    <SET B <REST .B 2>>>)>)
	 (ELSE
	  <COND (<G=? .SUM .START>
		 <SET BKTNUM <+ <MOD .SUM ,LABEL-TABLE-LENGTH> 1>>
		 <SET BKT <NTH .LABEL-TABLE .BKTNUM>>
		 <REPEAT ((B .BKT))
		    <COND (<EMPTY? .B>
			   <PUT .LABEL-TABLE .BKTNUM 
				(.SUM
				 <SETG LOOP-COUNT <- ,LOOP-COUNT 1>>
				 !.BKT)>
			   <RETURN>)>
		    <COND (<==? .SUM <1 .B>> 
			   <COND (<G? <2 .B> 0>
				  <2 .B <SETG LOOP-COUNT <- ,LOOP-COUNT 1>>>)>
			   <RETURN>)>
		    <SET B <REST .B 2>>>)>)>>

<DEFINE PRINT-LABEL (LABEL-TABLE I "AUX" LAB (OUTCHAN .OUTCHAN))
   #DECL ((LAB) <OR FIX FALSE>)
   <SET LAB <FIND-LABEL .LABEL-TABLE .I>>
   <COND (.LAB 
	  <COND (<G? .LAB 0>
		 <PRINTSTRING "tag">
		 <PRIN1 .LAB>)
		(ELSE
		 <PRINTSTRING "loop">
		 <PRIN1 <- .LAB>>)>)>>

<DEFINE FIND-END (MSBR:MSUBR "AUX" 
		  (START <4 .MSBR>)
		  (IMSB-ATM <1 .MSBR>)
		  (END <* 4 
			  <LENGTH 
			   <1 ,.IMSB-ATM:IMSUBR>:<PRIMTYPE UVECTOR>>>)) 
   #DECL ((START) FIX (END) FIX)
   <MAPF %<>
	 <FUNCTION (BKT:LIST)
	    <MAPF %<>
		  <FUNCTION (ATM "AUX" VAL STRT)
		     #DECL ((STRT) FIX)
		     <COND (<AND <TYPE? .ATM ATOM>
				 <GASSIGNED? .ATM>
				 <TYPE? <SET VAL ,.ATM> MSUBR>
				 <==? <1 .VAL> .IMSB-ATM>
				 <G? <SET STRT <4 .VAL>> .START>
				 <L? .STRT .END>>
			    <SET END .STRT>)>>
		  .BKT>>
	 ,ATOM-TABLE:VECTOR>
   .END>

;"Stuff to handle the horrendous opcode table.  There is a slot for each"
;"possible opcode byte.  An entry of %<> means that the opcode is undefined."
;"An entry of type OPCODE-TABLE means that the next byte must also be"
;"inspected.  An entry of type vector specifies an instruction in the form:"
;"[short-name:string operands:vector long-name:string]."

<GDECL (OPCODE-TABLE) OPCODE-TABLE>

;"Stuff to handle register names"

<DEFINE PRINT-REGISTER (REG)
   <PRINTSTRING <NTH ,REGISTER-NAMES <+ <ANDB .REG 15> 1>>>>

;"Stuff to handle references to the kernel.  This is used whenever EXPOSE"
;"encounters the '@#address' construct.  A hash table is used.  Each bucket"
;"is a list of the form (loc1 name1 loc2 name2 ...)."

;"PRINT-KERNEL-LOCATION is defined to return %<> if it couldn't find"
;"an appropriate symbolic name."

<DEFINE PRINT-KERNEL-LOCATION (LOC "AUX" BKTNUM BKT MEM)
   #DECL ((LOC BKTNUM) FIX (BKT) LIST (MEM) <OR FALSE <LIST FIX STRING>>)
   <SET BKTNUM <+ <MOD .LOC ,KERNEL-TABLE-LENGTH> 1>>
   <SET BKT <NTH ,KERNEL-TABLE .BKTNUM>>
   <SET MEM <MEMQ .LOC .BKT>>
   <COND (.MEM <PRINTSTRING <2 .MEM>>)>>

<ENDPACKAGE>
