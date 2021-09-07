#include "SplitString.agc"
#include "parseImageList.agc"
#include "MenuSystem.agc"
#include "LoadTextFromString.agc"
#include "parseSoundList.agc"
#include "downloadManager.agc"
#include "GameMap.agc"
#include "Gameplay.agc"
#include "userPreferences.agc"
#include "trackListings.agc"
#include "credits.agc"
#include "scores.agc"

#constant FULLVERSION 1
#constant VERSIONID 100

#constant IMG_ROADATLAS 9
#constant IMG_ROADMIN 10
#constant IMG_ROADMAX 14
#constant IMG_CARATLAS 19
#constant IMG_CARFIRST 20
#constant IMG_CARSECOND 22

#constant IMG_BLANKROAD 115
#constant SFX_BRAKE 100
#constant SFX_BRAKESHORT 101
#constant SFX_CHECKPOINT 102
#constant SFX_CRASH2 103
#constant SFX_CRASH3 104
#constant SFX_CRASH5 105
#constant SFX_CRASHSIDE 106
#constant SFX_ENGINE2 107
#constant SFX_SIDEROAD 108
#constant SFX_TIRES 109
#constant SFX_MESSAGE 110
#constant SFX_INTRO 111
#constant SFX_GET 116
#constant SCREEN_WIDTH 960
#constant SCREEN_HEIGHT 640
#constant DEFAULT_FONT 117

#constant CARSTATE_NORMAL 0
#constant CARSTATE_CRASH 1
#constant CARSTATE_RESET 2
#constant CARSTATE_FINISH 3
#constant SCREENY_OFFSET -96

rem handle gamestate changes
#constant GAMESTATE_MAINMENU = 0
#constant GAMESTATE_OPTIONS = 1
#constant GAMESTATE_ABOUT = 2

#constant GAMEPLAY_MODE_SELECT 0
#constant GAMEPLAY_MODE_CLASSIC 1
#constant GAMEPLAY_MODE_END 2
#constant GAMEPLAY_MODE_CLASSICM 3
#constant GAMEPLAY_MODE_ENDM 4
#constant GAMEPLAY_MODE_CREDITS 5

#constant DOWNLOAD_SUCCESS 2
#constant DOWNLOAD_VERIFYING 1
#constant DOWNLOAD_TIMEOUT -1
#constant DOWNLOAD_NOHOST -2
#constant DOWNLOAD_ACTIVE 3

#constant IMAGE_FLAG_LEFT 137
#constant IMAGE_FLAG_RIGHT 138

rem now actually load the map
#CONSTANT GAMERESULT_GOOD -1
#CONSTANT GAMERESULT_BAD -2
#CONSTANT GAMERESULT_EXIT -3
#CONSTANT GAMERESULT_RESTART -4

#constant MENU_BG_SPRITE 500
#constant MENU_IMAGE_SPRITE 501
#constant MENU_BG_IMAGE 118
#constant MENU_TEXT_HEADER 500
#constant MENU_TEXT_WEBSITE 599
#constant MENU_TEXT_BUTTON1 501
#constant MENU_TEXT_BUTTON2 502
#constant MENU_TEXT_MIN 503
#constant MENU_TEXT_MAX 509
#constant MENU_TEXT_LEFT_ALIGN 80
#constant MENU_TEXT_INPUT_OFFSET 16
#constant MENU_TEXT_SLIDER 510

#constant MENU_TITLE_SPRITE 499
#constant MENU_TITLE_IMAGE0 45
#constant MENU_TITLE_IMAGE1 46
#constant MENU_TITLE_IMAGE2 47

#constant MENU_TEXT_ABOUT 200
#constant MENU_TEXT_HOWTO 400
#constant MENU_MUSIC 1

#constant GAMEPLAY_TEXT_MIN 550
#constant GAMEPLAY_TEXT_MAX 553
#constant GAMEPLAY_SPRITE_START 502
#constant GAMEPLAY_SPRITE_LOADING 504
#constant GAMEPLAY_SPRITE_CREDITS 505

#constant GAME_MUSIC_START 2
#constant GAME_MUSIC_END 5


rem for the road
type typeRoadSprite
    scale as float
    depth as integer
    spriteID as integer
    imageID as integer
    imageTimer as float
    multiplier as float
    baseImageID as integer
endtype

rem type so we can group the individual road sprites together
type typeRoadGroup
    minSpriteID as integer
    maxSpriteID as integer
    sideSpriteID as integer
endtype

rem type that holds road segment data
type typeRoadData
    pBG as integer
    sBG as integer
    gBG as integer
    tBG as integer
    finish as integer
    checkpoint as integer
    objLeft as integer
    objRight as integer
    laneA as integer
    laneB as integer
    laneC as integer
    X as float
    Y as float
endtype

rem type that holds enemy car data
type typeEnemyCar
    lane as float
    position as float
    positionGroup as integer
    spriteID as integer
    active as integer
    changingLanes as integer
    targetLane as integer
    imageID as integer
    speed as float
    collision as integer
endtype

rem load all text data into the program
TYPE TYPE_TEXT_LIBRARY
    id as integer
    english as string
endtype

