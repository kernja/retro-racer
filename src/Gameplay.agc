
function PlayGame(pMap as string, pExtract as integer)
    ResetPlayerVariables()
    LoadGameMap(pMap, pExtract)
    UpdateRoadStripes()

    carShakeX as integer
    carShakeY as integer
    rem update backdrop positions
    SetSpritePosition(1000, 0, GetSpriteY(2001))
    SetSpritePosition(1001, tBGX, GetSpriteY(1000) - 490 + (verticalOffset * 100))
    SetSpritePosition(1002, tBGX, GetSpriteY(1001) + 608)

    rem update joystick position
    if playerPrefControl = 0
        SetJoystickScreenPosition(160, 512, 192)
    else
        SetJoystickScreenPosition(800, 512, 192)
    endif

    rem set player car sprite to default
    SetSpriteImage(1010, 34)

    SetGameplayVisible(1)
    StopMusic()

        i as integer
        j as integer
        raceState as integer
                pauseResult as integer
                pauseResult = -1

    SetSpritePosition(1000, 0, GetSpriteY(2001))
    RenderGameplayStart()
    ResumeGameMusic()

    while raceState >= 0
        carShakeX = 0
        carShakeY = 0


        oldOffsetX = carOffsetX
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
     for i = 0 to 2
        rem update only if active :/
        if roadCars[i].active = 1
            roadCars[i].position = roadCars[i].position + (GetFrameTime() * -roadCars[i].speed) + (GetFrameTime() * vehicleSpeed)

            rem error check to make sure the cars are in focus
            if roadCars[i].position <= 0.0 or roadCars[i].position >= 319
                roadCars[i].position = 0
                roadCars[i].active = 0
                roadCars[i].lane = -2
                roadCars[i].targetLane = -2
                roadCars[i].changingLanes = 0
                setSpriteVisible(roadCars[i].spriteID, 0)
            else

            `if GetSpriteY(roadCars[i].spriteID) <= 32
             `    setSpriteVisible(roadCars[i].spriteID, 0)
            `else
                setSpriteVisible(roadCars[i].spriteID, 1)
            `endif
            endif


            rem automatically slow down car if it's behind us
            if roadCars[i].position >= 310
                roadCars[i].speed = vehicleSpeed * .8
            endif

            rem randomly decide to change lanes if not already changing
            if roadCars[i].changingLanes = 0
                if random(1,65535) < (2000 * (mapProperties[7] + 1))
                    if CanChangeLanes(i, roadCars[i].positionGroup) = 1

                        rem is in outermost lanes
                        if roadCars[i].lane = -1 or roadCars[i].lane = 1
                            if IsLaneFree(i, 0) = 1
                                roadCars[i].targetLane = 0
                                roadCars[i].changingLanes = 1
                            endif
                        else
                            rem center lane, tie break to see which one to go
                            if random(1, 2) = 1
                                if IsLaneFree(i, -1) = 1
                                    roadCars[i].targetLane = -1
                                    roadCars[i].changingLanes = 1
                                endif
                            else
                                if IsLaneFree(i, 1) = 1
                                    roadCars[i].targetLane = 1
                                    roadCars[i].changingLanes = 1
                                endif
                            endif
                        endif
                    endif
                endif
            endif

            if roadCars[i].targetLane > roadCars[i].lane
               roadCars[i].lane = roadCars[i].lane + (GetFrameTime() * .33)

               if roadCars[i].lane > roadCars[i].targetLane
                    roadCars[i].lane = roadCars[i].targetLane
                    roadCars[i].changingLanes = 0
               endif
            endif

            if roadCars[i].targetLane < roadCars[i].lane
               roadCars[i].lane = roadCars[i].lane - (GetFrameTime() * .33)

               if roadCars[i].lane < roadCars[i].targetLane
                    roadCars[i].lane = roadCars[i].targetLane
                    roadCars[i].changingLanes = 0
               endif
            endif

            roadCars[i].positionGroup = GetRoadPositionGroup(roadCars[i].position)

          `  if roadCars[i].positionGroup < 15
            `    SetSpriteFlip(roadCars[i].spriteID, 0, 0)
            `    SetSpriteImage(roadCars[i].spriteID, roadCars[i].imageID)
           ` else
                if GetSpriteXByOffset(roadCars[i].spriteID) > GetSpriteXByOffset(1010) + 96
                        SetSpriteFlip(roadCars[i].spriteID, 0, 0)
                        SetSpriteImage(roadCars[i].spriteID, roadCars[i].imageID + 1)

                    if mapProperties[7] = 2
                        if roadCars[i].speed > 30
                            roadCars[i].speed = roadCars[i].speed + (4 * GetFrameTime())
                        endif
                    endif
                elseif GetSpriteXByOffset(roadCars[i].spriteID) < GetSpriteXByOffset(1010) - 96
                        SetSpriteFlip(roadCars[i].spriteID, 1, 0)
                        SetSpriteImage(roadCars[i].spriteID, roadCars[i].imageID + 1)

                    if mapProperties[7] = 2
                        if roadCars[i].speed > 30
                            roadCars[i].speed = roadCars[i].speed + (4 * GetFrameTime())
                        endif
                    endif

                else
                    if mapProperties[7] = 2
                        if roadCars[i].speed > 30
                            roadCars[i].speed = roadCars[i].speed - (5 * GetFrameTime())

                            if roadCars[i].speed < 0
                                roadCars[i].speed = 0
                            endif
                        endif
                    endif

                    SetSpriteFlip(roadCars[i].spriteID, 0, 0)
                    SetSpriteImage(roadCars[i].spriteID, roadCars[i].imageID)
                endif
          `  endif

            SetSpriteOffset(roadCars[i].spriteID, GetSpriteWidth(roadCars[i].spriteID) * .5, GetSpriteHeight(roadCars[i].spriteID))
            SetSpriteDepth(roadCars[i].spriteID, roadSprites[round(roadCars[i].position)].depth + 2)
            SetSpriteScaleByOffset(roadCars[i].spriteID, roadSprites[round(roadCars[i].position)].scale * .5, roadSprites[round(roadCars[i].position)].scale * .5)
            SetSpritePositionByOffset(roadCars[i].spriteID, (roadCars[i].lane * 208 * roadSprites[round(roadCars[i].position)].scale) + 480 + (roadCurve * roadSprites[round(roadCars[i].position)].multiplier) + (carOffsetX * (round(roadCars[i].position) / 320.0)) , GetSpriteY(roadSprites[round(roadCars[i].position)].spriteID))

            if roadCars[i].positionGroup >= 21 and carState = CARSTATE_NORMAL
                if GetSpriteCollision(1010, roadCars[i].spriteID) = 1
                    if roadCars[i].collision = 0

                        rem collisions
                        rem first is side to side
                        if sqrt( (GetSpriteXByOffset(1010) - GetSpriteXByOffset(roadCars[i].spriteID)) ^ 2 + ((GetSpriteYByOffset(1010) - GetSpriteYByOffset(roadCars[i].spriteID)) ^ 2)) > 100
                             roadCars[i].collision = 1

                            if GetsoundInstances(SFX_CRASHSIDE) <= 2
                                PlaySoundPref(SFX_CRASHSIDE)
                                if playerFinish = 0
                                    playerScore = playerScore * .9
                                endif
                            endif

                            rem swipe to the right
                            if GetSpriteXByOffset(1010) > GetSpriteXByOffset(roadCars[i].spriteID)
                                carSwipeRight = carSwipeRight + (vehicleSpeed * .5)
                                carSwipeLeft = 0
                            else
                                carSwipeRight = 0
                                carSwipeLeft = carSwipeLeft + (vehicleSpeed * .5)
                            endif

                            roadCars[i].speed = roadCars[i].speed  + (vehicleSpeed * .5)

                            if roadCars[i].speed < (vehicleSpeed * 1.1)
                                roadCars[i].speed = vehicleSpeed * 1.1
                            endif


                            vehicleSpeed = vehicleSpeed * .65

                        else
                            roadCars[i].collision = 1
                            rem second is straight on behind collision
                            PlaySoundPref(SFX_CRASH2)
                            roadCars[i].speed =  roadCars[i].speed + (vehicleSpeed * .5)

                            if playerFinish = 0
                            playerScore = playerScore * .9
                            endif

                            if roadCars[i].speed < (vehicleSpeed * 1.1)
                                roadCars[i].speed = vehicleSpeed * 1.1
                            endif

                            vehicleSpeed = vehicleSpeed * .65

                        endif


                        roadCars[i].position = roadCars[i].position - 5


                        if roadCars[i].speed < 50
                            roadCars[i].speed = 50
                        endif
                  else
                        roadCars[i].collision = 0
                    endif

                endif
            else
                    roadCars[i].collision = 0
            endif

            if carState = CARSTATE_CRASH or carState = CARSTATE_RESET
                if roadCars[i].speed < 80
                    roadCars[i].speed = 80
                endif
            endif

        else
            if CanSpawnVehicle() = 1
                if random(1,65535) < (500 * (mapProperties[7] + 1))
                    tLane as integer
                    tLane = GetFreeLane()

                    if tLane > -2
                        if random(1, 2) = 1
                            roadCars[i].imageID = IMG_CARFIRST
                        else
                            roadCars[i].imageID = IMG_CARSECOND
                        endif
                       ` setSpriteImage(roadCars[i].spriteID, roadCars[i].imageID)
                        setSpriteVisible(roadCars[i].spriteID, 1)
                        roadCars[i].lane =  tLane
                        roadCars[i].targetLane = roadCars[i].lane
                        roadCars[i].speed = (random(50, 90) * (1.0 / (mapProperties[7] + 1.0)))
                        roadCars[i].active = 1
                        roadCars[i].changingLanes = 0
                        roadCars[i].position = 5
                    endif
                endif
            else
                roadCars[i].lane = -2
                roadCars[i].targetLane = -2
                roadCars[i].changingLanes = 0
            endif

            SetSpriteVisible(roadCars[i].spriteID, 0)
        endif
     next


        rem update car swiping to main vehicle
        carOffsetX = carOffsetX - (carSwipeRight * GetFrameTime() * 10)
        carOffsetX = carOffsetX + (carSwipeLeft * GetFrameTime() * 10)

        carSwipeRight = carSwipeRight - GetFrameTime() * 20
        carSwipeLeft = carSwipeLeft - GetFrameTime() * 20

        if carSwipeRight < 0
            carSwipeRight = 0
        endif

        if carSwipeLeft < 0
            carSwipeLeft = 0
        endif

        rem update background bg big
        SetSpritePosition(1000, 0, GetSpriteY(2001))
        tBGX as float
        tBGX = GetSpriteX(1001)

        tBGX = tBGX - roadCurve * (vehicleSpeed / 120.0)
        if tBGX > 0
            tBGX = tBGX - 960.0
        endif
        if tBGX < -960
            tBGX = tBGX + 960.0
        endif
        SetSpritePosition(1001, tBGX, GetSpriteY(1000) - 490 + (verticalOffset * 100))

        rem update background bg small
        tBGX = GetSpriteX(1002)
        tBGX = tBGX - roadCurve * (vehicleSpeed / 60.0)
        if tBGX > 0
            tBGX = tBGX - 960.0
        endif

        if tBGX < -960
            tBGX = tBGX + 960.0
        endif
        SetSpritePosition(1002, tBGX, GetSpriteY(1001) + 608)

        SetSpriteVisible(1009, 0)

        rem timer
        if playerFinish = 0
            rem we keep on ticking even if we're out of gas
            playerTotalTime = playerTotalTime + GetFrameTime()

            if mapProperties[0] > 0
                mapProperties[0] = mapProperties[0] - GetFrameTime()

                if mapProperties[0] < 0
                    mapProperties[0] = 0
                    rem music and sound
                    StopAllSounds()
                    StopMusic()
                    PlaySoundPref(114)
                endif
            endif
        endif

        rem car physics
        if carState = CARSTATE_NORMAL

            if playerFinish = 0
                tJoystickX as float
                tJoystickY as float

                tJoystickX = GetJoystickX()
                tJoystickY = GetJoystickY()

                rem always start at zero in case we do end up crashing
                carCrashDegree = 179.99
                carCrashY = 0
                crashOffsetX = 0

                if tJoystickX < 0
                    rem vehicle turning left
                    if carBrake = 0
                        SetSpriteImage(1010, 31)
                    else
                         SetSpriteImage(1010, 35)
                    endif
                elseif tJoystickX > 0
                    rem turning right
                    if carBrake = 0
                        SetSpriteImage(1010, 32)
                    else
                         SetSpriteImage(1010, 36)
                    endif
                else
                    rem vehicle forward
                    if carBrake = 0
                        SetSpriteImage(1010, 30)
                    else
                         SetSpriteImage(1010, 34)
                    endif
                endif

                    rem car turning code
                    if vehicleSpeed > 3
                        rem originally: carOffsetX = carOffsetX + (GetFrameTime() * tJoystickX * (-240 * (1-(vehicleSpeed / 200))))
                        carOffsetX = carOffsetX + (GetFrameTime() * tJoystickX * (-480 * (1-(vehicleSpeed / 200))))
                    endif

                    rem determine whether or not dust kickup is visible
                    if tJoystickX < 0 and oldOffsetX > carOffsetX
                        if random(1, 65535) > 44000
                            PlaySoundPref(SFX_TIRES)
                        endif

                        SetSpriteVisible(1009, 1)
                    endif
                    if tJoystickX > 0 and oldOffsetX < carOffsetX
                        if random(1, 65535) > 44000
                            PlaySoundPref(SFX_TIRES)
                        endif
                            SetSpriteVisible(1009, 1)
                    endif

                    rem accelerate car
                    if tJoystickY < 0 and mapProperties[0] > 0
                        vehicleSpeed = vehicleSpeed + (GetFrameTime() * ((-10 * tJoystickY) * ((sin(vehicleSpeed * 9)) + 1.25)))
                    elseif mapProperties[0] = 0
                        rem player has run out of gas
                        vehicleSpeed = vehicleSpeed + (GetFrameTime() * -5)

                        rem gameover
                        if vehicleSpeed <= 0
                            vehicleSpeed = 0

                                if GetSoundInstances(114) = 0
                                    rem change conditions based on gameplay mode
                                    if playerGameplayMode = GAMEPLAY_MODE_END or playerGameplayMode = GAMEPLAY_MODE_ENDM
                                        raceState = GAMERESULT_GOOD
                                    else
                                        raceState = GAMERESULT_BAD
                                    endif
                            endif
                        endif
                    endif

                    rem brake
                    if tJoystickY > 0
                        carBrake = 1
                        if vehicleSpeed > 5
                            SetSpriteVisible(1009, 1)
                        endif

                       if GetSoundInstances(SFX_BRAKESHORT) = 0 and vehicleSpeed > 0
                            PlaySoundPref(SFX_BRAKESHORT)

                        elseif vehicleSpeed = 0
                            stopsound(SFX_BRAKESHORT)
                        endif

                      vehicleSpeed = vehicleSpeed + (GetFrameTime() * -28 * tJoystickY)
                    elseif tJoystickY <= 0
                       carBrake = 0
                       stopsound(SFX_BRAKESHORT)
                    endif

                    rem car is offroad on the left
                    if carOffsetX > 565

                        offroadTime = offroadTime + GetFrameTime()
                        if vehicleSpeed > 15
                            carShakeX = random(1, 4) - 2
                            carShakeY = random(1, 4) - 2
                            vehicleSpeed = vehicleSpeed - GetFrameTime()  * 15
                        endif


                        if carOffsetX > 595

                        for i = 22 to 24
                            if getSpriteVisible(roadGroup[i].sideSpriteID + 1000) = 1 and carState = CARSTATE_NORMAL
                                carState = CARSTATE_CRASH
                                playerScore = playerScore * .5
                                crashOffsetX = -1

                                stopmusic()
                            endif
                        next
                        endif

                        if offroadTime >= .1 and vehicleSpeed > 15
                            offroadTime = 0
                            PlaySoundPref(SFX_SIDEROAD)
                        endif

                    elseif carOffsetX < -565


                        rem or offroad on the right
                        offroadTime = offroadTime + GetFrameTime()
                        if vehicleSpeed > 15
                            vehicleSpeed = vehicleSpeed - GetFrameTime()  * 15
                            carShakeX = random(1, 4) - 2
                            carShakeY = random(1, 4) - 2
                        endif

                        if carOffsetX < -595
                        for i = 22 to 24
                            if getSpriteVisible(roadGroup[i].sideSpriteID + 2000) = 1 and carState = CARSTATE_NORMAL
                                carState = CARSTATE_CRASH
                                playerScore = playerScore * .5
                                crashOffsetX = 1
                                 stopmusic()
                            endif
                        next
                        endif

                        if offroadTime >= .1 and vehicleSpeed > 15
                            offroadTime = 0
                            PlaySoundPref(SFX_SIDEROAD)
                        endif
                    else
                        offroadTime = .1
                    endif
            else

                SetSpriteSize(1010, 256, 256)
                SetSpriteOffset(1010, 128, 256)
                SetSpriteVisible(1009, 1)

                if vehicleSpeed > 0 or mapProperties[0] > 0

                    SetSpriteImage(1010, 37)
                    StopMusic()

                    if GetSoundInstances(101) = 0
                        PlaySoundPref(101)
                    endif

                    vehicleSpeed = vehicleSpeed - (GetFrameTime() * 25)
                    if vehicleSpeed < 0
                        vehicleSpeed = 0
                    endif

                    if mapProperties[0] > vehicleSpeed
                        vehicleSpeed = mapProperties[0]
                    endif

                    mapProperties[0] = mapProperties[0] - (GetFrameTime() * 15)
                    playerScore = playerScore + (GetFrameTime() * 3000)
                    if mapProperties[0] < 0
                        playerScore = playerScore + (mapProperties[0] * 200)
                        mapProperties[0] = 0
                    endif

                    SetTextVisible(GAMEPLAY_TEXT_MIN + 3, 0)
                else
                    SetSpriteImage(1010, 33)
                    SetSpriteVisible(1009, 0)
                    vehicleSpeed = 0
                    StopAllSounds()

                    PlaySoundPref(112)
                    while GetSoundInstances(112) > 0
                        SyncOverride()
                    endwhile

                    raceState = GAMERESULT_GOOD
                endif
            endif
        endif

        rem vehicle crashed
        if carState = CARSTATE_CRASH
            stopsound(SFX_BRAKESHORT)
            stopsound(SFX_SIDEROAD)
            carSwipeRight = 0
            carSwipeLeft = 0

            rem we crashed into something YAY
            carCrashDegree = carCrashDegree + (GetFrameTime() * 200)

            if carCrashDegree >= 180.0 or vehicleSpeed <= 0
                    carCrashDegree = 0
                    carCrashY = 0
                    StopMusic()
                    PlaySoundPref(SFX_CRASH3)

                if vehicleSpeed <= 0
                    carState = CARSTATE_RESET
                    carCrashY = 0
                    vehicleSpeed = 0
                endif

            endif

            carOffsetX = carOffsetX + (crashOffsetX * vehicleSpeed * GetFrameTime() * 10)
            carCrashY = sin(carCrashDegree) * vehicleSpeed * 5
            vehicleSpeed = vehicleSpeed - (GetFrameTime() * 45)

            if carCrashDegree > 170 or carCrashDegree < 10
                SetSpriteVisible(1009, 1)
                SetSpriteImage(1010, random(38, 41))
            else
                SetSpriteVisible(1009, 0)
            endif

        endif

        if debugMode = 1
            if GetRawMouseRightReleased() = 1
                currentRoadIndex = currentRoadIndex + 3000
            endif
        endif

        rem reset vehicle
        if carState = CARSTATE_RESET
            SetSpriteImage(1010, 30)

            if carOffsetX > 0
                carOffsetX = carOffsetX - (100 * GetFrameTime())
                    if carOffsetX < 0
                        carOffsetX = 0

                            carState = CARSTATE_NORMAL
                        if mapProperties[0] > 0
                            ResumeGameMusic()
                        endif
                    endif
            elseif carOffsetX < 0
                carOffsetX = carOffsetX + (100 * GetFrameTime())
                    if carOffsetX > 0
                        carOffsetX = 0
                        carState = CARSTATE_NORMAL

                        if mapProperties[0] > 0
                            ResumeGameMusic()
                        endif

                    endif
            endif
        endif

        rem add constraints onto vehicle speed
        if vehicleSpeed < 0
            vehicleSpeed = 0
        endif

        if vehicleSpeed > 150
            vehicleSpeed = 150
        endif

        playerScore = playerScore + (vehicleSpeed * GetFrameTime() * 6)

        rem play vehicle engine noise
        if vehicleSpeed > 0 and getsoundinstances(SFX_ENGINE2) = 0 and carState = CARSTATE_NORMAL and mapProperties[0] > 0
            if playerPrefSFX = 1
                PlaySound(SFX_ENGINE2, 100, 1)
            endif
        elseif vehicleSpeed = 0 or carState = CARSTATE_CRASH or mapProperties[0] = 0
            stopsound(SFX_ENGINE2)
        endif

        rem update sprite position in case of car crash
        SetSpritePositionByOffset(1010, 480  + carShakeX, 320 + 300 - carCrashY + SCREENY_OFFSET + carShakeY)
        SetSpritePositionByOffset(1009, 480  + carShakeX, 320 + 300 - carCrashY + SCREENY_OFFSET + carShakeY)

        UpdateDisplay()
        rem update option menu
