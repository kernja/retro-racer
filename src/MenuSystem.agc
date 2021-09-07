
function HandleTitle()
    tScreenTimer as float
    tScreenTimer = 3

    tSoundTimer as float
    tSoundTimer = 3.2

    tTouched as integer
    tTouched = 0

    LoadParsedImage(val(GetTextLibraryString(MENU_TITLE_IMAGE0)))
    LoadParsedImage(val(GetTextLibraryString(MENU_TITLE_IMAGE1)))
    LoadParsedImage(val(GetTextLibraryString(MENU_TITLE_IMAGE2)))

    CreateSprite(MENU_TITLE_SPRITE, val(GetTextLibraryString(MENU_TITLE_IMAGE0)))
    AddSpriteAnimationFrame(MENU_TITLE_SPRITE, val(GetTextLibraryString(MENU_TITLE_IMAGE1)))
    AddSpriteAnimationFrame(MENU_TITLE_SPRITE, val(GetTextLibraryString(MENU_TITLE_IMAGE0)))

    SetSpritePosition(MENU_TITLE_SPRITE, 960, 0)
    while tSoundTimer > 0
        rem move sprite towards left of screen
        if tScreenTimer > 0
            tScreenTimer = tScreenTimer - GetFrameTime()
            if tScreenTimer < 0
                tScreenTimer = 0
            endif
        endif

        if GetPointerReleased() = 1 and tTouched = 0
            tTouched = 1
            `DeleteImage(val(GetTextLibraryString(MENU_TITLE_IMAGE0)))
            `CopyImage(val(GetTextLibraryString(MENU_TITLE_IMAGE0)), val(GetTextLibraryString(MENU_TITLE_IMAGE2)), 0, 0, 960, 640)
            ClearSpriteAnimationFrames(MENU_TITLE_SPRITE)
            AddSpriteAnimationFrame(MENU_TITLE_SPRITE, val(GetTextLibraryString(MENU_TITLE_IMAGE1)))
            AddSpriteAnimationFrame(MENU_TITLE_SPRITE, val(GetTextLibraryString(MENU_TITLE_IMAGE2)))

            PlaySoundPref(SFX_INTRO)
            PlaySprite(MENU_TITLE_SPRITE, 10)
             SetSpritePosition(MENU_TITLE_SPRITE, 0, 0)
            CreateRoadStripes()

        endif

        if tTouched = 1
             tScreenTimer = 0
             `CreateRoadStripes()
             tSoundTimer = 0

             `tSoundTimer = tSoundTimer - GetFrameTime()
        endif

        SetSpritePosition(MENU_TITLE_SPRITE, 960 * (tScreenTimer / 3), 0)
        Sync()
    endwhile

    rem start playing menu music
    deletesprite(MENU_TITLE_SPRITE)
    deleteimage(MENU_TITLE_IMAGE0)
    deleteimage(MENU_TITLE_IMAGE1)
endfunction

function InitMenuSystem()
    i as integer

    rem create background image
    CreateSprite(MENU_BG_SPRITE, MENU_BG_IMAGE)
    SetSpriteDepth(MENU_BG_SPRITE, 21)

    rem create our image sprite
    rem just use some random image as it will constantly change anyway
    CreateSprite(MENU_IMAGE_SPRITE, MENU_BG_IMAGE)
    SetSpriteDepth(MENU_IMAGE_SPRITE, 20)
    SetSpritePosition(MENU_IMAGE_SPRITE, 0, 160)
    SetSpriteVisible(MENU_IMAGE_SPRITE, 0)
    SetSpriteSize(MENU_IMAGE_SPRITE, 960, 256)

    rem sprite for credits
    CreateSprite(GAMEPLAY_SPRITE_CREDITS, 0)
    SetSpriteDepth(GAMEPLAY_SPRITE_CREDITS, 15)
    SetSpritePosition(GAMEPLAY_SPRITE_CREDITS, 0, 544)
    SetSpriteVisible(GAMEPLAY_SPRITE_CREDITS, 0)
    SetSpriteSize(GAMEPLAY_SPRITE_CREDITS, 960, 96)

    rem create sprite used for showing then the race starts
    CreateSprite(GAMEPLAY_SPRITE_START, 141)
    SetSpriteDepth(GAMEPLAY_SPRITE_START, 15)
    SetSpritePosition(GAMEPLAY_SPRITE_START, 0, 544)
    SETSPRITEVISIBLE(GAMEPLAY_SPRITE_START, 0)

    rem create sprite used for showing that we're loading
    CreateSprite(GAMEPLAY_SPRITE_LOADING, 0)
    SetSpriteSize(GAMEPLAY_SPRITE_LOADING, 960, 640)
    SetSpriteDepth(GAMEPLAY_SPRITE_LOADING, 15)
    SetSpritePosition(GAMEPLAY_SPRITE_LOADING, 0, 0)
    SETSPRITEVISIBLE(GAMEPLAY_SPRITE_LOADING, 0)

    rem craete header text
    CreateDefaultTextObject(MENU_TEXT_HEADER, 20)
    HorizontallyCenterText(MENU_TEXT_HEADER, GetTextLibraryString(1), 32)

    rem create website text
    CreateDefaultTextObject(MENU_TEXT_WEBSITE, 20)
    HorizontallyCenterText(MENU_TEXT_WEBSITE, GetTextLibraryString(2), 576)
    SetTextVisible(MENU_TEXT_WEBSITE, 0)

    rem create buttons
    CreateDefaultTextObject(MENU_TEXT_BUTTON1, 20)
    LeftAlignText(MENU_TEXT_BUTTON1, GetTextLibraryString(3), 32, 576)
    SetTextVisible(MENU_TEXT_BUTTON1, 0)

    CreateDefaultTextObject(MENU_TEXT_BUTTON2, 20)
    RightAlignText(MENU_TEXT_BUTTON2, GetTextLibraryString(4), 928, 576)
    SetTextVisible(MENU_TEXT_BUTTON2, 0)

    rem create menu items
    for i = MENU_TEXT_MIN to MENU_TEXT_MAX
        CreateDefaultTextObject(i, 20)
        LeftAlignText(i, GetTextLibraryString(18), 80, 114 + ((i - MENU_TEXT_MIN) * 64))
        SetTextVisible(i, 0)
    next

    rem create gameplay text objects
    for i = GAMEPLAY_TEXT_MIN to GAMEPLAY_TEXT_MAX
        CreateDefaultTextObject(i, 20)
        SetTextVisible(i, 0)
    next

    rem create menu slider
    CreateDefaultTextObject(MENU_TEXT_SLIDER, 20)
    SetTextString(MENU_TEXT_SLIDER, "O")
    `SetTextPosition(MENU_TEXT_SLIDER, 576, 0)
    SetTextVisible(MENU_TEXT_SLIDER, 0)
    SetTextPosition(MENU_TEXT_SLIDER, 896, 112)


    ResetMenuText()
    StopAllSounds()
    PlayMusicPref(MENU_MUSIC, 1)
endfunction

function CreateDefaultTextObject(pID as integer, pDepth as integer)
    CreateText(pID, " ")
    SetTextDepth(pID, pDepth)
    SetTextSize(pID, 32)
    SetTextSpacing(pID, -8)
endfunction

rem reset all menu text items on screen to blank
rem hide buttons as well
function ResetMenuText()
    i as integer
    rem reset text to their default positions
    for i = MENU_TEXT_MIN to MENU_TEXT_MAX
        LeftAlignText(i, "", 80, 114 + ((i - MENU_TEXT_MIN) * 64))
        SetTextVisible(i, 0)
        SetTextColor(i, 255, 255, 255, 255)
    next

    rem reset all text to default white color
    for i = MENU_TEXT_HEADER to MENU_TEXT_MAX
        SetTextColor(i, 255, 255, 255, 255)
    next

    rem hide header
    SetTextVisible(MENU_TEXT_HEADER, 0)
    rem hide buttons
    SetTextVisible(MENU_TEXT_BUTTON1, 0)
    SetTextVisible(MENU_TEXT_BUTTON2, 0)
    rem hide website
    SetTextVisible(MENU_TEXT_WEBSITE, 0)

    rem hide sprite image
    SetSpriteVisible(MENU_IMAGE_SPRITE, 0)

    rem hide slider
    SetTextVisible(MENU_TEXT_SLIDER, 0)
endfunction

function SetMenuVisible(pVisible as integer)
    SetSpriteVisible(MENU_BG_SPRITE, pVisible)
    ResetMenuText()
endfunction

rem set up the main menu like it should be
function PrepareMainMenu()
    i as integer

    rem reset the text and buttons
    ResetMenuText()
    rem set up main menu header
    HorizontallyCenterText(MENU_TEXT_HEADER, GetTextLibraryString(1), 32)
    rem make it visible
    SetTextVisible(MENU_TEXT_HEADER, 1)

    rem make website button visible
    SetTextVisible(MENU_TEXT_WEBSITE, 1)

    rem prep menu text
    SetTextString(MENU_TEXT_MIN,GetTextLibraryString(6))
    SetTextString(MENU_TEXT_MIN + 1,GetTextLibraryString(26))
    SetTextString(MENU_TEXT_MIN + 2,GetTextLibraryString(7))
    SetTextString(MENU_TEXT_MIN + 3,GetTextLibraryString(8))

    for i = MENU_TEXT_MIN to MENU_TEXT_MIN + 3
        SetTextVisible(i, 1)
    next

    rem housekeeping
    DeleteParsedImages()

    rem VERY important to sync after setup to clear out input data
    SyncOverride()
endfunction

function RenderMainMenu()
    i as integer

    while 1 = 1
        for i = MENU_TEXT_MIN to MENU_TEXT_MIN + 3
           if CheckTextClick(i, SFX_MESSAGE) = 1
                if i = MENU_TEXT_MIN + 2
                    PrepareOptionsMenu()
                    RenderOptionsMenu()
                    PrepareMainMenu()
                elseif i = MENU_TEXT_MIN + 3
                    `PrepareAboutMenu()
                    `RenderAboutMenu()
                    `PrepareMainMenu()
                    SetMenuVisible(0)
                        PlayCredits()

                    PlayMusicPref(MENU_MUSIC, 1)
                                        SetMenuVisible(1)
                    PrepareMainMenu()
                elseif i = MENU_TEXT_MIN + 1
                    PrepareHowToMenu()
                    RenderHowToMenu()
                    PrepareMainMenu()
                elseif i = MENU_TEXT_MIN
                    PrepareGameplayTypeMenu()
                    RenderGameplayTypeMenu()
                    PrepareMainMenu()
                endif
           endif
        next

    if CheckTextClick(MENU_TEXT_WEBSITE, SFX_MESSAGE) = 1
        OpenBrowser("http://www.playbukketgames.com")
    endif

    SyncOverride()
    endwhile
