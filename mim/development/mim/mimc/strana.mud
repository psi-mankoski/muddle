
<PACKAGE "STRANA">

<ENTRY LENGTH-ANA
       EMPTY?-ANA
       LENGTH?-ANA
       NTH-ANA
       REST-ANA
       PUT-ANA
       PUTREST-ANA
       MEMQ-ANA
       NTH-REST-ANA
       MONAD-ANA
       BACK-ANA
       TOP-ANA>

<USE "SYMANA" "CHKDCL" "COMPDEC" "ADVMESS">

"Structure hackers for the compiler (analyzers)"

<DEFINE LNTH-MT-ANA (NOD RTYP COD
		     "AUX" (K <KIDS .NOD>) (LN <LENGTH .K>) TEM (WHO ())
			   (TY BOOLEAN)
			   (WHON
			    <AND <OR <AND <==? .COD ,LNTH-CODE>
					  <ASSIGNED? GLN>
					  <ANCEST .GLN <PARENT .NOD>>>
				     <AND <==? .PRED <PARENT .NOD>>
					  <==? .COD ,MT-CODE>>>
				 .NOD>))
   #DECL ((NOD) NODE (LN COD) FIX (K) <LIST [REST NODE]> (WHO) <SPECIAL LIST>
	  (WHON) <SPECIAL <OR NODE FALSE>>)
   <COND
    (<SEGFLUSH .NOD .RTYP>)
    (ELSE
     <ARGCHK .LN 1 <NODE-NAME .NOD> .NOD>
     <SET TEM <STRUCTYP <EANA <1 .K> STRUCTURED <NODE-NAME .NOD>>>>
     <COND
      (<OR .TEM <==? .COD ,MT-CODE>>
       <PUT .NOD ,NODE-TYPE .COD>
       <SET TY BOOLEAN>)
      (ELSE
       <COND (.VERBOSE
	      <ADDVMESS .NOD
			("Not open compiled because type is:  "
			 <RESULT-TYPE <1 .K>>)>)>
       <PUT .NOD ,NODE-TYPE ,ISUBR-CODE>)>)>
   <COND (<==? .COD ,MT-CODE>
	  <MAPF <>
		<FUNCTION (L "AUX" (SYM <2 .L>) (FLG <1 .L>)) 
			#DECL ((L) <LIST <OR FALSE ATOM> SYMTAB> (SYM) SYMTAB)
			'<SET TRUTH
			      <ADD-TYPE-LIST .SYM
					     '<STRUCTURED [REST <NOT ANY>]>
					     .TRUTH
					     .FLG
					     <REST .L 2>>>
			<SET UNTRUTH
			     <ADD-TYPE-LIST .SYM
					    '<STRUCTURED ANY>
					    .UNTRUTH
					    .FLG
					    <REST .L 2>>>
			T>
		.WHO>)
	 (ELSE <SET GLE .WHO>)>
   <TYPE-OK? <COND (<==? <NODE-SUBR .NOD> ,LENGTH> <FORM FIX (0 ,PLUSINF)>)
		   (ELSE .TY)>
	     .RTYP>>

<DEFINE ANCEST (N1 N2) 
	#DECL ((N1 N2) NODE)
	<REPEAT ()
		<COND (<==? .N1 .N2> <RETURN>)>
		<OR <==? <NODE-TYPE .N2> ,SET-CODE> <RETURN <>>>
		<COND (<TYPE? <PARENT .N2> NODE> <SET N2 <PARENT .N2>>)
		      (ELSE <RETURN <>>)>>>

<DEFINE LENGTH-ANA (N R) <LNTH-MT-ANA .N .R ,LNTH-CODE>>

<DEFINE EMPTY?-ANA (N R) <LNTH-MT-ANA .N .R ,MT-CODE>>

<COND (<GASSIGNED? LENGTH-ANA>
       <PUTPROP ,EMPTY? ANALYSIS ,EMPTY?-ANA>
       <PUTPROP ,LENGTH ANALYSIS ,LENGTH-ANA>)>

