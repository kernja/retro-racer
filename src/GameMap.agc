

function LoadGameMap(pMap as string, pExtract as integer)
    rem show that we're loading
    LoadParsedImage(val(GetTextLibraryString(48)))
    SetSpriteImage(GAMEPLAY_SPRITE_LOADING, val(GetTextLibraryString(48)))
    SETSPRITEVISIBLE(GAMEPLAY_SPRITE_LOADING, 1)
    SyncOverride()

    fileID as integer
    tString as string
    count as integer
    i as integer
    flagCount as integer
    currentCurve as float
    currentHeight as float

    rem reset road data
    undim roadData[]
    roadDataCount = 1
    count = 1
    flagCount = 0
    rem reset all sprites to blank (middle of road)
    ResetMapSprites()

    rem reset player variables
    ResetPlayerVariables()

    //if pExtract = 1
    //    fileID = openToRead("download/map.rrc")
    //else
        fileID = openToRead(pMap)
    //endif

    rem read first line
    tString = readline(fileID)

    rem read in map name
    rem mapName = GetStringToken(tString, ",", 1)
    rem read in map properties
    for i = 0 to 9
        mapProperties[i] = valfloat(GetStringToken(tString, ",", i + 2))
            if i = 1
                mapProperties[i] = (mapProperties[i] * .1)
                currentHeight = mapProperties[i]
            endif
    next

    rem now read in what images we need to load
    count = val(readline(fileID))
    for i = 0 to count - 1
        tString = readline(fileID)
        LoadParsedImage(val(tString))
    next
    rem load in supplemental images
    rem for downloaded maps
    ParseSupplementalImagesFromFile()

    rem now actually apply those images. =)
    SetSpriteImage(1001, mapProperties[2])
    SetSpriteImage(1002, mapProperties[3])
    SetSpriteImage(1000, mapProperties[4])
    SetSpriteSize(1000, 961, 640)
    rem road
    DeleteImage(9)
    CopyImage(9, mapProperties[5], 0, 0, 256, 128)
    SetImageMagFilter(9, 0)
    SetImageMinFilter(9, 0)
    rem enemy
    DeleteImage(19)
    CopyImage(19, mapProperties[6], 0, 0, 512, 512)
    SetImageMagFilter(19, 0)
    SetImageMinFilter(19, 0)
    rem player
    DeleteImage(29)
    CopyImage(29, mapProperties[9], 0, 0, 1024, 768)
    SetImageMagFilter(29, 0)
    SetImageMinFilter(29, 0)

    rem read in data count
    roadDataCount = val(readline(fileID))
    roadDataCount = roadDataCount + 25
    dim roadData[roadDataCount]

    rem buffer out 25 spaces for a blank strech of road
    for i = 0 to 24
        roadData[i].X = 0
        roadData[i].Y = 0
        roadData[i].pBG = 0
        roadData[i].sBG = 0
        roadData[i].gBG = 0
        roadData[i].tBG = 0
        roadData[i].objLeft = 0
        roadData[i].objRight = 0
        roadData[i].laneA = 0
        roadData[i].laneB = 0
        roadData[i].laneC = 0
        roadData[i].checkpoint = 0
        roadData[i].finish = 0
    next

    rem read in all track data
    `while fileEOF(fileID) <> 1
    for i = 25 to roadDataCount
        tString = readline(fileID)
        roadData[i].X = (valfloat(GetStringToken(tString, ",", 2)) * .001)
        roadData[i].Y = (valfloat(GetStringToken(tString, ",", 3)) * .001)
        roadData[i].pBG = val(GetStringToken(tString, ",", 4))
        roadData[i].sBG = val(GetStringToken(tString, ",", 5))
        roadData[i].gBG = val(GetStringToken(tString, ",", 6))
        roadData[i].tBG = val(GetStringToken(tString, ",", 7))
        roadData[i].objLeft = val(GetStringToken(tString, ",", 8))
        roadData[i].objRight = val(GetStringToken(tString, ",", 9))
        roadData[i].laneA = val(GetStringToken(tString, ",", 10))
        roadData[i].laneB = val(GetStringToken(tString, ",", 11))
        roadData[i].laneC = val(GetStringToken(tString, ",", 12))
        roadData[i].checkpoint = val(GetStringToken(tString, ",", 13))
        roadData[i].finish = 0

        currentHeight = currentHeight + roadData[i].Y
        if currentHeight > 0
            currentHeight = 0
        endif

        if currentHeight < -1.5
            currentHeight = -1.5
        endif

        currentCurve = currentCurve + roadData[i].X
        `IMAGE_FLAG_LEFT
        `IMAGE_FLAG_LEFT
        if roadData[i].checkpoint = -1
            roadData[i].objLeft = IMAGE_FLAG_LEFT
            roadData[i].objRight = IMAGE_FLAG_RIGHT
        endif
    `endwhile
    next

    closefile(fileID)

    rem now we add buffer space for finish
    if playerGameplayMode = GAMEPLAY_MODE_CLASSIC or playerGameplayMode = GAMEPLAY_MODE_CLASSICM
        count = roadDataCount
        roadDataCount = roadDataCount + 1200
        dim roadData[roadDataCount]

        for i = count to roadDataCount - 1
            roadData[i].X = 0
            roadData[i].Y = 0
            roadData[i].pBG = 0
            roadData[i].sBG = 0
            roadData[i].gBG = 0
            roadData[i].tBG = 0
            roadData[i].objLeft = 0
            roadData[i].objRight = 0
            roadData[i].laneA = 0
            roadData[i].laneB = 0
            roadData[i].laneC = 0
            roadData[i].checkpoint = 0
            roadData[i].finish = 1

            if flagCount = 0
                roadData[i].objLeft = IMAGE_FLAG_LEFT
                roadData[i].objRight = IMAGE_FLAG_RIGHT
            endif


            flagCount = flagCount + 1

            if flagCount = 5
                roadData[i].objLeft = IMAGE_FLAG_LEFT
            endif

            if flagCount = 10
                roadData[i].objRight = IMAGE_FLAG_RIGHT

            endif

            if flagCount = 11
                            flagCount = 1
            endif

        next
    elseif playerGameplayMode = GAMEPLAY_MODE_END or playerGameplayMode = GAMEPLAY_MODE_ENDM
        count = roadDataCount
        roadDataCount = roadDataCount + 1000
        dim roadData[roadDataCount]

        for i = count to roadDataCount - 1
            roadData[i].X = AverageOverInterval(currentCurve, 0, 1000)
            roadData[i].Y = AverageOverInterval(currentHeight, mapProperties[1], 1000)
            roadData[i].pBG = 0
            roadData[i].sBG = 0
            roadData[i].gBG = 0
            roadData[i].tBG = 0
            roadData[i].objLeft = 0
            roadData[i].objRight = 0
            roadData[i].laneA = 0
            roadData[i].laneB = 0
            roadData[i].laneC = 0
            roadData[i].checkpoint = 0
            roadData[i].finish = 0

            if i = count
                roadData[i].checkpoint = -1
                roadData[i].objLeft = IMAGE_FLAG_LEFT
                roadData[i].objRight = IMAGE_FLAG_RIGHT
            endif

        next
    endif

    rem set up default values for rendering engine
    verticalOffset = mapProperties[1]
    currentRoadIndex = 24.0
    targetRoadIndex = 24.0
    `mapProperties[7] = 2

    REM HIDE LOADING SPRITE
    SETSPRITEVISIBLE(GAMEPLAY_SPRITE_LOADING, 0)
endfunction

function UpdateRoad()
    UpdateRoadStripes()
    targetRoadIndex = currentRoadIndex + (vehicleSpeed * GetFrameTime())

    if targetRoadIndex >= roadDataCount
        if playerGameplayMode = GAMEPLAY_MODE_CLASSIC or playerGameplayMode = GAMEPLAY_MODE_CLASSICM
            targetRoadIndex = roadDataCount
        else
            currentRoadIndex = 24
            targetRoadIndex = 24
        endif
    endif

    curInt as integer
    tarInt as integer
    i as integer
    j as integer

    curInt = round(currentRoadIndex)
    tarInt = round(targetRoadIndex)

    if tarInt > curInt
        rem loop through the pieces of track that we will be going through
        for i = curInt to tarInt - 1

            rem loop through all of the segments that need to be updated
            for j = 0 to 24
                ApplyRoadData(j, i - j)
            next
        next
    endif

    currentRoadIndex = targetRoadIndex
endfunction

function ApplyRoadData(pSegment as integer, pIndex as integer)
    i as integer

    rem we only want to do some things if it is on the first frame of road (furthest away)
    if pSegment = 0
        roadCurve = roadCurve + (roadData[pIndex].X * mirrorMap)
        verticalOffset = verticalOffset + roadData[pIndex].Y

        if verticalOffset < -1.5
            verticalOffset = -1.5
        endif

        if verticalOffset > 0
            verticalOffset = 0
        endif

        if roadData[pIndex].pBG > 0
            SetSpriteImage(1001, roadData[pIndex].pBG)
        endif

        if roadData[pIndex].sBG > 0
            SetSpriteImage(1002, roadData[pIndex].sBG)
        endif

        if roadData[pIndex].gBG > 0
            SetSpriteImage(1000, roadData[pIndex].gBG)
            SetSpriteSize(1000, 961, 640)

        endif

        if roadData[pIndex].tBG > 0
            deleteimage(9)
            copyimage(9, roadData[pIndex].tBG, 0, 0, 256, 128)
                SetImageMagFilter(9, 0)
                SetImageMinFilter(9, 0)
        endif
    endif

    if pSegment = 23
        carOffsetX = carOffsetX + (roadCurve)

        if roadData[pIndex].finish = 1
            playerFinish = 1
        endif

        if roadData[pIndex].checkpoint = -1
            StopSound(114)
            PlaySoundPref(102)

                if carState = CARSTATE_NORMAL
                    If GetMusicPlaying() = 0
                        ResumeGameMusic()
                    endif
                endif
            mapProperties[0] = mapProperties[0] + mapProperties[8]
        endif
    endif

    rem now we can add objects to the sides
    if roadData[pIndex].objLeft > 0
        SetSpriteImage(roadGroup[pSegment].sideSpriteID + 1000, roadData[pIndex].objLeft)
        SetSpriteVisible(roadGroup[pSegment].sideSpriteID + 1000, 1)
    `    SetSpriteVisible(roadGroup[round(spriteTest)].sideSpriteID + 1000, 1)
    else
        SetSpriteVisible(roadGroup[pSegment].sideSpriteID + 1000, 0)
    endif

    if roadData[pIndex].objRight > 0
        SetSpriteImage(roadGroup[pSegment].sideSpriteID + 2000, roadData[pIndex].objRight)
        SetSpriteVisible(roadGroup[pSegment].sideSpriteID + 2000, 1)
    `    SetSpriteVisible(roadGroup[round(spriteTest)].sideSpriteID + 2000, 1)
    else
        SetSpriteVisible(roadGroup[pSegment].sideSpriteID + 2000, 0)
    endif
endfunction

function CheckCreateSprite(pID, pSizeX, pSizeY)
    if GetSpriteExists(pID) = 0
        CreateSprite(pID, 0)
        SetSpriteSize(pID, pSizeX, pSizeY)
    endif
endfunction

function ResetMapSprites()
    i as integer

    rem create bg sprites
    rem black bar
    CheckCreateSprite(999, 960, 96)
    SetSpriteOffset(999, 0, 0)
    SetSpriteImage(999, 116)
    SetSpriteSize(999, 960, 96)
    SetSpritePosition(999, 0,544)
    SetSpriteDepth(999, 25)
    SetSpriteVisible(999, 0)

    rem create bg sprites
    rem background bottom
    CheckCreateSprite(1000, 961 , 640)
    SetSpriteOffset(1000, 0, 0)
    SetSpritePosition(1000, 0, 480 + SCREENY_OFFSET)
    SetSpriteDepth(1000, 5000)
    SetSpriteVisible(1000, 0)

    rem background top
    CheckCreateSprite(1001, 960, 320)
    SetSpriteOffset(1001, 0, 0)
    SetSpritePosition(1001, 0, SCREENY_OFFSET)
    SetSpriteDepth(1001, 5002)
    SetSpriteVisible(1001, 1)
    SetSpriteScale(1001, 2, 2)
    SetSpriteVisible(1001, 0)

    rem background top footer
    CheckCreateSprite(1002, 960, 16)
    SetSpriteOffset(1002, 0, 0)
    SetSpritePosition(1002, 0, SCREENY_OFFSET)
    SetSpriteDepth(1002, 5001)
    SetSpriteVisible(1002, 1)
    SetSpriteScale(1002, 2, 2)
    SetSpriteVisible(1002, 0)
    SetSpriteTransparency(1002, 1)
    rem car kickup
    CheckCreateSprite(1009, 256, 32)
    SetSpriteAnimation(1009, 256, 32, 4)
    SetSpriteOffset(1009, 128, 32)
    SetSpriteDepth(1009, 4700)
    SetSpriteImage(1009, 139)
    SetSpriteAnimation( 1009, 256, 32, 4 )
    SetSpritePositionByOffset(1009, 480, 320 + 300 + SCREENY_OFFSET)
    PlaySprite(1009, 60)
    SetSpriteVisible(1009, 0)

    rem car
    CheckCreateSprite(1010, 192, 256)
    SetSpriteSize(1010, 192, 256)
    SetSpriteOffset(1010, 96, 256)
    SetSpriteDepth(1010, 4700)
    SetSpritePositionByOffset(1010, 480, 320 + 300 + SCREENY_OFFSET)
    rem collision box for car
    `SetSpriteShapeBox(1010, -80, -80, 80, 0, 0)
    SetSpriteVisible(1010, 0)

    rem enemycars
    for i = 0 to 2
        DeleteSprite(1011 + i)
        CheckCreateSprite(1011 + i, 192, 256)
        SetSpriteImage(1011 + i, IMG_CARFIRST)
        SetSpriteSize(1011 + i, -1, -1)
        SetSpriteOffset(1011 + i, 96, 256)
        SetSpriteDepth(1011 + i, 5000)
        SetSpriteScale(1011 + i, .1, .1)
        SetSpriteVisible(1011 + i, 0)
        roadCars[i].spriteID = 1011 + i
        roadCars[i].position = 0
        roadCars[i].lane = -2
        roadCars[i].speed = 10
        roadCars[i].active = 0
        roadCars[i].imageID = IMG_CARFIRST
    next

    rem road sprites
    tempImageID as integer
    tempImageID = 10
    for i = 0 to 24
        for j = roadGroup[i].minSpriteID to roadGroup[i].maxSpriteID
            SetSpriteImage(j, tempImageID)
            SetSpritePositionByOffset(j, 480, 320 + j - 2000 + SCREENY_OFFSET)
            roadSprites[j - 2001].imageID = tempImageID
            SetSpriteVisible(j, 0)
        next

        tempImageID = tempImageID + 1

        if tempImageID = IMG_ROADMAX
            tempImageID = IMG_ROADMIN
        endif

        SyncOverride()
    next

    rem hide side objects
    for i = 0 to 24
        SetSpriteVisible(roadGroup[i].sideSpriteID + 1000, 0)
        SetSpriteVisible(roadGroup[i].sideSpriteID + 2000, 0)
    next
    rem set background to default location

