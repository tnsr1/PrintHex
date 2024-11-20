PROCEDURE dec2hex
PARAMETER nDecimal, nDigits
**  Converts from base 10 to base 16.  Returns Hex notation in a string whose length
**  is always at least 2.  The nDigits parameter can be specified to pad the
**  string with zeroes.

IF PARAMETERS() = 2
	RETURN RIGHT(TRANSFORM(nDecimal, "@0"), IIF(nDigits <= 8, nDigits, 8))
ENDIF

*  If no second parameter, must determine correct number of digits.
nExponent = 2	&& Always return at least two characters.
DO WHILE nExponent < 9
	IF nDecimal <= (16^nExponent)
		RETURN RIGHT(TRANSFORM(nDecimal, "@0"), nExponent)
	ENDIF
	nExponent = nExponent + 1
ENDDO
ENDPROC
