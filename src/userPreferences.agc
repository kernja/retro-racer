
function LoadUserPrefs()
    fileID as integer
    tString as string
    tValue as string
    tID as integer
    tPath as string

    if GetfileExists("userPref.txt")
        fileID = openToRead("userPref.txt")


                while fileEOF(fileID) <> 1
                    rem read description for value
                    tString = readline(fileID)
                    rem read actual value
                    tValue = readline(fileID)

                    if tString = "prefMusic"
                        playerPrefMusic = val(tValue)
                    elseif tString = "prefSFX"
                        playerPrefSFX = val(tValue)
                    elseif tString = "prefMPH"
                        playerPrefMPh = val(tValue)
                    elseif tString = "prefDisplay"
                        playerPrefControl = val(tValue)
                    endif
                endwhile
        closefile(fileID)
    else
        SaveUserPrefs()
    endif



endfunction

function SaveUserPrefs()
    fileID as integer
    tValue as string
    tID as integer
    tPath as string

    `if GetfileExists("userPref.txt")
        fileID = openToWrite("userPref.txt", 0)

        WriteLine(fileID, "prefMusic")
        WriteLine(fileID, str(playerPrefMusic))

        WriteLine(fileID, "prefSFX")
        WriteLine(fileID, str(playerPrefSFX))

        WriteLine(fileID, "prefMPH")
        WriteLine(fileID, str(playerPrefMPH))

        WriteLine(fileID, "prefDisplay")
        WriteLine(fileID, str(playerPrefcontrol))

    closefile(fileID)

endfunction
