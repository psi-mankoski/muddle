"Definitions for VAX disk i/o"

<NEWSTRUC I$DISK-CHANNEL VECTOR
	  NS-JFN FIX			; "File descriptor"
	  NS-DEV <OR ATOM STRING FALSE>	; "CHOMPING UNIX!!!"
	  NS-SNM <OR ATOM STRING FALSE>
	  NS-NM1 <OR STRING FALSE>
	  NS-NM2 <OR STRING FALSE>
	  NS-DSN <OR STRING FALSE>
	  NS-STATUS FIX			; "Flags for i/o system"
	  NS-MODE FIX			; "Mode for open"
	  NS-BINARY? <OR ATOM FALSE>	; "True if simulating 32-bit output"
	  NS-PTR FIX
	  NS-SPTR FIX
	  NS-TBUF <OR STRING BYTES UVECTOR FALSE>
	  NS-BUF <OR STRING BYTES UVECTOR FALSE>
	  NS-BC FIX
	  NS-OBC FIX
	  NS-WRITE-BUF? <OR ATOM FALSE>>

<GDECL (I$SBUF1) STRING (I$UBUF1) UVECTOR>

<MSETG BUFLEN 80>

<MSETG BYTES/WORD 4>

<MSETG SBUFLEN <* ,BYTES/WORD ,BUFLEN>>