endfunction

rem set up the main menu like it should be
function PreparePauseMenu()
    i as integer

    rem reset the text and buttons
    ResetMenuText()
    rem set up main menu header
    HorizontallyCenterText(MENU_TEXT_HEADER, GetTextLibraryString(42), 32)
    rem make it visible
    SetTextVisible(MENU_TEXT_HEADER, 1)
    rem make bg visible
    SetSpriteVisible(MENU_BG_SPRITE, 1)

    rem prep menu text
    SetTextString(MENU_TEXT_MIN,GetTextLibraryString(43))
    SetTextString(MENU_TEXT_MIN + 1,GetTextLibraryString(44))
    SetTextString(MENU_TEXT_MIN + 2,GetTextLibraryString(49))

    for i = MENU_TEXT_MIN to MENU_TEXT_MIN + 2
        SetTextVisible(i, 1)
    next

    for i = GAMEPLAY_TEXT_MIN to GAMEPLAY_TEXT_MAX
        SetTextVisible(i, 0)
    next

    rem VERY important to sync after setup to clear out input data
    SyncOverride()
endfunction

function RenderPauseMenu()
    i as integer
    myReturn as integer
    myReturn = -1

    while myReturn = -1
            for i = MENU_TEXT_MIN to MENU_TEXT_MIN + 2
               if CheckTextClick(i, SFX_MESSAGE) = 1
                    if i = MENU_TEXT_MIN + 1
                        rem player quit
                        myReturn = 0
                    elseif i = MENU_TEXT_MIN
                        rem resume game
                        myReturn = 1
                    elseif i = MENU_TEXT_MIN + 2
                        rem resume game
                        myReturn = 2
                    endif
               endif
            next

        SyncOverride()
    endwhile

    rem do cleanup
    for i = GAMEPLAY_TEXT_MIN to GAMEPLAY_TEXT_MAX
        SetTextVisible(i, 1)
    next

endfunction myReturn

function PrepareOptionsMenu()
    i as integer

    rem reset the text and buttons
    ResetMenuText()
    rem set up main menu header
    HorizontallyCenterText(MENU_TEXT_HEADER, GetTextLibraryString(25), 32)
    rem make it visible
    SetTextVisible(MENU_TEXT_HEADER, 1)

    rem make website button visible
    SetTextVisible(MENU_TEXT_WEBSITE, 0)

    rem prep menu text
    SetTextString(MENU_TEXT_MIN, GetTextLibraryString(12 + playerPrefMusic))
    SetTextString(MENU_TEXT_MIN + 1, GetTextLibraryString(14 + playerPrefSFX))
    SetTextString(MENU_TEXT_MIN + 2, GetTextLibraryString(16 + playerPrefMPH))
    `SetTextString(MENU_TEXT_MIN + 3, GetTextLibraryString(18 + playerPrefControl))
    `SetTextString(MENU_TEXT_MIN + 4, GetTextLibraryString(20 + playerPrefMirror))
    SetTextString(MENU_TEXT_MAX, GetTextLibraryString(22))

    for i = MENU_TEXT_MIN to MENU_TEXT_MIN + 2
        SetTextVisible(i, 1)
    next

    SetTextVisible(MENU_TEXT_MAX, 1)

    rem prep button to exit
    RightAlignText(MENU_TEXT_BUTTON2, GetTextLibraryString(24), 928, 576)
    SetTextVisible(MENU_TEXT_BUTTON2, 1)

    rem VERY important to sync after setup to clear out input data
    SyncOverride()
endfunction

function RenderOptionsMenu()
    i as integer
    selection as integer
    cleared as integer
    debugTimer as float

    while selection = 0
        if GetPointerX() < 32 and GetPointerY() < 32
            if GetPointerState() = 1
                debugTimer = debugTimer + GetFrameTime()

                if debugTimer >= 5
                    debugMode = 1
                    DebugScores()
                    message("debug mode activated")
                endif
            endif
        else
            debugTimer = 0
        endif

        for i = MENU_TEXT_MIN to MENU_TEXT_MIN + 2
            if GetTextVisible(i) = 1
                if CheckTextClick(i, SFX_MESSAGE) = 1
                    if i = MENU_TEXT_MIN
                        if playerPrefMusic = 0
                            playerPrefMusic = 1
                        else
                            playerPrefMusic = 0
                        endif

                        TogglePlaybackMusic()
                    elseif i = (MENU_TEXT_MIN + 1)
                        if playerPrefSFX = 0
                            playerPrefSFX = 1
                        else
                            playerPrefSFX = 0
                        endif
                    elseif i = (MENU_TEXT_MIN + 2)
                        if playerPrefMPH = 0
                            playerPrefMPH = 1
                        else
                            playerPrefMPH= 0
                        endif
                    elseif i = (MENU_TEXT_MIN + 3)
                        if playerPrefControl = 0
                            playerPrefControl = 1
                        else
                            playerPrefControl = 0
                        endif
                    `elseif i = (MENU_TEXT_MIN + 4)
                    `    if playerPrefMirror = 0
                    `        playerPrefMirror = 1
                    `    else
                    `        playerPrefMirror = 0
                     `   endif
                    endif

                    SetTextString(MENU_TEXT_MIN, GetTextLibraryString(12 + playerPrefMusic))
                    SetTextString(MENU_TEXT_MIN + 1,GetTextLibraryString(14 + playerPrefSFX))
                    SetTextString(MENU_TEXT_MIN + 2,GetTextLibraryString(16 + playerPrefMPH))
                    SetTextString(MENU_TEXT_MIN + 3,GetTextLibraryString(18 + playerPrefControl))
                    `SetTextString(MENU_TEXT_MIN + 4,GetTextLibraryString(20 + playerPrefMirror))
                endif
            else
                `playerPrefMirror = 0
                SetTextString(MENU_TEXT_MIN + 4,GetTextLibraryString(20 + playerPrefMirror))
            endif
        next

        rem we only want this to be clicked on once
        rem to clear options
        if cleared = 0
            if CheckTextClick(MENU_TEXT_MAX, SFX_CRASH2) = 1
                SetTextString(MENU_TEXT_MAX, GetTextLibraryString(23))
                SetTextColor(MENU_TEXT_MAX, 255, 0, 0, 255)
                cleared = 1
                ClearScores()
                SetTextVisible(MENU_TEXT_MIN + 4, 0)
            endif
        endif

        rem check to see if the user wants out
        if CheckTextClick(MENU_TEXT_BUTTON2, SFX_MESSAGE) = 1
            selection = 1
        endif

    SyncOverride()
    endwhile

    rem save our data
    SaveUserPrefs()
endfunction

rem set up the about like it should be
function PrepareAboutMenu()
    i as integer
    rem reset the text and buttons
    ResetMenuText()
    rem set up main menu header
    HorizontallyCenterText(MENU_TEXT_HEADER, GetTextLibraryString(28), 32)
    rem make it visible
    SetTextVisible(MENU_TEXT_HEADER, 1)

    rem prep menu text
    for i = MENU_TEXT_MIN to MENU_TEXT_MAX
        HorizontallyCenterText(i, GetTextLibraryString(MENU_TEXT_ABOUT + (i - MENU_TEXT_MIN)), GetTextY(i))
        SetTextVisible(i, 1)
    next

    rem prep button to exit
    RightAlignText(MENU_TEXT_BUTTON2, GetTextLibraryString(27), 928, 576)
    SetTextVisible(MENU_TEXT_BUTTON2, 1)

    rem VERY important to sync after setup to clear out input data
    SyncOverride()
