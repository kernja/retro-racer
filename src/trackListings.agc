function ParseDownloadListings()
    downloadListingCount = 0
    undim downloadListings[]

    fileID as integer
    tString as string
    count as integer

    count = 1


    fileID = openToRead("download/listings.txt")
    tString = readline(fileID)

    while fileEOF(fileID) <> 1
        tString = readline(fileID)
        `message(tString)
        `if val(GetStringToken(tString, ",", 1)) <= VERSIONID

         if VerifyCourseAppVersion(tString) = 1
            dim downloadListings[count]

            downloadListings[count - 1].version = val(GetStringToken(tString, ",", 1))
            downloadListings[count - 1].name = GetStringToken(tString, ",", 2)
            downloadListings[count - 1].file = GetStringToken(tString, ",", 3)
            downloadListings[count - 1].image = GetStringToken(tString, ",", 4)
            downloadListings[count - 1].author = GetStringToken(tString, ",", 5)
            downloadListings[count - 1].difficulty = val(GetStringToken(tString, ",", 6))
            count = count + 1
        endif
    endwhile

    closefile(fileID)

    downloadListingCount = count
endfunction

function VerifyCourseAppVersion(pString as string)
    myReturn as integer
    i as integer

    myReturn = 0

    for i = 1 to CountStringTokens((pString, "+"))
        if val(GetStringToken(pString, "+", i)) = VERSIONID
            myReturn = 1
            exit
        endif
    next

endfunction myReturn

function ParseStandardListings()
    standardListingCount = 0
    undim standardListings[]

    fileID as integer
    tString as string
    i as integer

    if FULLVERSION = 1
    fileID = openToRead("trackList.txt")
    else
    fileID = openToRead("trackListLite.txt")
    endif
    rem skip first line as it's header
    tString = readline(fileID)

    rem read next line as it's count
    tString = readline(fileID)
    standardListingCount = val(tString)
    rem redim array
    dim standardListings[standardListingCount]

    for i = 0 to standardListingCount - 1
        tString = readline(fileID)
        standardListings[i].id = val(GetStringToken(tString, ",", 1))
        standardListings[i].name = GetStringToken(tString, ",", 2)
        standardListings[i].file = GetStringToken(tString, ",", 3)
        standardListings[i].imageID = val(GetStringToken(tString, ",", 4))
        standardListings[i].difficulty = val(GetStringToken(tString, ",", 5))
    next

    closefile(fileID)
endfunction



