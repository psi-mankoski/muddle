
<GDECL (FCODE-CHANNEL)
       <OR FALSE CHANNEL>
       (FCODE-BUFFER)
       UVECTOR
       (FCODE-BUFFER-PAGE FCODE-FILE-POINTER MAX-BUFFERS)
       FIX
       (FCODE-BUFFER-CHANGED?)
       BOOLEAN
       (FCODE-LIST)
       <LIST [REST <OR FIX CODEVEC>]>
       (FCURRENT-CODE)
       CODEVEC
       (FCODE-COUNT FCURRENT-WORD FBYTE-OFFSET FSHIFT)
       FIX>

<SETG MAX-BUFFERS 5>

<MSETG FCODEVEC-LENGTH <* ,CODEVEC-LENGTH 4>>

<DEFINE INIT-FINAL-CODE () 
	<SETG FCURRENT-CODE <IUVECTOR ,CODEVEC-LENGTH 0>>
	<SETG FCODE-LIST (,FCURRENT-CODE)>
	<SETG FCODE-CHANNEL <>>
	<SETG FCODE-BUFFER <IUVECTOR ,CODEVEC-LENGTH 0>>
	<SETG FCODE-BUFFER-PAGE -1>
	<SETG FCODE-FILE-POINTER 0>
	<SETG FCODE-COUNT 1>
	<SETG FCURRENT-WORD 0>
	<SETG FBYTE-OFFSET 1>
	<SETG FSHIFT 32>>

<DEFINE RESET-FCODE () 
	<REPEAT ()
		<COND (<TYPE? <1 ,FCODE-LIST> FIX>
		       <SETG FCODE-LIST <REST ,FCODE-LIST>>)
		      (<RETURN>)>>
	<SETG FCURRENT-CODE <1 ,FCODE-LIST>>
	<SETG FCODE-BUFFER-PAGE -1>
	<COND (,FCODE-CHANNEL <CLOSE ,FCODE-CHANNEL> <SETG FCODE-CHANNEL <>>)>
	<SETG FCODE-FILE-POINTER 0>
	<SETG FCODE-COUNT 1>
	<SETG FCURRENT-WORD 0>
	<SETG FBYTE-OFFSET 1>
	<SETG FSHIFT 32>>

<DEFINE OPEN-FCODE-FILE ("AUX" CH) 
	<COND (<NOT <SET CH
			 <CHANNEL-OPEN DISK "CACHE.FILE" "CREATE" "BINARY">>>
	       <ERROR <SYS-ERR "CACHE.FILE" .CH>>)>
	<SETG FCODE-CHANNEL .CH>
	T>

<DEFINE WRITE-FCODE (BUF PAGE "AUX" (CH ,FCODE-CHANNEL)) 
	#DECL ((BUF) UVECTOR (PAGE) FIX)
	<COND (<NOT ,FCODE-CHANNEL> <OPEN-FCODE-FILE>)>
	<SET CH ,FCODE-CHANNEL>
	<ACCESS .CH <* .PAGE ,CODEVEC-LENGTH>>
	<CHANNEL-OP .CH WRITE-BUFFER .BUF>
	T>

<DEFINE READ-FCODE (BUF PAGE "AUX" (CH ,FCODE-CHANNEL))
	<ACCESS .CH <* .PAGE ,CODEVEC-LENGTH>>
	<CHANNEL-OP .CH READ-BUFFER .BUF>> 

<DEFINE ADD-BYTE-TO-FCODE (BYT
			   "AUX" RLST (CCODE ,FCURRENT-CODE)
				 (CWORD ,FCURRENT-WORD) (OFF ,FBYTE-OFFSET)
				 (SHFT ,FSHIFT) COUNT)
	#DECL ((SHFT BYT) FIX)
	<COND (<G? <SET SHFT <- .SHFT 8>> 0>
	       <SETG FCURRENT-WORD <CHTYPE <ORB .CWORD <LSH .BYT .SHFT>> FIX>>)
	      (ELSE
	       <SET COUNT ,FCODE-COUNT>
	       <COND (<EMPTY? .CCODE>
		      <SET RLST
			   <REST ,FCODE-LIST <- </ .COUNT ,CODEVEC-LENGTH> 1>>>
		      <COND (<1? <LENGTH .RLST>>
			     <SET CCODE <NEW-FCODE-BUFFER>>)
			    (ELSE <SET CCODE <2 .RLST>>)>)>
	       <SET BYT <CHTYPE <ORB .CWORD .BYT> FIX>>
	       <PUT .CCODE 1 .BYT>
	       <SETG FCURRENT-CODE <REST .CCODE>>
	       <SETG FCODE-COUNT <+ .COUNT 1>>
	       <SETG FCURRENT-WORD 0>
	       <SET SHFT 32>)>
	<SETG FSHIFT .SHFT>
	<SETG FBYTE-OFFSET <+ .OFF 1>>
	.OFF>