endfunction

function RenderAboutMenu()
    i as integer
    currentIndex as integer
    maxIndex as integer

    currentIndex = MENU_TEXT_ABOUT
    maxIndex = MENU_TEXT_ABOUT + 21

    while currentIndex <= maxIndex

        rem exception case to throw users to websites
        if currentIndex = MENU_TEXT_ABOUT
            if CheckTextClick(MENU_TEXT_MIN + 2, SFX_MESSAGE) = 1
                OpenBrowser(GetTextString(MENU_TEXT_MIN + 2))
            endif

            if CheckTextClick(MENU_TEXT_MIN + 5, SFX_MESSAGE) = 1
                OpenBrowser(GetTextString(MENU_TEXT_MIN + 5))
            endif
        elseif currentIndex = 214
            if CheckTextClick(MENU_TEXT_MAX, SFX_MESSAGE) = 1
                OpenBrowser(lower(GetTextString(MENU_TEXT_MAX)))
            endif
        endif

        rem check to see if the user wants out
        if CheckTextClick(MENU_TEXT_BUTTON2, SFX_MESSAGE) = 1
            currentIndex = currentIndex + 7

            rem load the next block of text
            if currentIndex <= maxIndex
                for i = MENU_TEXT_MIN to MENU_TEXT_MAX
                    HorizontallyCenterText(i, GetTextLibraryString(currentIndex + (i - MENU_TEXT_MIN)), GetTextY(i))
                next
            endif

            rem change button text so it says back to main menu
            if currentIndex = maxIndex
                RightAlignText(MENU_TEXT_BUTTON2, GetTextLibraryString(24), 928, 576)
            endif
        endif

    SyncOverride()
    endwhile

endfunction

rem set up the how to menu like it should be
function PrepareHowToMenu()
    i as integer
    rem reset the text and buttons
    ResetMenuText()
    rem set up main menu header
    HorizontallyCenterText(MENU_TEXT_HEADER, GetTextLibraryString(29), 32)
    rem make it visible
    SetTextVisible(MENU_TEXT_HEADER, 1)

    rem prep menu text
    for i = MENU_TEXT_MIN to MENU_TEXT_MAX
        if i = MENU_TEXT_MIN + 1
            SetTextVisible(i, 0)
            LoadParsedImage(val(GetTextLibraryString(MENU_TEXT_HOWTO + (i - MENU_TEXT_MIN))))
            SetSpriteImage(MENU_IMAGE_SPRITE, val(GetTextLibraryString(MENU_TEXT_HOWTO + (i - MENU_TEXT_MIN))))
            SetSpriteVisible(MENU_IMAGE_SPRITE, 1)
        else
            HorizontallyCenterText(i, GetTextLibraryString(MENU_TEXT_HOWTO + (i - MENU_TEXT_MIN)), GetTextY(i))
            SetTextVisible(i, 1)
        endif
    next

    rem prep button to exit
    RightAlignText(MENU_TEXT_BUTTON2, GetTextLibraryString(27), 928, 576)
    SetTextVisible(MENU_TEXT_BUTTON2, 1)

    rem VERY important to sync after setup to clear out input data
    SyncOverride()
endfunction


function RenderHowToMenu()
    i as integer
    currentIndex as integer
    maxIndex as integer

    currentIndex = MENU_TEXT_HOWTO
    maxIndex = MENU_TEXT_HOWTO + 56

    while currentIndex <= maxIndex

        rem check to see if the user wants out
        if CheckTextClick(MENU_TEXT_BUTTON2, SFX_MESSAGE) = 1
            currentIndex = currentIndex + 7

            rem load the next block of text
            if currentIndex <= maxIndex
                for i = MENU_TEXT_MIN to MENU_TEXT_MAX
                    if i = MENU_TEXT_MIN + 1
                        SetTextVisible(i, 0)
                        LoadParsedImage(val(GetTextLibraryString(currentIndex + (i - MENU_TEXT_MIN))))
                        SetSpriteImage(MENU_IMAGE_SPRITE, val(GetTextLibraryString(currentIndex + (i - MENU_TEXT_MIN))))
                        SetSpriteVisible(MENU_IMAGE_SPRITE, 1)
                    else
                        HorizontallyCenterText(i, GetTextLibraryString(currentIndex + (i - MENU_TEXT_MIN)), GetTextY(i))
                        SetTextVisible(i, 1)
                    endif
                next
            endif

            rem change button text so it says back to main menu
            if currentIndex = maxIndex
                RightAlignText(MENU_TEXT_BUTTON2, GetTextLibraryString(24), 928, 576)
            endif
        endif

    SyncOverride()
    endwhile

endfunction



rem set up the main menu like it should be
function PrepareFailedMenu()
    i as integer

    rem reset the text and buttons
    ResetMenuText()
    rem set up main menu header
    HorizontallyCenterText(MENU_TEXT_HEADER, GetTextLibraryString(38), 32)
    rem make it visible
    SetTextVisible(MENU_TEXT_HEADER, 1)

    rem prep menu text
    HorizontallyCenterText(MENU_TEXT_MIN, mapName, GetTextY(MENU_TEXT_MIN))
    HorizontallyCenterText(MENU_TEXT_MIN + 5, GetTextLibraryString(39), GetTextY(MENU_TEXT_MIN + 5))

    rem set preview image visible
    SetSpriteVisible(MENU_IMAGE_SPRITE, 1)

    SetTextVisible(MENU_TEXT_MIN, 1)
    SetTextVisible(MENU_TEXT_MIN + 5, 1)

    for i = MENU_TEXT_MIN to MENU_TEXT_MIN + 1
        SetTextVisible(i, 1)
    next

    rem prep button to retry
    RightAlignText(MENU_TEXT_BUTTON2, GetTextLibraryString(40), 928, 576)
    SetTextVisible(MENU_TEXT_BUTTON2, 0)

    rem prep button to fail
    LeftAlignText(MENU_TEXT_BUTTON1, GetTextLibraryString(41), 32, 576)
    SetTextVisible(MENU_TEXT_BUTTON1, 0)

    rem VERY important to sync after setup to clear out input data
    SyncOverride()
endfunction

function RenderFailedMenu()
    myReturn as integer
    myReturn = -1
    myTimer as float
    myTimer = 0
    i as integer
    StopMusic()
    PlaySoundPref(115)
    while myReturn = -1
        myTimer = myTimer + GetFrameTime()
        if myTimer > 3
            myTimer = 3
            SetTextVisible(MENU_TEXT_BUTTON2, 1)
            SetTextVisible(MENU_TEXT_BUTTON1, 1)
        endif

        rem check to see if the user wants to try again
        if GetTextVisible(MENU_TEXT_BUTTON2) = 1
            if CheckTextClick(MENU_TEXT_BUTTON2, SFX_MESSAGE) = 1
                myReturn = 1
            endif
            rem they dont want to
            if CheckTextClick(MENU_TEXT_BUTTON1, SFX_MESSAGE) = 1
                myReturn = 0
                ResumeLastMusic()
            endif
        endif

    SyncOverride()
    endwhile

endfunction myReturn