<DEFINE LENGTH?-ANA (NOD RTYP
		     "AUX" (K <KIDS .NOD>) TEM (WHO ())
			   (WHON <AND <==? .PRED <PARENT .NOD>> .NOD>))
   #DECL ((NOD) NODE (K) <LIST [REST NODE]> (WHON) <SPECIAL ANY>
	  (WHO) <SPECIAL LIST>)
   <COND
    (<SEGFLUSH .NOD .RTYP>)
    (ELSE
     <ARGCHK <LENGTH .K> 2 LENGTH? .NOD>
     <SET TEM <EANA <1 .K> STRUCTURED LENGTH?>>
     <SET WHON <>>
     <EANA <2 .K> FIX LENGTH?>
     <COND (<==? <NODE-TYPE <2 .K>> ,QUOTE-CODE>	    ;"Constant 2d arg?"
	    <MAPF <>
		  <FUNCTION (L "AUX" (SYM <2 .L>) (FLG <1 .L>)) 
			  #DECL ((L) <LIST ANY SYMTAB> (SYM) SYMTAB)
			  <SET UNTRUTH
			       <ADD-TYPE-LIST
				.SYM
				<FORM STRUCTURED [<NODE-NAME <2 .K>> ANY]>
				.TRUTH
				.FLG
				<REST .L 2>>>>
		  .WHO>)>
     <COND (<SET TEM <STRUCTYP .TEM>> <PUT .NOD ,NODE-TYPE ,LENGTH?-CODE>)
	   (ELSE
	    <COND (.VERBOSE
		   <ADDVMESS .NOD
			     ("Not open compiled because type is:  "
			      <RESULT-TYPE <1 .K>>)>)>
	    <PUT .NOD ,NODE-TYPE ,ISUBR-CODE>)>
     <TYPE-OK? <FORM OR
		     <FORM FIX
			   (0
			    <COND (<==? <NODE-TYPE <2 .K>> ,QUOTE-CODE>
				   <NODE-NAME .NOD>)
				  (ELSE ,PLUSINF)>)>
		     FALSE>
	       .RTYP>)>>

<COND (<GASSIGNED? LENGTH?-ANA> <PUTPROP ,LENGTH? ANALYSIS ,LENGTH?-ANA>)>

<DEFINE MONAD-ANA (NOD RTYP "AUX" (K <KIDS .NOD>) (LN <LENGTH .K>) TEM)
	#DECL ((NOD) NODE (K) <LIST [REST NODE]>)
	<COND (<SEGFLUSH .NOD .RTYP>
	       <TYPE-OK? .RTYP BOOLEAN>)
	      (ELSE
	       <ARGCHK .LN 1 MONAD? .NOD>
	       <SET TEM <EANA <1 .K> STRUCTURED <NODE-NAME .NOD>>>
	       <PUT .NOD ,NODE-TYPE ,MONAD-CODE>
	       <TYPE-OK? .RTYP BOOLEAN>)>>

<COND (<GASSIGNED? MONAD-ANA> <PUTPROP ,MONAD? ANALYSIS ,MONAD-ANA>)>