<DEFINE NEW-FCODE-BUFFER ("AUX" (RLST ,FCODE-LIST) CCODE
				(BPAGE ,FCODE-FILE-POINTER))
	<COND (<G? <LENGTH .RLST> ,MAX-BUFFERS>
	       <MAPR <>
		     <FCN (BUFR "AUX" (BUF <1 .BUFR>))
			  <COND (<TYPE? .BUF UVECTOR>
				 <PUT .BUFR 1 .BPAGE>
				 <SET CCODE .BUF>
				 <MAPLEAVE>)>>
		     .RLST>
	       <WRITE-FCODE .CCODE .BPAGE>
	       <SETG FCODE-FILE-POINTER <+ .BPAGE 1>>
	       <PUTREST <REST .RLST <- <LENGTH .RLST> 1>> (.CCODE)>)
	      (ELSE
	       <SET CCODE <IUVECTOR ,CODEVEC-LENGTH 0>>
	       <PUTREST <REST .RLST <- <LENGTH .RLST> 1>> (.CCODE)>)>
	.CCODE>

<DEFINE PUT-FCODE (DEST VAL
		   "AUX" (CL ,FCODE-LIST) (OFF ,FBYTE-OFFSET)
			 (CWORD ,FCURRENT-WORD) (SHFT ,FSHIFT))
   #DECL ((DEST VAL SHFT) FIX (CL) LIST)
   <COND (<AND <==? </ <+ .OFF 2> 4> </ <+ .DEST 3> 4>> <N==? .SHFT 32>>
	  <SETG FCURRENT-WORD
		<CHTYPE <PUTBITS .CWORD
				 <BITS 8
				       <NTH '![24 16 8 0!]
					    <+ <MOD <+ .DEST 3> 4> 1>>>
				 .VAL>
			FIX>>)
	 (ELSE
	  <REPEAT ((PTR .DEST) WD CCODE)
		  #DECL ((CCODE) UVECTOR)
		  <COND (<L=? .PTR ,FCODEVEC-LENGTH>
			 <SET OFF </ <+ .PTR 3> 4>>
			 <SET SHFT
			      <NTH '![24 16 8 0!] <+ <MOD <+ .PTR 3> 4> 1>>>
			 <COND (<TYPE? <1 .CL> UVECTOR> <SET CCODE <1 .CL>>)
			       (<SET CCODE <GET-FCODE-BUFFER <1 .CL> WRITE>>)>
			 <SET WD
			      <PUTBITS <NTH .CCODE .OFF> <BITS 8 .SHFT> .VAL>>
			 <PUT .CCODE .OFF .WD>
			 <RETURN>)>
		  <COND (<EMPTY? <SET CL <REST .CL>>>
			 <ERROR OUT-OF-BOUNDS PUT-FCODE>)>
		  <SET PTR <- .PTR ,FCODEVEC-LENGTH>>>)>>

<DEFINE NTH-FCODE (DEST
		   "AUX" (CL ,FCODE-LIST) VAL (OFF ,FBYTE-OFFSET)
			 (CWORD ,FCURRENT-WORD) (SHFT ,FSHIFT))
   #DECL ((DEST) FIX (CL) LIST)
   <COND (<AND <==? </ <+ .OFF 2> 4> </ <+ .DEST 3> 4>> <N==? .SHFT 32>>
	  <CHTYPE <GETBITS .CWORD
			   <BITS 8
				 <NTH '![24 16 8 0!]
				      <+ <MOD <+ .DEST 3> 4> 1>>>>
		  FIX>)
	 (ELSE
	  <REPEAT ((PTR .DEST) CCODE)
		  #DECL ((CCODE) UVECTOR)
		  <COND (<L=? .PTR ,FCODEVEC-LENGTH>
			 <SET OFF </ <+ .PTR 3> 4>>
			 <SET SHFT
			      <NTH '![24 16 8 0!] <+ <MOD <+ .PTR 3> 4> 1>>>
			 <COND (<TYPE? <1 .CL> UVECTOR> <SET CCODE <1 .CL>>)
			       (<SET CCODE <GET-FCODE-BUFFER <1 .CL> READ>>)>
			 <SET VAL
			      <CHTYPE <GETBITS <NTH .CCODE .OFF>
					       <BITS 8 .SHFT>>
				      FIX>>
			 <RETURN .VAL>)>
		  <COND (<EMPTY? <SET CL <REST .CL>>>
			 <ERROR OUT-OF-BOUNDS .DEST NTH-FCODE>)>
		  <SET PTR <- .PTR ,FCODEVEC-LENGTH>>>)>>

<DEFINE GET-FCODE-BUFFER (PAGE MODE) 
	#DECL ((PAGE) FIX (MODE) ATOM)
	<COND (<==? .PAGE ,FCODE-BUFFER-PAGE>
	       <AND <==? .MODE WRITE> <SETG FCODE-BUFFER-CHANGED? T>>)
	      (ELSE
	       <COND (<AND <G=? ,FCODE-BUFFER-PAGE 0> ,FCODE-BUFFER-CHANGED?>
		      <WRITE-FCODE ,FCODE-BUFFER ,FCODE-BUFFER-PAGE>)>
	       <READ-FCODE ,FCODE-BUFFER .PAGE>
	       <SETG FCODE-BUFFER-PAGE .PAGE>
	       <COND (<==? .MODE READ> <SETG FCODE-BUFFER-CHANGED? <>>)
		     (ELSE <SETG FCODE-BUFFER-CHANGED? T>)>)>
	,FCODE-BUFFER>

<DEFINE ADVANCE-FCODE (NUM) 
	#DECL ((NUM) FIX)
	<REPEAT ()
		<ADD-BYTE-TO-FCODE .NUM>
		<COND (<0? <SET NUM <- .NUM 1>>> <RETURN>)>>>