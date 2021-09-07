function LoadTextFromCSV(pFileName as string)
    REM MYRETURN VALUE
    REM TO STORE WHETHER OR NOT EVERYTHING COMPLETED SUCCESSFULLY
    REM 0 MEANS NO, 1 MEANS YES
    REM SET IT TO 1 INITIALLY, IF SOME ERROR OCCURS SET IT TO 0
    REM IF IT MAKES IT THROUGH THE ENTIRE FUNCTION NORMALLY, IT HAS COMPLETED SUCCESSFULLY!
    myReturn as integer
    myReturn = 1
	REM FILE ID THAT WE WORK WITH WHEN MANIPULATING THE FILE
	tFileID as integer
	i as integer

	REM VARIABLE TO HOLD DATA BEING READ FROM THE CSV
	tString as string

    REM MAKE SURE FILE PASSED IN EXISTS
	if GetFileExists(pFileName) = 1

	REM GET FILE NAME AND FILE ID
	tFileID = opentoread(pFileName)

		REM READ FIRST LINE OF FILE
		REM AS IT CONTAINS HEADER INFO
		tString = readline(tFileID)
        TextCount = 0

        while fileeof(tFileID) = 0

		REM READ IN LINE FROM FILE
		tString = readline(tFileID)

		   REM MAKE SURE THAT LINE IS NOT EMPTY
         	   if tString <> ""
                    TextCount = TextCount + 1
                    dim TextList[TextCount] as TYPE_Text_LIBRARY
                    TextList[TextCount - 1].id = val(SplitString(tString, "]", 0))
                    TextList[TextCount - 1].english = SplitString(tString, "]", 1)
                endif
        endwhile

		REM CLOSE FILE
        closefile(tFileID)
    else
        REM CSV NOT FOUND. RETURN 0
        myReturn = 0
	endif

endfunction myReturn

function GetTextLibraryString(pID as integer)
    myReturn as string
    i as integer
    pLanguage as integer

    `if pID = -1
     `   if pLanguage = 0
            myReturn = TextList[0].english
    `    endif

    `    exitfunction myReturn
    `endif

    for i = 0 to TextCount - 1
        if TextList[i].id = pID
            if pLanguage = 0
                myReturn = TextList[i].english
            endif

            exitfunction myReturn
        endif
    next
endfunction myReturn

