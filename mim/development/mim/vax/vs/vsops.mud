<DEFINITIONS "VSOPS">

<INCLUDE "VSDEFS" "VSTYPES">

<USE "NEWSTRUC" "VSBASE">

<GDECL (OPLIST) <LIST [REST ATOM OP]>>

<NEWSTRUC OP VECTOR
	  OP-NAME ATOM
	  OP-CODE FIX
	  OP-REPLY? <OR ATOM FALSE>
	  OP-ARGS <VECTOR [REST ANY]>
	  OP-STUFF? <OR ATOM FALSE>
	  OP-FORCE? <OR ATOM FALSE>>

<SETG OPLIST ()>

<DEFINE COP ("TUPLE" STUFF "AUX" (REPLY?:<SPECIAL ATOM> STRING))
   <OP !.STUFF>>

<DEFINE FOP ("TUPLE" STUFF "AUX" (FORCE?:<SPECIAL ATOM> T))
   <OP !.STUFF>>

<DEFINE SOP (NAME CODE REPLY?:<SPECIAL ATOM> "TUPLE" STUFF)
   <OP .NAME .CODE !.STUFF>>

<DEFINE ROP ("TUPLE" STUFF "AUX" (REPLY?:<SPECIAL ATOM> T))
   <OP !.STUFF>>

<MSETG ARG-FUNC 1>
<MSETG ARG-WINDOW 2>
<NEWTYPE LONG FIX>
<NEWTYPE SHORT FIX>
<NEWTYPE BYTE FIX>
<NEWTYPE COUNT-STRING FIX>
<NEWTYPE COUNT FIX>
<MSETG SEND-PACKET-WORD-LENGTH 6>

<DEFINE OP (NAME CODE "TUPLE" ARGDESC "AUX" (REPLY? <AND <ASSIGNED? REPLY?>
							 .REPLY?>)
	    (FORCE? <AND <ASSIGNED? FORCE?> .FORCE?>)
	    (SCT 0) (STUFF? <>) (STYPE <>) AVEC)
  <MSETG .NAME .CODE>
  <SET AVEC
       <MAPF ,VECTOR
	<FUNCTION (X "AUX" NUM)
	   <COND (<==? .X F>
		  ,ARG-FUNC)
		 (<==? .X W>
		  ,ARG-WINDOW)
		 (<MEMQ .X '[B S L CS CB]>
		  <COND (<==? .X L> 
			 <COND (<NOT <0? <MOD .SCT 4>>>
				<SET SCT <* </ <+ .SCT 4> 4> 4>>)>
			 <SET NUM <CHTYPE </ .SCT 4> LONG>>
			 <SET SCT <+ .SCT 4>>)
			(<==? .X B>
			 <SET NUM <CHTYPE .SCT BYTE>>
			 <SET SCT <+ .SCT 1>>)
			(T
			 <COND (<NOT <0? <MOD .SCT 2>>>
				<SET SCT <+ .SCT 1>>)>
			 <SET NUM <CHTYPE </ .SCT 2> SHORT>>
			 <SET SCT <+ .SCT 2>>)>
		  <COND (<MEMQ .X '[CS CB]>
			 <COND (<==? .X CS>
				<SET NUM <CHTYPE .NUM COUNT-STRING>>)
			       (T
				<SET NUM <CHTYPE .NUM COUNT>>)>
			 <SET STUFF? T>)>
		  .NUM)
		 (<==? .X STUFF>
		  <SET STUFF? T>
		  <MAPRET>)>>
	.ARGDESC>>
  <SETG OPLIST (.NAME <CHTYPE [.NAME .CODE .REPLY? .AVEC .STUFF? .FORCE?] OP>
		!,OPLIST)>>

