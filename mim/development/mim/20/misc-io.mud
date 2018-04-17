<PACKAGE "MISC-IO">

<ENTRY GNJFN NEXT-FILE>

<COND (<NOT <GASSIGNED? NEW-CHANNEL-TYPE>> <SETG NEW-CHANNEL-TYPE ,TIME>)>

<NEW-CHANNEL-TYPE GNJFN DEFAULT
		 OPEN GNJFN-OPEN
		 CLOSE GNJFN-CLOSE
		 NEXT-FILE GNJFN-STEP>

<DEFINE GNJFN-OPEN (STYPE OPR NAME "AUX" JFN)
  #DECL ((NAME) STRING)
  <COND (<SET JFN
	      <CALL SYSOP GTJFN-S-S
		    %<CHTYPE <ORB ,GJ-OLD ,GJ-IFG ,GJ-SHT ,GJ-FLG>
			     FIX>
		    .NAME>>
	 [<ANDB .JFN *777777*> .JFN])>>

<DEFINE GNJFN-STEP (CHANNEL OPER "AUX" (VEC <CHANNEL-DATA .CHANNEL>) TMP)
  #DECL ((CHANNEL) CHANNEL (VEC) <VECTOR FIX>)
  <COND (<SET TMP <CALL SYSOP GNJFN <2 .VEC> '(RETURN 1)>>
	 <1 .VEC .TMP>)>>

<DEFINE GNJFN-CLOSE (CHANNEL OPER "AUX" (VEC <CHANNEL-DATA .CHANNEL>))
  #DECL ((CHANNEL) CHANNEL (VEC) <VECTOR FIX>)
  <CALL SYSOP RLJFN <2 .VEC>>>



<NEW-CHANNEL-TYPE PARSE DEFAULT
		  OPEN PARSE-OPEN
		  CLOSE PARSE-CLOSE>

<DEFINE VALUE? (ATM "AUX" TS)
  #DECL ((ATM) ATOM (TS) <OR FALSE FIX STRING>)
  <SET TS <COND (<ASSIGNED? .ATM>
		 ..ATM)
		(<GASSIGNED? .ATM>
		 ,.ATM)>>
  <COND (<OR <NOT .TS> <TYPE? .TS FIX> <EMPTY? .TS>> 0)
	(.TS)>>

<DEFINE PARSE-OPEN (TYP OPER NAME
		    "OPTIONAL" (NM1 <VALUE? NM1>) (NM2 <VALUE? NM2>)
		               (DEV <VALUE? DEV>) (SNM <VALUE? SNM>)
		     "AUX" JFN)
  #DECL ((NAME) STRING (NM1 NM2 DEV SNM) <OR FIX STRING> (JFN) <OR FALSE FIX>)
  <COND (<SET JFN <CALL SYSOP GTJFN-L
			.NAME ,GJ-OFG
			%<CHTYPE <ORB ,/NULIO <LSH ,/NULIO 18>> FIX>
			.DEV .SNM .NM1 .NM2 0 0 0>>
	 [.JFN])>>

<DEFINE PARSE-CLOSE (CH OPER "AUX" (DATA <CHANNEL-DATA .CH>))
  #DECL ((CH) CHANNEL (DATA) <VECTOR FIX>)
  <CALL SYSOP RLJFN <1 .DATA>>>
<ENDPACKAGE>
