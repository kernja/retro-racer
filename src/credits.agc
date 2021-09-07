rem now actually load the map

function PlayCredits()
    creditsScroll as float
    creditsScroll = 0
    creditsFinished as integer
    carFinished as integer
    setTimer as float

    playerGameplayMode = GAMEPLAY_MODE_CREDITS

    ResetPlayerVariables()
    LoadGameMap("maps/ending.rrc", 0)
    LoadParsedImage(241)
    SetSpriteImage(GAMEPLAY_SPRITE_CREDITS, 241)

        SetSpriteUV(GAMEPLAY_SPRITE_CREDITS, 0, 0, 0, 0.09375, 1, 0, 1, 0.09375)
    UpdateRoadStripes()

    rem update backdrop positions
    SetSpritePosition(1000, 0, GetSpriteY(2001))
    SetSpritePosition(1001, tBGX, GetSpriteY(1000) - 490 + (verticalOffset * 100))
    SetSpritePosition(1002, tBGX, GetSpriteY(1001) + 608)

    `SetGameplayVisible(1)
    SetCreditsVisible(1)
    StopMusic()


    i as integer
    j as integer

    SetSpritePosition(1000, 0, GetSpriteY(2001))
    PlayMusicPref(15, 1)
    vehicleSpeed = 0

    while setTimer <= 1
        oldOffsetX = carOffsetX

        if creditsFinished = 0
             if GetPointerState() = 1
                vehicleSpeed = vehicleSpeed + (GetFrameTime() * 120)
                if vehicleSpeed > 640
                    vehicleSpeed = 640
                endif

            else
                vehicleSpeed = vehicleSpeed + (GetFrameTime() * 10)
                if vehicleSpeed > 60
                    vehicleSpeed = 60
                endif
            endif



        else
            vehicleSpeed = 0
        endif

        UpdateRoad()

        if carOffsetX > 750
            carOffsetX = 750
        endif

        if carOffsetX < -750
            carOffsetX = -750
        endif

        if verticalOffset > 0
            verticalOffset = 0
        endif

        if verticalOffset < -1.5
            verticalOffset = -1.5
        endif

     rem update cars
     for i = 0 to 0

            if creditsFinished = 0
                roadCars[i].position = roadCars[i].position + (GetFrameTime() * -roadCars[i].speed) + (GetFrameTime() * vehicleSpeed)
                roadCars[i].position = 300
                roadCars[i].active = 0
                roadCars[i].lane = 0
                roadCars[i].targetLane = 0
                roadCars[i].changingLanes = 0
                roadCars[i].speed = 0
            else
                roadCars[i].speed = 400
                roadCars[i].position = roadCars[i].position + (GetFrameTime() * -roadCars[i].speed) + (GetFrameTime() * vehicleSpeed)

                if roadCars[i].position < 1
                    roadCars[i].position = 1
                    carFinished = 1
                endif
            endif
            setSpriteVisible(roadCars[i].spriteID, 1)

            roadCars[i].positionGroup = GetRoadPositionGroup(roadCars[i].position)

            SetSpriteOffset(roadCars[i].spriteID, GetSpriteWidth(roadCars[i].spriteID) * .5, GetSpriteHeight(roadCars[i].spriteID))
            SetSpriteDepth(roadCars[i].spriteID, roadSprites[round(roadCars[i].position)].depth + 2)
            SetSpriteScaleByOffset(roadCars[i].spriteID, roadSprites[round(roadCars[i].position)].scale * .5, roadSprites[round(roadCars[i].position)].scale * .5)
            SetSpritePositionByOffset(roadCars[i].spriteID, (roadCars[i].lane * 208 * roadSprites[round(roadCars[i].position)].scale) + 480 + (roadCurve * roadSprites[round(roadCars[i].position)].multiplier) + (carOffsetX * (round(roadCars[i].position) / 320.0)) , GetSpriteY(roadSprites[round(roadCars[i].position)].spriteID))

        SyncOverride()

        if GetPointerState() = 1
            creditsScroll = creditsScroll + (GetFrameTime() * .0170 * 8)
        else
            creditsScroll = creditsScroll + (GetFrameTime() * .0170)
        endif


        if creditsScroll > (1.0 - 0.09375)
            creditsScroll = 1.0 - 0.09375

                if creditsFinished = 0
                    StopMusic()
                endif

                creditsFinished = 1

        endif

        SetSpriteUV(GAMEPLAY_SPRITE_CREDITS, 0, creditsScroll, 0, creditsScroll + 0.09375, 1, creditsScroll, 1, creditsScroll + 0.09375)

        if carFinished = 1
            setTimer = setTimer + (GetFrameTime())
        endif

     next



    endwhile
    StopAllSounds()
    SetGameplayVisible(0)
    DeleteSupplementalImagesFromFile()
endfunction