<COND
 (<GASSIGNED? OP>
  <SOP X-OPEN-WINDOW 1 LONG F W S S S S L L>
  <FOP X-MAP-WINDOW 2 W>
  <FOP X-UNMAP-WINDOW 3 W>
  <FOP X-MOVE-WINDOW 4 W S S>
  <FOP X-CHANGE-WINDOW 5 W S S>
  <FOP X-DESTROY-WINDOW 6 W>
  <ROP X-QUERY-WINDOW 7 W>
  <FOP X-RAISE-WINDOW 8 W>
  <FOP X-LOWER-WINDOW 9 W>
  <FOP X-CIRC-WINDOW 10 W>
  <FOP X-DESTROY-SUBWINDOWS 11 W>
  <FOP X-CHANGE-COLOR 12 W L L>
  <FOP X-CONFIGURE-WINDOW 13 W S S S S>
  <SOP X-OPEN-TRANSPARENCY 14 LONG W S S S S>
  <OP X-STORE-NAME 15 W CS>
  <COP X-FETCH-NAME 16 W>
  <OP X-SET-RESIZE-HINT 17 W S S S S>
  <ROP X-GET-RESIZE-HINT 18 W>
  <OP X-UNMAP-TRANSPARENT 19 W>
  <FOP X-REGISTER-CURSOR 30 F W L L B B B B>
  <FOP X-UNREGISTER-CURSOR 31 W>
  <ROP X-QUERY-MOUSE 32 W>
  <FOP X-SELECT-INPUT 50 F W>
  <ROP X-INTERPRET-LOCATOR 51 W L>
  <SOP X-GRAB-MOUSE 53 ERROR F W L L B B B B S>
  <SOP X-FOCUS-KEYBOARD 54 ERROR W>
  <FOP X-WARP-MOUSE 55 W S S>
  <ROP X-GRAB-BUTTON 56 ERROR F W L L B B B B S S>
  <OP X-CLEAR 70 W>
  <OP X-RASTER-FILL 71 F W S S S S>
  <OP X-RASTER-PUT 72 F W S S S S L>
  <OP X-RASTER-PATTERN 73 F W S S S S L>
  <OP X-RASTER-COPY 74 F W S S S S S S S S>
  <OP X-LINE 75 F W S S S S>
  <OP X-DRAW 76 F W S STUFF>
  <OP X-TEXT 77 F W S S L CB>
  <OP X-CLIPMODE 78 F W>
  <OP X-FEEP 79 F W>
  <OP X-DRAW-DASHED 80 F W S S S S STUFF>
  <OP X-BITS-PUT 81 F W S S S S STUFF>
  <SOP X-RASTER-SAVE 82 LONG W S S S S>
  <OP X-DRAW-FILLED 83 F W S L STUFF>
  <ROP X-SETUP 90 W>
  <SOP X-GET-FONT 91 LONG F W STUFF>
  <ROP X-QUERY-FONT 92 W L>
  <OP X-FREE-FONT 93 W L>
  <SOP X-STORE-RASTER 94 LONG W S S STUFF>
  <SOP X-STORE-PATTERN 95 LONG W STUFF>
  <OP X-FREE-RASTER 96 W L>
  <OP X-FREE-PATTERN 97 W L>
  <ROP X-TEXTWIDTH 98 W L S S S S S S>
  <FOP X-SHIFT-LOCK 99 W F>
  <FOP X-UNGRAB-MOUSE 100 W>
  <SOP X-STRING-WIDTH 101 SHORT W L CB>
  <FOP X-KEY-CLICK 102 W F>
  <FOP X-AUTO-REPEAT 103 W F>
  <FOP X-UNGRAB-BUTTON 104 W S>
  <FOP X-STORE-BYTES 105 W F CS>
  <COP X-FETCH-BYTES 106 W F>
  <OP X-ADD-HOST 107 W L>
  <OP X-REMOVE-HOST 108 W L>
  <COP X-CHAR-WIDTHS 109 W L>)>

