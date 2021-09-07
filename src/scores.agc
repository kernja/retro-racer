
function LoadScores()
    fileID as integer
    tString as string
    tValue as string
    tID as integer
    tPath as string

    i as integer
    j as integer

    if GetfileExists("scores.txt")
        fileID = openToRead("scores.txt")

                while fileEOF(fileID) <> 1
                    rem read description for value
                    tString = readline(fileID)
                    rem read actual value
                    tValue = readline(fileID)

                    if tString = "finishModes"
                        for i = 0 to 3
                            playerModeFinish[i] = val(GetStringToken(tValue, ",", i + 1))
                        next
                    else
                        for i = 0 to 8
                            for j = 0 to 3
                                playerScores[j, i] = val(GetStringToken(tValue, ",", j + 2))
                            next

                            tValue = readline(fileID)
                        next
                    endif
                endwhile
        closefile(fileID)
    else
        SaveScores()
    endif



endfunction

function SaveScores()

    if debugMode = 1
        exitfunction
    endif

    fileID as integer
    tValue as string
    tID as integer
    tPath as string

    i as integer
    j as integer
    fileID = openToWrite("scores.txt", 0)

        WriteLine(fileID, "finishModes")

        tValue = ""
        for i = 0 to 3
            if i < 3
                tValue = tValue + str(playerModeFinish[i]) + ","
            else
                tValue = tValue + str(playerModeFinish[i])
            endif
        next
        WriteLine(fileID, tValue)

        WriteLine(fileID, "mapScores")
        for i = 0 to 8
            tValue = str(i) + ","

            for j = 0 to 3
                    if j < 3
                        tValue = tValue + str(playerScores[j, i]) + ","
                    else
                        tValue = tValue + str(playerScores[j, i])
                    endif
            next

            WriteLine(fileID, tValue)
        next

    closefile(fileID)

endfunction

Function ClearScores()
    i as integer
    j as integer

    for i = 0 to 3
        playerModeFinish[i] = 0

        for j = 0 to 8
            playerScores[i, j] = 0
        next
    next

    SaveScores()
endfunction

Function DebugScores()
    i as integer
    j as integer

    for i = 0 to 3
        playerModeFinish[i] = 1

        for j = 0 to 8
            playerScores[i, j] = 1
        next
    next

endfunction

