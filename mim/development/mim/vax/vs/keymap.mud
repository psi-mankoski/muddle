<PACKAGE "KEYMAP">

<ENTRY DEFINE-NORMAL-KEY DEFINE-FUNCTION-KEY WRITE-MAPS>

<INCLUDE "KEYDEFS" "VSTYPES" "VSDEFS" "VSKEYDEFS">
<USE "VSINPUT">

<DEFINE WRITE-MAPS ("OPT" (WHERE:STRING ,X-DEFAULT-KEYMAP)
		    "AUX" NM2:<SPECIAL STRING> 
		    CH:<OR <CHANNEL 'DISK> FALSE>
		    KN:FIX)
   <COND
    (<GASSIGNED? NORMAL-KEYS>
     <SET NM2 "NORMAL">
     <COND (<SET CH <GEN-OPEN .WHERE "CREATE" "BINARY" DISK>>
	    <SET KN ,KEY-MIN-NORM>
	    <CHANNEL-OP .CH WRITE-BYTE <LENGTH ,NORMAL-KEYS:VECTOR>>
	    <CHANNEL-OP .CH WRITE-BYTE .KN>
	    <MAPF <>
	     <FUNCTION (NK:<OR KEY FALSE>)
		<COND (.NK
		       <CHANNEL-OP .CH WRITE-BYTE .KN>
		       <CHANNEL-OP .CH WRITE-BUFFER .NK>)>
		<SET KN <+ .KN 1>>>
	     ,NORMAL-KEYS:VECTOR>
	    <CLOSE .CH>)
	   (T
	    <ERROR CANT-WRITE-KEY-FILE!-ERRORS <SYS-ERR .CH .WHERE T>
		   WRITE-MAPS>)>)>
   <COND
    (<GASSIGNED? FUNCTION-KEYS>
     <SET NM2 "FUNCTION">
     <COND (<SET CH <GEN-OPEN .WHERE "CREATE" "BINARY" DISK>>
	    <SET KN ,KEY-MIN-FCN>
	    <CHANNEL-OP .CH WRITE-BYTE <LENGTH ,FUNCTION-KEYS:VECTOR>>
	    <CHANNEL-OP .CH WRITE-BYTE .KN>
	    <MAPF <>
	     <FUNCTION (NK:<OR KEY FALSE>)
		<COND (.NK
		       <CHANNEL-OP .CH WRITE-BYTE .KN>
		       <CHANNEL-OP .CH WRITE-BUFFER .NK>)>
		<SET KN <+ .KN 1>>>
	     ,FUNCTION-KEYS:VECTOR>
	    <CLOSE .CH>)
	   (T
	    <ERROR CANT-WRITE-KEY-FILE!-ERRORS <SYS-ERR .CH .WHERE T>
		   WRITE-MAPS>)>)>>
	     

<DEFINE DEFINE-NORMAL-KEY (WHICH:ATOM NORM:CHARACTER SHIFT:CHARACTER "OPT"
			   (LOCK?:<OR ATOM FALSE> T) 
			   (CONTROL:<OR CHARACTER FALSE> <>)
			   (CONTROL-SHIFT:<OR CHARACTER FALSE> <>)
			   "AUX" KEYNO (NK <CHTYPE <IUVECTOR 5> KEY>))
   <COND (<NOT <GASSIGNED? NORMAL-KEYS>>
	  <SETG NORMAL-KEYS <IVECTOR <+ 1 <- ,KEY-MAX-NORM ,KEY-MIN-NORM>>
				     <>>>)>
   <COND (<OR <NOT <GASSIGNED? .WHICH>>
	      <NOT <TYPE? <SET KEYNO ,.WHICH> FIX>>>
	  <ERROR NO-SUCH-KEY!-ERRORS .WHICH DEFINE-NORMAL-KEY>)
	 (T
	  <SET KEYNO ,.WHICH>
	  <KD-NORM .NK <CHTYPE .NORM FIX>>
	  <KD-SHIFT .NK <CHTYPE .SHIFT FIX>>
	  <COND (.LOCK?
		 <KD-LOCK .NK <CHTYPE .SHIFT FIX>>)
		(T
		 <KD-LOCK .NK <CHTYPE .NORM FIX>>)>
	  <COND (.CONTROL
		 <KD-CTRL .NK <CHTYPE .CONTROL FIX>>)
		(T
		 <KD-CTRL .NK <ANDB *37* <ASCII .NORM>>>)>
	  <COND (.CONTROL-SHIFT
		 <KD-CS .NK <CHTYPE .CONTROL-SHIFT FIX>>)
		(T
		 <KD-CS .NK <KD-CTRL .NK>>)>
	  <PUT ,NORMAL-KEYS <- .KEYNO ,KEY-MIN-NORM -1>
	       .NK>)>>

