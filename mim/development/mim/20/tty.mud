<PACKAGE "TTY">

<ENTRY TERM-MOVE? NORMAL-OUT IMAGE-OUT SET-IMAGE-MODE SET-ECHO-MODE
       CLEAR-SCREEN CLEAR-EOL CLEAR-EOS KILL-CHAR ERASE-CHAR
       HOME-CURSOR BOTTOM-CURSOR HOR-POS-CURSOR VER-POS-CURSOR MOVE-CURSOR
       BACK-CURSOR DOWN-CURSOR UP-CURSOR FORWARD-CURSOR SAVE-CURSOR
       RESTORE-CURSOR INSERT-LINE INSERT-CHAR GET-TYPE PAD TYPE-AHEAD?
       TYPE-CHAR SET-CURSOR-POSITION>

<USE "TWAY">

%<FLOAD "PS:<TAA.IO-DEFS>TTYDEFS.MUD">

<NEW-CHANNEL-TYPE TTY (TWAY DEFAULT)
		 GET-TYPE TTY-GET-TYPE
		 QUERY TTY-QUERY
		 OPEN TTY-OPEN
		 TYPE-AHEAD? TTY-TYPE-AHEAD?
		 READ-BYTE-IMMEDIATE TTY-READ-IMMEDIATE
		 READ-BYTE TTY-READ-BYTE
		 READ-BUFFER TTY-READ-BUFFER
		 FILL-READ-BUFFER TTY-FILL-READ
		 BUFLEN TTY-BUFLEN
		 GET-READ-BUFFER TTY-GET-READ
		 PRINT-DATA TTY-PRINT-DATA
		 TERM-MOVE? TTY-TERM-MOVE?
		 NORMAL-OUT TTY-NORMAL-OUT
		 IMAGE-OUT TTY-IMAGE-OUT
		 SET-IMAGE-MODE TTY-SET-IMAGE
		 SET-ECHO-MODE TTY-SET-ECHO
		 RESET TTY-RESET
		 PAGE-WIDTH TTY-PARM
		 PAGE-HEIGHT TTY-PARM
		 PAGE-X TTY-PARM
		 PAGE-Y TTY-PARM
		 SET-CURSOR-POSITION TTY-SET-CURS
		 CLEAR-SCREEN CLEAR-SCREEN
		 CLEAR-EOL CLEAR-EOL
		 CLEAR-EOS CLEAR-EOS
		 FRESH-LINE FRESH-LINE
		 KILL-CHAR KILL-CHAR
		 ERASE-CHAR ERASE-CHAR
		 HOME-CURSOR HOME-CURSOR
		 BOTTOM-CURSOR BOTTOM-CURSOR
		 HOR-POS-CURSOR HOR-POS-CURSOR
		 VER-POS-CURSOR VER-POS-CURSOR
		 MOVE-CURSOR MOVE-CURSOR
		 BACK-CURSOR BACK-CURSOR
		 DOWN-CURSOR DOWN-CURSOR
		 UP-CURSOR UP-CURSOR
		 FORWARD-CURSOR FORWARD-CURSOR
		 SAVE-CURSOR SAVE-CURSOR
		 RESTORE-CURSOR RESTORE-CURSOR
		 INSERT-LINE INSERT-LINE
		 INSERT-CHAR INSERT-CHAR
		 PAD TTY-PAD
		 TYPE-CHAR TTY-TYPE-CHAR>

"This must be patterned according to the definition of TWAY-CHANNEL, so the
TWAY code will work when it's wanted."

<NEWSTRUC TTY-CHANNEL VECTOR
	  TT-RJFN FIX
	  TT-MODE FIX
	  TT-BSZ FIX
	  TT-RBUF <OR FALSE STRING>
	  TT-RBC FIX
	  TT-WJFN FIX
	  TT-WBUF <OR FALSE STRING>
	  TT-WBC FIX
	  TT-RFSAV FIX						 ;"Saved RFMOD"
	  TT-RFCUR FIX		 ;"Current setting of RFMOD"
	  TT-QUEUE <OR STRING CHARACTER FALSE>
	  TT-QCT FIX>