rem set up the main menu like it should be
function PrepareCompletedMenu(pDownload as integer)
    i as integer

    rem reset the text and buttons
    ResetMenuText()
                                SetMenuVisible(1)
    rem set up main menu header
    HorizontallyCenterText(MENU_TEXT_HEADER, GetTextLibraryString(323), 32)
    rem make it visible
    SetTextVisible(MENU_TEXT_HEADER, 1)

    rem prep menu text
    rem this is the map name
    HorizontallyCenterText(MENU_TEXT_MIN, mapName, GetTextY(MENU_TEXT_MIN))

    rem this the message stating if it's a new high score or not
    rem check to see if it's a downloaded course

    StopMusic()


    if (pDownload = 0)
        rem if not, see if the value is indeed greater
       ` message(str(round(playerScore)))
       ` message(str(playerScores[playerGameplayMode - 1, playerTrackIndex]))

        if (round(playerScore) > playerScores[playerGameplayMode - 1, playerTrackIndex])
            PlaySoundPref(SFX_GET)
            HorizontallyCenterText(MENU_TEXT_MIN + 5, GetTextLibraryString(35), GetTextY(MENU_TEXT_MIN + 5))
            playerScores[playerGameplayMode - 1, playerTrackIndex] = round(playerScore)
        else
            rem it's not
            HorizontallyCenterText(MENU_TEXT_MIN + 5, GetTextLibraryString(322), GetTextY(MENU_TEXT_MIN + 5))
        endif

      `  if playerTrackIndex = 8
     `       playerModeFinish[playerGameplayMode - 1] = 1
       ` endif

        SaveScores()
    else
         PlaySoundPref(SFX_GET)
        HorizontallyCenterText(MENU_TEXT_MIN + 5, GetTextLibraryString(322), GetTextY(MENU_TEXT_MIN + 5))
    endif

    rem this is the score
    HorizontallyCenterText(MENU_TEXT_MAX, str(round(playerScore)), GetTextY(MENU_TEXT_MAX))

    rem set bg visible
    SetSpriteVisible(MENU_BG_SPRITE, 1)

    rem set preview image visible
    SetSpriteVisible(MENU_IMAGE_SPRITE, 1)

    SetTextVisible(MENU_TEXT_MIN, 1)
    SetTextVisible(MENU_TEXT_MIN + 5, 1)
    SetTextVisible(MENU_TEXT_MAX, 1)

    rem prep button to fail
    `LeftAlignText(MENU_TEXT_BUTTON1, GetTextLibraryString(), 32, 576)
    `SetTextVisible(MENU_TEXT_BUTTON1, 1)
    RightAlignText(MENU_TEXT_BUTTON2, GetTextLibraryString(27), 928, 576)
    SetTextVisible(MENU_TEXT_BUTTON2, 1)

    rem VERY important to sync after setup to clear out input data
    SyncOverride()
    SyncOverride()
endfunction

function RenderCompletedMenu()
    myReturn as integer
    myReturn = -1

    while myReturn = -1

            rem go back a menu
            if CheckTextClick(MENU_TEXT_BUTTON2, SFX_MESSAGE) = 1
                myReturn = 0
            endif

    SyncOverride()
    endwhile

endfunction myReturn


rem set up the main menu like it should be
function PrepareAchievementMenu()
    i as integer

    if playerTrackIndex < (standardListingCount - 1)
        exitfunction
    elseif playerModeFinish[playerGameplayMode - 1] = 1
        exitfunction
    else
        rem reset the text and buttons
        ResetMenuText()
        SetMenuVisible(1)
        rem set up main menu header
        HorizontallyCenterText(MENU_TEXT_HEADER, GetTextLibraryString(323), 32)
        rem make it visible
        SetTextVisible(MENU_TEXT_HEADER, 1)

        rem load award sprite
        LoadParsedImage(248);
        rem award sprite
        SetSpriteImage(MENU_IMAGE_SPRITE, 248)

        rem prep menu text
        rem this says new mode locked
        HorizontallyCenterText(MENU_TEXT_MIN, GetTextLibraryString(56), GetTextY(MENU_TEXT_MIN))
        PlaySoundPref(SFX_GET)

        if playerGameplayMode = 1
            rem mode name
            HorizontallyCenterText(MENU_TEXT_MIN + 5, GetTextLibraryString(57), GetTextY(MENU_TEXT_MIN + 5))
            rem this is the description
            HorizontallyCenterText(MENU_TEXT_MAX, GetTextLibraryString(58), GetTextY(MENU_TEXT_MAX))
        elseif playerGameplayMode = 2
            rem mode name
            HorizontallyCenterText(MENU_TEXT_MIN + 5, GetTextLibraryString(59), GetTextY(MENU_TEXT_MIN + 5))
            rem this is the description
            HorizontallyCenterText(MENU_TEXT_MAX, GetTextLibraryString(60), GetTextY(MENU_TEXT_MAX))
        elseif playerGameplayMode = 3
            rem mode name
            HorizontallyCenterText(MENU_TEXT_MIN + 5, GetTextLibraryString(61), GetTextY(MENU_TEXT_MIN + 5))
            rem this is the description
            HorizontallyCenterText(MENU_TEXT_MAX, GetTextLibraryString(58), GetTextY(MENU_TEXT_MAX))
        else
            rem this says new mode locked
            HorizontallyCenterText(MENU_TEXT_MIN, GetTextLibraryString(64), GetTextY(MENU_TEXT_MIN))
             rem mode name
            HorizontallyCenterText(MENU_TEXT_MIN + 5, GetTextLibraryString(62), GetTextY(MENU_TEXT_MIN + 5))
            rem this is the description
            HorizontallyCenterText(MENU_TEXT_MAX, GetTextLibraryString(63), GetTextY(MENU_TEXT_MAX))
        endif

        rem set bg visible
        SetSpriteVisible(MENU_BG_SPRITE, 1)

        rem set preview image visible
        SetSpriteVisible(MENU_IMAGE_SPRITE, 1)

        SetTextVisible(MENU_TEXT_MIN, 1)
        SetTextVisible(MENU_TEXT_MIN + 5, 1)
        SetTextVisible(MENU_TEXT_MAX, 1)

        rem prep button to fail
        RightAlignText(MENU_TEXT_BUTTON2, GetTextLibraryString(27), 928, 576)
        SetTextVisible(MENU_TEXT_BUTTON2, 1)

        rem VERY important to sync after setup to clear out input data
        SyncOverride()
    endif

endfunction

function RenderAchievementMenu()

    if playerTrackIndex < (standardListingCount - 1)
        exitfunction
    elseif playerModeFinish[playerGameplayMode - 1] = 1
        exitfunction
    else

        myReturn as integer
        myReturn = -1

        while myReturn = -1

                rem go back a menu
                if CheckTextClick(MENU_TEXT_BUTTON2, SFX_MESSAGE) = 1
                    myReturn = 0
                endif

        SyncOverride()
        endwhile

        playerModeFinish[playerGameplayMode - 1] = 1
        SaveScores()
    endif

endfunction myReturn

remstart
function RenderHowToMenu()
    i as integer
    currentIndex as integer
    maxIndex as integer

    currentIndex = MENU_TEXT_HOWTO
    maxIndex = MENU_TEXT_HOWTO + 56

    while currentIndex <= maxIndex

        rem check to see if the user wants out
        if CheckTextClick(MENU_TEXT_BUTTON2, SFX_MESSAGE) = 1
            currentIndex = currentIndex + 7

            rem load the next block of text
            if currentIndex <= maxIndex
                for i = MENU_TEXT_MIN to MENU_TEXT_MAX
                    if i = MENU_TEXT_MIN + 1
                        SetTextVisible(i, 0)
                        LoadParsedImage(val(GetTextLibraryString(currentIndex + (i - MENU_TEXT_MIN))))
                        SetSpriteImage(MENU_IMAGE_SPRITE, val(GetTextLibraryString(currentIndex + (i - MENU_TEXT_MIN))))
                        SetSpriteVisible(MENU_IMAGE_SPRITE, 1)
                    else
                        HorizontallyCenterText(i, GetTextLibraryString(currentIndex + (i - MENU_TEXT_MIN)), GetTextY(i))
                        SetTextVisible(i, 1)
                    endif
                next
            endif

            rem change button text so it says back to main menu
            if currentIndex = maxIndex
                RightAlignText(MENU_TEXT_BUTTON2, GetTextLibraryString(24), 928, 576)
            endif
        endif

    SyncOverride()
    endwhile

endfunction
remend

function PrepareGameplayTypeMenu()
    i as integer

    rem reset the text and buttons
    ResetMenuText()
    rem set up main menu header
    HorizontallyCenterText(MENU_TEXT_HEADER, GetTextLibraryString(50), 32)
    rem make it visible
    SetTextVisible(MENU_TEXT_HEADER, 1)

    rem prep menu text
    SetTextString(MENU_TEXT_MIN,GetTextLibraryString(51))

    if playerModeFinish[0] = 1
        SetTextString(MENU_TEXT_MIN + 1,GetTextLibraryString(52))
    else
         SetTextString(MENU_TEXT_MIN + 1,GetTextLibraryString(55))
    endif

    if playerModeFinish[1] = 1
        SetTextString(MENU_TEXT_MIN + 2,GetTextLibraryString(53))
    else
        SetTextString(MENU_TEXT_MIN + 2,GetTextLibraryString(55))
    endif

    if playerModeFinish[2] = 1
        SetTextString(MENU_TEXT_MIN + 3,GetTextLibraryString(54))
    else
        SetTextString(MENU_TEXT_MIN + 3,GetTextLibraryString(55))
    endif

    for i = MENU_TEXT_MIN to MENU_TEXT_MIN + 3
        SetTextVisible(i, 1)
    next

    rem housekeeping
    DeleteParsedImages()

    rem prep button to exit
    LeftAlignText(MENU_TEXT_BUTTON1, GetTextLibraryString(3), 32, 576)
    SetTextVisible(MENU_TEXT_BUTTON1, 1)

    `RightAlignText(MENU_TEXT_BUTTON1, GetTextLibraryString(3), 928, 576)
    `SetTextVisible(MENU_TEXT_BUTTON1, 1)
    rem VERY important to sync after setup to clear out input data
    SyncOverride()
endfunction

function RenderGameplayTypeMenu()
    stayInMenu as integer
    stayInMenu = 1
    i as integer

    rem clear out gameplay mode
    playerGameplayMode = GAMEPLAY_MODE_SELECT

    while stayInMenu = 1
        for i = MENU_TEXT_MIN to MENU_TEXT_MIN + 3
           if GetTextString(i) = GetTextLibraryString(55)

           else
               if CheckTextClick(i, SFX_MESSAGE) = 1
                    if i = MENU_TEXT_MIN
                        playerGameplayMode = GAMEPLAY_MODE_CLASSIC
                        mirrorMap = 1
                    elseif i = MENU_TEXT_MIN + 1
                        playerGameplayMode = GAMEPLAY_MODE_END
                        mirrorMap = 1
                    elseif i = MENU_TEXT_MIN + 2
                        playerGameplayMode = GAMEPLAY_MODE_CLASSICM
                        mirrorMap = -1
                    else
                        playerGameplayMode = GAMEPLAY_MODE_ENDM
                        mirrorMap = -1
                    endif
                endif
           endif
        next

        rem check to see if the user wants out
        if CheckTextClick(MENU_TEXT_BUTTON1, SFX_MESSAGE) = 1
            stayInMenu = 0
        endif

        rem user selected a gameplay mode
        if playerGameplayMode > GAMEPLAY_MODE_SELECT
            rem shoot them off to a new loop
            PrepareTrackTypeMenu()
            RenderTrackTypeMenu()
            PrepareGameplayTypeMenu()

            playerGameplayMode = GAMEPLAY_MODE_SELECT
        endif
    SyncOverride()

    endwhile
endfunction

function PrepareTrackTypeMenu()
    i as integer

    rem reset the text and buttons
    ResetMenuText()
    rem set up main menu header
    HorizontallyCenterText(MENU_TEXT_HEADER, GetTextLibraryString(300), 32)
    rem make it visible
    SetTextVisible(MENU_TEXT_HEADER, 1)

    rem prep menu text
    SetTextString(MENU_TEXT_MIN,GetTextLibraryString(301))
    SetTextString(MENU_TEXT_MIN + 1,GetTextLibraryString(302))

    for i = MENU_TEXT_MIN to MENU_TEXT_MIN + 1
        SetTextVisible(i, 1)
    next

    rem housekeeping
    DeleteParsedImages()

    rem prep button to exit
    LeftAlignText(MENU_TEXT_BUTTON1, GetTextLibraryString(3), 32, 576)
    SetTextVisible(MENU_TEXT_BUTTON1, 1)

    rem VERY important to sync after setup to clear out input data
    SyncOverride()
endfunction

function RenderTrackTypeMenu()
    stayInMenu as integer
    stayInMenu = 1
    i as integer

    while stayInMenu = 1
        for i = MENU_TEXT_MIN to MENU_TEXT_MIN + 1
           if CheckTextClick(i, SFX_MESSAGE) = 1
                `elseif i = MENU_TEXT_MIN + 1
                `    PrepareHowToMenu()
                `    RenderHowToMenu()
                `    PrepareMainMenu()
                `endif
                if i = MENU_TEXT_MIN + 1
                    if FULLVERSION = 0
                        PrepareInternetLiteMenu()
                        RenderInternetLiteMenu()
                        PrepareTrackTypeMenu()
                    else
                         EmptyDownloadDirectory()
                                            SyncOverride()
                        if PrepareInternetFullMenu() = DOWNLOAD_SUCCESS
                            RenderInternetFullMenu()
                        endif

                        PrepareTrackTypeMenu()
                    endif
                elseif i = MENU_TEXT_MIN
                    SyncOverride()
                    PrepareStandardTrackMenu()
                    RenderStandardTrackMenu()
                    PrepareTrackTypeMenu()
                    remstart
                    continuePlaying as integer
                    continuePlaying = 1


                    while continuePlaying = 1
                        gameResult as integer
                        SetMenuVisible(0)

                        gameResult = PlayGame()

                         PlayMusicPref(MENU_MUSIC, 1)
                            if gameResult = GAMERESULT_BAD
                                SetMenuVisible(1)
                                PrepareFailedMenu()

                                continuePlaying = RenderFailedMenu()
                            elseif gameResult = GAMERESULT_RESTART
                                SetMenuVisible(0)
                                continuePlaying = 1
                            else
                                SetMenuVisible(1)
                                continuePlaying = 0
                            endif
                    endwhile

                    PrepareTrackTypeMenu()
                    remend
                endif
           endif
        next

        rem check to see if the user wants out
        if CheckTextClick(MENU_TEXT_BUTTON1, SFX_MESSAGE) = 1
            stayInMenu = 0
        endif

    SyncOverride()
    endwhile
