
<RPACKAGE "MACROS">

<ENTRY DO CASE INC DEC CHOP IF IF-NOT PRIMTYPE?>

;
"Sample DO usage
<DO ((X 1 10)
     \"UNTIL\" (<==? .Y STOP>
	      <ERROR EARLY-STOP>
	      #FALSE (\"NO-MORE\"))
     \"GEN\" (Z .FOO <REST .FOO .X> <EMPTY? .Z> <ERROR Z-RAN-OUT> T)
     \"EXTRA\" Y)
    <COND (<SET Y <NTH ,DATA .X>>
	   <PRINT .Y>)>
    <PRIN1 <1 .Z>>>
"

<DEFMAC DO ('ARGL
	    "ARGS" BODY
	    "AUX" (PRE-CODE ()) (POST-CODE ()) (PRE-TEST ()) (POST-TEST ())
		    (STATE ,COLON-FOR) (RETURNS ()))
	#DECL ((ARGL BODY) LIST (STATE) FIX (RETURNS) <SPECIAL LIST>
	       (POST-CODE PRE-TEST POST-TEST) <SPECIAL <LIST [REST <LIST ANY>]>>
	       (PRE-CODE) <SPECIAL LIST> (VALUE) FORM)
	<SET ARGL
	     <MAPF ,LIST
		   <FUNCTION (NAM) 
			   <COND (<TYPE? .NAM STRING>
				  <COND (<=? .NAM "FOR"> <SET STATE ,COLON-FOR>)
					(<=? .NAM "GEN"> <SET STATE ,COLON-GEN>)
					(<=? .NAM "WHILE">
					 <SET STATE ,COLON-WHILE>)
					(<=? .NAM "UNTIL">
					 <SET STATE ,COLON-UNTIL>)
					(<=? .NAM "VALUE">
					 <SET STATE ,COLON-VALUE>)
					(<OR <=? .NAM "AUX"> <=? .NAM "AUX">>
					 <SET STATE ,COLON-NONE>)
					(ELSE <SET STATE ,COLON-NONE> <MAPRET .NAM>)>)
				 (<==? .STATE ,COLON-NONE> <MAPRET .NAM>)
				 (ELSE
				  <COND (<NOT <TYPE? .NAM LIST>>
					 <SET NAM (.NAM)>)>
				  <CASE ,==? .STATE
					     (,COLON-FOR <MAPRET <DO-FOR !.NAM>>)
					     (,COLON-GEN <MAPRET <DO-GEN !.NAM>>)
					     (,COLON-WHILE <DO-WHILE !.NAM>)
					     (,COLON-UNTIL <DO-UNTIL !.NAM>)
					     (,COLON-VALUE <DO-VALUE !.NAM>)>)>
			   <MAPRET>>
		   .ARGL>>
	<SET RETURNS <COND-BODY '(<RETURN T>) .RETURNS>>
	<FORM REPEAT
	      .ARGL
	      !<MAPF ,LIST <FUNCTION (L)
				     #DECL ((L) <LIST ANY>)
				     <MAKE-COND <1 .L> .RETURNS <REST .L>>>
		     .PRE-CODE>					    ;"FOR tests"
	      !<MAPF ,LIST <FUNCTION (L)
				     #DECL ((L) <LIST ANY>)
				     <MAKE-COND <1 .L> .RETURNS <REST .L>>>
		     .PRE-TEST>					  ;"WHILE tests"
	      !.BODY
	      !<MAPF ,LIST <FUNCTION (L)
				     #DECL ((L) <LIST ANY>)
				     <MAKE-COND <1 .L> .RETURNS <REST .L>>>
		     .POST-TEST>				  ;"UNTIL tests"
	      !.POST-CODE					;"FOR updates">>


<AND? <SETG COLON-NONE 0>
      <SETG COLON-FOR 1>
      <SETG COLON-GEN 2>
      <SETG COLON-UNTIL 3>
      <SETG COLON-WHILE 4>
      <SETG COLON-VALUE 5>
      <MANIFEST COLON-NONE COLON-FOR COLON-GEN COLON-UNTIL COLON-WHILE COLON-VALUE>>
\ 

;"Generators for DO"

