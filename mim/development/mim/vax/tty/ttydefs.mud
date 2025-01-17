; "TTYCHARS, SGTTY, TTYDEV, AND IOCTL.H"
<BLOCK (<ROOT>)>
<USE "NEWSTRUC">

<MSETG CHAR-SIZE 1>
<MSETG INT-SIZE 4>
<MSETG TCHARS-SIZE 6>
<MSETG LTCHARS-SIZE 6>
<MSETG TTYCHARS-SIZE 14>
<MSETG SGTTYB-SIZE 6>

<MSETG SG-ISPEED 1>
<MSETG SG-OSPEED 2>
<MSETG SG-ERASE 3>
<MSETG SG-KILL 4>
<MSETG SG-FLAGS 5>

"Terminal speeds"
<MSETG B0	0>
<MSETG B50	1>
<MSETG B75	2>
<MSETG B110	3>
<MSETG B134	4>
<MSETG B150	5>
<MSETG B200	6>
<MSETG B300	7>
<MSETG B600	8>
<MSETG B1200	9>
<MSETG B1800	10>
<MSETG B2400	11>
<MSETG B4800	12>
<MSETG B9600	13>
<MSETG EXTA	14>
<MSETG EXTB	15>


"ttychars offsets (don't seem to be any ioctls to play with these"
<MSETG TC-ERASE 1>
<MSETG TC-KILL 2>
<MSETG TC-INTRC 3>
<MSETG TC-QUITC 4>
<MSETG TC-STARTC 5>
<MSETG TC-STOPC 6>
<MSETG TC-EOFC 7>
<MSETG TC-BRKC 8>
<MSETG TC-SUSPC 9>
<MSETG TC-DSUSPC 10>
<MSETG TC-RPRNTC 11>
<MSETG TC-FLUSHC 12>
<MSETG TC-WERASC 13>
<MSETG TC-LNEXTC 14>

"TCHARS OFFSETS"
<MSETG T-INTRC 1>	; "INTERRUPT "
<MSETG T-QUITC 2>	; "QUIT "
<MSETG T-STARTC 3>	; "START OUTPUT "
<MSETG T-STOPC 4>	; "STOP OUTPUT "
<MSETG T-EOFC 5>	; "END-OF-FILE "
<MSETG T-BRKC 6>	; "INPUT DELIMITER (LIKE NL) "

"LTCHARS OFFSETS"
<MSETG T-SUSPC 1>	; "STOP PROCESS SIGNAL "
<MSETG T-DSUSPC 2>	; "DELAYED STOP PROCESS SIGNAL "
<MSETG T-RPRNTC 3>	; "REPRINT LINE "
<MSETG T-FLUSHC 4>	; "FLUSH OUTPUT (TOGGLES) "
<MSETG T-WERASC 5>	; "WORD ERASE "
<MSETG T-LNEXTC 6>	; "LITERAL NEXT CHARACTER "

<MSETG LTCHAR-DEFAULTS <STRING <ASCII 26> ;"Char Cntl-Z"
			      <ASCII 25> ;"Char Cntl-Y"
			      <ASCII 18> ;"Char Cntl-R"
			      <ASCII 15> ;"Char Cntl-O"
			      <ASCII 23> ;"Char Cntl-W"
			      <ASCII 22> ;"Char Cntl-V">>

<MSETG TCHAR-DEFAULTS <STRING <ASCII 7> ;"Char Bell"
			     <ASCII 1> ;"Char Cntl-A"
			     <ASCII 19> ;"Char Cntl-S"
			     <ASCII 17> ;"Char Cntl-Q"
			     <ASCII 4> ;"Char Cntl-D"
			     <CHTYPE -1 CHARACTER>>>