<DEFINE NTH-REST-ANA (NOD RTYP COD
		      "OPTIONAL" (TF <>)
		      "AUX" (K <KIDS .NOD>) (LN <LENGTH .K>) TS VAL TPS
			    (RV <OR .TF <==? <NODE-NAME .NOD> INTH>>)
			    (SVWHO ()) AMT PT
			    (NM <COND (.RV NTH) (ELSE <NODE-NAME .NOD>)>) XX
			    (OWHON <AND <==? .WHON <PARENT .NOD>> .NOD>) NUMB)
   #DECL ((COD NUMB LN) FIX (NOD WHON PRED) NODE (K) <LIST [REST NODE]>
	  (WHO SVWHO) LIST)
   <SET VAL
    <PROG ((WHO ()) (WHON <>))
      #DECL ((WHON) <SPECIAL ANY> (WHO) <SPECIAL LIST>)
      <COND
       (<SEGFLUSH .NOD .RTYP>)
       (ELSE
	<COND (<1? .LN>
	       <PUT .NOD
		    ,KIDS
		    <SET K (<1 .K> <NODE1 ,QUOTE-CODE .NOD FIX 1 ()>)>>)
	      (ELSE <ARGCHK .LN 2 <NODE-NAME .NOD> .NOD>)>
	<COND (.RV
	       <OR .TF <SET TF <EANA <2 .K> '<OR FIX OFFSET> .NM>>>
	       <SET WHON .NOD>
	       <SET TS <EANA <1 .K> STRUCTURED .NM>>)
	      (ELSE
	       <SET WHON .NOD>
	       <SET TS <EANA <1 .K> STRUCTURED .NM>>
	       <SET WHON <>>
	       <OR .TF <SET TF <EANA <2 .K> '<OR FIX OFFSET> .NM>>>)>
	<COND (<AND <==? <NODE-TYPE <2 .K>> ,QUOTE-CODE>
		    <SET AMT <NODE-NAME <2 .K>>>
		    <==? <ISTYPE? .TF> OFFSET>>
	       <SET TS <TYPE-AND .TS <GET-DECL .AMT>>>
	       <SET AMT <INDEX .AMT>>
	       <PUT <1 .K> ,RESULT-TYPE .TS>)>
	<COND (<ASSIGNED? AMT>
	       <COND (<==? .COD ,NTH-CODE>
		      <COND (<==? .AMT 1>
			     <SET TS <TYPE-AND .TS <FORM STRUCTURED .RTYP>>>)
			    (ELSE
			     <SET TS <TYPE-AND .TS <FORM STRUCTURED
							 [<- .AMT 1> ANY]
							 .RTYP>>>)>)
		     (<SET PT <STRUCTYP .RTYP>>
		      <COND (<==? .AMT 0>
			     <SET TS <TYPE-AND .TS <FORM PRIMTYPE .PT>>>)
			    (ELSE
			     <SET TS <TYPE-AND .TS <FORM <FORM PRIMTYPE .PT>
							 [.AMT ANY]>>>)>)
		     (<N==? .AMT 0>
		      <SET TS <TYPE-AND .TS <FORM STRUCTURED [.AMT ANY]>>>)>)
	      (<==? .COD ,NTH-CODE>
	       <SET TS <TYPE-AND .TS <FORM STRUCTURED ANY>>>)
	      (<SET PT <STRUCTYP .RTYP>>
	       <SET TS <TYPE-AND .TS <FORM PRIMTYPE .PT>>>)>
	<PUT <1 .K> ,RESULT-TYPE .TS>
	<SET TPS <STRUCTYP .TS>>
	<COND (<AND .TPS <==? <NODE-TYPE <2 .K>> ,QUOTE-CODE>>
	       <SET SVWHO .WHO>)>
	<COND
	 (<OR <AND <==? <NODE-TYPE <2 .K>> ,QUOTE-CODE>
		   <==? <NODE-NAME <2 .K>> 1>>
	      <AND .TPS
		   <OR <==? <ISTYPE? .TF> FIX>
		       <AND <==? <ISTYPE? .TF> OFFSET>
			    <==? <NODE-TYPE <2 .K>> ,QUOTE-CODE>>
		       <AND <TYPE-OK? .TF FIX>
			    <N==? <NODE-TYPE <2 .K>> ,QUOTE-CODE>>>>>
	  <PUT .NOD ,NODE-TYPE .COD>)
	 (ELSE
	  <AND <==? .COD ,NTH-CODE> <PUT .NOD ,NODE-NAME NTH>>
	  <COND (.VERBOSE
		 <ADDVMESS .NOD ("Not open compiled because type is:  " .TS)>)>
	  <PUT .NOD ,NODE-TYPE ,ISUBR-CODE>)>
	<TYPE-OK?
	 <GET-ELE-TYPE
	  .TS
	  <COND (<==? <NODE-TYPE <2 .K>> ,QUOTE-CODE>
		 <SET NUMB
		      <COND (<==? <ISTYPE? .TF> OFFSET>
			     <INDEX <NODE-NAME <2 .K>>>)
			    (ELSE <NODE-NAME <2 .K>>)>>)
		(ELSE ALL)>
	  <==? <NODE-SUBR .NOD> ,REST>>
	 .RTYP>)>>>
   <MAPF <>
	 <FUNCTION (L "AUX" (SYM <2 .L>) (FL <1 .L>) T1 T2) 
		 #DECL ((L) <LIST ANY SYMTAB [REST ATOM FIX]> (SYM) SYMTAB)
		 <SET XX (.NM .NUMB !<REST .L 2>)>
		 <SET-CURRENT-TYPE
		  .SYM
		  <TYPE-AND <GET-CURRENT-TYPE .SYM> <TYPE-NTH-REST .VAL .XX>>>
		 <COND (.OWHON <SET WHO ((.FL .SYM !.XX) !.WHO)>)>
		 <COND (<AND <==? .PRED <PARENT .NOD>>
			     <SET T1 <TYPE-OK? .VAL FALSE>>
			     <SET T2 <TYPE-OK? .VAL '<NOT FALSE>>>>
			<SET TRUTH <ADD-TYPE-LIST .SYM .T2 .TRUTH .FL .XX>>
			<SET UNTRUTH
			     <ADD-TYPE-LIST .SYM .T1 .UNTRUTH .FL .XX>>)>>
	 .SVWHO>
   <COND (<AND <==? .TPS LIST>
	       <OR <==? <NODE-TYPE <1 .K>> ,LVAL-CODE>
		   <==? <NODE-TYPE <1 .K>> ,SET-CODE>>
	       <LOOK-FOR .NOD <1 .K> <2 .K> <==? <NODE-SUBR .NOD> ,REST>>>
	  <PUT .NOD ,NODE-TYPE ,ALL-REST-CODE>)
	 (<AND <==? .TPS LIST>
	       <==? .COD ,REST-CODE>
	       <GASSIGNED? PUT-SAME-CODE>
	       <==? <NODE-TYPE <1 .K>> ,PUTR-CODE>
	       <==? <NODE-TYPE <2 .K>> ,QUOTE-CODE>
	       <==? .NUMB 1>>
	  <PUT .NOD ,NODE-TYPE ,PUTR-CODE>)>
   .VAL>

<DEFINE LOOK-FOR (MN N1 N RFLG "AUX" TT K (S ()) (SS (() () ()))) 
	#DECL ((S) <LIST [REST NODE]> (N MN N1) NODE (TT) <OR FALSE NODE>
	       (K) <LIST [REST NODE]>)
	<REPEAT ()
		<COND (<==? <NODE-TYPE .N1> ,LVAL-CODE>
		       <SET S (.N1 !.S)>
		       <RETURN>)
		      (<==? <NODE-TYPE .N1> ,SET-CODE>
		       <SET S (.N1 !.S)>
		       <SET N1 <2 <KIDS .N1>>>)
		      (ELSE <RETURN>)>>
	<AND <OR <AND .RFLG
		      <SET TT <SET-SEARCH .N ,ARITH-CODE .S .SS>>
		      <==? <NODE-SUBR <SET N .TT>> ,->
		      <==? <LENGTH <SET K <KIDS .N>>> 2>
		      <==? <NODE-TYPE <2 .K>> ,QUOTE-CODE>
		      <==? <NODE-NAME <2 .K>> 1>
		      <SET N <1 .K>>>
		 <NOT .RFLG>>
	     <SET TT <SET-SEARCH .N ,LNTH-CODE .S <REST .SS>>>
	     <SET TT <SET-SEARCH <1 <KIDS .TT>> ,LVAL-CODE .S <REST .SS 2>>>
	     <SMEMQ <NODE-NAME .TT> .S>
	     <PUT .MN ,TYPE-INFO .SS>>>