rem holds image data (being red into the app)
type typeImageData
    imageID as integer
    imagePath as string
    imageType as integer
    imageName as string
    keepDelete as integer
    flag0 as integer
    magFilter as integer
    minFilter as integer
endtype

rem default course data
type typeStandardCourseListing
    id as integer
    name as string
    file as string
    imageID as integer
    difficulty as integer
endtype


rem download course data
type typeDownloadCourseListing
    version as integer
    name as string
    file as string
    image as string
    author as string
    difficulty as integer
endtype

global gameState as integer

rem hold player preferences
global playerPrefMusic as integer
global playerPrefSFX as integer
global playerPrefMPH as integer
global playerPrefControl as integer
global playerPrefMirror as integer

rem hold debugMode
global debugMode as integer

rem set default values
playerPrefMusic = 1
playerPrefSFX = 1
playerPrefMPH = 1
playerPrefControl = 0
playerPrefMirror = 0
rem load in preferenaces file
LoadUserPrefs()

rem load inh in high score table
global dim playerModeFinish[4] as integer
global dim playerScores[4,9] as integer
LoadScores()


global dim TextList[1] as TYPE_Text_LIBRARY
global TextCount as integer
LoadTextFromCSV("text/eng.txt")

rem load sounds into memory
rem load music into memory
global dim soundList[] as integer
global soundCount as integer
soundCount = 0
ParseSoundsFromFile()
ParseMusicFromFile()

rem this holds music data for playing music
global lastSetMusic as integer
global lastSetMusicLoop as integer


rem load all images into memory
global imageDataCount as integer
global dim imageData[] as typeImageData
ParseImagesFromFile()

global standardListingCount as integer
global dim standardListings[1] as typeStandardCourseListing
rem now load it all in
ParseStandardListings()


global downloadListingCount as integer
global dim downloadListings[1] as typeDownloadCourseListing

rem load test map
global mapName as string
global dim mapProperties[10] as float
global dim roadData[] as typeRoadData
global roadDataCount as integer

rem player car variables
global carState as integer
global carBrake as integer
global crashOffsetX as integer
global carOffsetX as float
global oldOffsetX as float
global vehicleSpeed as float
global verticalOffset as float
global roadCurve as float
global offroadTime as float
global carCrashY as float
global carCrashDegree as float
global carSwipeLeft as float
global carSwipeRight as float
global playerScore as float
global playerFinish as integer
global playerTotalTime as float

global playerGameplayMode as integer
global playerTrackIndex as integer
global mirrorMap as integer

rem so we know what index we are in the map
global currentRoadIndex as float
global targetRoadIndex as float

global dim roadCars[3] as typeEnemyCar
rem init road groupings
global dim roadGroup[25] as typeRoadGroup
InitRoadGroupings()
rem create all sprites for the track
global dim roadSprites[320] as typeRoadSprite

Rem set default font image
SetTextDefaultFontImage(DEFAULT_FONT)
SetTextDefaultMagFilter(0)
SetTextDefaultMinFilter(0)

Rem load default road images into memory
rem these are special case as these images will NEVER be changed.
LoadImage(9, "demo/atlasGreenSm.png")
setImageMagfilter(9, 0)
SetImageMinFilter(9, 0)
LoadSubImage(10, 9, "one.png")
LoadSubImage(11, 9, "two.png")
LoadSubImage(12, 9, "thr.png")
LoadSubImage(13, 9, "for.png")
LoadImage(19, "images/vehicles/enemy01.png")
setImageMagfilter(19, 0)
SetImageMinFilter(19, 0)
LoadSubImage(20, 19, "one.png")
LoadSubImage(21, 19, "two.png")
LoadSubImage(22, 19, "thr.png")
LoadSubImage(23, 19, "for.png")
LoadImage(29, "images/vehicles/taurel.png")
setImageMagfilter(29, 0)
SetImageMinFilter(29, 0)
LoadSubImage(30, 29, "n.png")
LoadSubImage(31, 29, "l.png")
LoadSubImage(32, 29, "r.png")
LoadSubImage(33, 29, "b.png")
LoadSubImage(34, 29, "bn.png")
LoadSubImage(35, 29, "bl.png")
LoadSubImage(36, 29, "br.png")
LoadSubImage(37, 29, "bb.png")
LoadSubImage(38, 29, "c1.png")
LoadSubImage(39, 29, "c2.png")
LoadSubImage(40, 29, "c3.png")
LoadSubImage(41, 29, "c4.png")

sync()
rem default seggints
SetDisplayAspect( 4.0/3.0 )
SetVirtualResolution(960, 640)
SetOrientationAllowed(0, 0, 1, 1)
rem batch as many calls as we can at once
SetSortTextures(1)
sync()

EmptyDownloadDirectory()
HandleTitle()
InitMenuSystem()
PrepareMainMenu()

do
    if gameState = GAMESTATE_MAINMENU
        RenderMainMenu()
    endif

loop


Function GetDistance2D(x1 as float, x2 as float, y1 as float, y2 as float)
    myReturn as float
    myReturn  = sqrt( ((x2 - x1) ^ 2) + ((y2 - y1) ^ 2))
endfunction myReturn