<COND (<NOT <GASSIGNED? HEX>>
<DEFINE HEX (FROB)
  #DECL ((FROB) STRING)
  <REPEAT ((NUM 0) DIG BAS)
    #DECL ((NUM) FIX)
    <COND (<EMPTY? .FROB>
	   <RETURN .NUM>)>
    <COND (<AND <G=? <ASCII <SET DIG <1 .FROB>>>
		     <ASCII !\0>>
		<L=? <ASCII .DIG> <ASCII !\9>>>
	   <SET NUM <+ <* .NUM 16>
		       <- <ASCII .DIG> <ASCII !\0>>>>)
	  (<OR <AND <G=? <ASCII .DIG> <ASCII !\A>>
		    <L=? <ASCII .DIG> <ASCII !\F>>
		    <SET BAS !\A>>
	       <AND <G=? <ASCII .DIG> <ASCII !\a>>
		    <L=? <ASCII .DIG> <ASCII !\f>>
		    <SET BAS !\a>>>
	   <SET NUM <+ <* .NUM 16>
		       <+ 10 <- <ASCII .DIG> <ASCII .BAS>>>>>)
	  (<RETURN #FALSE ("ILLEGAL DIGIT")>)>
    <SET FROB <REST .FROB>>>>)>

; "IOCTL'S HAVE THE COMMAND ENCODED IN THE LOWER WORD,
   AND THE SIZE OF ANY IN OR OUT PARAMETERS IN THE UPPER
   WORD.  THE HIGH 2 BITS OF THE UPPER WORD ARE USED
   TO ENCODE THE IN/OUT STATUS OF THE PARAMETER; FOR NOW
   WE RESTRICT PARAMETERS TO AT MOST 128 BYTES."
<MSETG IOCPARM-MASK <HEX "7F">> 	; "PARAMETERS MUST BE < 128 BYTES "
<MSETG IOC-VOID <HEX "20000000">>	; "NO PARAMETERS "
<MSETG IOC-OUT  <HEX "40000000">>	; "COPY OUT PARAMETERS "
<MSETG IOC-IN  <HEX "80000000">>	; "COPY IN PARAMETERS "
<MSETG IOC-INOUT <ORB ,IOC-IN ,IOC-OUT>>
; "THE <HEX "20000000"> IS SO WE CAN DISTINGUISH NEW IOCTL'S FROM OLD "
<DEFINE SIZEOF (FROB)
  <COND (<==? .FROB CHAR> ,CHAR-SIZE)
	(<==? .FROB INT> ,INT-SIZE)
	(<==? .FROB TCHARS> ,TCHARS-SIZE)
	(<==? .FROB LTCHARS> ,LTCHARS-SIZE)
	(<==? .FROB TTYCHARS> ,TTYCHARS-SIZE)
	(<==? .FROB SGTTYB> ,SGTTYB-SIZE)>>

<DEFINE -IO (X Y) <CHTYPE <ORB ,IOC-VOID <LSH .X 8> .Y> FIX>>
<DEFINE -IOR (X Y T) <CHTYPE <ORB ,IOC-OUT <LSH <ANDB <SIZEOF .T>
						      ,IOCPARM-MASK> 16>
				  <LSH .X 8> .Y> FIX>>
<DEFINE -IOW (X Y T) <CHTYPE <ORB ,IOC-IN <LSH <ANDB <SIZEOF .T> ,IOCPARM-MASK>
					       16>
				  <LSH .X 8> .Y> FIX>>
<DEFINE -IOWR (X Y T) <CHTYPE <ORB ,IOC-INOUT
				   <LSH <ANDB <SIZEOF .T> ,IOCPARM-MASK> 16>
				   <LSH .X 8> .Y> FIX>>

; "TTY IOCTL COMMANDS"
<MSETG TIOCGETD <-IOR !\t 0 INT>> 	; "GET LINE DISCIPLINE "
<MSETG TIOCSETD <-IOW !\t 1 INT>> 	; "SET LINE DISCIPLINE "
<MSETG TIOCHPCL <-IO !\t 2>> 	; "HANG UP ON LAST CLOSE "
<MSETG TIOCMODG <-IOR !\t 3 INT>> 	; "GET MODEM CONTROL STATE "
<MSETG TIOCMODS <-IOW !\t 4 INT>> 	; "SET MODEM CONTROL STATE "
<MSETG  TIOCM-LE *0001*> 	; "LINE ENABLE "
<MSETG  TIOCM-DTR *0002*> 	; "DATA TERMINAL READY "
<MSETG  TIOCM-RTS *0004*> 	; "REQUEST TO SEND "
<MSETG  TIOCM-ST *0010*> 	; "SECONDARY TRANSMIT "
<MSETG  TIOCM-SR *0020*> 	; "SECONDARY RECEIVE "
<MSETG  TIOCM-CTS *0040*> 	; "CLEAR TO SEND "
<MSETG  TIOCM-CAR *0100*> 	; "CARRIER DETECT "
<MSETG  TIOCM-CD TIOCM-CAR>
<MSETG  TIOCM-RNG *0200*> 	; "RING "
<MSETG  TIOCM-RI TIOCM-RNG>
<MSETG  TIOCM-DSR *0400*> 	; "DATA SET READY "
<MSETG TIOCGETP <-IOR !\t 8 SGTTYB>>; "GET PARAMETERS -- GTTY "
<MSETG TIOCSETP <-IOW !\t 9 SGTTYB>>; "SET PARAMETERS -- STTY "
<MSETG TIOCSETN <-IOW !\t 10 SGTTYB>>; "AS ABOVE BUT NO FLUSHTTY "
<MSETG TIOCEXCL <-IO !\t 13>> 	; "SET EXCLUSIVE USE OF TTY "
<MSETG TIOCNXCL <-IO !\t 14>> 	; "RESET EXCLUSIVE USE OF TTY "
<MSETG TIOCFLUSH <-IOW !\t 16 INT>>	; "FLUSH BUFFERS "
<MSETG TIOCSETC <-IOW !\t 17 TCHARS>>; "SET SPECIAL CHARACTERS "
<MSETG TIOCGETC <-IOR !\t 18 TCHARS>>; "GET SPECIAL CHARACTERS "
<MSETG  TANDEM  <HEX "00000001">>	; "SEND STOPC ON OUT Q FULL "
<MSETG  CBREAK  <HEX "00000002">>	; "HALF-COOKED MODE "
<MSETG  LCASE  <HEX "00000004">>	; "SIMULATE LOWER CASE "
<MSETG  ECHO  <HEX "00000008">>	; "ECHO INPUT "
<MSETG  CRMOD  <HEX "00000010">>	; "MAP \R TO \R\N ON OUTPUT "
<MSETG  RAW  <HEX "00000020">>	; "NO I/O PROCESSING "
<MSETG  ODDP  <HEX "00000040">>	; "GET/SEND ODD PARITY "
<MSETG  EVENP  <HEX "00000080">>	; "GET/SEND EVEN PARITY "
<MSETG  ANYP  <HEX "000000C0">>	; "GET ANY PARITY/SEND NONE "
<MSETG  NLDELAY  <HEX "00000300">>	; "\N DELAY "
<MSETG   NL0 <HEX "00000000">>
<MSETG   NL1 <HEX "00000100">>	; "TTY 37 "
<MSETG   NL2 <HEX "00000200">>	; "VT05 "
<MSETG   NL3 <HEX "00000300">>
<MSETG  TBDELAY  <HEX "00000C00">>	; "HORIZONTAL TAB DELAY "
<MSETG   TAB0 <HEX "00000000">>
<MSETG   TAB1 <HEX "00000400">>	; "TTY 37 "
<MSETG   TAB2 <HEX "00000800">>
<MSETG  XTABS  <HEX "00000C00">>	; "EXPAND TABS ON OUTPUT "
<MSETG  CRDELAY  <HEX "00003000">>	; "\R DELAY "
<MSETG   CR0 <HEX "00000000">>
<MSETG   CR1 <HEX "00001000">>	; "TN 300 "
<MSETG   CR2 <HEX "00002000">>	; "TTY 37 "
<MSETG   CR3 <HEX "00003000">>	; "CONCEPT 100 "
<MSETG  VTDELAY  <HEX "00004000">>	; "VERTICAL TAB DELAY "
<MSETG   FF0 <HEX "00000000">>
<MSETG   FF1 <HEX "00004000">>	; "TTY 37 "
<MSETG  BSDELAY  <HEX "00008000">>	; "\B DELAY "
<MSETG   BS0 <HEX "00000000">>
<MSETG   BS1 <HEX "00008000">>
<MSETG  ALLDELAY <CHTYPE <ORB ,NLDELAY ,TBDELAY ,CRDELAY ,VTDELAY ,BSDELAY> FIX>>
<MSETG  CRTBS  <HEX "00010000">>	; "DO BACKSPACING FOR CRT "
<MSETG  PRTERA  <HEX "00020000">>	; "\ ... / ERASE "
<MSETG  CRTERA  <HEX "00040000">>	; "" \B " TO WIPE OUT CHAR "
<MSETG  TILDE  <HEX "00080000">>	; "HAZELTINE TILDE KLUDGE "
<MSETG  MDMBUF  <HEX "00100000">>	; "START/STOP OUTPUT ON CARRIER INTR "
<MSETG  LITOUT  <HEX "00200000">>	; "LITERAL OUTPUT "
<MSETG  TOSTOP  <HEX "00400000">>	; "SIGSTOP ON BACKGROUND OUTPUT "
<MSETG  FLUSHO  <HEX "00800000">>	; "FLUSH OUTPUT TO TERMINAL "
<MSETG  NOHANG  <HEX "01000000">>	; "NO SIGHUP ON CARRIER DROP "
<MSETG  L001000  <HEX "02000000">>
<MSETG  CRTKIL  <HEX "04000000">>	; "KILL LINE WITH " \B " "
<MSETG  L004000  <HEX "08000000">>
<MSETG  CTLECH  <HEX "10000000">>	; "ECHO CONTROL CHARS AS ^X "
<MSETG  PENDIN  <HEX "20000000">>	; "TP->T-RAWQ NEEDS REREAD "
<MSETG  DECCTQ  <HEX "40000000">>	; "ONLY ^Q STARTS AFTER ^S "
<MSETG  NOFLSH  <HEX "80000000">>	; "NO OUTPUT FLUSH ON SIGNAL "
; "LOCALS FROM 127 DOWN "
<MSETG TIOCLBIS <-IOW !\t 127 INT>>	; "BIS LOCAL MODE BITS "
<MSETG TIOCLBIC <-IOW !\t 126 INT>>	; "BIC LOCAL MODE BITS "
<MSETG TIOCLSET <-IOW !\t 125 INT>>	; "SET ENTIRE LOCAL MODE WORD "
<MSETG TIOCLGET <-IOR !\t 124 INT>>	; "GET LOCAL MODES "
<MSETG  LCRTBS  <LSH ,CRTBS 16>>
<MSETG  LPRTERA <LSH ,PRTERA 16>>
<MSETG  LCRTERA <LSH ,CRTERA 16>>
<MSETG  LTILDE <LSH ,TILDE 16>>
<MSETG  LMDMBUF <LSH ,MDMBUF 16>>
<MSETG  LLITOUT <LSH ,LITOUT 16>>
<MSETG  LTOSTOP <LSH ,TOSTOP 16>>
<MSETG  LFLUSHO <LSH ,FLUSHO 16>>
<MSETG  LNOHANG <LSH ,NOHANG 16>>
<MSETG  LCRTKIL <LSH ,CRTKIL 16>>
<MSETG  LCTLECH <LSH ,CTLECH 16>>
<MSETG  LPENDIN <LSH ,PENDIN 16>>
<MSETG  LDECCTQ <LSH ,DECCTQ 16>>
<MSETG  LNOFLSH <LSH ,NOFLSH 16>>
<MSETG TIOCSBRK <-IO !\t 123>> 	; "SET BREAK BIT "
<MSETG TIOCCBRK <-IO !\t 122>> 	; "CLEAR BREAK BIT "
<MSETG TIOCSDTR <-IO !\t 121>> 	; "SET DATA TERMINAL READY "
<MSETG TIOCCDTR <-IO !\t 120>> 	; "CLEAR DATA TERMINAL READY "
<MSETG TIOCGPGRP <-IOR !\t 119 INT>>	; "GET PGRP OF TTY "
<MSETG TIOCSPGRP <-IOW !\t 118 INT>>	; "SET PGRP OF TTY "
<MSETG TIOCSLTC <-IOW !\t 117 LTCHARS>>; "SET LOCAL SPECIAL CHARS "
<MSETG TIOCGLTC <-IOR !\t 116 LTCHARS>>; "GET LOCAL SPECIAL CHARS "
<MSETG TIOCOUTQ <-IOR !\t 115 INT>>	; "OUTPUT QUEUE SIZE "
<MSETG TIOCSTI  <-IOW !\t 114 CHAR>>	; "SIMULATE TERMINAL INPUT "
<MSETG TIOCNOTTY <-IO !\t 113>> 	; "VOID TTY ASSOCIATION "
<MSETG TIOCPKT  <-IOW !\t 112 INT>>	; "PTY: SET/CLEAR PACKET MODE "
<MSETG  TIOCPKT-DATA  <HEX "00">>	; "DATA PACKET "
<MSETG  TIOCPKT-FLUSHREAD <HEX "01">>	; "FLUSH PACKET "
<MSETG  TIOCPKT-FLUSHWRITE <HEX "02">>	; "FLUSH PACKET "
<MSETG  TIOCPKT-STOP  <HEX "04">>	; "STOP OUTPUT "
<MSETG  TIOCPKT-START  <HEX "08">>	; "START OUTPUT "
<MSETG  TIOCPKT-NOSTOP  <HEX "10">>	; "NO MORE ^S,^Q "
<MSETG  TIOCPKT-DOSTOP  <HEX "20">>	; "NOW DO ^S ^Q "
<MSETG TIOCSTOP <-IO !\t 111>> 	; "STOP OUTPUT LIKE ^S "
<MSETG TIOCSTART <-IO !\t 110>> 	; "START OUTPUT LIKE ^Q "
<MSETG TIOCMSET <-IOW !\t 109 INT>>	; "SET ALL MODEM BITS "
<MSETG TIOCMBIS <-IOW !\t 108 INT>>	; "BIS MODEM BITS "
<MSETG TIOCMBIC <-IOW !\t 107 INT>>	; "BIC MODEM BITS "
<MSETG TIOCMGET <-IOR !\t 106 INT>>	; "GET ALL MODEM BITS "
<MSETG TIOCREMOTE <-IO !\t 105>> 	; "REMOTE INPUT EDITING "

<MSETG OTTYDISC *0*> 	; "OLD V7 STD TTY DRIVER "
<MSETG NETLDISC 1> 	; "LINE DISCIP FOR BERK NET "
<MSETG NTTYDISC 2> 	; "NEW TTY DISCIPLINE "
<MSETG TABLDISC 3> 	; "HITACHI TABLET DISCIPLINE "
<MSETG NTABLDISC 4> 	; "GTCO TABLET DISCIPLINE "

<MSETG FIOCLEX  <-IO !\f 1>> 	; "SET EXCLUSIVE USE ON FD "
<MSETG FIONCLEX <-IO !\f 2>> 	; "REMOVE EXCLUSIVE USE "
; "ANOTHER LOCAL "
<MSETG FIONREAD <-IOR !\f 127 INT>>	; "GET # BYTES TO READ "
<MSETG FIONBIO  <-IOW !\f 126 INT>>	; "SET/CLEAR NON-BLOCKING I/O "
<MSETG FIOASYNC <-IOW !\f 125 INT>>	; "SET/CLEAR ASYNC I/O "
<MSETG FIOSETOWN <-IOW !\f 124 INT>>	; "SET OWNER "
<MSETG FIOGETOWN <-IOR !\f 123 INT>>	; "GET OWNER "

; "SOCKET I/O CONTROLS "
<MSETG SIOCSHIWAT <-IOW !\s 0 INT>> 	; "SET HIGH WATERMARK "
<MSETG SIOCGHIWAT <-IOR !\s 1 INT>> 	; "GET HIGH WATERMARK "
<MSETG SIOCSLOWAT <-IOW !\s 2 INT>> 	; "SET LOW WATERMARK "
<MSETG SIOCGLOWAT <-IOR !\s 3 INT>> 	; "GET LOW WATERMARK "
<MSETG SIOCATMARK <-IOR !\s 7 INT>> 	; "AT OOB MARK? "
<MSETG SIOCSPGRP <-IOW !\s 8 INT>> 	; "SET PROCESS GROUP "
<MSETG SIOCGPGRP <-IOR !\s 9 INT>> 	; "GET PROCESS GROUP "

;<MSETG SIOCADDRT <-IOW !\r 10 RTENTRY>>	; "ADD ROUTE "
;<MSETG SIOCDELRT <-IOW !\r 11 RTENTRY>>	; "DELETE ROUTE "

;<MSETG SIOCSIFADDR <-IOW !\i 12 IFREQ>>	; "SET IFNET ADDRESS "
;<MSETG SIOCGIFADDR <-IOWR !\i 13 IFREQ>>	; "GET IFNET ADDRESS "
;<MSETG SIOCSIFDSTADDR <-IOW !\i 14 IFREQ>>	; "SET P-P ADDRESS "
;<MSETG SIOCGIFDSTADDR <-IOWR !\i 15 IFREQ>>	; "GET P-P ADDRESS "
;<MSETG SIOCSIFFLAGS <-IOW !\i 16 IFREQ>>	; "SET IFNET FLAGS "
;<MSETG SIOCGIFFLAGS <-IOWR !\i 17 IFREQ>>	; "GET IFNET FLAGS "
;<MSETG SIOCGIFCONF <-IOWR !\i 20 IFCONF>>	; "GET IFNET LIST "

<ENDBLOCK>
