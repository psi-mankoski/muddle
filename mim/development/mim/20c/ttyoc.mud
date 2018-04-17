<USE "TTY">

<NEWTYPE ARGNO FIX>

<DEFINE OC-TTY-OP (OP:ATOM ARGS:LIST
		   "AUX" (STUFF:<OR FALSE LIST> <GETPROP .OP TTY-OC>))
	<COND (.STUFF
	       <MAPF <>
		     <FUNCTION (INS)
			  <COND (<TYPE? .INS LIST>
				 <MAPF ,OCEMIT
				       <FUNCTION (X)
					    <COND (<TYPE? .X ARG-NO>
						   <MAPRET 
						    !<OBJ-VAL
						      <NTH .ARGS
							   <CHTYPE .X FIX>>>>)
						  (<TYPE? .X GVAL>
						   ,<CHTYPE .X ATOM>)
						  (ELSE .X)>>
					    .INS>)
				(<TYPE? .INS FORM>
				 <APPLY <1 .INS> .ARGS !<REST .INS>>)>>
		     .STUFF>
	       T)>>

<COND (<GASSIGNED? OC-TTY-OP> <PUTPROP TTY OC-INDICATOR ,OC-TTY-OP>)>


<PUTPROP SET-ECHO-MODE TTY-OC
	 '((MOVE O1* #ARG-NO 1)
	   (MOVE O1* ,OC-CHANNEL-DATA (O1*))
	   (MOVE B* ,OC-TT-RFCUR (O1*))
	   <DO-ECHO-SET #ARG-NO 2>)>

<DEFINE DO-ECHO-SET (ARGS:LIST ARGNO
		     "AUX" (ARG <NTH .ARGS <CHTYPE .ARGNO FIX>>) LBL (CHOMP <>))
	<COND (<NOT .ARG>
	       <OCEMIT TRZN B* ,TT-ECO>)
	      (<NOT <TYPE? .ARG ATOM>>
	       <OCEMIT TROE B* ,TT-ECO>)
	      (ELSE
	       <SET CHOMP T>
	       <LOAD-TYPE O* <OBJ-TYP .ARG>>
	       <OCEMIT CAIE O* !<TYPE-CODE FALSE T>>
	        <OCEMIT TRON B* ,TT-ECO>
	         <OCEMIT TRZN B* ,TT-ECO>)>
	<OCEMIT JRST <SET LBL <GENLBL "NOSFMOD">>>
	<COND (.CHOMP
	       <OCEMIT CAIE O* !<TYPE-CODE FALSE T>>
	       <OCEMIT TRO B* ,TT-ECO>)>
	<OCEMIT MOVEM B* ,OC-TT-RFCUR '(O1*)>
	<OCEMIT MOVE A* ,OC-TT-RJFN '(O1*)>
	<OCEMIT SFMOD!-JSYS>
	<OCEMIT JUMP P* <XJUMP IOERR>>
	<LABEL .LBL>>

<PUTPROP CLEAR-EOL TTY-OC
	 '((MOVE O2* #ARG-NO 1)
	   (MOVE O1* ,OC-CHANNEL-DATA (O2*))
	   (SKIPE O* ,OC-TT-WBUF (O1*))
	   (SKIPN O* ,OC-TT-WBC (O1*))
	   (JRST #TTY-TAG 1)
	   <CALL-DUMP-WRITE-BUFFER>
	   #TTY-TAG 1
	   (MOVE A* ,OC-TT-WJFN (O1*))
	   (MOVEI B* ,/VTCEL)
	   (OCEMIT SFMOD!-JSYS)
	   (OCEMIT JUMP P* <XJUMP IOERR>))>

<DEFINE CALL-DUMP-WRITE-BUFFER (ARGS:LIST "AUX" GC)
	<COND (<AND ,GLUE-MODE <MEMQ DUMP-WRITE-BUFFER ,PRE-NAMES>>
	       <FRAME!-MIMOC (<SET GC <GENLBL "?FRM">> DUMP-WRITE-BUFFER)>)
	      (ELSE
	       <FRAME!-MIMOC '('DUMP-WRITE-BUFFER)>)>
	<OCEMIT PUSH ,OC-CHANNEL-DATA-1 '(O2*)>
	<OCEMIT PUSH ,OC-CHANNEL-DATA '(O2*)>
	<CALL!-MIMOC (''DUMP-WRITE-BUFFER 1 !<COND (.GC (.GC)) (ELSE ())>)>>


<CHANNEL-OP 'TTY 'WRITE-BYTE INCHAN9 CHR24>

<CHANNEL-OP 'TTY 'GET-READ-BUFFER INCHAN9 = TEMP43>

<DEFINE TTY-GET-READ (TTY OPER "OPTIONAL" NEW
			"AUX" (DATA <CHANNEL-DATA .TTY>))
  #DECL ((TTY) CHANNEL (DATA) TTY-CHANNEL (NEW) STRING)
  <COND (<ASSIGNED? NEW>
	 <TT-RBUF .DATA .NEW>
	 .NEW)
	(T
	 <TT-RBUF .DATA>)>>

<CHANNEL-OP 'TTY 'BUFLEN INCHAN9 TEMP43>

<DEFINE TTY-BUFLEN (TTY OPER "OPTIONAL" NEW "AUX" (DATA <CHANNEL-DATA .TTY>))
  #DECL ((TTY) CHANNEL (DATA) TTY-CHANNEL (NEW) FIX)
  <COND (<ASSIGNED? NEW>
	 <TT-RBC .DATA .NEW>
	 .NEW)
	(T
	 <TT-RBC .DATA>)>>

<CHANNEL-OP 'TTY 'DOWN-CURSOR INCHAN9>


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

<CHANNEL-OP 'TTY 'INSERT-LINE INCHAN9 1>

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


<CHANNEL-OP 'TTY 'ERASE-CHAR INCHAN9>


<DEFINE KILL-CHAR (TTY OPER)
  #DECL ((TTY) CHANNEL)
  <DPYOP <CHANNEL-DATA .TTY> ,/VTERA>>


<DEFINE ERASE-CHAR (TTY OPER "OPTIONAL" (N 1) "AUX" (SU <CHANNEL-USER .TTY>)) 
	#DECL ((TTY) CHANNEL (N) FIX)
	<UPDATE-MC .TTY (<- .N>)>
	<DPYOP <CHANNEL-DATA .TTY> ,/VTBEC .N>>


<CHANNEL-OP 'TTY 'WRITE-BUFFER INCHAN9 BUF4 END7>