<DEFMAC VSOP ('VS100 NAME "ARGS" ARGS "AUX" L OD ALIST AAL
	      (COUNTER <>) (ARGL .ARGS) (FARGL <>) (AUXL ())
	      RES (VALDECL <>) REPLY?)
  <COND (<SET L <MEMQ .NAME ,OPLIST>>
	 <SET OD <2 .L>>
	 <SET ALIST (<FORM O-FUNC&CODE '.PACKET <OP-CODE .OD>>)>
	 <SET AAL .ALIST>
	 <REPEAT ((ADESC <OP-ARGS .OD>) D TEMP)
	    <COND (<EMPTY? .ADESC> 
		   <COND (<AND <NOT <OP-STUFF? .OD>>
			       <NOT <EMPTY? .ARGL>>>
			  <ERROR TOO-MANY-ARGUMENTS-TO-VSOP .NAME .OD
				 .ARGS>)>
		   <RETURN>)>
	    <COND (<EMPTY? .ARGL>
		   <ERROR TOO-FEW-ARGUMENTS-TO-VSOP .NAME .OD .ARGS>)>
	    <COND (<TYPE? <SET D <1 .ADESC>> FIX>
		   <COND (<==? .D ,ARG-FUNC>
			  <1 .ALIST
			     <FORM O-FUNC&CODE '.PACKET
				   <COMBINE <OP-CODE .OD> <1 .ARGL>>>>)
			 (<==? .D ,ARG-WINDOW>
			  <SET AAL <REST <PUTREST .AAL
						  (<FORM O-WINDOW '.PACKET
							 <1 .ARGL>>)>>>)
			 (T
			  <ERROR BAD-VSOP-DESCRIPTOR .OD .D>)>)
		  (<TYPE? .D LONG>
		   <SET AAL <REST <PUTREST .AAL
					   (<FORM <NTH ,LONGS
						       <+ <CHTYPE .D FIX> 1>>
						  '.PACKET
						  <1 .ARGL>>)>>>)
		  (<TYPE? .D SHORT>
		   <COND (<AND <0? <MOD <CHTYPE .D FIX> 2>>
			       <NOT <EMPTY? <REST .ADESC>>>
			       <NOT <EMPTY? <REST .ARGL>>>
			       <TYPE? <2 .ADESC> SHORT>>
			  <SET AAL
			       <REST
				<PUTREST .AAL
					 (<FORM <NTH ,LONGS
						     <+ </ <CHTYPE .D FIX> 2>
							1>>
						'.PACKET
						<COMBINE <1 .ARGL> <2 .ARGL>>>)>>>
			  <SET ARGL <REST .ARGL>>
			  <SET ADESC <REST .ADESC>>)
			 (T
			  <SET AAL
			       <REST
				<PUTREST .AAL
					 (<FORM <NTH ,SHORTS
						     <+ <CHTYPE .D FIX> 1>>
						'.PACKET
						<1 .ARGL>>)>>>)>)
		  (<TYPE? .D BYTE>
		   <PROG ((OFFS <TUPLE .D <> <> <>>) 
			  (ARGS <TUPLE <1 .ARGL> <> <> <>>) (CCT 1))
		      <COND (<AND <0? <MOD <CHTYPE .D FIX> 4>>
				  <NOT <EMPTY? <REST .ADESC>>>
				  <NOT <EMPTY? <REST .ARGL>>>
				  <TYPE? <2 .ADESC> SHORT BYTE>>
			     <SET CCT 2>
			     <2 .OFFS <2 .ADESC>>
			     <2 .ARGS <2 .ARGL>>
			     <COND (<AND <TYPE? <2 .ADESC> BYTE>
					 <NOT <EMPTY? <REST .ADESC 2>>>
					 <NOT <EMPTY? <REST .ARGL 2>>>
					 <TYPE? <3 .ADESC> SHORT BYTE>>
				    <SET CCT 3>
				    <3 .OFFS <3 .ADESC>>
				    <3 .ARGS <3 .ARGL>>
				    <COND (<AND <TYPE? <3 .ADESC> BYTE>
						<NOT <EMPTY? <REST .ADESC 3>>>
						<NOT <EMPTY? <REST .ARGL 3>>>
						<TYPE? <4 .ADESC> BYTE>>
					   <SET CCT 4>
					   <4 .OFFS <4 .ADESC>>
					   <4 .ARGS <4 .ARGL>>)>)>)
			    (<AND <0? <MOD <CHTYPE .D FIX> 2>>
				  <NOT <EMPTY? <REST .ADESC>>>
				  <NOT <EMPTY? <REST .ARGL>>>
				  <TYPE? <2 .ADESC> BYTE>>
			     <2 .OFFS <2 .ADESC>>
			     <2 .ARGS <2 .ARGL>>
			     <SET CCT 2>)>
		      <COND (<1? .CCT>
			     <SET AAL <REST
				       <PUTREST .AAL
						(<FORM <NTH ,BYTE-MACS
							    <+ <CHTYPE .D FIX> 1>>
						       '.PACKET
						       <1 .ARGL>>)>>>)
			    (T
			     <SET AAL
				  <REST
				   <PUTREST .AAL
					    (<COMBINE-HAIRY .OFFS .ARGS .CCT
							    <NTH ,SHORTS
								 <+
								  </ <CHTYPE .D FIX>
								     2> 1>>
							    <NTH ,LONGS
								 <+
								  </ <CHTYPE .D FIX>
								     4> 1>>>)>>>
			     <SET ARGL <REST .ARGL <- .CCT 1>>>
			     <SET ADESC <REST .ADESC <- .CCT 1>>>)>>)
		  (<TYPE? .D COUNT COUNT-STRING>
		   <SET COUNTER (.D <1 .ARGL>)>)
		  (T
		   <ERROR BAD-DESCRIPTOR .OD>)>
	    <SET ARGL <REST .ARGL>>
	    <SET ADESC <REST .ADESC>>>
	 <COND (<==? <OP-REPLY? .OD> T>
		<SET VALDECL '<OR FALSE UVECTOR>>
		<SET REPLY? T>)
	       (<==? <OP-REPLY? .OD> ERROR>
		<SET VALDECL '<OR ATOM FALSE>>
		<SET REPLY? ERROR>)
	       (<==? <OP-REPLY? .OD> STRING>
		<SET VALDECL '<OR STRING FALSE>>
		<SET REPLY? STRING>)
	       (<OP-REPLY? .OD>
		<SET VALDECL '<OR FIX FALSE>>
		<COND (<==? <OP-REPLY? .OD> LONG>
		       <SET REPLY? 1>)
		      (T
		       <SET REPLY? 2>)>)
	       (T
		<SET REPLY? <>>)>
	 <COND (<NOT .COUNTER>
		<COND (<==? <LENGTH .ARGL> 1>
		       <COND (<TYPE? <1 .ARGL> STRING UVECTOR>
			      <SET ARGL (<1 .ARGL> <LENGTH <1 .ARGL>>)>)
			     (T
			      <SET FARGL <1 .ARGL>>
			      <SET ARGL ('.FROB <FORM LENGTH '.FROB>)>)>)>
		<SET AUXL (('PACKET:UVECTOR ',SEND-PACKET))>
		<COND (.FARGL
		       <SET AUXL ((FROB .FARGL) !.AUXL)>)>
		<SET RES
		   <FORM BIND .AUXL
		      !.ALIST
		      <FORM VSB-SEND .VS100 <COND (.REPLY? T)
						(T
						 <OP-FORCE? .OD>)>
			    .REPLY? '.PACKET ,SEND-PACKET-WORD-LENGTH
			    !.ARGL>>>)
	       (T
		<SET AUXL (('PACKET:UVECTOR ',SEND-PACKET))>
		<SET RES
		   <FORM BIND .AUXL
		      !.ALIST
		      <FORM <NTH ,SHORTS
				 <+ <CHTYPE <1 .COUNTER> FIX> 1>>
			    '.PACKET
			    <2 .COUNTER>>
		      <FORM VSB-SEND .VS100
			    <COND (.REPLY? T)
				  (T <OP-FORCE? .OD>)>
			    .REPLY?
			    '.PACKET ,SEND-PACKET-WORD-LENGTH
			    !<COND (<==? <LENGTH .ARGL> 1>
				    (<1 .ARGL> <2 .COUNTER>))
				   (T .ARGL)>>>>)>
	 <COND (.VALDECL <CHTYPE [.RES .VALDECL] ADECL>)
	       (T .RES)>)
	(T
	 <ERROR NO-SUCH-VSOP!-ERRORS .NAME VSOP>)>>

<DEFINE COMBINE-HAIRY (OFFS:<PRIMTYPE VECTOR> ARGS:<PRIMTYPE VECTOR> CCT:FIX
		       SMAC LMAC)
   <SET OFFS <SUBSTRUC .OFFS 0 .CCT <REST .OFFS <- <LENGTH .OFFS> .CCT>>>>
   <SET ARGS <SUBSTRUC .ARGS 0 .CCT <REST .ARGS <- <LENGTH .ARGS> .CCT>>>>
   <MAPR <>
	 <FUNCTION (V)
	    <1 .V <REDUCE <1 .V>>>>
	 .ARGS>
   <COND (<AND <TYPE? <1 .OFFS> BYTE>
	       <TYPE? <2 .OFFS> SHORT>>
	  <1 .OFFS <CHTYPE </ <CHTYPE <1 .OFFS> FIX> 2> SHORT>>
	  <FORM .LMAC '.PACKET <COMBINE <1 .ARGS> <2 .ARGS>>>)
	 (<==? .CCT 2>
	  <FORM .SMAC '.PACKET <COMBINE-BYTES <1 .ARGS> <2 .ARGS>>>)
	 (<==? .CCT 3>
	  <COND (<TYPE? <3 .OFFS> SHORT>
		 <FORM .LMAC '.PACKET <COMBINE <COMBINE-BYTES <1 .ARGS>
							      <2 .ARGS>>
					       <3 .ARGS>>>)
		(T
		 <FORM .LMAC '.PACKET <COMBINE <COMBINE-BYTES <1 .ARGS>
							      <2 .ARGS>>
					       <COMBINE-BYTES <3 .ARGS> 0>>>)>)
	 (T
	  <FORM .LMAC '.PACKET <COMBINE <COMBINE-BYTES <1 .ARGS> <2 .ARGS>>
					<COMBINE-BYTES <3 .ARGS> <4 .ARGS>>>>)>>

<DEFINE COMBINE-BYTES (X Y)
   <COND (<AND <TYPE? .X FIX>
	       <TYPE? .Y FIX>>
	  <PUTBITS .X <BITS 8 8> .Y>)
	 (<AND <TYPE? .Y FIX>
	       <0? .Y>>
	  .X)
	 (<AND <TYPE? .X FIX>
	       <0? .X>>
	  <FORM LSH .X 8>)
	 (T
	  <FORM PUTBITS .X <BITS 8 8> .Y>)>>

<DEFINE COMBINE (X Y)
   <SET X <REDUCE .X>>
   <SET Y <REDUCE .Y>>
   <COND (<AND <TYPE? .X FIX>
	       <TYPE? .Y FIX>>
	  <PUTLHW .X .Y>)
	 (<AND <TYPE? .Y FIX>
	       <0? .Y>>
	  .X)
	 (T
	  <FORM PUTLHW .X .Y>)>>

<DEFINE REDUCE (X)
   <COND (<TYPE? .X FIX> .X)
	 (T
	  <COND (<TYPE? .X GVAL>)
		(<AND <TYPE? .X FORM>
		      <==? <LENGTH .X> 2>
		      <==? <1 .X> GVAL>
		      <TYPE? <2 .X> ATOM>>
		 <SET X <CHTYPE <2 .X> GVAL>>)>
	  <COND (<AND <TYPE? .X GVAL>
		      <MANIFEST? <CHTYPE .X ATOM>>>
		 <SET X <EVAL .X>>)>
	  .X)>>

<SETG LONGS [O-LPAR0 O-LPAR1 O-LPAR2 O-LPAR3]>
<SETG SHORTS [O-SPAR0 O-SPAR1 O-SPAR2 O-SPAR3 O-SPAR4 O-SPAR5 O-SPAR6
	      O-SPAR7]>
<SETG BYTE-MACS [O-BPAR0 O-BPAR1 O-BPAR2 O-BPAR3 O-BPAR4 O-BPAR5 O-BPAR6
		 O-BPAR7 O-BPAR8 O-BPAR9 O-BPAR10 O-BPAR11 O-BPAR12 O-BPAR13
		 O-BPAR14 O-BPAR15]>

<END-DEFINITIONS>