endfunction

function SetGameplayVisible(pValue)
    i as integer
    j as integer

    rem backgrounds visible
    for i = 999 to 1002
        SetSpriteVisible(i, pValue)
    next

    rem car visible
    SetSpriteVisible(1010, pValue)

    rem car dust is always hidden
    SetSpriteVisible(1009, 0)

    rem enemy cars are hidden too
    for i = 1011 to 1013
        SetSpriteVisible(i, 0)
    next

    rem now road stuff
     for i = 0 to 24
            for j = roadGroup[i].minSpriteID to roadGroup[i].maxSpriteID
                SetSpriteVisible(j, pValue)
            next
    next

    rem hide side objects
    for i = 0 to 24
        SetSpriteVisible(roadGroup[i].sideSpriteID + 1000, 0)
        SetSpriteVisible(roadGroup[i].sideSpriteID + 2000, 0)
    next

    rem joystick
    SetJoystickVisible(pValue)

    rem hud
    for i = GAMEPLAY_TEXT_MIN to GAMEPLAY_TEXT_MAX
        SetTextVisible(i, pValue)
    next

    rem credits
    SetSpriteVisible(GAMEPLAY_SPRITE_CREDITS, 0)
endfunction

function SetCreditsVisible(pValue)
    i as integer
    j as integer

    rem backgrounds visible
    for i = 999 to 1002
        SetSpriteVisible(i, pValue)
    next

    rem always hide car
    SetSpriteVisible(1010, 0)

    rem car dust is always hidden
    SetSpriteVisible(1009, 0)

    rem hide all enemy cars except for the first one
    for i = 1011 to 1013
        SetSpriteVisible(i, 0)
    next

    SetSpriteVisible(1011, pValue)
    SetSpriteVisible(GAMEPLAY_SPRITE_CREDITS, pValue)

    rem now road stuff
     for i = 0 to 24
            for j = roadGroup[i].minSpriteID to roadGroup[i].maxSpriteID
                SetSpriteVisible(j, pValue)
            next
    next

    rem hide side objects
    for i = 0 to 24
        SetSpriteVisible(roadGroup[i].sideSpriteID + 1000, 0)
        SetSpriteVisible(roadGroup[i].sideSpriteID + 2000, 0)
    next

    rem joystick
    SetJoystickVisible(0)

    rem hud
    for i = GAMEPLAY_TEXT_MIN to GAMEPLAY_TEXT_MAX
        SetTextVisible(i, 0)
    next