endfunction


rem set up the standard track menu
function PrepareStandardTrackMenu()
    rem reset the text and buttons
    ResetMenuText()
    DeleteParsedImages()

    rem hide all object text
    rem first line is used for text
    HorizontallyCenterText(MENU_TEXT_HEADER, GetTextLibraryString(315), GetTextY(MENU_TEXT_HEADER))
    SetTextVisible(MENU_TEXT_HEADER, 1)
    rem populate default values for listings
    for i = 0 to standardListingCount - 1
        if i <= 6
            if i >= 1
                 if playerScores[playerGameplayMode - 1, i - 1] > 0
                    LeftAlignText(i + MENU_TEXT_MIN, standardListings[i].name, MENU_TEXT_LEFT_ALIGN, GetTextY(i + MENU_TEXT_MIN))
                 else
                    LeftAlignText(i + MENU_TEXT_MIN, GetTextLibraryString(55), MENU_TEXT_LEFT_ALIGN, GetTextY(i + MENU_TEXT_MIN))
                 endif
            else
                LeftAlignText(i + MENU_TEXT_MIN, standardListings[i].name, MENU_TEXT_LEFT_ALIGN, GetTextY(i + MENU_TEXT_MIN))
            endif

            SetTextVisible(i + MENU_TEXT_MIN , 1)
        else
            exit
        endif
    next

    rem hide sprite image
    SetSpriteVisible(MENU_IMAGE_SPRITE, 0)

    rem set slider visible
    SetTextVisible(MENU_TEXT_SLIDER, 1)
    rem prep button to exit
    LeftAlignText(MENU_TEXT_BUTTON1, GetTextLibraryString(3), 32, 576)
    SetTextVisible(MENU_TEXT_BUTTON1, 1)

endfunction

function RenderStandardTrackMenu()
   stayInMenu as integer
   stayInMenu = 1

    originalX as float
    originalY as float

    currentX as float
    currentY as float

    holdTimer as float
    movedIndex as integer

    currentIndex as integer = 0
    currentDistance as float

    maxIndex as integer
    maxIndex = standardListingCount - 7

    mIndexF as float
    cIndexF as float



    while stayInMenu = 1
        if GetPointerPressed() = 1
            originalX = 0
            originalY = GetPointerY()
            holdTimer = 0.0
            movedIndex = 0
        endif

        if GetPointerState() = 1
            if GetPointerX() > 864
                currentX = 0
                currentY = GetPointerY()

                currentDistance = GetDistance2D(currentX, originalX, currentY, originalY)
                if currentDistance > 32 and currentY < originalY
                    movedIndex = 1
                    currentIndex = currentIndex - 1
                    originalX = currentX
                    originalY = currentY
                endif

                if currentDistance > 48 and currentY > originalY
                    movedIndex = 1
                    currentIndex = currentIndex + 1
                    originalX = currentX
                    originalY = currentY
                endif
            endif
        endif

        rem boundary check
        if currentIndex > maxIndex
            currentIndex = maxIndex
        endif

        if currentIndex < 0
            currentIndex = 0
        endif

        mIndexF = maxIndex
        cIndexF = currentIndex


        rem only to click checks if they didn't scroll
        if movedIndex = 0
            rem check to see if the user selected a track
            for i = MENU_TEXT_MIN to MENU_TEXT_MAX
                rem only chetck visible text options
                if GetTextVisible(i) = 1
                    rem bitches want to play a course

                        tempTrackIndex as integer
                        tempTrackIndex =  currentIndex + i - MENU_TEXT_MIN

                        if tempTrackIndex = 0
                            if CheckTextClick(i, SFX_MESSAGE) = 1
                                mapName = GetTextString(i)
                                playerTrackIndex = currentIndex + i - MENU_TEXT_MIN
                                PrepareStandardPreview()
                                RenderStandardPreview()
                                PrepareStandardTrackMenu()
                                `SetMenuVisible(1)
                                stayInMenu = 1
                            endif
                        elseif (tempTrackIndex >= 1 and playerScores[playerGameplayMode - 1, tempTrackIndex  - 1] > 0)
                            if CheckTextClick(i, SFX_MESSAGE) = 1
                                mapName = GetTextString(i)
                                playerTrackIndex = currentIndex + i - MENU_TEXT_MIN
                                PrepareStandardPreview()
                                RenderStandardPreview()
                                PrepareStandardTrackMenu()
                                `SetMenuVisible(1)
                                stayInMenu = 1
                            endif
                        endif
                endif
            next

            rem check to see if the user wants out
            if CheckTextClick(MENU_TEXT_BUTTON1, SFX_MESSAGE) = 1
                stayInMenu = 0
            endif
        else
            for i = MENU_TEXT_MIN to MENU_TEXT_MAX
                SetTextColor(i, 255, 255, 255, 255)
            next
            rem otherwise sometimes the button stays yellow
            CheckTextHover(MENU_TEXT_BUTTON1)
        endif

        rem update slider
        if maxIndex > 0
            SetTextPosition(MENU_TEXT_SLIDER, 896, 112 + (386 * (cIndexF / mIndexF)))
        else
            SetTextPosition(MENU_TEXT_SLIDER, 896, 498)
        endif

        rem update listings
        for i = currentIndex to standardListingCount
            if (i - currentIndex) <= 6
                ``LeftAlignText(i + MENU_TEXT_MIN - currentIndex, standardListings[i].name, MENU_TEXT_LEFT_ALIGN, GetTextY(i + MENU_TEXT_MIN - currentIndex))
                    if i >= 1
                         if playerScores[playerGameplayMode - 1, i - 1] > 0
                            LeftAlignText(i + MENU_TEXT_MIN  - currentIndex, standardListings[i].name, MENU_TEXT_LEFT_ALIGN, GetTextY(i + MENU_TEXT_MIN  - currentIndex))
                         else
                            LeftAlignText(i + MENU_TEXT_MIN  - currentIndex, GetTextLibraryString(55), MENU_TEXT_LEFT_ALIGN, GetTextY(i + MENU_TEXT_MIN  - currentIndex))
                         endif
                    else
                        LeftAlignText(i + MENU_TEXT_MIN  - currentIndex, standardListings[i].name, MENU_TEXT_LEFT_ALIGN, GetTextY(i + MENU_TEXT_MIN  - currentIndex))
                    endif
            else
                exit
            endif
        next

        SyncOverride()
    endwhile