<DEFINE DO-FOR	       ;"Make a variable declaration and a test for FOR looping"
	(VARIABLE "OPTIONAL" (INITIAL 1) FINAL (STEP 1) "TUPLE" VAL)
	#DECL ((VAL) TUPLE (PRE-CODE POST-CODE) LIST) 
	<COND (<OR <NOT <ASSIGNED? FINAL>>
		   <==? .STEP 0>
		   <==? .STEP 0.0000000>>)
	      (<AND <TYPE? .STEP FIX FLOAT> <G? .STEP 0>>       ;"Stepping up ?"
	       <SET PRE-CODE
		    (!.PRE-CODE
		     (<FORM G? <FORM LVAL .VARIABLE> .FINAL> !.VAL))>)
	      (<AND <TYPE? .STEP FIX FLOAT> <L? .STEP 0>>     ;"Stepping down ?"
	       <SET PRE-CODE
		    (!.PRE-CODE
		     (<FORM L? <FORM LVAL .VARIABLE> .FINAL> !.VAL))>)
	      (ELSE			    ;"Assume unknown stepping direction"
	       <SET PRE-CODE
		    (!.PRE-CODE
		     (<FORM COND
			    (<FORM G? .STEP 0>
			     <FORM G? <FORM LVAL .VARIABLE> .FINAL>)
			    (<FORM L? .STEP 0>
			     <FORM L? <FORM LVAL .VARIABLE> .FINAL>)>
		      !.VAL))>)>
	<SET POST-CODE
	     (!.POST-CODE
	      <FORM SET .VARIABLE <FORM + <FORM LVAL .VARIABLE> .STEP>>)>
	(.VARIABLE .INITIAL)>

<DEFINE DO-GEN	       ;"Make a variable declaration and a test for FOR looping"
	(VARIABLE "OPTIONAL" (INITIAL ()) STEP PRED "TUPLE" VAL) 
	#DECL ((VARIABLE) ATOM (VAL) TUPLE (PRE-CODE POST-CODE) LIST)
	<COND (<ASSIGNED? PRED>
	       <SET PRE-CODE
		    (!.PRE-CODE (.PRED !.VAL))>)>
	<COND (<ASSIGNED? STEP>
	       <SET POST-CODE (!.POST-CODE <FORM SET .VARIABLE .STEP>)>)>
	(.VARIABLE .INITIAL)>

<DEFINE DO-WHILE (EXPR "TUPLE" VAL)	      ;"Make a test to do looping WHILE"
	#DECL ((VAL) TUPLE (PRE-TEST) LIST)
	<SET PRE-TEST
	     (!.PRE-TEST
	      (<FORM NOT .EXPR> !.VAL))>>

<DEFINE DO-UNTIL (EXPR "TUPLE" VAL)	      ;"Make a test to do looping UNTIL"
	#DECL ((VAL) TUPLE (POST-TEST) LIST)
	<SET POST-TEST
	     (!.POST-TEST (.EXPR !.VAL))>>

<DEFINE DO-VALUE ("TUPLE" BODY) 
	#DECL ((BODY) TUPLE (RETURNS) LIST)
	<COND (<NOT <EMPTY? .RETURNS>>
	       <ERROR TOO-MANY!-ERRORS "VALUE" DO>)
	      (ELSE <SET RETURNS (!.BODY)>)>>

<DEFINE MAKE-COND (PRED DEF BODY) 
	#DECL ((VALUE) <FORM ATOM LIST> (DEF BODY) LIST)
	<FORM COND (.PRED !<COND-BODY .DEF .BODY>)>>

<DEFINE COND-BODY (DEF BODY) 
	#DECL ((VALUE) LIST (DEF BODY) LIST)
	<COND (<EMPTY? .BODY> .DEF)
	      (ELSE
	       <SET DEF <REST .BODY <- <LENGTH .BODY> 1>>>
	       <PUT .DEF 1 <FORM RETURN <1 .DEF>>>
	       .BODY)>>

\ 