<DEFINE DEFINE-FUNCTION-KEY (WHICH:ATOM NORM:<OR FIX CHARACTER>
			     SHIFT:<OR FIX CHARACTER> "AUX" NK KEYNO)
   <COND (<NOT <GASSIGNED? FUNCTION-KEYS>>
	  <SETG FUNCTION-KEYS <IVECTOR <- ,KEY-MAX-FCN ,KEY-MIN-FCN -1> <>>>)>
   <COND (<OR <NOT <GASSIGNED? .WHICH>>
	      <NOT <TYPE? <SET KEYNO ,.WHICH> FIX>>>
	  <ERROR NO-SUCH-FUNCTION-KEY!-ERRORS .WHICH DEFINE-FUNCTION-KEY>)
	 (T
	  <SET NK <CHTYPE <IUVECTOR 5 0> KEY>>
	  <COND (<TYPE? .NORM FIX>
		 <KD-NORM .NK <- .NORM>>)
		(T
		 <KD-NORM .NK <CHTYPE .NORM FIX>>)>
	  <COND (<TYPE? .SHIFT FIX>
		 <KD-SHIFT .NK <- .SHIFT>>)
		(T
		 <KD-SHIFT .NK <CHTYPE .SHIFT FIX>>)>
	  <KD-LOCK .NK <KD-NORM .NK>>
	  <KD-CTRL .NK <KD-NORM .NK>>
	  <KD-CS .NK <KD-SHIFT .NK>>
	  <PUT ,FUNCTION-KEYS <- .KEYNO ,KEY-MIN-FCN -1> .NK>)>>