endfunction

function SetJoystickVisible(pValue)
    rem joystick
    if GetVirtualJoystickExists(1) = 1
        SetVirtualJoystickActive(1, pValue)
        SetVirtualJoystickVisible(1, pValue)
    endif
endfunction

function InitRoadGroupings()
runningTotal as integer
currentGroup as integer
rem set initial values since this is the exception case
runningTotal = 1
currentGroup = 1

roadGroup[0].minSpriteID = 2001
roadGroup[0].maxSpriteID = 2001
roadGroup[0].sideSpriteID = 2001

rem loop through the rest
for i = 1 to 24
    currentGroup = currentGroup + 1

    roadGroup[i].minSpriteID = 2000 + runningTotal + 1
    roadGroup[i].maxSpriteID = 2000 + runningTotal + currentGroup

    if roadGroup[i].maxSpriteID > 2320
        roadGroup[i].maxSpriteID = 2320
    endif

    roadGroup[i].sideSpriteID = round((roadGroup[i].minSpriteID + roadGroup[i].maxSpriteID) * .5)

    runningTotal = runningTotal + currentGroup
next i
endfunction

function UpdateRoadStripes()
i as integer
switchImage as integer
spriteY as float

    for i = 0 to 319
        spriteY = 0
        switchImage = 0

        if vehicleSpeed < 80
            roadSprites[i].imageTimer = roadSprites[i].imageTimer + (GetFrameTime() * vehicleSpeed)
        else
            roadSprites[i].imageTimer = roadSprites[i].imageTimer + (GetFrameTime() * 80)
        endif

        spriteY = GetSpriteY(roadSprites[i].spriteID)

        if i < 160
            SetSpritePositionByOffset(roadSprites[i].spriteID, 480 + (roadCurve * roadSprites[i].multiplier) + (carOffsetX * (i / 320.0)) , 480 + ((159 - i) * verticalOffset) + SCREENY_OFFSET)

            if GetSpriteExists(roadSprites[i].spriteID + 1000) = 1
                SetSpritePositionByOffset(roadSprites[i].spriteID + 1000, 480 + (roadCurve * roadSprites[i].multiplier) + (carOffsetX * (i / 320.0)) + (roadSprites[i].scale * -340) , 480 + ((159 - i) * verticalOffset) + SCREENY_OFFSET)
                SetSpritePositionByOffset(roadSprites[i].spriteID + 2000, 480 + (roadCurve * roadSprites[i].multiplier) + (carOffsetX * (i / 320.0)) + (roadSprites[i].scale * 340), 480 + ((159 - i) * verticalOffset) + SCREENY_OFFSET)
            endif
        else
            if GetSpriteExists(roadSprites[i].spriteID + 1000) = 1
                SetSpritePositionByOffset(roadSprites[i].spriteID + 1000, 480 + (roadCurve * roadSprites[i].multiplier) + (carOffsetX * (i / 320.0)) + (roadSprites[i].scale * -340) , spriteY )
                SetSpritePositionByOffset(roadSprites[i].spriteID + 2000, 480 + (roadCurve * roadSprites[i].multiplier) + (carOffsetX * (i / 320.0)) + (roadSprites[i].scale * 340), spriteY )
            endif

            SetSpritePositionByOffset(roadSprites[i].spriteID, 480 + (roadCurve * roadSprites[i].multiplier) + (carOffsetX * (i / 320.0)), spriteY)
        endif

        switchImage = switchImage + trunc(roadSprites[i].imageTimer)
        roadSprites[i].imageTimer = roadSprites[i].imageTimer - trunc(roadSprites[i].imageTimer)
        `while roadSprites[i].imageTimer >= 1
        `    switchImage = switchImage + 1
        `    roadSprites[i].imageTimer = roadSprites[i].imageTimer - 1
        `endwhile

      `  if roadSprites[i].imageTimer >=1
       `     roadSprites[i].imageTimer = roadSprites[i].imageTimer - 1
       `     switchImage = 1
       ` endif

        if switchImage > 0
            roadSprites[i].imageID = roadSprites[i].imageID - switchImage

            while roadSprites[i].imageID < IMG_ROADMIN
                roadSprites[i].imageID = roadSprites[i].imageID + 4
            endwhile

            SetSpriteImage(roadSprites[i].spriteID, roadSprites[i].imageID)
        endif

    next