endfunction

function PrepareStandardPreview()
    ResetMenuText()

    LoadParsedImage(standardListings[playerTrackIndex].imageID)
    SetSpriteImage(MENU_IMAGE_SPRITE, standardListings[playerTrackIndex].imageID)
    SetSpriteVisible(MENU_IMAGE_SPRITE, 1)

    rem hide all object text
    for i = MENU_TEXT_MIN to MENU_TEXT_MAX
        SetTextVisible(i, 0)
    next i

    rem first line is used for text
    HorizontallyCenterText(MENU_TEXT_HEADER, GetTextLibraryString(319), GetTextY(MENU_TEXT_HEADER))
    SetTextVisible(MENU_TEXT_HEADER, 1)
    rem update track name
    HorizontallyCenterText(MENU_TEXT_MIN, standardListings[playerTrackIndex].name, GetTextY(MENU_TEXT_MIN))
    SetTextVisible(MENU_TEXT_MIN, 1)

    rem show high score
    HorizontallyCenterText(MENU_TEXT_MAX, GetTextLibraryString(321) + str(playerScores[playerGameplayMode - 1, playerTrackIndex]), GetTextY(MENU_TEXT_MAX))
    SetTextVisible(MENU_TEXT_MAX, 1)

    rem show difficulty
    HorizontallyCenterText(MENU_TEXT_MIN + 5, GetTextLibraryString(standardListings[playerTrackIndex].difficulty + 316) , GetTextY(MENU_TEXT_MIN + 5))
    SetTextVisible(MENU_TEXT_MIN + 5, 1)

    rem prep button to select track
    LeftAlignText(MENU_TEXT_BUTTON1, GetTextLibraryString(3), GetTextX(MENU_TEXT_BUTTON1), 576)
    SetTextVisible(MENU_TEXT_BUTTON1, 1)

    RightAlignText(MENU_TEXT_BUTTON2, GetTextLibraryString(320), 928, 576)
    SetTextVisible(MENU_TEXT_BUTTON2, 1)

    SyncOverride()
endfunction myReturn

function RenderStandardPreview()
   stayInMenu as integer
   stayInMenu = 1
   gameResult as integer
   gameResult = 0

    while stayInMenu = 1
        rem check to see if the user wants out
        if CheckTextClick(MENU_TEXT_BUTTON1, SFX_MESSAGE) = 1
            stayInMenu = 0
        endif

        if CheckTextClick(MENU_TEXT_BUTTON2, SFX_MESSAGE) = 1
            rem Standard map
            `SetMenuVisible(0)
            ``TimerWait(2)
            `DeleteParsedImages()
            SetMenuVisible(0)
            stayInMenu = 0

            continuePlaying as integer
            continuePlaying = 1


                while continuePlaying = 1

                    SetMenuVisible(0)

                    gameResult = PlayGame(standardListings[playerTrackIndex].file, 0)
                     PlayMusicPref(MENU_MUSIC, 1)
                        if gameResult = GAMERESULT_BAD
                            SetMenuVisible(1)
                            PrepareFailedMenu()

                            continuePlaying = RenderFailedMenu()
                        elseif gameResult = GAMERESULT_RESTART
                            SetMenuVisible(0)
                            continuePlaying = 1
                        else
                            continuePlaying = 0

                            if gameResult > GAMERESULT_EXIT
                                PrepareCompletedMenu(0)
                                RenderCompletedMenu()
                                PrepareAchievementMenu()
                                RenderAchievementMenu()
                                ResumeLastMusic()
                            endif
                            PrepareStandardTrackMenu()
                            SetMenuVisible(1)
                            stayInMenu = 0
                        endif

                endwhile
        endif

         if gameResult >= 0
            SyncOverride()
        endif

    endwhile

endfunction

rem set up the main menu like it should be
remstart
function PrepareLetsRaceMenu()
    i as integer

    rem reset the text and buttons
    ResetMenuText()
    rem set up main menu header
    HorizontallyCenterText(MENU_TEXT_HEADER, GetTextLibraryString(300), 32)
    rem make it visible
    SetTextVisible(MENU_TEXT_HEADER, 1)

    rem prep menu text
    SetTextString(MENU_TEXT_MIN,GetTextLibraryString(301))
    SetTextString(MENU_TEXT_MIN + 1,GetTextLibraryString(302))

    for i = MENU_TEXT_MIN to MENU_TEXT_MIN + 1
        SetTextVisible(i, 1)
    next

    rem housekeeping
    DeleteParsedImages()

    rem prep button to exit
    RightAlignText(MENU_TEXT_BUTTON2, GetTextLibraryString(3), 928, 576)
    SetTextVisible(MENU_TEXT_BUTTON2, 1)
    rem VERY important to sync after setup to clear out input data
    SyncOverride()
endfunction