<COND
 (<GASSIGNED? DEFINE-NORMAL-KEY>
  <DEFINE-NORMAL-KEY KEY-RUBOUT <ASCII 127> <ASCII 127> <> <ASCII 127> <ASCII 127>>
  <DEFINE-NORMAL-KEY KEY-RETURN <ASCII 13> <ASCII 13> <> <ASCII 13> <ASCII 13>>
  <DEFINE-NORMAL-KEY KEY-TAB <ASCII 9> <ASCII 9> <> <ASCII 9> <ASCII 9>>
  <DEFINE-NORMAL-KEY KEY-BACKQUOTE <ASCII 27> <ASCII 27> <> <ASCII 27> <ASCII 27>>
  <DEFINE-NORMAL-KEY KEY-1 !\1 !\! <> !\1 !\!>
  <DEFINE-NORMAL-KEY KEY-Q !\q !\Q T !\ <>>
  <DEFINE-NORMAL-KEY KEY-A !\a !\A T !\ <>>
  <DEFINE-NORMAL-KEY KEY-Z !\z !\Z T !\ <>>
  <DEFINE-NORMAL-KEY KEY-2 !\2 !\@ <> !\2 !\@>
  <DEFINE-NORMAL-KEY KEY-W !\w !\W T !\ <>>
  <DEFINE-NORMAL-KEY KEY-S !\s !\S T !\ <>>
  <DEFINE-NORMAL-KEY KEY-X !\x !\X T !\ <>>
  <DEFINE-NORMAL-KEY KEY-3 !\3 !\# <> !\3 !\#>
  <DEFINE-NORMAL-KEY KEY-E !\e !\E T !\ <>>
  <DEFINE-NORMAL-KEY KEY-D !\d !\D T !\ <>>
  <DEFINE-NORMAL-KEY KEY-C !\c !\C T !\ <>>
  <DEFINE-NORMAL-KEY KEY-4 !\4 !\$ <> !\4 !\$>
  <DEFINE-NORMAL-KEY KEY-R !\r !\R T !\ <>>
  <DEFINE-NORMAL-KEY KEY-F !\f !\F T !\ <>>
  <DEFINE-NORMAL-KEY KEY-V !\v !\V T !\ <>>
  <DEFINE-NORMAL-KEY KEY-SPACE !\  !\  T <ASCII 0> <>>
  <DEFINE-NORMAL-KEY KEY-5 !\5 !\% <> !\5 !\%>
  <DEFINE-NORMAL-KEY KEY-T !\t !\T T !\ <>>
  <DEFINE-NORMAL-KEY KEY-G !\g !\G T !\ <>>
  <DEFINE-NORMAL-KEY KEY-B !\b !\B T !\ <>>
  <DEFINE-NORMAL-KEY KEY-6 !\6 !\^ <> !\ <>>
  <DEFINE-NORMAL-KEY KEY-Y !\y !\Y T !\ <>>
  <DEFINE-NORMAL-KEY KEY-H !\h !\H T !\ <>>
  <DEFINE-NORMAL-KEY KEY-N !\n !\N T !\ <>>
  <DEFINE-NORMAL-KEY KEY-7 !\7 !\& <> !\7 !\&>
  <DEFINE-NORMAL-KEY KEY-U !\u !\U T !\ <>>
  <DEFINE-NORMAL-KEY KEY-J !\j !\J T <ASCII 10> <>>
  <DEFINE-NORMAL-KEY KEY-M !\m !\M T <ASCII 13> <>>
  <DEFINE-NORMAL-KEY KEY-8 !\8 !\* <> !\8 !\*>
  <DEFINE-NORMAL-KEY KEY-I !\i !\I T <ASCII 9> <>>
  <DEFINE-NORMAL-KEY KEY-K !\k !\K T !\ <>>
  <DEFINE-NORMAL-KEY KEY-COMMA !\, !\< <> !\, !\<>
  <DEFINE-NORMAL-KEY KEY-9 !\9 !\( <> !\9 !\(>
  <DEFINE-NORMAL-KEY KEY-O !\o !\O T !\ <>>
  <DEFINE-NORMAL-KEY KEY-L !\l !\L T !\ <>>
  <DEFINE-NORMAL-KEY KEY-DOT !\. !\> <> !\. !\>>
  <DEFINE-NORMAL-KEY KEY-0 !\0 !\) <> !\0 !\)>
  <DEFINE-NORMAL-KEY KEY-P !\p !\P T <> <>>
  <DEFINE-NORMAL-KEY KEY-SEMI !\; !\: <> !\; !\:>
  <DEFINE-NORMAL-KEY KEY-SLASH !\/ !\? <> !\/ !\?>
  <DEFINE-NORMAL-KEY KEY-EQUAL !\= !\+ <> !\= !\+>
  <DEFINE-NORMAL-KEY KEY-RIGHT-SQUARE !\] !\} <> !\ <>>
  <DEFINE-NORMAL-KEY KEY-BACKSLASH !\\ !\| <> !\ <>>
  <DEFINE-NORMAL-KEY KEY-DASH !\- !\_ <> !\ <>>
  <DEFINE-NORMAL-KEY KEY-LEFT-SQUARE !\[ !\{ <> !\ <>>
  <DEFINE-NORMAL-KEY KEY-QUOTE !\' !\" <> !\' !\">
  <DEFINE-NORMAL-KEY KEY-ANGLE !\` !\~ <> !\` !\~>
  <DEFINE-FUNCTION-KEY KEY-F1 ,X-F1 ,X-F1>
  <DEFINE-FUNCTION-KEY KEY-F2 ,X-F2 ,X-F2>
  <DEFINE-FUNCTION-KEY KEY-F3 ,X-F3 ,X-F3>
  <DEFINE-FUNCTION-KEY KEY-F4 ,X-F4 ,X-F4>
  <DEFINE-FUNCTION-KEY KEY-F5 ,X-F5 ,X-F5>
  <DEFINE-FUNCTION-KEY KEY-F6 ,X-F6 ,X-F6>
  <DEFINE-FUNCTION-KEY KEY-F7 ,X-F7 ,X-F7>
  <DEFINE-FUNCTION-KEY KEY-F8 ,X-F8 ,X-F8>
  <DEFINE-FUNCTION-KEY KEY-F9 ,X-F9 ,X-F9>
  <DEFINE-FUNCTION-KEY KEY-F10 ,X-F10 ,X-F10>
  <DEFINE-FUNCTION-KEY KEY-F14 ,X-F14 ,X-F14>
  <DEFINE-FUNCTION-KEY KEY-F15 ,X-HELP ,X-HELP>
  <DEFINE-FUNCTION-KEY KEY-F16 ,X-F16 ,X-F16>
  <DEFINE-FUNCTION-KEY KEY-F17 ,X-F17 ,X-F17>
  <DEFINE-FUNCTION-KEY KEY-F18 ,X-F18 ,X-F18>
  <DEFINE-FUNCTION-KEY KEY-F19 ,X-F19 ,X-F19>
  <DEFINE-FUNCTION-KEY KEY-F20 ,X-F20 ,X-F20>
  <DEFINE-FUNCTION-KEY KEY-E1 ,X-E1 ,X-E1>
  <DEFINE-FUNCTION-KEY KEY-E2 ,X-E2 ,X-E2>
  <DEFINE-FUNCTION-KEY KEY-E3 ,X-E3 ,X-E3>
  <DEFINE-FUNCTION-KEY KEY-E4 ,X-E4 ,X-E4>
  <DEFINE-FUNCTION-KEY KEY-E5 ,X-E5 ,X-E5>
  <DEFINE-FUNCTION-KEY KEY-E6 ,X-E6 ,X-E6>
  <DEFINE-FUNCTION-KEY KEY-N0 ,X-NP0 !\0>
  <DEFINE-FUNCTION-KEY KEY-NDOT ,X-NPDOT !\.>
  <DEFINE-FUNCTION-KEY KEY-ENTER ,X-ENTER <ASCII 13>>
  <DEFINE-FUNCTION-KEY KEY-N1 ,X-NP1 !\1>
  <DEFINE-FUNCTION-KEY KEY-N2 ,X-NP2 !\2>
  <DEFINE-FUNCTION-KEY KEY-N3 ,X-NP3 !\3>
  <DEFINE-FUNCTION-KEY KEY-N4 ,X-NP4 !\4>
  <DEFINE-FUNCTION-KEY KEY-N5 ,X-NP5 !\5>
  <DEFINE-FUNCTION-KEY KEY-N6 ,X-NP6 !\6>
  <DEFINE-FUNCTION-KEY KEY-N7 ,X-NP7 !\7>
  <DEFINE-FUNCTION-KEY KEY-N8 ,X-NP8 !\8>
  <DEFINE-FUNCTION-KEY KEY-N9 ,X-NP9 !\9>
  <DEFINE-FUNCTION-KEY KEY-NCOMMA ,X-NPCOMMA !\,>
  <DEFINE-FUNCTION-KEY KEY-NDASH ,X-NPDASH !\->
  <DEFINE-FUNCTION-KEY KEY-PF1 ,X-PF1 ,X-PF1>
  <DEFINE-FUNCTION-KEY KEY-PF2 ,X-PF2 ,X-PF2>
  <DEFINE-FUNCTION-KEY KEY-PF3 ,X-PF3 ,X-PF3>
  <DEFINE-FUNCTION-KEY KEY-PF4 ,X-PF4 ,X-PF4>
  <DEFINE-FUNCTION-KEY KEY-LEFT ,X-LEFT ,X-LEFT>
  <DEFINE-FUNCTION-KEY KEY-RIGHT ,X-RIGHT ,X-RIGHT>
  <DEFINE-FUNCTION-KEY KEY-UP ,X-UP ,X-UP>
  <DEFINE-FUNCTION-KEY KEY-DOWN ,X-DOWN ,X-DOWN>
  <DEFINE-FUNCTION-KEY KEY-F11 !\ !\>
  <DEFINE-FUNCTION-KEY KEY-F12 !\ !\>
  <DEFINE-FUNCTION-KEY KEY-F13 <ASCII 10> <ASCII 10>>)>

<ENDPACKAGE>