endfunction

function CreateRoadStripes()
i as integer
j as integer
    for i = 0 to 24
        for j = roadGroup[i].minSpriteID to roadGroup[i].maxSpriteID
            CreateSprite(j, IMG_BLANKROAD)
            SetSpriteOffset(j, 512, 0)
            SetSpriteDepth(j, 5000 - j + 2000)

            scale as float
            scale = ((j - 2000) * 2) / 320.0
            scale = scale - (.2 * sin((j - 2000) * .7))
            SetSpriteImage(j, IMG_BLANKROAD)

            if j > 2030
                SetSpriteScaleByOffset(j, scale, scale * .1)
            else
                SetSpriteScaleByOffset(j, scale, scale * .8)
            endif

            SetSpritePositionByOffset(j, 480, 320 + j - 2000 + SCREENY_OFFSET)
            SetSpriteTransparency(j, 1)

            roadSprites[j - 2001].scale = scale
            roadSprites[j - 2001].depth = 5000 - j + 2000
            roadSprites[j - 2001].spriteID = j
            roadSprites[j - 2001].imageID = 10
            roadSprites[j - 2001].imageTimer = 1
            roadSprites[j - 2001].multiplier = 25.0 * tan(((280 - j + 2000)) / 4)

            SyncOverride()
        next
    next

    for i = 0 to 24
        CreateSprite(1000 + roadGroup[i].sideSpriteID, 0)
        SetSpriteSize(1000 + roadGroup[i].sideSpriteID, 256, 256)
        SetSpriteOffset(1000 + roadGroup[i].sideSpriteID, 256, 256)
        SetSpriteDepth(1000 + roadGroup[i].sideSpriteID, 5000 - roadGroup[i].sideSpriteID + 2000 + 1)

        CreateSprite(2000 + roadGroup[i].sideSpriteID, 0)
        SetSpriteSize(2000 + roadGroup[i].sideSpriteID, 256, 256)
        SetSpriteOffset(2000 + roadGroup[i].sideSpriteID, 0, 256)
        SetSpriteDepth(2000 + roadGroup[i].sideSpriteID, 5000 - roadGroup[i].sideSpriteID + 2000 + 1)

        scale as float
        scale = ((roadGroup[i].sideSpriteID - 2000) * 2) / 320.0
        scale = scale - (.2 * sin((roadGroup[i].sideSpriteID - 2000) * .7))
        SetSpriteScaleByOffset(roadGroup[i].sideSpriteID + 1000, scale, scale)
        SetSpriteScaleByOffset(roadGroup[i].sideSpriteID + 2000, scale, scale)

        SetSpriteVisible(roadGroup[i].sideSpriteID + 1000, 0)
        SetSpriteVisible(roadGroup[i].sideSpriteID + 2000, 0)
    next

    rem create all sprites here too
    ResetMapSprites()
