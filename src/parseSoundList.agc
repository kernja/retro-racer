
function ParseSoundsFromFile()
    fileID as integer
    tString as string

    tID as integer
    tPath as string


    fileID = openToRead("sfxList.txt")

    while fileEOF(fileID) <> 1
        tString = readline(fileID)

        tID = val(GetStringToken(tString, ",", 1))
        tPath = GetStringToken(tString, ",", 2)

        LoadSound(tID, tPath)

        soundCount = soundCount + 1
        dim soundList[soundCount]
        soundList[soundCount - 1] = tID
    endwhile

    closefile(fileID)

endfunction

function StopAllSounds()
    i as integer
    for i = 0 to soundCount - 1
        if i > SFX_CHECKPOINT or i < SFX_CHECKPOINT
            stopSound(soundList[i])
        endif
    next
endfunction

function ParseMusicFromFile()
    fileID as integer
    tString as string

    tID as integer
    tPath as string

    fileID = openToRead("musicList.txt")
    while fileEOF(fileID) <> 1
        tString = readline(fileID)

        tID = val(GetStringToken(tString, ",", 1))
        tPath = GetStringToken(tString, ",", 2)

        LoadMusic(tID, tPath)
        `message(tPath)
    endwhile

    closefile(fileID)

endfunction

function PlayMusicPref(pIndex as integer, pLoop as integer)
    tOldMusicID as integer

    if playerPrefMusic = 1
        tOldMusicID = lastSetMusic
        lastSetMusic = pIndex
        lastSetMusicLoop = pLoop

        if GetMusicPlaying() > pIndex or GetMusicPlaying() < pIndex
            stopMusic()
            playMusic(pIndex, pLoop, pIndex, pIndex)
        endif

    else
        lastSetMusic = pIndex
        lastSetMusicLoop = pLoop
    endif
endfunction

function ResumeLastMusic()
    if playerPrefMusic = 1
        playMusic(lastSetMusic, lastSetMusicLoop, lastSetMusic, lastSetMusic)
    endif
endfunction

function ResumeGameMusic()
    if playerPrefMusic = 1
        playMusic(random(GAME_MUSIC_START, GAME_MUSIC_END), lastSetMusicLoop, GAME_MUSIC_START, GAME_MUSIC_END)
    endif
endfunction

function TogglePlaybackMusic()
    if playerPrefMusic = 0
        stopmusic()
    else
        playMusic(lastSetMusic, lastSetMusicLoop)
    endif
endfunction

Function PlaySoundPref(pID as integer)
    if playerPrefSFX = 1
        playsound(pID)
    endif
endfunction