<DEFINE SET-SEARCH (N C S SS "AUX" (L ())) 
	#DECL ((N) NODE (C) FIX (S) <LIST [REST NODE]> (L SS) LIST)
	<REPEAT ()
		<COND (<==? .C <NODE-TYPE .N>> <PUT .SS 1 .L> <RETURN .N>)>
		<COND (<OR <N==? <NODE-TYPE .N> ,SET-CODE>
			   <SMEMQ <NODE-NAME .N> .S>>
		       <RETURN <>>)>
		<SET L (.N !.L)>
		<SET N <2 <KIDS .N>>>>>

<DEFINE SMEMQ (SYM L) 
	#DECL ((SYM) SYMTAB (L) LIST)
	<MAPR <>
	      <FUNCTION (LL "AUX" (N <1 .LL>)) 
		      #DECL ((N) NODE)
		      <COND (<==? <NODE-NAME .N> .SYM> <MAPLEAVE .LL>)>>
	      .L>>

<DEFINE NTH-ANA (N R) <NTH-REST-ANA .N .R ,NTH-CODE>>

<DEFINE REST-ANA (N R) <NTH-REST-ANA .N .R ,REST-CODE>>

<COND (<GASSIGNED? NTH-ANA>
       <PUTPROP ,NTH ANALYSIS ,NTH-ANA>
       <PUTPROP ,REST ANALYSIS ,REST-ANA>)>

