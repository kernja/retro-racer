
function ParseImagesFromFile()
    fileID as integer
    tString as string
    count as integer

    count = 1

    fileID = openToRead("imageList.txt")
    tString = readline(fileID)

    while fileEOF(fileID) <> 1
        tString = readline(fileID)

        if val(GetStringToken(tString, ",", 1)) < 1000
            dim imageData[count]
            imageData[count - 1].imageID = val(GetStringToken(tString, ",", 1))
            imageData[count - 1].imagePath = GetStringToken(tString, ",", 2)
            imageData[count - 1].imageType = val(GetStringToken(tString, ",", 3))
            imageData[count - 1].imageName = GetStringToken(tString, ",", 4)
            imageData[count - 1].keepDelete = val(GetStringToken(tString, ",", 5))
            imageData[count - 1].flag0 = val(GetStringToken(tString, ",", 6))
            imageData[count - 1].magFilter = val(GetStringToken(tString, ",", 7))
            imageData[count - 1].minFilter = val(GetStringToken(tString, ",", 8))

            if imageData[count - 1].keepDelete = 1
                loadimage(imageData[count - 1].imageID, imageData[count - 1].imagePath)
                setImageMagfilter(imageData[count - 1].imageID, imageData[count - 1].magFilter)
                setImageMinfilter(imageData[count - 1].imageID, imageData[count - 1].minFilter)
            endif

            count = count + 1
        endif
    endwhile

    closefile(fileID)

    imageDataCount = count
endfunction


Function LoadParsedImage(pID as integer)
    i as integer

    if GetImageExists(pID) = 0
        for i = 0 to imageDataCount - 1
            if imageData[i].imageID = pID
                    loadimage(imageData[i].imageID, imageData[i].imagePath)
                    rem set texture to min and max filters
                    setimagemagfilter(imageData[i].imageID, imageData[i].magFilter)
                    setimageminfilter(imageData[i].imageID, imageData[i].minFilter)
                exit
            endif
        next
    endif

endfunction


function DeleteParsedImages()
    i as integer

    for i = 0 to imageDataCount - 1
        if imageData[i].keepDelete = 0
            deleteimage(imageData[i].imageID)
        endif
    next
endfunction


function ParseSupplementalImagesFromFile()
    fileID as integer
    tString as string

    if getfileExists("download/imageList.txt") = 1
        fileID = openToRead("download/imageList.txt")
        if getfilesize(fileID) > 128
        while fileEOF(fileID) <> 1
            tString = readline(fileID)

                if val(GetStringToken(tString, ",", 1)) >= 1000
                    deleteimage(val(GetStringToken(tString, ",", 1)))
                    loadimage(val(GetStringToken(tString, ",", 1)), GetStringToken(tString, ",", 2))
                    setImageMagfilter(val(GetStringToken(tString, ",", 1)), val(GetStringToken(tString, ",", 7)))
                    setImageMinfilter(val(GetStringToken(tString, ",", 1)), val(GetStringToken(tString, ",", 8)))
                endif
        endwhile
        endif
    closefile(fileID)
    endif
endfunction

function DeleteSupplementalImagesFromFile()
    fileID as integer
    tString as string

     if getfileExists("download/imageList.txt") = 1
        fileID = openToRead("download/imageList.txt")

        if getfilesize(fileID) > 128
            while fileEOF(fileID) <> 1
                tString = readline(fileID)
                tID as integer
                tPath as string

                tID = val(GetStringToken(tString, ",", 1))
                tPath = GetStringToken(tString, ",", 2)

                    if tID >= 1000
                        if getImageexists(tID) = 1
                            deleteimage(tID)
                            NullFile(tPath)
                        endif
                    endif
            endwhile
        endif
        closefile(fileID)

    endif
endfunction