function RenderLetsRaceMenu()
    stayInMenu as integer
    stayInMenu = 1
    i as integer

    while stayInMenu = 1
        for i = MENU_TEXT_MIN to MENU_TEXT_MIN + 1
           if CheckTextClick(i, SFX_MESSAGE) = 1
                `elseif i = MENU_TEXT_MIN + 1
                `    PrepareHowToMenu()
                `    RenderHowToMenu()
                `    PrepareMainMenu()
                `endif
                if i = MENU_TEXT_MIN + 1
                    if FULLVERSION = 0
                        PrepareInternetLiteMenu()
                        RenderInternetLiteMenu()
                        PrepareLetsRaceMenu()
                    else
                         EmptyDownloadDirectory()
                        if PrepareInternetFullMenu() = DOWNLOAD_SUCCESS
                            RenderInternetFullMenu()
                        endif
                        PrepareLetsRaceMenu()
                    endif
                elseif i = MENU_TEXT_MIN
                    continuePlaying as integer
                    continuePlaying = 1

                    while continuePlaying = 1
                        gameResult as integer
                        SetMenuVisible(0)

                        gameResult = PlayGame()

                         PlayMusicPref(MENU_MUSIC, 1)
                            if gameResult = GAMERESULT_BAD
                                SetMenuVisible(1)
                                PrepareFailedMenu()

                                continuePlaying = RenderFailedMenu()
                            elseif gameResult = GAMERESULT_RESTART
                                SetMenuVisible(0)
                                continuePlaying = 1
                            else
                                SetMenuVisible(1)
                                continuePlaying = 0
                            endif
                    endwhile

                    PrepareLetsRaceMenu()

                endif
           endif
        next

        rem check to see if the user wants out
        if CheckTextClick(MENU_TEXT_BUTTON2, SFX_MESSAGE) = 1
            stayInMenu = 0
        endif

    SyncOverride()
    endwhile
endfunction
remend


rem set up the internet lite menu
function PrepareInternetLiteMenu()
    i as integer

    rem reset the text and buttons
    ResetMenuText()
    rem set up main menu header
    HorizontallyCenterText(MENU_TEXT_HEADER, GetTextLibraryString(303), GetTextY(MENU_TEXT_HEADER))
    rem make it visible
    SetTextVisible(MENU_TEXT_HEADER, 1)

    LoadParsedImage(132)
    SetSpriteImage(MENU_IMAGE_SPRITE, 132)
    SetSpriteVisible(MENU_IMAGE_SPRITE, 1)
    rem prep menu text
    HorizontallyCenterText(MENU_TEXT_MIN,GetTextLibraryString(304), GetTextY(MENU_TEXT_MIN))
    HorizontallyCenterText(MENU_TEXT_MIN + 5,GetTextLibraryString(305), GetTextY(MENU_TEXT_MIN + 5))
    HorizontallyCenterText(MENU_TEXT_MIN + 6,GetTextLibraryString(306), GetTextY(MENU_TEXT_MIN + 6))

    SetTextVisible(MENU_TEXT_MIN, 1)
    SetTextVisible(MENU_TEXT_MIN + 5, 1)
    SetTextVisible(MENU_TEXT_MIN + 6, 1)

    rem prep button to exit
    LeftAlignText(MENU_TEXT_BUTTON1, GetTextLibraryString(3), 32, 576)
    SetTextVisible(MENU_TEXT_BUTTON1, 1)
    rem VERY important to sync after setup to clear out input data
    SyncOverride()
endfunction

function RenderInternetLiteMenu()
    stayInMenu as integer
    stayInMenu = 1
    i as integer

    while stayInMenu = 1

        rem check to see if the user wants out
        if CheckTextClick(MENU_TEXT_BUTTON1, SFX_MESSAGE) = 1
            stayInMenu = 0
        endif

    SyncOverride()
    endwhile
endfunction

rem set up the internet lite menu
function PrepareInternetFullMenu()
    i as integer
    myReturn as integer

    EmptyDownloadDirectory()

    if debugMode = 0
        myReturn = RunInternetDownload("www.playbukketgames.com", "/games/rr/listings.zip", "listings.zip", 5)
    else
        myReturn = RunInternetDownload("www.playbukketgames.com", "/games/rr/listingsDebug.zip", "listings.zip", 5)
    endif

    if myReturn = DOWNLOAD_SUCCESS
        rem prepare scroll menu
        ExtractZipFile("listings.zip", "", 0)
        ParseDownloadListings()
        RefreshInternetFullMenu()
    endif
endfunction myReturn


function RefreshInternetFullMenu()

    rem reset the text and buttons
    ResetMenuText()
    DeleteParsedImages()
        rem hide all object text
        `for i = MENU_TEXT_MIN to MENU_TEXT_MAX
       `     SetTextVisible(i, 0)
       ` next i

        `SetTextVisible(MENU_TEXT_MIN, 1)
        rem first line is used for text
        HorizontallyCenterText(MENU_TEXT_HEADER, GetTextLibraryString(315), GetTextY(MENU_TEXT_HEADER))
        SetTextVisible(MENU_TEXT_HEADER, 1)
        rem populate default values for listings
        for i = 0 to downloadListingCount - 1
            if i <= 6
                LeftAlignText(i + MENU_TEXT_MIN, downloadListings[i].name, MENU_TEXT_LEFT_ALIGN, GetTextY(i + MENU_TEXT_MIN))
                SetTextVisible(i + MENU_TEXT_MIN , 1)
            else
                exit
            endif
        next

        rem hide sprite image
        SetSpriteVisible(MENU_IMAGE_SPRITE, 0)

        rem set slider visible
        SetTextVisible(MENU_TEXT_SLIDER, 1)
        rem prep button to exit
        rem hide it because we only want to cancel out on error
        LeftAlignText(MENU_TEXT_BUTTON1, GetTextLibraryString(3), 32, 576)
        SetTextVisible(MENU_TEXT_BUTTON1, 1)
endfunction

function RenderInternetFullMenu()
   stayInMenu as integer
   stayInMenu = 1

    originalX as float
    originalY as float

    currentX as float
    currentY as float

    holdTimer as float
    movedIndex as integer

    currentIndex as integer = 0
    currentDistance as float

    maxIndex as integer
    maxIndex = downloadListingCount - 8

    mIndexF as float
    cIndexF as float



    while stayInMenu = 1
        if GetPointerPressed() = 1
            originalX = 0
            originalY = GetPointerY()
            holdTimer = 0.0
            movedIndex = 0
        endif

        if GetPointerState() = 1
            if GetPointerX() > 864
                currentX = 0
                currentY = GetPointerY()

                currentDistance = GetDistance2D(currentX, originalX, currentY, originalY)
                if currentDistance > 32 and currentY < originalY
                    movedIndex = 1
                    currentIndex = currentIndex - 1
                    originalX = currentX
                    originalY = currentY
                endif

                if currentDistance > 48 and currentY > originalY
                    movedIndex = 1
                    currentIndex = currentIndex + 1
                    originalX = currentX
                    originalY = currentY
                endif
            endif
        endif

        rem boundary check
        if currentIndex > maxIndex
            currentIndex = maxIndex
        endif

        if currentIndex < 0
            currentIndex = 0
        endif

        mIndexF = maxIndex
        cIndexF = currentIndex


        rem only to click checks if they didn't scroll
        if movedIndex = 0
            rem check to see if the user selected a track
            for i = MENU_TEXT_MIN to MENU_TEXT_MAX
                rem only chetck visible text options
                if GetTextVisible(i) = 1
                    rem bitches want to play a course
                    if CheckTextClick(i, SFX_MESSAGE) = 1
                        mapName = GetTextString(i)
                        if PrepareDownloadPreview(currentIndex + i - MENU_TEXT_MIN) = DOWNLOAD_SUCCESS
                            RenderDownloadPreview(currentIndex + i - MENU_TEXT_MIN)
                        endif
                        RefreshInternetFullMenu()
                    endif
                endif
            next
            rem check to see if the user wants out
            if CheckTextClick(MENU_TEXT_BUTTON1, SFX_MESSAGE) = 1
                stayInMenu = 0
            endif
        else
            for i = MENU_TEXT_MIN to MENU_TEXT_MAX
                SetTextColor(i, 255, 255, 255, 255)
            next
            rem otherwise sometimes the button stays yellow
            CheckTextHover(MENU_TEXT_BUTTON2)
        endif

        rem update slider
        if maxIndex > 0
            SetTextPosition(MENU_TEXT_SLIDER, 896, 112 + (386 * (cIndexF / mIndexF)))
        else
            SetTextPosition(MENU_TEXT_SLIDER, 896, 498)
        endif

        rem update listings
        for i = currentIndex to downloadListingCount - 1
            if (i - currentIndex) <= 6
                LeftAlignText(i + MENU_TEXT_MIN - currentIndex, downloadListings[i].name, MENU_TEXT_LEFT_ALIGN, GetTextY(i + MENU_TEXT_MIN - currentIndex))
                `SetTextVisible(i + MENU_TEXT_MIN - currentIndex , 1)
            else
                exit
            endif
        next

        SyncOverride()
    endwhile

    rem to cleanup
    EmptyDownloadDirectory()
endfunction


function PrepareDownloadGameplay(pIndex as integer)
    SetSpriteImage(MENU_IMAGE_SPRITE, 130)
    SetSpriteVisible(MENU_IMAGE_SPRITE, 1)
    SetMenuVisible(1)

    i as integer
    myReturn as integer
    myReturn = RunInternetDownload("www.playbukketgames.com", downloadListings[pIndex].file, "download.zip", 12)

    if myReturn = DOWNLOAD_SUCCESS
        SetMenuVisible(0)
        ExtractZipFile("download.zip", "", 0)
        myReturn = PlayGame("download/map.rrc", 1)
    else
        myReturn = GAMERESULT_EXIT
    endif
endfunction myReturn

function PrepareDownloadPreview(pIndex as integer)
    i as integer
    myReturn as integer
    `DeleteImage(130)
    LoadParsedImage(130)
    EmptyDownloadDirectory()
    myReturn = RunInternetDownload("www.playbukketgames.com", downloadListings[pIndex].image, "download/image2.png", 7)

    if myReturn = DOWNLOAD_SUCCESS
        ResetMenuText()
        `DeleteParsedImages()
        `DeleteImage(130)
        `LoadParsedImage(130)
        DeleteImage(133)
        LoadImage(133, "download/image2.png")
        rem make room for the temp image
        rem this image is used for download state anyway
        RefreshDownloadPreview(pIndex)
    endif
endfunction myReturn

function RefreshDownloadPreview(pIndex as integer)

    SetSpriteImage(MENU_IMAGE_SPRITE, 133)
    SetSpriteVisible(MENU_IMAGE_SPRITE, 1)

    rem hide all object text
    for i = MENU_TEXT_MIN to MENU_TEXT_MAX
        SetTextVisible(i, 0)
    next i

    rem first line is used for text
    HorizontallyCenterText(MENU_TEXT_HEADER, GetTextLibraryString(319), GetTextY(MENU_TEXT_HEADER))
    SetTextVisible(MENU_TEXT_HEADER, 1)
    rem update track name
    HorizontallyCenterText(MENU_TEXT_MIN, downloadListings[pIndex].name, GetTextY(MENU_TEXT_MIN))
    SetTextVisible(MENU_TEXT_MIN, 1)

    rem show author
    HorizontallyCenterText(MENU_TEXT_MIN + 5, downloadListings[pIndex].author, GetTextY(MENU_TEXT_MIN + 5))
    SetTextVisible(MENU_TEXT_MIN + 5, 1)

    rem show difficulty
    HorizontallyCenterText(MENU_TEXT_MAX, GetTextLibraryString(downloadListings[pIndex].difficulty + 316) , GetTextY(MENU_TEXT_MAX))
    SetTextVisible(MENU_TEXT_MAX, 1)

    rem prep button to select track
    LeftAlignText(MENU_TEXT_BUTTON1, GetTextLibraryString(3), GetTextX(MENU_TEXT_BUTTON1), 576)
    SetTextVisible(MENU_TEXT_BUTTON1, 1)

    RightAlignText(MENU_TEXT_BUTTON2, GetTextLibraryString(320), 928, 576)
    SetTextVisible(MENU_TEXT_BUTTON2, 1)
endfunction

