
<PACKAGE "GNJFN">

<ENTRY GNJFN
       DIR
       DIR?
       NEXT-FILE
       RETURN-FILES
       RETURN-DIRS
       RETURN-ALL
       LOWERCASSIFY>

<USE "NEWSTRUC">

<NEW-CHANNEL-TYPE GNJFN <>
		  OPEN GNJFN-OPEN
		  PRINT-DATA GNJFN-PRINT-DATA
		  NAME GNJFN-NAME
		  SHORT-NAME GNJFN-SHORT-NAME
		  DEV GNJFN-DEV
		  SNM GNJFN-SNM
		  NM1 GNJFN-NM1
		  NM2 GNJFN-NM2
		  DIR GNJFN-DIR
		  DIR? GNJFN-DIR?
		  NEXT-FILE GNJFN-NEXT-FILE
		  CLOSE GNJFN-CLOSE>

<SETG RETURN-FILES 1>

<SETG RETURN-DIRS 2>

<SETG RETURN-ALL 3>

<MANIFEST RETURN-FILES>

<MANIFEST RETURN-DIRS>

<MANIFEST RETURN-ALL>

<NEWSTRUC GNJFN-DATA VECTOR
	  GN-STRING STRING
	  GN-BUF STRING
	  GN-RET FIX
	  GN-CHAN <CHANNEL 'DISK>
	  GN-DIR STRING
	  GN-DIRSNM <PRIMTYPE VECTOR>
	  GN-DIR? ANY>

