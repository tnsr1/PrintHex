* foxpro code
* autors alex; + mistral
* Функция для чтения файла и вывода его содержимого в шестнадцатеричном формате

*!*	This code reads the contents of a file specified by the `cFileName` variable, 
*!*	and writes the contents in hexadecimal format to a new file with the same name but with the ".hex" extension.

*!*	The code first opens the file in read-only mode, and determines the size of the file. 
*!*	If the file is empty, an error message is displayed and the function returns.

*!*	The code then reads the file in blocks of 16 bytes, and for each block, 
*!*	it generates a line of hexadecimal output that includes the offset of the block, 
*!*	the hexadecimal representation of the bytes, and the ASCII representation of the bytes 
*!*	(with non-printable characters replaced with periods).

*!*	The generated output is written to the new ".hex" file, 
*!*	and the process continues until the entire file has been read and written.

*!*	Finally, the file is closed and a "Done!" message is displayed.

CLEAR
_SCREEN.MousePointer = 11 
	m.cFileName = "c:\dev\vfp\HexEdit\hexedit.sct"  && Замените на имя вашего файла

	*INPUT
    LOCAL lnFile, lnWord, lcHex, lnBytesRead, lnBlockSize, lnFileSize, lcString, lnIndex, lnTotalBytes
    LOCAL lnLeft
    *OUTPUT
    LOCAL lnHexLine, lcHexLine, lcOut, m.lcHexLineView

	m.lcOut = FORCEEXT(cFileName, "hex")

    m.lnBlockSize = 16  && Размер блока для чтения
    m.lnFile = FOPEN(cFileName, 0)  && (Default) Read-only

    IF m.lnFile = -1
        WAIT WINDOW "Ошибка открытия файла" NOWAIT
        ?"Ошибка открытия файла"
        RETURN
    ENDIF

	* Seek to end of file to determine number of bytes in the file.
	m.lnFileSize = FSEEK(m.lnFile, 0, 2)     && Move pointer to EOF

	IF m.lnFileSize <= 0
	 * If file is empty, display an error message.
	    WAIT WINDOW "Этот файл пуст!" NOWAIT
	    ?"Этот файл пуст!"
		RETURN
	ENDIF

    *This line of code create a new file or clear the contents of an existing file.
    STRTOFILE("", m.lcOut, .F.)

	= FSEEK(m.lnFile, 0, 0)      && Move pointer to BOF

	m.lnTotalBytes = 0
	m.lnHexLine = 0
	m.lnLeft = m.lnFileSize
    DO WHILE m.lnLeft > 0
        m.lcString = FREAD(m.lnFile, MIN(m.lnBlockSize, m.lnLeft))  && Чтение блока данных
        m.lnBytesRead = LEN(m.lcString)
        IF m.lnBytesRead = 0
            EXIT
        ENDIF
        
        m.lnTotalBytes = m.lnTotalBytes + m.lnBytesRead
        m.lnLeft = m.lnFileSize - m.lnTotalBytes

	    m.lcHexLine = Hex8(m.lnHexLine) + ": "
		
        FOR m.lnIndex = 1 TO m.lnBytesRead
	        m.lcChar = SUBSTR(m.lcString, m.lnIndex, 1)
            m.lcHex = HexWord(ASC(m.lcChar))
	        m.lcHexLine = m.lcHexLine + m.lcHex
	        
	        IF m.lnIndex = 8 
		        m.lcHexLine = m.lcHexLine + "|"
		    ELSE
			    m.lcHexLine = m.lcHexLine + " "
			ENDIF
        ENDFOR

		m.lcString = STRTRAN(m.lcString, CHR(9), ".")
		m.lcString = STRTRAN(m.lcString, CHR(10), ".")
		m.lcString = STRTRAN(m.lcString, CHR(13), ".")
		
	    STRTOFILE(m.lcHexLine + " | " + m.lcString + CHR(13) + CHR(10), m.lcOut, .T.)

		m.lnHexLine = m.lnHexLine + 16
		
    ENDDO

    FCLOSE(m.lnFile)  && Закрытие файла
    
    _SCREEN.MousePointer = 0
    
    *MESSAGEBOX("Готово!")
    
    MODIFY FILE (m.lcOut)
RETURN

* Функция для преобразования слова в шестнадцатеричное представление
FUNCTION HexWord(tnWord, tlZeroX)
    RETURN (IIF(m.tlZeroX,"0x","")+STRCONV(CHR(m.tnWord),15))
ENDFUNC

* Функция для преобразования числа в шестнадцатеричное представление с 8 символами
FUNCTION Hex8(tnNum)
    IF m.tnNum = 0
        RETURN REPLICATE("0", 8)
    ENDIF
    LOCAL lcHex, lnDigit
    m.lcHex = ""
    DO WHILE ABS(m.tnNum) > 0
        m.lnDigit = BITAND(m.tnNum, 0x0F)
        m.lcHex = SUBSTR("0123456789ABCDEF", m.lnDigit + 1, 1) + m.lcHex
        m.tnNum = BITRShift(m.tnNum, 4)
    ENDDO
    RETURN PADL(m.lcHex, 8, "0")
ENDFUNC