<DEFINE PUT-ANA (NOD RTYP
		 "OPTIONAL" (TF <>)
		 "AUX" (K <KIDS .NOD>) (LN <LENGTH .K>) (TS ANY) TV (TPS <>)
		       VAL (SVWHO ()) WHICH NS TVO TEM (P ()) TFF NUMB
		       (RV <OR .TF <==? <NODE-NAME .NOD> IPUT>>) AMT
		       (NM <COND (.RV PUT) (ELSE <NODE-NAME .NOD>)>))
   #DECL ((NOD) NODE (K) <LIST [REST NODE]> (LN NUMB) FIX (WHO P SVWHO) LIST)
   <SET VAL
    <PROG ((WHO ()) (WHON <>))
      #DECL ((WHO) <SPECIAL LIST> (WHON) <SPECIAL <OR FALSE NODE>>)
      <COND
       (<SEGFLUSH .NOD .RTYP>)
       (ELSE
	<ARGCHK .LN 3 <NODE-NAME .NOD> .NOD>
	<COND (.RV
	       <SET WHON <>>
	       <OR .TF <SET TF <SET TFF <EANA <2 .K> '<OR FIX OFFSET> PUT>>>>
	       <SET WHON .NOD>
	       <SET TS <ANA <1 .K> STRUCTURED>>
	       <SET WHON <>>)
	      (ELSE
	       <SET WHON .NOD>
	       <SET TS <ANA <1 .K> STRUCTURED>>
	       <SET WHON <>>
	       <OR .TF <SET TFF <SET TF <EANA <2 .K> '<OR FIX OFFSET> PUT>>>>)>
	<SET TV <ANA <3 .K> ANY>>
	<COND (<AND <==? <NODE-TYPE <2 .K>> ,QUOTE-CODE>
		    <SET AMT <NODE-NAME <2 .K>>>
		    <==? <ISTYPE? .TF> OFFSET>>
	       <SET TS <TYPE-AND .TS <GET-DECL <NODE-NAME <2 .K>>>>>
	       <SET AMT <INDEX .AMT>>
	       <PUT <1 .K> ,RESULT-TYPE .TS>)>
	<OR <AND <OR <==? <ISTYPE? .TF> FIX>
		     <AND <==? <ISTYPE? .TF> OFFSET>
			  <==? <NODE-TYPE <2 .K>> ,QUOTE-CODE>>>
		 <==? <NODE-SUBR .NOD> ,PUT>>
	    <SET TF <>>>
	<SET NS
	     <COND (<AND .TF .TS <ASSIGNED? AMT>>
		    <SET WHICH .AMT>
		    <FORM STRUCTURED
			  !<COND (<1? .WHICH> (ANY))
				 (ELSE ([<- .WHICH 1> ANY] ANY))>>)
		   (ELSE <SET WHICH ALL> '<STRUCTURED ANY>)>>
	<SET TS <TYPE-AND .TS .NS>>
	<COND
	 (<AND <N==? .WHICH ALL> <N==? .TV ANY>>
	  <COND
	   (<OR
	     <NOT <TYPE? .TS FORM SEGMENT>>
	     <COND
	      (<==? <1 .TS> OR>
	       <MAPF <>
		<FUNCTION (X!-INITIAL) 
			<COND
			 (<AND <TYPE? .X!-INITIAL FORM>
			       <==? <REST .X!-INITIAL
					  <- <LENGTH .X!-INITIAL> 1>>
				    <REST .NS <- <LENGTH .NS> 1>>>>
			  <MAPLEAVE <>>)
			 (ELSE T)>>
		<REST .TS>>)
	      (ELSE
	       <N==? <REST .NS <- <LENGTH .NS> 1>>
		     <REST .TS <- <LENGTH .TS> 1>>>)>>
	    <PUT .NS <LENGTH .NS> .TV>)
	   (ELSE <PUT <SET NS <FORM !.NS>> <LENGTH .NS> .TV>)>)>
	<COND
	 (<AND .TS .TF <NOT <EMPTY? .WHO>>>
	  <SET NS
	   <MAPF ,TYPE-MERGE
	    <FUNCTION (L "AUX" (S <2 .L>) (ND <DECL-SYM .S>)) 
	       #DECL ((L) <LIST ANY SYMTAB> (S) SYMTAB)
	       <SET ND <DECL-DOWN .ND !<REST .L 2!>>>
	       <COND (<NOT <SET ND <TYPE-AND .ND .NS>>>
		      <COMPILE-ERROR "Bad argument to PUT " .NOD>)>
	       <SET ND
		<TYPE-AND
		 <TOP-TYPE <DECL-DOWN <GET-CURRENT-TYPE .S> !<REST .L 2!>>>
		 .ND>>>
	    .WHO>>
	  <SET TV <TYPE-AND .TV <GET-ELE-TYPE .NS .WHICH>>>)
	 (<NOT <EMPTY? .WHO>> <SET TV ANY>)>
	<AND .TS
	     <PUT <1 .K> ,RESULT-TYPE <SET TS <TYPE-AND <TOP-TYPE .NS> .TS>>>>
	<COND (.TS
	       <SET TVO <GET-ELE-TYPE .TS .WHICH>>
	       <SET TS <GET-ELE-TYPE .TS .WHICH <> .TV>>)>
	<COND (<AND .TS .TF <==? <NODE-TYPE <2 .K>> ,QUOTE-CODE>>
	       <SET SVWHO .WHO>)>
	<COND (<AND .TS .TF>
	       <PUT .NOD ,SIDE-EFFECTS (.NOD !<SIDE-EFFECTS .NOD!>)>)>
	<COND
	 (<AND .TS
	       .TF
	       <SET TPS <STRUCTYP .TS>>
	       <OR <==? <ISTYPE? .TF> FIX> <==? <ISTYPE? .TF> OFFSET>>>
	  <PUT .NOD ,NODE-TYPE ,PUT-CODE>
	  <COND (<AND <==? <NODE-TYPE <1 .K>> ,QUOTE-CODE>
		      <NOT ,INTERPRETER-IMPLEMENTOR?>>
		 <COMPILE-ERROR "Attempt to PUT in quoted object " .NOD>)>)
	 (ELSE
	  <COND (<AND .VERBOSE <==? <NODE-SUBR .NOD> ,PUT>>
		 <ADDVMESS .NOD ("Not open compiled because type is: " .TS)>)>
	  <PUT .NOD ,NODE-TYPE ,IPUT-CODE>
	  <PUT .NOD ,NODE-NAME PUT>)>)>
      <PUT-FLUSH <OR .TPS ALL>>
      <TYPE-OK? <COND (.TS .TS) (ELSE ANY)> .RTYP>>>
   <COND
    (<==? <NODE-TYPE .NOD> ,PUT-CODE>
     <MAPF <>
      <FUNCTION (L "AUX" (SYM <2 .L>)) 
	      #DECL ((L) <LIST ANY SYMTAB [REST ATOM FIX]> (SYM) SYMTAB)
	      <SET-CURRENT-TYPE
	       .SYM
	       <PUT-TYPE-HACK <GET-CURRENT-TYPE .SYM>
			      .TS
			      <LPR <REST .L 2>>
			      .WHICH
			      0>>>
      .SVWHO>)>
   <COND (<AND <==? <NODE-TYPE .NOD> ,PUT-CODE>
	       <GASSIGNED? PUT-SAME-CODE>
	       <MEMQ .TPS '[LIST VECTOR UVECTOR TUPLE STRING BYTES]>
	       <MAPF <>
		     <FUNCTION (N) 
			     <COND (<AND <G=? <LENGTH .N>
					      <INDEX ,SIDE-EFFECTS>>
					 <SIDE-EFFECTS .N>>
				    <MAPLEAVE <>>)
				   (ELSE T)>>
		     .K>
	       <MEMQ <NODE-TYPE <3 .K>> ,HACK-NODES>
	       <==? <ISTYPE? <RESULT-TYPE <3 .K>>> FIX>
	       <NOT <EMPTY? <SET TEM <KIDS <3 .K>>>>>
	       <NOT <OR <==? <NODE-SUBR <3 .K>> ,/>
			<AND <==? <NODE-SUBR <3 .K>> ,->
			     <NOT <AND <==? <LENGTH .TEM> 2>
				       <==? <NODE-NAME <2 .TEM>> 1>>>>>>
	       <MAPR <>
		     <FUNCTION (L "AUX" (N <1 .L>)) 
			     <COND (<AND <==? <NODE-TYPE .N> ,NTH-CODE>
					 <SAME-OBJ <1 .K> <1 <KIDS .N>>>
					 <SAME-OBJ <2 .K> <2 <KIDS .N>>>>
				    <COND (<NOT <EMPTY? .P>>
					   <PUTREST .P <REST .L>>
					   <SET TEM (.N !.TEM)>)>
				    <MAPLEAVE>)>
			     <SET P .L>
			     <>>
		     .TEM>>
	  <PUT <3 .K> ,KIDS .TEM>
	  <PUT .NOD ,NODE-TYPE ,PUT-SAME-CODE>)>
   .VAL>

<DEFINE PUT-TYPE-HACK (TY TS L WHICH EX) 
	#DECL ((L) <LIST [REST FIX ATOM]>)
	<COND
	 (<EMPTY? .L> .TS)
	 (<AND <EMPTY? <REST .L 2>> <==? <2 .L> REST>>
	  <GET-ELE-TYPE .TY
			<+ <1 .L> .WHICH>
			<>
			<PUT-TYPE-HACK <GET-ELE-TYPE .TS .WHICH>
				       .TS
				       <REST .L 2>
				       .WHICH
				       0>>)
	 (<==? <2 .L> REST> <PUT-TYPE-HACK .TY .TS <REST .L 2> .WHICH <1 .L>>)
	 (ELSE
	  <GET-ELE-TYPE
	   .TY
	   <+ <1 .L> .EX>
	   <>
	   <PUT-TYPE-HACK <GET-ELE-TYPE .TY <+ <1 .L> .EX>>
			  .TS
			  <REST .L 2>
			  .WHICH
			  0>>)>>

<DEFINE LPR (L) 
	#DECL ((VALUE L) LIST)
	<COND (<EMPTY? .L> .L) (ELSE (!<LPR <REST .L>> <1 .L>))>>

<SETG HACK-NODES [,ABS-CODE ,ARITH-CODE]>

<COND (<GASSIGNED? PUT-ANA> <PUTPROP ,PUT ANALYSIS ,PUT-ANA>)>

<DEFINE SAME-OBJ (N1 N2) 
	#DECL ((N1 N2) NODE)
	<COND (<==? <NODE-TYPE .N1> <NODE-TYPE .N2>>
	       <COND (<MEMQ <NODE-TYPE .N1> ,SNODES>
		      <==? <NODE-NAME .N1> <NODE-NAME .N2>>)
		     (ELSE
		      <MAPF <>
			    <FUNCTION (N3 N4) 
				    <COND (<SAME-OBJ .N3 .N4>)
					  (ELSE <MAPLEAVE <>>)>>
			    <KIDS .N1>
			    <KIDS .N2>>)>)>>

<DEFINE DECL-DOWN ("TUPLE" TUP "AUX" (ND <1 .TUP>) (LN <- <LENGTH .TUP> 1>)) 
	#DECL ((TUP) TUPLE (LN) FIX)
	<REPEAT ()
		<COND (<L? .LN 2> <RETURN .ND>)
		      (ELSE
		       <SET ND
			    <GET-ELE-TYPE .ND
					  <NTH .TUP <+ .LN 1>>
					  <==? <NTH .TUP .LN> REST>>>)>
		<SET LN <- .LN 2>>>>

<DEFINE DECL-UP (NX L) 
	#DECL ((L) LIST)
	<REPEAT ((FIRST T) (NUM 0))
		#DECL ((NUM) FIX (L) LIST)
		<COND (<EMPTY? .L> <RETURN .NX>)>
		<COND (<==? <1 .L> NTH>
		       <SET NX
			    <FORM STRUCTURED
				  !<COND (<0? <SET NUM <+ .NUM <2 .L> -1>>> ())
					 (<1? .NUM> (ANY))
					 (ELSE ([.NUM ANY]))>
				  .NX>>
		       <SET NUM 0>
		       <SET FIRST <>>)
		      (.FIRST <SET NX <REST-DECL .NX <2 .L>>>)
		      (ELSE <SET NUM <+ .NUM <2 .L>>>)>
		<SET L <REST .L 2>>>>

<DEFINE PUTREST-ANA (NOD RTYP "AUX" (K <KIDS .NOD>) T1 T2) 
	#DECL ((NOD) NODE (K) <LIST [REST NODE]>)
	<COND (<==? <NODE-SUBR .NOD> ,REST> <REST-ANA .NOD .RTYP>)
	      (<SEGFLUSH .NOD .RTYP>
	       <PUT .NOD ,SIDE-EFFECTS (.NOD !<SIDE-EFFECTS .NOD>)>
	       <TYPE-OK? '<PRIMTYPE LIST> .RTYP>)
	      (ELSE
	       <ARGCHK <LENGTH .K> 2 PUTREST .NOD>
	       <SET T1 <EANA <1 .K> '<PRIMTYPE LIST> PUTREST>>
	       <SET T2 <EANA <2 .K> '<PRIMTYPE LIST> PUTREST>>
	       <COND (<==? <NODE-TYPE <1 .K>> ,QUOTE-CODE>
		      <COMPILE-ERROR "Attempt to PUTREST in quoted object "
				     .NOD>)>
	       <PUT .NOD ,NODE-TYPE ,PUTR-CODE>
	       <PUT .NOD ,SIDE-EFFECTS (.NOD !<SIDE-EFFECTS .NOD>)>
	       <TYPE-OK? .T1 .RTYP>)>>

<COND (<GASSIGNED? PUTREST-ANA> <PUTPROP ,PUTREST ANALYSIS ,PUTREST-ANA>)>

<DEFINE MEMQ-ANA (N R "AUX" (K <KIDS .N>) TYP VTYP STYP ETY) 
   #DECL ((N) NODE (K) <LIST [REST NODE]>)
   <COND
    (<SEGFLUSH .N .R>)
    (ELSE
     <ARGCHK <LENGTH .K> 2 MEMQ .N>
     <SET VTYP <EANA <1 .K> ANY MEMQ>>
     <SET TYP <EANA <2 .K> STRUCTURED MEMQ>>
     <COND (<NOT <TYPE-OK? .VTYP <SET ETY <GET-ELE-TYPE .TYP ALL>>>>
	    <COMPILE-WARNING "MEMQ never true " .N>)>
     <COND (<AND <SET STYP <STRUCTYP .TYP>> <N==? .STYP TEMPLATE>>
	    <PUT .N ,NODE-TYPE ,MEMQ-CODE>)
	   (ELSE
	    <COND (.VERBOSE
		   <ADDVMESS .N
			     ("Not efficiently  open compiled because type is:  " .TYP)>)>
	    <PUT .N ,NODE-TYPE ,MEMQ-CODE>)>
     <TYPE-OK? <TYPE-MERGE BOOL-FALSE
			   <COND (<AND .ETY <N==? .ETY ANY>>
				  <FORM <COND (.STYP) (STRUCTURED)>
					.ETY
					[REST .ETY]>)
				 (.STYP <FORM .STYP ANY>)
				 ('<STRUCTURED ANY>)>>
	       .R>)>>

<DEFINE TOP-ANA (N R "AUX" (K <KIDS .N>)) 
	#DECL ((N) NODE (K) <LIST [REST NODE]>)
	<COND (<SEGFLUSH .N .R>)
	      (ELSE
	       <ARGCHK <LENGTH .K> 1 TOP .N>
	       <SET TYP <EANA <1 .K> STRUCTURED TOP>>
	       <COND (<AND <SET TYP <STRUCTYP .TYP>> <==? .TYP LIST>>
		      <COMPIL-ERROR "Cant TOP a list: " .N>)>
	       <PUT .N ,NODE-TYPE ,TOP-CODE>
	       <TYPE-OK? <COND (.TYP) (ELSE STRUCTURED)> .R>)>>

<DEFINE BACK-ANA (N R "AUX" (K <KIDS .N>)) 
	#DECL ((N) NODE (K) <LIST [REST NODE]>)
	<COND (<SEGFLUSH .N .R>)
	      (ELSE
	       <ARGCHK <LENGTH .K> '(1 2) BACK .N>
	       <SET TYP <EANA <1 .K> STRUCTURED TOP>>
	       <COND (<AND <SET TYP <STRUCTYP .TYP>> <==? .TYP LIST>>
		      <COMPIL-ERROR "Cant BACK a list: " .N>)>
	       <COND (<NOT <EMPTY? <REST .K>>> <EANA <2 .K> FIX BACK>)>
	       <PUT .N ,NODE-TYPE ,BACK-CODE>
	       <TYPE-OK? <COND (.TYP) (ELSE STRUCTURED)> .R>)>>

<COND (<GASSIGNED? BACK-ANA> <PUTPROP ,BACK ANALYSIS ,BACK-ANA>)>

<COND (<GASSIGNED? TOP-ANA> <PUTPROP ,TOP ANALYSIS ,TOP-ANA>)>

<COND (<GASSIGNED? MEMQ-ANA> <PUTPROP ,MEMQ ANALYSIS ,MEMQ-ANA>)>

<ENDPACKAGE>