function RenderDownloadPreview(pIndex as integer)
   stayInMenu as integer
   stayInMenu as integer
   stayInMenu = 1

    while stayInMenu = 1
        rem check to see if the user wants out
        if CheckTextClick(MENU_TEXT_BUTTON1, SFX_MESSAGE) = 1
            stayInMenu = 0
        endif

        if CheckTextClick(MENU_TEXT_BUTTON2, SFX_MESSAGE) = 1
            `SetMenuVisible(0)
            stayInMenu = 0

            continuePlaying as integer
            continuePlaying = 1


                while continuePlaying = 1
                    gameResult as integer
                    gameResult = PrepareDownloadGameplay(pIndex)
                   SetSpriteImage(MENU_IMAGE_SPRITE, 133)
                     PlayMusicPref(MENU_MUSIC, 1)
                        if gameResult = GAMERESULT_BAD
                            SetMenuVisible(1)
                            PrepareFailedMenu()

                            continuePlaying = RenderFailedMenu()
                        elseif gameResult = GAMERESULT_RESTART
                            SetMenuVisible(0)
                            continuePlaying = 1
                        else
                            continuePlaying = 0

                            if gameResult > GAMERESULT_EXIT
                                PrepareCompletedMenu(1)
                                RenderCompletedMenu()
                                ResumeLastMusic()
                            endif

                            RefreshInternetFullMenu()
                            SetMenuVisible(1)
                            stayInMenu = 0

                            SetMenuVisible(1)
                            `SyncOverride()

                        endif

                endwhile

        endif

         if gameResult >= 0
            SyncOverride()
        endif


    endwhile

endfunction

function RunInternetDownload(pHost as string, pFileRemote as string, pFileLocal as string, pTimeout as float)
    i as integer
    tryAgain as integer
        stayInMenu as integer
    tryAgain = 1

    while tryAgain = 1
        stayInMenu = 1
        NullFile(pFileLocal)
        rem reset the text and buttons
        ResetMenuText()
        rem set up main menu header
        HorizontallyCenterText(MENU_TEXT_HEADER, GetTextLibraryString(303), GetTextY(MENU_TEXT_HEADER))
        rem make it visible
        SetTextVisible(MENU_TEXT_HEADER, 1)

        LoadParsedImage(130)
        SetSpriteImage(MENU_IMAGE_SPRITE, 130)
        SetSpriteVisible(MENU_IMAGE_SPRITE, 1)
        rem prep menu text
        HorizontallyCenterText(MENU_TEXT_MIN,GetTextLibraryString(299), GetTextY(MENU_TEXT_MIN))
        HorizontallyCenterText(MENU_TEXT_MIN + 5,GetTextLibraryString(307), GetTextY(MENU_TEXT_MIN + 5))
        HorizontallyCenterText(MENU_TEXT_MIN + 6,GetTextLibraryString(308), GetTextY(MENU_TEXT_MIN + 6))

        SetTextVisible(MENU_TEXT_MIN, 1)
        SetTextVisible(MENU_TEXT_MIN + 5, 1)
        SetTextVisible(MENU_TEXT_MIN + 6, 1)

        rem prep button to exit
        rem hide it because we only want to cancel out on error
        LeftAlignText(MENU_TEXT_BUTTON1, GetTextLibraryString(3), GetTextX(MENU_TEXT_BUTTON1), 576)
        SetTextVisible(MENU_TEXT_BUTTON1, 0)

        RightAlignText(MENU_TEXT_BUTTON2, GetTextLibraryString(311), 928, 576)
        SetTextVisible(MENU_TEXT_BUTTON2, 0)
        rem VERY important to sync after setup to clear out input data
        SyncOverride()



        downloadStatus as integer
        `downloadStatus = DownloadFile("www.playbukketgames.com", "/games/rr/listings.zip", "download/listings.zip", 5)
        downloadStatus = DownloadFile(pHost, pFileRemote, pFileLocal, pTimeout)
            rem update screen display
            if downloadStatus = DOWNLOAD_SUCCESS
                PlaySoundPref(SFX_MESSAGE)
                HorizontallyCenterText(MENU_TEXT_MIN + 5,GetTextLibraryString(313), GetTextY(MENU_TEXT_MIN + 5))
                HorizontallyCenterText(MENU_TEXT_MIN + 6,GetTextLibraryString(314), GetTextY(MENU_TEXT_MIN + 6))

                LoadParsedImage(131)
                SetSpriteImage(MENU_IMAGE_SPRITE, 131)
                TimerWait(1)
                `ExtractZipFile("download/listings.zip", "download")
            else
                PlaySoundPref(SFX_CRASH2)
                HorizontallyCenterText(MENU_TEXT_MIN + 5,GetTextLibraryString(309), GetTextY(MENU_TEXT_MIN + 5))
                HorizontallyCenterText(MENU_TEXT_MIN + 6,GetTextLibraryString(310), GetTextY(MENU_TEXT_MIN + 6))
                LoadParsedImage(132)
                SetSpriteImage(MENU_IMAGE_SPRITE, 132)
                SetTextVisible(MENU_TEXT_BUTTON1, 1)
                SetTextVisible(MENU_TEXT_BUTTON2, 1)
            endif

            while stayInMenu = 1
                if downloadStatus = DOWNLOAD_SUCCESS
                    stayInMenu = 0
                    tryAgain = 0
                else
                    rem delete download files
                    EmptyDownloadDirectory()
                    rem check to see if the user wants out
                    if CheckTextClick(MENU_TEXT_BUTTON1, SFX_MESSAGE) = 1
                        stayInMenu = 0
                        tryAgain = 0
                    elseif CheckTextClick(MENU_TEXT_BUTTON2, SFX_MESSAGE) = 1
                        stayInMenu = 0
                    endif
                endif

                SyncOverride()
            endwhile
    endwhile
endfunction downloadStatus

function CheckTextHover(pID as integer)
    tPointerX as integer
    tPointerY as integer

    tPointerX = GetPointerX()
    tPointerY = GetPointerY()
    tHover as integer = 0

    if tPointerX > GetTextX(pID) - MENU_TEXT_INPUT_OFFSET and tPointerX < GetTextX(pID) + GetTextTotalWidth(pID) + MENU_TEXT_INPUT_OFFSET
        if tPointerY > GetTextY(pID) - MENU_TEXT_INPUT_OFFSET and tPointerY < GetTextY(pID) + GetTextTotalHeight(pID) + MENU_TEXT_INPUT_OFFSET
            if GetPointerState() = 1 or GetPointerReleased() = 1
                tHover = 1
            endif
        endif
    endif

    if tHover = 1
        SetTextColor(pID, 255, 255, 0, 255)
    else
        SetTextColor(pID, 255, 255, 255, 255)
    endif

endfunction tHover

function CheckTextClick(pID as integer, pSound as integer)
    tReturn as integer

    if CheckTextHover(pID) = 1
        if GetPointerReleased() = 1
            PlaySoundPref(pSound)
            tReturn = 1
        endif
    endif

endfunction tReturn

function HorizontallyCenterText(pID as integer, pString as string, pY as integer)
    tWidth as integer
    tHalf as integer

    SetTextString(pID, pString)
    tWidth = GetTextTotalWidth(pID)
    tHalf = tWidth * .5
    SetTextPosition(pID, (SCREEN_WIDTH * .5) - tHalf, pY)
endfunction

function LeftAlignText(pID as integer, pString as string, pX as integer, pY as integer)
    SetTextString(pID, pString)
    SetTextPosition(pID, pX, pY)
endfunction

function RightAlignText(pID as integer, pString as string, pX as integer, pY as integer)
    tWidth as integer

    SetTextString(pID, pString)
    tWidth = GetTextTotalWidth(pID)
    SetTextPosition(pID, pX - tWidth, pY)
endfunction

function TimerWait(pTime as float)
timerCount as float
timerCount = 0

    while timerCount < pTime
        timerCount = timerCount + GetFrameTime()
        SyncOverride()
    endwhile
endfunction

function RenderGameplayStart()
     tCount as float
     tCountTotal as float
     i as integer

    tCount = 1
    tCountTotal = 0

    SetSpriteImage(GAMEPLAY_SPRITE_START, 141)
    SetSpriteVisible(GAMEPLAY_SPRITE_START, 1)

    for i = GAMEPLAY_TEXT_MIN to GAMEPLAY_TEXT_MAX
        SetTextVisible(i, 0)
    next

        SyncOverride()
    while tCountTotal <= 6
        tCount = tCount - GetFrameTime()
        tCountTotal = tCountTotal + GetFrameTime()

        if tCount <= 0
            if trunc(tCountTotal) = 1

            elseif trunc(tCountTotal) = 2
            PlaySoundPref(113)
                SetSpriteImage(GAMEPLAY_SPRITE_START, 142)
            elseif trunc(tCountTotal) = 3
                    SetSpriteImage(GAMEPLAY_SPRITE_START, 143)
            elseif trunc(tCountTotal) = 4
                SetSpriteImage(GAMEPLAY_SPRITE_START, 144)
            elseif trunc(tCountTotal) = 5
                SetSpriteImage(GAMEPLAY_SPRITE_START, 145)
            endif

            tCount = tCount + 1
        endif

        SyncOverride()
    endwhile

    for i = GAMEPLAY_TEXT_MIN to GAMEPLAY_TEXT_MAX
        SetTextVisible(i, 1)
    next
  SetSpriteVisible(GAMEPLAY_SPRITE_START, 0)
endfunction
