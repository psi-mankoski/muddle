<DEFINE I$GET-PAGES (PAGLOC PAGES) T>

<DEFINE I$FLUSH-PAGES (PAGLOC PAGES "AUX" ERR)
	#DECL ((PAGES PAGLOC) FIX)
	<COND (<NOT <SET ERR <CALL SYSOP PMAP -1 <ORB ,M$$MY-PROC-LH .PAGLOC>
				   <ORB ,M$$SETZ .PAGES>>>>
	       <ERROR PMAP-FAILURE!-ERRORS .ERR>)
	      (ELSE .ERR)>>

<DEFINE I$ASK-SYSTEM-FOR-PAGES (PAGES PGTBL) <>>