;
"Sample CASE usage
<CASE ,TYPE? <GET .FOO DATA>
      (ATOM <PRINT IDENTIFIER> 0)
      (FIX <PRINT INTEGER> 1)
      (FLOAT <PRINT REAL> 2)
      DEFAULT
      (<PRINT OTHER> 3)
      (!'(LIST VECTOR UVECTOR ,XTRA) <PRINT STRUCTURE> 4)
      (STRING <PRINT STRING> 5)>
"

<DEFMAC CASE ('PRED 'EXPR "ARGS" CASES "AUX" (DEFAULT-CASE <>)) 
   #DECL ((CASES) LIST (DEFAULT-CASE) <OR FALSE LIST> (VALUE) FORM)
   <COND (<AND <TYPE? .PRED FORM>
	       <==? <LENGTH .PRED> 2>
	       <==? <1 .PRED> GVAL>
	       <TYPE? <2 .PRED> ATOM>>
	  <SET PRED <2 .PRED>>)
	 (<TYPE? .PRED GVAL> <SET PRED <CHTYPE .PRED ATOM>>)>
   <FORM
    BIND
    ((OB .EXPR))
    <FORM
     COND
     !<MAPF ,LIST
       <FUNCTION (PHRASE "AUX" EXPR) 
	       <COND (<==? .PHRASE DEFAULT>
		      <COND (.DEFAULT-CASE
			     <ERROR TOO-MANY-DEFAULTS!-ERRORS CASE>)
			    (ELSE <SET DEFAULT-CASE ()>)>
		      <MAPRET>)
		     (<OR <NOT <TYPE? .PHRASE LIST>> <EMPTY? .PHRASE>>
		      <ERROR BAD-CLAUSE!-ERRORS CASE>)
		     (<AND .DEFAULT-CASE <EMPTY? .DEFAULT-CASE>>
		      <SET DEFAULT-CASE ((DEFAULT !.PHRASE))>
		      <MAPRET>)
		     (<NOT <TYPE? <SET EXPR <1 .PHRASE>> SEGMENT>>
		      (<FORM .PRED '.OB .EXPR> !<REST .PHRASE>))
		     (<EMPTY? .EXPR> (<FORM .PRED '.OB> !<REST .PHRASE>))
		     (<==? <1 .EXPR> QUOTE>
		      <COND (<OR <EMPTY? <REST .EXPR>>
				 <NOT <STRUCTURED? <2 .EXPR>>>>
			     <ERROR ILLEGAL-SEGMENT!-ERRORS CASE>)
			    (ELSE
			     (<DO-SEG .PRED (!<2 .EXPR>)> !<REST .PHRASE>))>)
		     (ELSE (<FORM .PRED '.OB .EXPR> !<REST .PHRASE>))>>
       .CASES>
     !.DEFAULT-CASE>>>

<DEFINE DO-SEG (PRED OPS) 
	#DECL ((OPS) LIST (VALUE) FORM)
	<COND (<OR <==? .PRED TYPE?> <==? .PRED PRIMTYPE?> <EMPTY? .OPS>>
	       <CHTYPE (.PRED '.OB !.OPS) FORM>)
	      (ELSE
	       <CHTYPE (OR
			!<MAPF ,LIST
			       <FUNCTION (X) <FORM .PRED '.OB .X>>
			       .OPS>)
		       FORM>)>>

\ 

<DEFMAC INC ('ATM "OPTIONAL" ('AMT 1)) 
	<FORM SET .ATM <FORM + <FORM LVAL .ATM> .AMT>>>

<DEFMAC DEC ('ATM "OPTIONAL" ('AMT 1)) 
	<FORM SET .ATM <FORM - <FORM LVAL .ATM> .AMT>>>

<DEFMAC CHOP ('ATM "OPTIONAL" ('AMT 1)) 
	<FORM SET .ATM <FORM REST <FORM LVAL .ATM> .AMT>>>

<DEFMAC IF ("ARGS" BODY) <FORM COND .BODY>>

<DEFMAC IF-NOT ('PRED "ARGS" BODY) <FORM COND (<FORM NOT .PRED> !.BODY)>>

<DEFMAC PRIMTYPE? ('EXPR "ARGS" BODY) 
	#DECL ((BODY) LIST)
	<COND (<EMPTY? .BODY>
	       <ERROR TOO-FEW-ARGUMENTS-SUPPLIED!-ERRORS PRIMTYPE?>)
	      (<EMPTY? <REST .BODY>>
	       <FORM ==? <FORM PRIMTYPE .EXPR> <1 .BODY>>)
	      (ELSE
	       <FORM PROG
		     ((OB <FORM PRIMTYPE .EXPR>))
		     #DECL ((OB) ATOM (VALUE) <OR FALSE ATOM>)
		     <FORM COND
			   (<CHTYPE (OR
				     !<MAPF ,LIST
					    <FUNCTION (X) <FORM ==? '.OB .X>>
					    .BODY>)
				    FORM>
			    '.OB)>>)>>

<ENDPACKAGE>