`
        if GetTextVisible(GAMEPLAY_TEXT_MIN + 3) = 1
            if CheckTextClick(GAMEPLAY_TEXT_MIN + 3, SFX_MESSAGE) = 1 or GetResumed() = 1
                SetJoystickVisible(0)
                PreparePauseMenu()

                pauseResult = renderPauseMenu()

                    if pauseResult = 0
                        raceState = GAMERESULT_EXIT
                        SetGameplayVisible(0)
                        `ResetMenuText()
                                            `PrepareStandardTrackMenu()
                    elseif pauseResult = 1
                        SetJoystickVisible(1)
                        ResetMenuText()
                        SetSpriteVisible(MENU_BG_SPRITE, 0)
                    else
                        raceState = GAMERESULT_RESTART
                        SetGameplayVisible(0)
                    endif
            endif
        endif

        if debugMode = 1
            print(GetFrameTime())
            print(currentRoadIndex)
        endif

        if pauseResult > 0 or pauseResult < 0
            SyncOverride()
        endif

    endwhile


    if playerGameplayMode = GAMEPLAY_MODE_END or playerGameplayMode = GAMEPLAY_MODE_ENDM
       playerScore = round(playerTotalTime)
    else
       playerScore = round(playerScore)
    endif

    StopMusic()
    StopAllSounds()
    SetGameplayVisible(0)
    DeleteSupplementalImagesFromFile()
endfunction raceState

function UpdateDisplay()
    tText as string
    tLen as integer
    tTextTime as string
    tTempSpeed as float
    tTextSpeed as string
    tTextSpeedAbbr as string

    tTextScore as string

    rem figure out time
    tText = str(round(mapProperties[0]))
    tLen = len(tText)
    tTextTime = "TIME" + Spaces(8 - tLen) + tText

    rem figure out speed
    if playerPrefMPH = 1
        tTempSpeed = vehicleSpeed
        tTextSpeedAbbr = "MPH"
    else
        tTempSpeed = (vehicleSpeed * 1.61)
        tTextSpeedAbbr = "KPH"
    endif

    tText = str(round(tTempSpeed))
    tLen = len(tText)
    tTextSpeed = "SPEED" + Spaces(4 - tLen) + tText + tTextSpeedAbbr

    rem figure out SCORE
    if playerGameplayMode = GAMEPLAY_MODE_CLASSIC or playerGameplayMode = GAMEPLAY_MODE_CLASSICM
        tText = str(round(playerScore))
        tLen = len(tText)
        tTextScore = "SCORE" + Spaces(7 - tLen) + tText
    else
        tText = str(round(playerTotalTime))
        tLen = len(tText)
        tTextScore = "SCORE" + Spaces(7 - tLen) + tText
    endif

    if playerPrefControl = 1
        LeftAlignText(GAMEPLAY_TEXT_MIN, tTextTime, 0, 544)
        LeftAlignText(GAMEPLAY_TEXT_MIN + 1, tTextSpeed, 0, 576)
        LeftAlignText(GAMEPLAY_TEXT_MIN + 2, tTextScore, 0, 608)
        LeftAlignText(GAMEPLAY_TEXT_MIN + 3, "PAUSE", 448, 576)
    else
        RightAlignText(GAMEPLAY_TEXT_MIN, tTextTime, 960, 544)
        RightAlignText(GAMEPLAY_TEXT_MIN + 1, tTextSpeed, 960, 576)
        RightAlignText(GAMEPLAY_TEXT_MIN + 2, tTextScore, 960, 608)
        LeftAlignText(GAMEPLAY_TEXT_MIN + 3, "PAUSE", 352, 576)
    endif
endfunction

function SyncOverride()
   if GetRawKeyState(27) = 1
        end
   endif

    Sync()
endfunction
