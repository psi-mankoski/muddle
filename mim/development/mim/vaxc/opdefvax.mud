
<MSETG BITS-PER-FIELD 8>

<MSETG FIELDS-PER-WORD 4>

<MSETG FIELDS-PER-OP <* ,FIELDS-PER-WORD 3>>

<MSETG WORDS-PER-OP 4>

<MSETG INIT-SHIFT <- <* ,BITS-PER-FIELD ,FIELDS-PER-WORD> ,BITS-PER-FIELD>>

<MSETG FIELD-MASK *377*>

<DEFINE DEFOP (STR CODE "TUPLE" MODES "AUX" STR-I (WD1 0) (SHFT ,INIT-SHIFT)) 
   #DECL ((STR STR-I) STRING (MODES) <TUPLE [REST FIX]> (CODE SHFT WD1) FIX)
   <MSETG <OR <LOOKUP <SET STR-I <STRING "INST-" .STR>> ,OP-OBLIST>
	      <INSERT .STR-I ,OP-OBLIST>>
	  .CODE>
   <PUT ,OP-VECTOR <SET CODE <+ <* .CODE ,WORDS-PER-OP> 1>> <SQUOZE .STR>>
   <SET WD1 <CHTYPE <LSH <LENGTH .MODES> .SHFT> FIX>>
   <MAPF <>
	 <FUNCTION (FLD) 
		 #DECL ((FLD) FIX)
		 <SET WD1
		      <CHTYPE <ORB .WD1
				   <LSH .FLD
					<SET SHFT <- .SHFT ,BITS-PER-FIELD>>>>
			      FIX>>
		 <COND (<0? .SHFT>
			<SET SHFT <+ ,INIT-SHIFT ,BITS-PER-FIELD>>
			<PUT ,OP-VECTOR <+ .CODE 1> .WD1>
			<SET WD1 0>
			<SET CODE <+ .CODE 1>>)>>
	 .MODES>
   <PUT ,OP-VECTOR <+ .CODE 1> .WD1>>

<DEFINE GET-INST-INFO (INST) #DECL ((INST) FIX)
	<REST ,OP-VECTOR <* .INST ,WORDS-PER-OP>>>

<DEFINE GET-OP-INFO (FNUM OP-INF "AUX" WD)
	#DECL ((WD FNUM) FIX (OP-INF) <UVECTOR [4 FIX]>)
	<COND (<G=? .FNUM <* 2 ,FIELDS-PER-WORD>>
	       <SET FNUM <- .FNUM <* 2 ,FIELDS-PER-WORD> 1>>
	       <SET WD <4 .OP-INF>>)
	      (<G=? .FNUM ,FIELDS-PER-WORD>
	       <SET FNUM <- .FNUM ,FIELDS-PER-WORD 1>>
	       <SET WD <3 .OP-INF>>)
	      (ELSE
	       <SET WD <2 .OP-INF>>
	       <SET FNUM <+ .FNUM 1>>)>
	<CHTYPE <ANDB <LSH .WD
			   <* <- .FNUM ,FIELDS-PER-WORD> ,BITS-PER-FIELD>>
		      ,FIELD-MASK> FIX>>

<DEFINE ADDRESS-MODES (MODES SIZES "AUX" (MODEN 0) (SIZEN 0))
	#DECL ((MODES SIZES) STRING (MODEN SIZEN) FIX)
	<MAPF <>
	      <FUNCTION (MODE)
		   <SET SIZEN 0>
		   <MAPF <>
			 <FUNCTION (SIZE "AUX" ST)
			      <MSETG <OR <LOOKUP <SET ST
						      <STRING "OP-" .MODE
							      .SIZE>>
						 ,OP-OBLIST>
					 <INSERT .ST ,OP-OBLIST>>
				     <+ <CHTYPE <LSH .MODEN 3> FIX> .SIZEN>>
			      <SET SIZEN <+ .SIZEN 1>>>
			 .SIZES>
		   <SET MODEN <+ .MODEN 1>>>
	      .MODES>
	<SET SIZEN -1>
	<MAPF <>
	      <FUNCTION (A "AUX" ST)
		   <MSETG <OR <LOOKUP <SET ST
					   <STRING "SZ-" .A>>
				      ,OP-OBLIST>
			      <INSERT .ST ,OP-OBLIST>>
			  <SET SIZEN <+ .SIZEN 1>>> > .SIZES>>

<SETG OP-OBLIST <OBLIST? DEFOP>>

<DEFINE INIT-OP-DEFS ()
	<SETG OP-VECTOR <IUVECTOR <* 256 ,WORDS-PER-OP> 0>>>

<GDECL (OP-VECTOR) <UVECTOR [REST FIX]>>

<MSETG SQUOZE-MULF <* 40 40 40 40 40>>

<DEFINE SQUOZE (STR "AUX" (VAL 0) (COUNT 6) C (TC 0) (MULF ,SQUOZE-MULF)) 
	#DECL ((VAL COUNT TC MULF) FIX (C) CHARACTER (STR) STRING)
	<REPEAT ()
		<COND (<OR <EMPTY? .STR> <L? .COUNT 1>> <RETURN .VAL>)>
		<SET TC <CHTYPE <SET C <1 .STR>> FIX>>
		<SET STR <REST .STR>>
		<COND (<AND <G=? .TC <ASCII !\0>> <L=? .TC <ASCII !\9>>>
		       <SET TC <- .TC 47>>)
		      (<AND <G=? .TC <ASCII !\A>> <L=? .TC <ASCII !\Z>>>
		       <SET TC <- .TC 54>>)
		      (<AND <G=? .TC <ASCII !\a>> <L=? .TC <ASCII !\z>>>
		       <SET TC <- .TC 86>>)
		      (<==? .C !\.> <SET TC 37>)
		      (<==? .C !\$> <SET TC 38>)
		      (<==? .C !\%> <SET TC 39>)
		      (T <AGAIN>)>
		<SET COUNT <- .COUNT 1>>
		<SET VAL <+ .VAL <* .TC .MULF>>>
		<SET MULF </ .MULF 40>>>>

<MSETG SQUOZE-DIVF <* 40 40 40 40 40>>

<DEFINE PRINT-SQUOZE (NUM
		      "OPTIONAL" (OUTCHAN .OUTCHAN)
		      "AUX" (DIVF ,SQUOZE-DIVF))
	#DECL ((NUM) FIX (OUTCHAN) <SPECIAL CHANNEL>)
	<REPEAT (VAL)
		<SET VAL <MOD </ .NUM .DIVF> 40>>
		<COND (<AND <L? .NUM 0> <G? .VAL 0>>
		       <SET VAL <+ .VAL 1>>
		       <SET NUM <- .NUM <* .VAL .DIVF>>>)>
		<COND (<0? .VAL> <RETURN>)
		      (<AND <G? .VAL 10> <L? .VAL 37>>
		       <PRINC <CHTYPE <+ .VAL 54> CHARACTER>>)
		      (<L=? .VAL 10> <PRINC <CHTYPE <+ .VAL 47> CHARACTER>>)
		      (<==? .VAL 37> <PRINC !\.>)
		      (<==? .VAL 38> <PRINC !\$>)
		      (<==? .VAL 39> <PRINC !\%>)>
		<COND (<1? .DIVF> <RETURN>)>
		<SET DIVF </ .DIVF 40>>>>