<PACKAGE "REHASH">

<ENTRY REHASH NEXT-PRIME>

<DEFINE REHASH (SIZ:FIX "AUX" (NT:VECTOR <IVECTOR .SIZ ()>)
	     (OT:VECTOR ,ATOM-TABLE))
   <MAPF <>
     <FUNCTION (L:LIST)
	<REPEAT (LL:LIST H:FIX)
	   <COND (<EMPTY? .L> <RETURN>)>
	   <SET LL <REST .L>>
	   <PUTREST .L ()>
	   <SET H <HASH-NAME <SPNAME <CHTYPE <1 .L> ATOM>> .SIZ>>
	   <PUT .NT .H <PUTREST .L <NTH .NT .H>>>
	   <SET L .LL>>>
     .OT>
   <SETG M$$OBLSIZ!-INTERNAL .SIZ>
   <SETG M$$OBLIST!-INTERNAL <SETG ATOM-TABLE .NT>>
   <CALL SETS OBLIST ,ATOM-TABLE>
   .SIZ>

<DEFINE NPRIME? (N) #DECL ((N) FIX)
	<REPEAT ((D 2) (SQ <FIX <+ <SQRT <FLOAT .N>> 1.0>>))
		<COND (<G? .D .SQ> <RETURN <>>)>
		<COND (<==? <MOD .N .D> 0> <RETURN .D>)>
		<SET D <+ .D 1>>>>

<DEFINE NEXT-PRIME (X) #DECL ((X) FIX)
	<REPEAT () <COND (<NOT <NPRIME? <SET X <+ .X 1>>>> <RETURN .X>)>>>

<ENDPACKAGE>