<DEFMAC UPDATE-MC ('CH 'X "OPTIONAL" 'Y "AUX" (L ()))
  <COND (<AND <ASSIGNED? X> .X <OR <NOT <STRUCTURED? .X>>
				   <NOT <EMPTY? .X>>>>
	 <SET L (<COND (<TYPE? .X LIST>
			<FORM MC-HPOS '.SU <FORM + <FORM MC-HPOS '.SU>
						   <1 .X>>>)
		       (<FORM MC-HPOS '.SU .X>)>)>)>
  <COND (<AND <ASSIGNED? Y> .Y <OR <NOT <STRUCTURED? .Y>>
				   <NOT <EMPTY? .Y>>>>
	 <SET L (<COND (<TYPE? .Y LIST>
			<FORM MC-VPOS '.SU <FORM + <FORM MC-VPOS '.SU>
						   <1 .Y>>>)
		       (<FORM MC-VPOS '.SU .Y>)> !.L)>)>
  <COND (<NOT <EMPTY? .L>>
	 <FORM BIND ((SU <FORM CHANNEL-USER .CH>))
	       <FORM COND (<FORM TYPE? '.SU MUD-CHAN> !.L)>>)>>

<DEFMAC DPYOP ('TTY 'OPR
	       "OPTIONAL" 'ARG1 'ARG2)
	<FORM BIND ()
	  <FORM COND (<FORM AND <FORM TT-WBUF .TTY>
			    <FORM NOT <FORM 0? <FORM TT-WBC .TTY>>>>
		      <FORM DUMP-WRITE-BUFFER .TTY>)>
	  <COND (<NOT <ASSIGNED? ARG1>>
		 <FORM CALL SYSOP VTSOP <FORM TT-WJFN .TTY> .OPR>)
		(<NOT <ASSIGNED? ARG2>>
		 <FORM CALL SYSOP VTSOP <FORM TT-WJFN .TTY>
		       <FORM ORB .OPR ,DP-AG1> .ARG1>)
		(T
		 <FORM CALL SYSOP VTSOP <FORM TT-WJFN .TTY>
		       <FORM ORB .OPR <ORB ,DP-AG1 ,DP-AG2>> .ARG1 .ARG2>)>>>

<DEFMAC GET-TTY-PARM ('DATA OPER "OPT" 'NEW
		      "AUX" (JFN <FORM TT-RJFN .DATA>))
  <COND (<==? .OPER PAGE-WIDTH>
	 <COND (<ASSIGNED? NEW>
		<FORM CALL SYSOP MTOPR .JFN ,/MOSLW .NEW ''(RETURN 3)>)
	       (T
		<FORM CALL SYSOP MTOPR .JFN ,/MORLW ''(RETURN 3)>)>)
	(<==? .OPER PAGE-HEIGHT>
	 <COND (<ASSIGNED? NEW>
		<FORM CALL SYSOP MTOPR .JFN ,/MOSLL .NEW ''(RETURN 3)>)
	       (T
		<FORM CALL SYSOP MTOPR .JFN ,/MORLL ''(RETURN 3)>)>)
	(<OR <==? .OPER PAGE-X> <==? .OPER PAGE-Y>>
	 <COND (<NOT <ASSIGNED? NEW>>
		<COND (<==? .OPER PAGE-X>
		       <FORM RHW <FORM CALL SYSOP RFPOS .JFN ''(RETURN 2)>>)
		      (<==? .OPER PAGE-Y>
		       <FORM LHW <FORM CALL SYSOP RFPOS .JFN ''(RETURN 2)>>)>)
	       (T
		<FORM BIND ((NJ .JFN)
			    (CPTR <FORM CALL SYSOP RFPOS '.NJ ''(RETURN 2)>)
			    (RN .NEW))
		  <COND (<==? .OPER PAGE-X>
			 <FORM UPDATE-MC .DATA '.RN>
			 <FORM CALL SYSOP SFPOS '.NJ
			       <FORM PUTRHW '.CPTR '.RN>
			       ''(RETURN 2)>)
			(T
			 <FORM UPDATE-MC .DATA <> '.RN>
			 <FORM CALL SYSOP SFPOS '.NJ
			       <FORM PUTLHW '.CPTR '.RN>
			       ''(RETURN 2)>)>>)>)>>
	   

<SETG TYPE-NAMES
      ["35" "37" "TI" "IMLAC" "DM2500" "HP2645"
       "NVT" "SYSTEM" "TVT" "VT05" "VT50" "LA30"
       "LINEPROCESSOR?" "LA36" "VT52" "GLASS" "FOX" "VT100V"
       "T1061" "H19" "C100" "VT100" "LA38" "LA120"
       "PTV" "SUPDUP" "HP2640" "AAA" "BBN"]>
 
<DEFINE TTY-GET-TYPE (CHANNEL OPER "AUX" (DATA <CHANNEL-DATA .CHANNEL>)
		      (VEC ,TYPE-NAMES) NUM)
  #DECL ((CHANNEL) CHANNEL (DATA) TTY-CHANNEL (VEC) <VECTOR [REST STRING]>
	 (NUM) FIX)
  <COND (<SET NUM <CALL SYSOP GTTYP <TT-RJFN .DATA> '(RETURN 2)>>
	 <COND (<G? .NUM <LENGTH .VEC>>
		"UNKNOWN")
	       (<NTH .VEC .NUM>)>)>>

<DEFINE TTY-TYPE-AHEAD? (CHANNEL OPER
			 "AUX" (DATA <CHANNEL-DATA .CHANNEL>) VAL
			 (QC <TT-QCT .DATA>))
  #DECL ((CHANNEL) CHANNEL (DATA) TTY-CHANNEL (VAL) <OR FIX FALSE>)
  <COND (<AND <SET VAL <CALL SYSOP SIBE <TT-RJFN .DATA> '(RETURN 2)>>
	      <NOT <0? .VAL>>>
	 <+ .VAL .QC>)
	(<G? .QC 0> .QC)>>

<DEFINE TTY-READ-IMMEDIATE (CHANNEL:CHANNEL OPER
			    "OPTIONAL" (NOWAIT?:<OR ATOM FALSE> <>)
			    "AUX" (DATA:TTY-CHANNEL <CHANNEL-DATA .CHANNEL>)
				  VAL:<OR FALSE FIX>
				  (ECHO?:<OR ATOM !<FALSE>>
				   <NOT <0? <ANDB <TT-RFCUR .DATA>
						  ,TT-ECO>>>)
				  (IMAGE?:<OR ATOM !<FALSE>>
				   <0? <ANDB <TT-RFCUR .DATA>
					     ,TT-DAM>>)
				  (CHR 0)
			    "VALUE" <OR CHARACTER FALSE>)
  <UNWIND
   <PROG (TC)
    <DUMP-WRITE-BUFFER .DATA>
    <COND (<SET CHR <GET-QUEUE-CHAR .DATA>>
	   <COND (<AND <NOT .IMAGE?> .ECHO?>
		  <CALL SYSOP BOUT <TT-WJFN .DATA> <CHTYPE .CHR FIX>>)>
	   .CHR)
	  (<OR <NOT .NOWAIT?>
	       <AND <SET VAL <CALL SYSOP SIBE <TT-RJFN .DATA> '(RETURN 2)>>
		    <NOT <0? .VAL>>>>
	   <COND (<NOT .IMAGE?>
		  <TTY-SET-IMAGE .CHANNEL .OPER T <>>)>
	   <COND (<SET TC <ISYSOP BIN <TT-RJFN .DATA> '(RETURN 2)>>
		  <SET CHR <CHTYPE .TC CHARACTER>>)
		 (<==? <1 .TC> *600220*>	; "IOX4"
		  ; "Come here when interrupted during the BIN.  We'll
		     just try again, but maybe the interrupt handler
		     did something odd."
		  <SET CHR T>)
		 (T
		  <SET CHR <>>)>
	   <COND (<NOT .IMAGE?>
		  <TTY-SET-IMAGE .CHANNEL .OPER <>>
		  <COND (<AND .ECHO? <TYPE? .CHR CHARACTER>>
			 <CALL SYSOP BOUT <TT-WJFN .DATA>
			       <CHTYPE .CHR FIX>>)>)>
	   <COND (<TYPE? .CHR ATOM>
		  <AGAIN>)
		 (<TYPE? .CHR FIX>
		  <>)
		 (T
		  .CHR)>)>>
   <COND (<NOT .IMAGE?>
	  <TTY-SET-IMAGE .CHANNEL .OPER <>>)>>>

<DEFINE TTY-READ-BYTE (CHANNEL OPER "AUX" (DATA <CHANNEL-DATA .CHANNEL>))
  #DECL ((CHANNEL) CHANNEL (DATA) TTY-CHANNEL)
  <COND (<AND <TT-RBUF .DATA>
	      <0? <TT-RBC .DATA>>>
	 <>)
	(<TWAY-READ-BYTE .CHANNEL .OPER>)>>

<DEFINE TTY-READ-BUFFER (TTY OPER BUF "OPTIONAL" (LEN <LENGTH .BUF>)
			 (CONT 0) "AUX" (DATA <CHANNEL-DATA .TTY>))
  #DECL ((TTY) CHANNEL (BUF) STRING (LEN CONT) FIX (DATA) TTY-CHANNEL)
  <COND (<TT-RBUF .DATA>
	 <TWAY-READ-BUFFER .TTY .OPER .BUF .LEN .CONT>)
	(T
	 <CALL READ <TT-RJFN .DATA> .BUF <MIN .LEN <LENGTH .BUF>> .CONT>)>>

<DEFINE TTY-GET-READ (TTY OPER "OPTIONAL" NEW
			"AUX" (DATA <CHANNEL-DATA .TTY>))
  #DECL ((TTY) CHANNEL (DATA) TTY-CHANNEL (NEW) STRING)
  <COND (<ASSIGNED? NEW>
	 <TT-RBUF .DATA .NEW>
	 .NEW)
	(T
	 <TT-RBUF .DATA>)>>

<DEFINE TTY-BUFLEN (TTY OPER "OPTIONAL" NEW "AUX" (DATA <CHANNEL-DATA .TTY>))
  #DECL ((TTY) CHANNEL (DATA) TTY-CHANNEL (NEW) FIX)
  <COND (<ASSIGNED? NEW>
	 <TT-RBC .DATA .NEW>
	 .NEW)
	(T
	 <TT-RBC .DATA>)>>

<DEFINE TTY-FILL-READ (TTY OPER "OPTIONAL" (CONT 0) (RBUF <>) (END <>)
		       (NOMORE <>)
		       "AUX" (DATA <CHANNEL-DATA .TTY>)
			     (OB <TT-RBUF .DATA>) (BUF <CALL TOPU .OB>) CT
			     TS
			     (SPROMPT <COND (<AND <ASSIGNED? READ-PROMPT>
						 <TYPE? <SET TS .READ-PROMPT>
							STRING>>
					    .TS)>)
			     (PROMPT
			      <STACK <STRING <OR .SPROMPT ""> <ASCII 0>>>)
			     TTAB:BYTES)
  #DECL ((DATA) TTY-CHANNEL (TTY) CHANNEL (BUF OB) STRING (CONT) FIX
	 (RBUF END) <OR STRING FALSE> (NOMORE) <OR ATOM FALSE>
	 (SPROMPT PROMPT) <OR STRING FALSE>)
  <COND (<NOT .SPROMPT> <SET PROMPT <>>)>
  <COND (<NOT .END>
	 <SET END <COND (<AND <ASSIGNED? READ-BREAKS>
			      <TYPE? <SET TS .READ-BREAKS> STRING>>
			 .TS)>>)>
  <COND (.RBUF <SET BUF <SET OB .RBUF>>)
	(<0? <TT-RBC .DATA>>
	 <COND (<NOT <0? .CONT>>
		<SET OB <CALL BACKU .OB .CONT>>
		<COND (<N==? .OB .BUF>
		       <MAPR <>
		         <FUNCTION (OLD NEW)
			   #DECL ((OLD NEW) STRING)
			   <1 .NEW <1 .OLD>>>
			 .OB .BUF>)>)>)
	(<SET CONT 0>)>
  <COND (<AND <0? .CONT>
	      .PROMPT>
	 <TWAY-WRITE-BUFFER .TTY .OPER .PROMPT
			    <- <LENGTH .PROMPT> 1>>)>
  ; "Eat and echo queued chars"
  <REPEAT (CHR (TB <REST .BUF .CONT>))
    <COND (<SET CHR <GET-QUEUE-CHAR .DATA>>
	   <1 .TB .CHR>
	   <SET TB <REST .TB>>
	   <SET CONT <+ .CONT 1>>
	   <TWAY-WRITE-BYTE .TTY .OPER .CHR>)
	  (T
	   <RETURN>)>>
  <DUMP-WRITE-BUFFER .DATA>
  <PROG ()
    <SET CT <CALL READ <TT-RJFN .DATA> .BUF <LENGTH .BUF> .CONT
		  <OR .END 0> <OR .PROMPT 0>>>
    <COND (<AND <NOT .NOMORE> <==? .CT <LENGTH .BUF>>>
	   <TT-RBUF .DATA <ISTRING <+ <LENGTH .BUF> 320>>>
	   <MAPR <>
	     <FUNCTION (OLD NEW)
	       <1 .NEW <1 .OLD>>>
	     .BUF <TT-RBUF .DATA>>
	   <SET BUF <TT-RBUF .DATA>>
	   <SET CONT .CT>
	   <AGAIN>)>
    .CT>
  <COND (<NOT .RBUF> 
	 <TT-RBUF .DATA .BUF>
	 <TT-RBC .DATA .CT>)>
  .CT>

<DEFINE TTY-TERM-MOVE? (TTY OPER "AUX" (DATA <CHANNEL-DATA .TTY>)) 
	#DECL ((TTY) CHANNEL (DATA) TTY-CHANNEL)
	<NOT <0? <ANDB <CALL SYSOP RTCHR <TT-WJFN .DATA> '(RETURN 2)>
		       ,TC-MOV>>>>

<DEFINE TTY-NORMAL-OUT (TTY OPER CHRS
			"OPTIONAL" (LENGTH <>)
			"AUX" (DATA <CHANNEL-DATA .TTY>))
	#DECL ((TTY) CHANNEL (DATA) TTY-CHANNEL
	       (CHRS) <OR BYTES STRING CHARACTER>)
	<TTY-SET-IMAGE .TTY SET-IMAGE-MODE <>>
	<COND (<TYPE? .CHRS STRING>
	       <TWAY-WRITE-BUFFER .TTY
				  .OPER
				  .CHRS
				  <COND (.LENGTH .LENGTH) (<LENGTH .CHRS>)>>)
	      (T <TWAY-WRITE-BYTE .TTY .OPER .CHRS>)>>

<DEFINE TTY-IMAGE-OUT (TTY OPER CHRS
		       "OPTIONAL" (LENGTH <>) "TUPLE" MORE
		       "AUX" (DATA <CHANNEL-DATA .TTY>))
	#DECL ((LENGTH) <OR FIX FALSE> (TTY) CHANNEL (DATA) TTY-CHANNEL
	       (CHRS) <OR FIX CHARACTER STRING BYTES>
	       (MORE) <TUPLE [REST <OR FIX BYTES STRING CHARACTER>]>)
	<TTY-SET-IMAGE .TTY SET-IMAGE-MODE T>
	<+ <WRITE-STUFF .TTY .OPER .CHRS .LENGTH>
	   <MAPF ,+
	     <FUNCTION (X)
	       <WRITE-STUFF .TTY .OPER .X <>>>
	     .MORE>>>

<SETG BUFSTR <ISTRING 12>>

<DEFINE WRITE-STUFF (TTY OPER CHRS LENGTH "AUX" (BS ,BUFSTR) (NEG? <>))
  #DECL ((TTY) CHANNEL (CHRS) <OR STRING FIX CHARACTER>
	 (LENGTH) <OR FIX FALSE> (BS) STRING (VALUE) <OR FIX FALSE>)
  <COND (<TYPE? .CHRS STRING BYTES>
	 <TWAY-WRITE-BUFFER .TTY .OPER .CHRS
			    <COND (.LENGTH .LENGTH)
				  (<LENGTH .CHRS>)>>)
	(<TYPE? .CHRS CHARACTER>
	 <TWAY-WRITE-BYTE .TTY .OPER .CHRS>
	 1)
	(T
	 <SET BS <REST .BS <LENGTH .BS>>>
	 <COND (<L? .CHRS 0>
		<SET NEG? T>
		<SET CHRS <- .CHRS>>)>
	 <REPEAT (REM (ANY? <>))
	   #DECL ((REM) FIX (ANY?) <OR ATOM FALSE>)
	   <COND (<0? .CHRS>
		  <COND (<NOT .ANY?>
			 <SET BS <CALL BACKU .BS 1>>
			 <1 .BS !\0>)
			(.NEG?
			 <SET BS <CALL BACKU .BS 1>>
			 <1 .BS !\->)>
		  <TWAY-WRITE-BUFFER .TTY .OPER .BS <LENGTH .BS>>
		  <RETURN <LENGTH .BS>>)>
	   <SET REM <MOD .CHRS 10>>
	   <SET CHRS </ .CHRS 10>>
	   <1 <SET BS <CALL BACKU .BS 1>> <ASCII <+ .REM <ASCII !\0>>>>
	   <SET ANY? T>>)>>

<DEFINE TTY-OPEN TO (STYPE OPR
		     "OPTIONAL" (NAME <>) (MODE "") (BSZ "")
		     OBUF? IBUF?
		     "AUX" OJFN IJFN ERR VAL)
	#DECL ((OJFN IJFN ERR) <OR FALSE FIX>)
	<COND (<NOT <ASSIGNED? IBUF?>>
	       <COND (<TYPE? .BSZ STRING>
		      <SET IBUF? T>)
		     (<SET IBUF? .BSZ>)>)>
	<COND (<NOT <ASSIGNED? OBUF?>>
	       <COND (<TYPE? .MODE STRING>
		      <SET OBUF? <>>)
		     (<SET OBUF? .MODE>)>)>
	<COND (<NOT .NAME>
	       <SET OJFN ,/PRIOU>
	       <SET IJFN ,/PRIIN>)
	      (<SET OJFN <GET-JFN .NAME
				  %<CHTYPE <ORB ,OF-RD ,OF-WR ,OF-APP> FIX>
				  7 <>>>
	       <SET IJFN .OJFN>)
	      (T <RETURN .OJFN .TO>)>
	<SET VAL <CALL SYSOP RFMOD .OJFN '(RETURN 2)>>
	<CHTYPE [.IJFN
		 -1
		 7
		 <COND (.IBUF? <ISTRING 320>)>
		 0
		 .OJFN
		 <COND (.OBUF? <ISTRING 320>)>
		 0
		 .VAL
		 .VAL
		 <>
		 0
		 <>
		 <>]
		TTY-CHANNEL>>

<DEFINE TTY-SET-ECHO (TTY OPER ON?
		      "AUX" (DATA <CHANNEL-DATA .TTY>)
			    (CURMOD
			     <NOT <0? <ANDB <TT-RFCUR .DATA> ,TT-ECO>>>))
	#DECL ((TTY) CHANNEL (DATA) TTY-CHANNEL (ON? CURMOD) <OR ATOM FALSE>)
	<COND (<N==? .CURMOD .ON?>
	       <TT-RFCUR .DATA <XORB <TT-RFCUR .DATA> ,TT-ECO>>
	       <CALL SYSOP SFMOD <TT-RJFN .DATA> <TT-RFCUR .DATA>>)>
	.TTY>

<DEFINE TTY-SET-IMAGE (TTY OPER ON? "OPTIONAL" (SCREW? T)
		       "AUX" (DATA <CHANNEL-DATA .TTY>)
			     (CURMOD
			      <0? <ANDB <TT-RFCUR .DATA> ,TT-DAM>>))
   #DECL ((TTY) CHANNEL (DATA) TTY-CHANNEL (ON? CURMOD) <OR ATOM FALSE>)
   <COND (<N==? .CURMOD .ON?>
	  <TWAY-BUFOUT .TTY BUFOUT <>>
	  <COND (<AND .ON? .SCREW?>
		 <CALL SYSOP SFPOS <TT-RJFN .DATA> -1>)>
	  <TT-RFCUR .DATA
		    <COND (.ON?
			   <ANDB <TT-RFCUR .DATA> %<CHTYPE <XORB ,TT-DAM -1>
							   FIX>>)
			  (T
			   <ORB <TT-RFCUR .DATA>
				<ANDB ,TT-DAM <TT-RFSAV .DATA>>>)>>
	  <CALL SYSOP SFMOD <TT-RJFN .DATA> <TT-RFCUR .DATA>>)>
   .TTY>

\ 

<DEFINE TTY-RESET (TTY OPER "OPTIONAL" (NEW? <>) (FLUSH? T)
		   "AUX" (DATA <CHANNEL-DATA .TTY>)) 
	#DECL ((TTY) CHANNEL (DATA) TTY-CHANNEL (FLUSH?) <OR ATOM FALSE>)
	<COND (.NEW?
	       ; "Get the current setting"
	       <TT-RFCUR .DATA <CALL SYSOP RFMOD <TT-RJFN .DATA>
				     '(RETURN 2)>>
	       ; "Make sure not in image mode"
	       <TTY-SET-IMAGE .TTY .OPER <>>
	       ; "Make sure echoing on"
	       <TTY-SET-ECHO .TTY .OPER T>
	       ; "Save this for future resets"
	       <TT-RFSAV .DATA <TT-RFCUR .DATA>>)
	      (T
	       <COND (<N==? <TT-RFCUR .DATA> <TT-RFSAV .DATA>>
		      <CALL SYSOP SFMOD <TT-RJFN .DATA> <TT-RFSAV .DATA>>
		      <TT-RFCUR .DATA <TT-RFSAV .DATA>>)>
	       ; "Throw away typeahead"
	       <COND (.FLUSH? <CALL SYSOP CFIBF <TT-RJFN .DATA>>)>)>
	<COND (<TT-RBUF .DATA>
	       <TT-RBC .DATA 0>
	       <TT-RBUF .DATA <CALL TOPU <TT-RBUF .DATA>>>)>
	<COND (<TT-WBUF .DATA>
	       <TT-WBC .DATA 0>
	       <TT-WBUF .DATA <CALL TOPU <TT-WBUF .DATA>>>)>
	<TT-QCT .DATA 0>
	.TTY>

<DEFINE TTY-QUERY (CHANNEL OPER BIT "AUX" (DATA <CHANNEL-DATA .CHANNEL>))
  #DECL ((CHANNEL) CHANNEL (BIT) FIX (DATA) TTY-CHANNEL)
  <COND (<==? .BIT ,BIT-INTELLIGENT>
	 <COND (<TT-RBUF .DATA> T)>)>>

\ 

<DEFINE TTY-SET-CURS (TTY OPER X Y "AUX" (DATA <CHANNEL-DATA .TTY>))
  #DECL ((TTY) CHANNEL (DATA) TTY-CHANNEL (X Y) FIX)
  <UPDATE-MC .TTY .X .Y>
  <CALL SYSOP SFPOS <TT-RJFN .DATA> <PUTLHW .X .Y>>
  T>

<DEFINE TTY-PARM (TTY OPER
		  "OPTIONAL" NEW
		  "AUX" (DATA <CHANNEL-DATA .TTY>))
	#DECL ((TTY) CHANNEL (DATA) TTY-CHANNEL (OPER) ATOM (NEW) FIX)
	<COND
	 (<==? .OPER PAGE-WIDTH>
	  <COND (<ASSIGNED? NEW>
		 <GET-TTY-PARM .DATA PAGE-WIDTH .NEW>)
		(T
		 <GET-TTY-PARM .DATA PAGE-WIDTH>)>)
	 (<==? .OPER PAGE-HEIGHT>
	  <COND (<ASSIGNED? NEW>
		 <GET-TTY-PARM .DATA PAGE-HEIGHT .NEW>)
		(T
		 <GET-TTY-PARM .DATA PAGE-HEIGHT>)>)
	 (<==? .OPER PAGE-X>
	  <COND (<ASSIGNED? NEW>
		 <GET-TTY-PARM .DATA PAGE-X .NEW>)
		(T
		 <GET-TTY-PARM .DATA PAGE-X>)>)
	 (<==? .OPER PAGE-Y>
	  <COND (<ASSIGNED? NEW>
		 <GET-TTY-PARM .DATA PAGE-Y .NEW>)
		(T
		 <GET-TTY-PARM .DATA PAGE-Y>)>)>>

\ 

<DEFINE INSERT-LINE (TTY OPER
		     "OPTIONAL" (N 1) (TOP <>) (BOT <>)
		     "AUX" (DATA <CHANNEL-DATA .TTY>))
	#DECL ((TTY) CHANNEL (N) FIX (TOP BOT) <OR FIX FALSE>
	       (DATA) TTY-CHANNEL)
	<COND (<0? .N> T)
	      (<NOT <OR .TOP .BOT>> <DPYOP .DATA ,/VTLID .N>)
	      (T
	       <COND (<NOT .TOP> <SET TOP <GET-TTY-PARM .DATA PAGE-Y>>)>
	       <COND (<NOT .BOT> <SET BOT <- <GET-TTY-PARM .DATA PAGE-HEIGHT>
					     1>>)>
	       <DPYOP .DATA
		      ,/VTLID
		      .N
		      <ORB <LSH .TOP 18> <ANDB .BOT *777777*>>>)>>

<DEFINE INSERT-CHAR (TTY OPER
		     "OPTIONAL" (N 1) (LEFT <>) (RIGHT <>)
		     "AUX" (DATA <CHANNEL-DATA .TTY>))
	#DECL ((TTY) CHANNEL (N) FIX (LEFT RIGHT) <OR FIX FALSE>)
	<COND (<NOT <OR .LEFT .RIGHT>> <DPYOP .DATA ,/VTCID .N>)
	      (T
	       <COND (<NOT .LEFT> <SET LEFT <GET-TTY-PARM .DATA PAGE-X>>)>
	       <COND (<NOT .RIGHT>
		      <SET RIGHT <- <GET-TTY-PARM .DATA PAGE-WIDTH> 1>>)>
	       <DPYOP .DATA
		      ,/VTCID
		      .N
		      <ORB <ANDB .RIGHT *777777000000*> .LEFT>>)>>

\ 

<DEFINE CLEAR-SCREEN (TTY OPER "AUX" SU) 
	#DECL ((TTY) CHANNEL)
	<UPDATE-MC .TTY 0 0>
	<DPYOP <CHANNEL-DATA .TTY> ,/VTCLR>>

<DEFINE CLEAR-EOL (TTY OPER) 
	#DECL ((TTY) CHANNEL)
	<DPYOP <CHANNEL-DATA .TTY> ,/VTCEL>>

<DEFINE CLEAR-EOS (TTY OPER)
  #DECL ((TTY) CHANNEL)
  <DPYOP <CHANNEL-DATA .TTY> ,/VTCEW>>

<DEFINE FRESH-LINE (TTY OPER "OPTIONAL" (N 1)) 
	#DECL ((TTY) CHANNEL (N) FIX)
	<UPDATE-MC .TTY 0>
	<DPYOP <CHANNEL-DATA .TTY> ,/VTADV .N>>

<DEFINE KILL-CHAR (TTY OPER)
  #DECL ((TTY) CHANNEL)
  <DPYOP <CHANNEL-DATA .TTY> ,/VTERA>>

<DEFINE ERASE-CHAR (TTY OPER "OPTIONAL" (N 1) "AUX" (SU <CHANNEL-USER .TTY>)) 
	#DECL ((TTY) CHANNEL (N) FIX)
	<UPDATE-MC .TTY (<- .N>)>
	<DPYOP <CHANNEL-DATA .TTY> ,/VTBEC .N>>

\ 

"SUBTITLE Cursor movement of various sorts"

<DEFINE HOME-CURSOR (TTY OPER)
	#DECL ((TTY) CHANNEL)
	<UPDATE-MC .TTY 0 0>
	<DPYOP <CHANNEL-DATA .TTY> ,/VTHOM>>

<DEFINE BOTTOM-CURSOR (TTY OPER)
	#DECL ((TTY) CHANNEL)
	<UPDATE-MC .TTY 0>
	<DPYOP <CHANNEL-DATA .TTY> ,/VTHMD>>

<DEFINE HOR-POS-CURSOR (TTY OPER X)
	#DECL ((TTY) CHANNEL)
	<UPDATE-MC .TTY .X>
	<DPYOP <CHANNEL-DATA .TTY> ,/VTHRZ .X>>

<DEFINE VER-POS-CURSOR (TTY OPER Y)
	#DECL ((TTY) CHANNEL)
	<UPDATE-MC .TTY <> .Y>
	<DPYOP <CHANNEL-DATA .TTY> ,/VTVRT .Y>>

<DEFINE MOVE-CURSOR (TTY OPER X Y "AUX" (CD <CHANNEL-DATA .TTY>)) 
	#DECL ((TTY) CHANNEL (CD) TTY-CHANNEL)
	<UPDATE-MC .TTY .X .Y>
	; "Caused by tops-20 bug with binary output"
	<CALL SYSOP SFPOS <TT-WJFN .CD> -1>
	<DPYOP .CD
	       ,/VTMOV
	       <ORB <LSH .Y 18> <ANDB .X *777777*>>>>

<DEFINE BACK-CURSOR (TTY OPER "OPTIONAL" (N 1)) 
	#DECL ((TTY) CHANNEL (N) FIX)
	<UPDATE-MC .TTY (<- .N>)>
	<DPYOP <CHANNEL-DATA .TTY> ,/VTBCK .N>>

<DEFINE DOWN-CURSOR (TTY OPER "OPTIONAL" (N 1)) 
	#DECL ((TTY) CHANNEL (N) FIX)
	<UPDATE-MC .TTY <> (.N)>
	<DPYOP <CHANNEL-DATA .TTY> ,/VTDWN .N>>

<DEFINE UP-CURSOR (TTY OPER "OPTIONAL" (N 1)) 
	#DECL ((TTY) CHANNEL (N) FIX)
	<UPDATE-MC .TTY <> (<- .N>)>
	<DPYOP <CHANNEL-DATA .TTY> ,/VTUP .N>>

<DEFINE FORWARD-CURSOR (TTY OPER "OPTIONAL" (N 1)) 
	#DECL ((TTY) CHANNEL (N) FIX)
	<UPDATE-MC .TTY (.N)>
	<DPYOP <CHANNEL-DATA .TTY> ,/VTFWD .N>>

\ 

<DEFINE SAVE-CURSOR (TTY OPER)
	#DECL ((TTY) CHANNEL)
	<DPYOP <CHANNEL-DATA .TTY> ,/VTSAV>>

<DEFINE RESTORE-CURSOR (TTY OPER)
	#DECL ((TTY) CHANNEL)
	<DPYOP <CHANNEL-DATA .TTY> ,/VTRES>>

<DEFINE TTY-PAD (TTY OPER AMT "AUX" (DATA <CHANNEL-DATA .TTY>)
		 SPD)
  #DECL ((TTY) CHANNEL (AMT) FIX (DATA) TTY-CHANNEL (SPD) <OR FALSE FIX>)
  <COND (<OR <NOT <SET SPD
		       <CALL SYSOP MTOPR <TT-WJFN .DATA> *27* '(RETURN 3)>>>
	     <==? .SPD -1>>
	 <SET SPD 9600>)>
  <SET SPD <ANDB .SPD *777777*>>
  <SET AMT <FIX </ <FLOAT <* .SPD .AMT>> 7000.0>>>
  <TTY-SET-IMAGE .TTY PAD T>
  <REPEAT ((BS ,BUFSTR) (TB .BS))
    #DECL ((TB BS) STRING)
    <COND (<0? .AMT>
	   <COND (<N==? .TB .BS>
		  <TWAY-WRITE-BUFFER .TTY .OPER .TB
				     <- <LENGTH .TB> <LENGTH .BS>>>)>
	   <RETURN>)>
    <COND (<EMPTY? .BS>
	   <TWAY-WRITE-BUFFER .TTY .OPER .TB>
	   <SET BS .TB>)>
    <1 .BS <ASCII 0>>
    <SET BS <REST .BS>>
    <SET AMT <- .AMT 1>>>>

<DEFINE TTY-TYPE-CHAR (CHANNEL OPER CHAR "AUX" (DATA <CHANNEL-DATA .CHANNEL>)
		       (Q <TT-QUEUE .DATA>) (QC <TT-QCT .DATA>))
  #DECL ((CHANNEL) CHANNEL (CHAR) CHARACTER (DATA) TTY-CHANNEL)
  <COND (<NOT .Q>
	 <TT-QUEUE .DATA .CHAR>
	 <TT-QCT .DATA 1>)
	(<TYPE? .Q CHARACTER>
	 <TT-QUEUE .DATA <SET Q <STRING .Q .CHAR "        ">>>
	 <TT-QCT .DATA 2>)
	(<==? .QC <LENGTH .Q>>
	 <TT-QUEUE .DATA <STRING .Q .CHAR "         ">>
	 <TT-QCT .DATA <+ .QC 1>>)
	(T
	 <PUT .Q <SET QC <+ .QC 1>> .CHAR>
	 <TT-QCT .DATA .QC>)>
  .CHAR>

<DEFINE GET-QUEUE-CHAR (DATA "AUX" CHR CT)
  #DECL ((DATA) TTY-CHANNEL)
  <COND (<G? <SET CT <TT-QCT .DATA>> 0>
	 <TT-QCT .DATA <SET CT <- .CT 1>>>
	 <COND (<TYPE? <SET CHR <TT-QUEUE .DATA>> CHARACTER>
		<TT-QUEUE .DATA <>>)
	       (T
		<SET CHR <1 .CHR>>
		<COND (<0? .CT> <TT-QUEUE .DATA <CALL TOPU <TT-QUEUE .DATA>>>)
		      (<TT-QUEUE .DATA <REST <TT-QUEUE .DATA>>>)>)>
	 .CHR)>>

\ 

<DEFINE TTY-PRINT-DATA (TTY OPER OUTCHAN "AUX" (DATA <CHANNEL-DATA .TTY>)
			TS) 
	#DECL ((TTY) CHANNEL (DATA) TTY-CHANNEL (TS) <OR FALSE STRING>)
	<PRINC "#TTY-CHANNEL [">
	<PRINC "JFN:">
	<COND (<==? <TT-RJFN .DATA> ,/PRIIN> <PRINC "PRIMARY">)
	      (T <PRIN1 <TT-RJFN .DATA>>)>
	<COND (<SET TS <TT-RBUF .DATA>>
	       <PRINC " RBUF:">
	       <PRIN1 <LENGTH <CALL TOPU .TS>>>
	       <PRINC !\/>
	       <PRIN1 <LENGTH .TS>>
	       <PRINC !\/>
	       <PRIN1 <TT-RBC .DATA>>)>
	<COND (<SET TS <TT-WBUF .DATA>>
	       <PRINC " WBUF:">
	       <PRIN1 <LENGTH <CALL TOPU .TS>>>
	       <PRINC !\/>
	       <PRIN1 <LENGTH .TS>>
	       <PRINC !\/>
	       <PRIN1 <TT-WBC .DATA>>)>
	<PRINC " RFCUR:">
	<PRIN1 <TT-RFCUR .DATA>>
	<PRINC !\]>>

<ENDPACKAGE>