endfunction

Function GetRoadPositionGroup(pLane as integer)
    i as integer
    myReturn as integer

    for i = 0 to 24
        if roadGroup[i].minSpriteID <= roadSprites[pLane].spriteID and roadGroup[i].maxSpriteID >= roadSprites[pLane].spriteID
            myReturn = i
            exit
        endif
    next

Endfunction myReturn

Function CanChangeLanes(pIndex as integer, pLaneGroup as integer)
    i as integer
    myReturn as integer
    myReturn = 1

    if pLaneGroup >= 18
        myReturn = 0
    endif


    if myReturn = 1
        for i = 0 to 2
            if roadCars[i].changingLanes = 1
                myReturn = 0
            endif
        next
    endif

endfunction myReturn

Function IsLaneFree(pIndex as integer, pLane as integer)
    i as integer
    myReturn as integer
    myReturn = 1

    for i = 0 to 2
        if round(roadCars[i].lane) = round(pLane)
            myReturn = 0
        endif
    next

endfunction myReturn

Function GetFreeLane()
    myReturn as integer
    i as integer

    myReturn = -2

    for i = -1 to 1
        if IsLaneFree(-1, i) = 1
            myReturn = i
        endif
    next

endfunction myReturn

Function CanSpawnVehicle()
    myReturn as integer
    myCount as integer
    myCount = 0
    myReturn = 0

    i as integer

    for i = 0 to 2
        if roadCars[i].active = 0
            myCount = myCount + 1
            myReturn = 1
        endif
    next i

    rem make it easier for easy difficulty
    rem force that there is always one car in reserve

    if mapProperties[7] <= 0
        if myCount = 1
            myReturn = 0
        endif
    endif


    for i = 0 to 2
        if roadCars[i].changingLanes = 1
            myReturn = 0
        endif
    next i

endfunction myReturn


function ResetPlayerVariables()
rem player car variables
    carBrake = 0
    carState = CARSTATE_NORMAL
    carOffsetX = 0.0
    oldOffsetX = 0.0
    vehicleSpeed = 0.0
    verticalOffset = 0.0
    roadCurve = 0.0
    offroadTime = 0.0
    carCrashY = 0.0
    carSwipeLeft = 0.0
    carSwipeRight = 0.0
    carCrashDegree = 179.9
    playerScore = 0
    playerFinish = 0
    playerTotalTime = 0.0
endfunction

function AverageOverInterval(pSource as float, pTarget as float, pIntervals as float)
    myReturn as float
    myReturn = (pTarget - pSource) / pIntervals

endfunction myReturn