<DEFMAC ENTRY-LEN ('BUF)
   <FORM + <FORM ASCII <FORM 5 .BUF>> <FORM * 256 <FORM ASCII <FORM 6 .BUF>>>>>

<DEFMAC NAME-LEN ('BUF)
   <FORM + <FORM ASCII <FORM 7 .BUF>> <FORM * 256 <FORM ASCII <FORM 8 .BUF>>>>>

<DEFINE GNJFN-OPEN (C-TYPE:ATOM OP:ATOM STR:STRING
		    "OPTIONAL" (F-OR-D:FIX ,RETURN-FILES)
		    "AUX" (NM-INFO:<PRIMTYPE
				    VECTOR> <IVECTOR 5 <>>) FIX-STRING:STRING
			  DIR:STRING CH:<OR <CHANNEL 'DISK> FALSE> BUF:STRING
			  CHAN-DAT:GNJFN-DATA
			  VAL:<OR FALSE GNJFN-DATA> TF:STRING
			  DIR-SPEC?:<OR ATOM FALSE>)
	<COND (<MEMQ !\/ .STR> <SET DIR-SPEC? T>) (T <SET DIR-SPEC? <>>)>
	<SET FIX-STRING <PARSE-FILE-NAME .STR <> T .NM-INFO>>
	<SET STR
	     <SUBSTRUC .FIX-STRING
		       0
		       <- <LENGTH .FIX-STRING> 1>
		       <REST .FIX-STRING>>>
	<REPEAT ((PLACE <LENGTH .STR>))
		#DECL ((PLACE) FIX)
		<COND (<==? <NTH .STR .PLACE> !\/>
		       <SET DIR <SUBSTRUC .STR 0 <- .PLACE 1>
					  <ISTRING <- .PLACE 1>>>>
		       <SET STR <REST .STR .PLACE>>
		       <RETURN>)
		      (T <SET PLACE <- .PLACE 1>>)>>
	<COND
	 (<SET CH <CHANNEL-OPEN DISK .DIR "READ" "ASCII" <>>>
	  <SET BUF <GET-BUFFER>>
	  <CHANNEL-OP .CH READ-BUFFER .BUF>
	  <SET BUF <REST .BUF <ENTRY-LEN .BUF>>>
	  <SET BUF <REST .BUF <ENTRY-LEN .BUF>>>
	  <SET CHAN-DAT
	       <CHTYPE [.STR .BUF .F-OR-D .CH
			.DIR .NM-INFO .DIR-SPEC?]
		       GNJFN-DATA>>
	  <COND (<AND <OR <EMPTY? .BUF>
			  <NOT <MATCH? .CHAN-DAT>>
			  <NOT <DIR-CHECK .CHAN-DAT>>>
		      <NOT <GET-NEXT-FILE .CHAN-DAT>>>
		 <FREE-BUFFER .BUF>
		 <CLOSE .CH>
		 <SET VAL #FALSE ("NO MORE MATCHING FILES")>)
		(T <SET VAL .CHAN-DAT>)>
	  .VAL)>>

<DEFINE DIR-CHECK (DAT:GNJFN-DATA "AUX" (RET <GN-RET .DAT>))
   <COND (<==? .RET ,RETURN-ALL>)
	 (T
	  <CHANNEL-DATA .CURRENT-CHANNEL .DAT>
	  <CHANNEL-OPEN? .CURRENT-CHANNEL T>
	  <COND (<CHANNEL-OP .CURRENT-CHANNEL:<CHANNEL 'GNJFN> DIR?>
		 <==? .RET ,RETURN-DIRS>)
		(T
		 <==? .RET ,RETURN-FILES>)>)>>

<DEFINE GNJFN-PRINT-DATA (CH:CHANNEL OP:ATOM
			  "OPTIONAL" (OUTCHAN:CHANNEL .OUTCHAN)
			  "AUX" (DATA:GNJFN-DATA <CHANNEL-DATA .CH>)
				F-OR-D:FIX)
	<SET F-OR-D <GN-RET .DATA>>
	<COND (<==? .F-OR-D ,RETURN-FILES> <PRIN1 "RETURN-FILES">)
	      (<==? .F-OR-D ,RETURN-DIRS> <PRIN1 "RETURN-DIRS">)
	      (T <PRIN1 "RETURN-ALL">)>>

<DEFINE GNJFN-NAME (CH:CHANNEL OP:ATOM "OPT" (WHICH *37*)
		    "AUX" (CHAN-DAT:GNJFN-DATA <CHANNEL-DATA .CH>))
   <COND (<NOT <EMPTY? <GN-BUF .CHAN-DAT>>>
	  <3 <GN-DIRSNM .CHAN-DAT> <GNJFN-NM1 .CH .OP>>
	  <4 <GN-DIRSNM .CHAN-DAT> <GNJFN-NM2 .CH .OP>>
	  <I$UNPARSE-SPEC!-INTERNAL <GN-DIRSNM .CHAN-DAT> .WHICH>)>>

<DEFINE GNJFN-SHORT-NAME (CH:CHANNEL OP 
			  "AUX" (DAT:GNJFN-DATA <CHANNEL-DATA .CH>)
			  (BUF <GN-BUF .DAT>)) 
   <I$STD-STRING!-INTERNAL <REST .BUF 8> T
			   <REST .BUF <+ 8 <NAME-LEN .BUF>>>>>

<DEFINE GNJFN-DEV (CH:CHANNEL OP
		   "AUX" (NM-INFO <GN-DIRSNM <CHANNEL-DATA .CH>:GNJFN-DATA>))
	<COND (<==? <1 .NM-INFO> T> <PARSE-DIR <> <> .NM-INFO <> <>>)>
	<1 .NM-INFO>>

<DEFINE GNJFN-SNM (CH:CHANNEL OP
		   "AUX" (NM-INFO <GN-DIRSNM <CHANNEL-DATA .CH>:GNJFN-DATA>))
	<COND (<==? <2 .NM-INFO> T> <PARSE-DIR <> <> .NM-INFO <> <>>)>
	<2 .NM-INFO>>

<DEFINE GNJFN-NM1 (CH:CHANNEL OP
		   "AUX" NAME:STRING NAME2:<OR STRING FALSE>
		   (DAT:GNJFN-DATA <CHANNEL-DATA .CH>) (BUF <GN-BUF .DAT>)
		   (LEN <NAME-LEN .BUF>))
   <COND (<AND <SET NAME2 <MEMQ !\. <REST .BUF 8>>>
	       <G? <LENGTH .NAME2> <- <LENGTH .BUF> 8 .LEN>>>
	  <SET NAME <I$STD-STRING!-INTERNAL <REST .BUF 8> T
				  .NAME2>>)
	 (T
	  <SET NAME <I$STD-STRING!-INTERNAL <REST .BUF 8> T
					    <REST .BUF <+ 8 .LEN>>>>)>
   .NAME>

<DEFINE GNJFN-NM2 (CH:CHANNEL OP
		   "AUX" NAME:<OR FALSE STRING> NAME2:<OR FALSE STRING>
		   (DAT:GNJFN-DATA <CHANNEL-DATA .CH>) (BUF <GN-BUF .DAT>)
		   (LEN <NAME-LEN .BUF>))
   <COND (<AND <SET NAME2 <MEMQ !\. <REST .BUF 8>>>
	       <G? <LENGTH .NAME2> <- <LENGTH .BUF> 8 .LEN>>>
	  <I$STD-STRING!-INTERNAL <REST .NAME2> T
				  <REST .BUF <+ 8 .LEN>>>)>>

<DEFINE GNJFN-DIR (CH:CHANNEL OP) <GN-DIR <CHANNEL-DATA .CH>:GNJFN-DATA>>

<DEFINE GNJFN-DIR? (CH:CHANNEL OP
		    "AUX" FILE:<OR FALSE STRING>
			  (CHAN-DAT:GNJFN-DATA <CHANNEL-DATA .CH>)
			  (BUF:STRING <GN-BUF .CHAN-DAT>) (LEN <NAME-LEN .BUF>)
			  (TF <GET-BUFFER>) FILE:STRING DLEN VAL)
   <SET FILE <SUBSTRUC .BUF 8 .LEN <REST .TF <- 511 .LEN>>>>
   <512 .TF <ASCII 0>>
   <COND (<GN-DIR? .CHAN-DAT>
	  <SET FILE <SUBSTRUC <GN-DIR .CHAN-DAT> 0 
			      <SET DLEN <LENGTH <GN-DIR .CHAN-DAT>>>
			      <BACK .FILE <+ .DLEN 1>>>>
	  <PUT .FILE <+ .DLEN 1> !\/>)>
   <SET VAL
	<NOT <0? <ANDB <STAT-FIELD <FILE-STAT .FILE>:STRING
				   9
				   2>
		       16384>>>>
   <FREE-BUFFER .TF>
   .VAL>

<DEFINE GNJFN-NEXT-FILE (CH:CHANNEL OP
			 "AUX" (CHAN-DAT:GNJFN-DATA <CHANNEL-DATA .CH>))
	<GET-NEXT-FILE .CHAN-DAT>>

<DEFINE GNJFN-CLOSE (CH:CHANNEL OP) 
   <FREE-BUFFER <GN-BUF <CHANNEL-DATA .CH>:GNJFN-DATA>>
   <CLOSE <GN-CHAN <CHANNEL-DATA .CH>:GNJFN-DATA>>>

<DEFINE GET-NEXT-FILE (CHAN-DAT:GNJFN-DATA
		       "AUX" F-OR-D:FIX BUF:STRING STR:STRING FNAME
			     EN-LNTH:FIX FLNTH:FIX
			     CHAN:<CHANNEL 'DISK> F?
			     FILE:STRING (NMBUF:<OR STRING FALSE> <>))
   <SET STR <GN-STRING .CHAN-DAT>>
   <SET BUF <GN-BUF .CHAN-DAT>>
   <SET BUF <REST .BUF <ENTRY-LEN .BUF>>>
   ; "Rest off previous match"
   <SET F-OR-D <GN-RET .CHAN-DAT>>
   <REPEAT ()
     <COND (<EMPTY? .BUF>
	    <GN-BUF .CHAN-DAT .BUF>
	    <SET CHAN <GN-CHAN .CHAN-DAT>>
	    <SET BUF <TOP .BUF>>
	    <COND (<==? <CHANNEL-OP .CHAN READ-BUFFER .BUF> 0>
		   <COND (.NMBUF <FREE-BUFFER .NMBUF>)>
		   <RETURN #FALSE ("NO MORE MATCHING FILES")>)
		  (T <GN-BUF .CHAN-DAT .BUF>)>)>
     <SET EN-LNTH
	  <ENTRY-LEN .BUF>>
     <SET FLNTH
	  <NAME-LEN .BUF>>
     <COND (<NOT .NMBUF> <SET NMBUF <GET-BUFFER>>)>
     <SET FNAME
	  <SUBSTRUC .BUF 8 .FLNTH <REST .NMBUF
					<- 512 .FLNTH 1>>>>
     <512 .NMBUF <ASCII 0>>
     <COND
      (<NOT <==? .F-OR-D ,RETURN-ALL>>
       <COND (<GN-DIR? .CHAN-DAT>
	      <SET FILE
		   <SUBSTRUC <GN-DIR .CHAN-DAT>
			     0
			     <LENGTH <GN-DIR .CHAN-DAT>>
			     <BACK .FNAME <+ 1 <LENGTH <GN-DIR .CHAN-DAT>>>>>>
	      <PUT .FILE <+ 1 <LENGTH <GN-DIR .CHAN-DAT>>> !\/>)
	     (T <SET FILE .FNAME>)>
       <SET F? <0? <ANDB <STAT-FIELD <FILE-STAT .FILE>:STRING 9 2> 16384>>>
       <COND (<OR <AND <==? .F-OR-D ,RETURN-DIRS> .F?>
		  <AND <==? .F-OR-D ,RETURN-FILES> <NOT .F?>>>
	      <SET BUF <REST .BUF <MIN .EN-LNTH <LENGTH .BUF>>>>
	      <AGAIN>)>)>
     <GN-BUF .CHAN-DAT .BUF>
     <COND (<MATCH? .CHAN-DAT>
	    <COND (.NMBUF <FREE-BUFFER .NMBUF>)>
	    <RETURN T>)
	   (T
	    <SET BUF <REST .BUF <MIN .EN-LNTH <LENGTH .BUF>>>>)>>>

<DEFINE MATCH? (CHAN-DAT:GNJFN-DATA "AUX" (BUF:STRING <GN-BUF .CHAN-DAT>)
		(STR:STRING <GN-STRING .CHAN-DAT>) (SLNTH:FIX <LENGTH .STR>)
		(FLEN:FIX <NAME-LEN .BUF>) CHECK
		(FPLACE 1) (FLAG T) (FLAG2 <>))
     <SET BUF <REST .BUF 8>>
     <OR <AND <==? .SLNTH 1> <==? <1 .STR> !\*>>
	 <REPEAT ()
	    <COND (<EMPTY? .STR>
		   <COND (<G? .FPLACE .FLEN> <RETURN>)
			 (T <SET STR .CHECK>)>)
		  (<==? <1 .STR> !\*>
		   <COND (.FLAG <SET FLAG <>>)>
		   <COND (<==? <LENGTH .STR> 1>
			  <COND (.FLAG2 <RETURN>) (T <RETURN <>>)>)
			 (T
			  <SET STR <REST .STR>>
			  <COND (.FLAG2 <SET FLAG2 <>>)>)>)
		  (<G? .FPLACE .FLEN>
		   <COND (.FLAG2
			  <COND (<EMPTY? .STR> <RETURN T>)
				(T <RETURN <>>)>)
			 (T <RETURN <>>)>)
		  (<==? <NTH .BUF .FPLACE> <1 .STR>>
		   <COND (.FLAG2)
			 (T <SET FLAG2 T> <SET CHECK .STR>)>
		   <SET STR <REST .STR>>
		   <SET FPLACE <+ 1 .FPLACE>>)
		  (.FLAG <RETURN <>>)
		  (.FLAG2
		   <SET FLAG2 <>>
		   <SET STR .CHECK>
		   <SET FPLACE <+ 1 .FPLACE>>)
		  (T <SET FPLACE <+ 1 .FPLACE>>)>>>>

<GDECL (BUFFERS) <VECTOR [REST STRING]>>

<DEFINE GET-BUFFER ("AUX" BUF)
   <COND (<NOT <GASSIGNED? BUFFERS>>
	  <SETG BUFFERS <REST <IVECTOR 3 ""> 3>>)>
   <COND (<EMPTY? ,BUFFERS>
	  <ISTRING 512>)
	 (T
	  <SET BUF <TOP <1 ,BUFFERS>>>
	  <SETG BUFFERS <REST ,BUFFERS>>
	  .BUF)>>

<DEFINE FREE-BUFFER (BUF:STRING)
   <COND (<==? <LENGTH ,BUFFERS> 3>)
	 (T
	  <SETG BUFFERS <BACK ,BUFFERS>>
	  <1 ,BUFFERS .BUF>
	  T)>>

<ENDPACKAGE>
