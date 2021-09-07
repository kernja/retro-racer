
function DownloadFile(pHost as string, pFileRemote as string, pFileLocal as string, pTimeout as float)

    rem create variable to monitor download status
    myReturn as integer
    myReturn = DOWNLOAD_ACTIVE
    fileProgress as float
    fileProgress = 0

    rem create download time variable
    downloadTime as float
    downloadTime = 0

    rem first fraame
    downloadFirstFrame as integer
    downloadFirstFrame = 1

    rem create httpConnection so that we can go download from the host
    myHttpConnection as integer
    myHttpConnection = CreateHttpConnection()
    rem connect to the host
    SetHttpHost(myHttpConnection, pHost, 0)

    rem delete local file
    DeleteFile(pFileLocal)

    rem verify we have a connection grrrrrrr
    if SendHttpRequest(myHttpConnection, "index.php") = ""
        myReturn = DOWNLOAD_NOHOST
    endif

    rem delcare variable to hold the downloaded process ID
    downloadFileID as integer
    downloadFileID = GetHTTPFile(myHttpConnection, pFileRemote, pFileLocal)
    rem system loop
    while myReturn = DOWNLOAD_ACTIVE

      rem only go through this if the file is currently being downloaded, e.g., not complete or timed out
      if myReturn = DOWNLOAD_ACTIVE
            rem verify that the file hasn't completely arrived yet
             if GetHTTPFileComplete(myHttpConnection) = 0
                rem increase downloadtime variable in case we timeout

                    downloadTime = downloadTime + GetFrameTime()


                fileProgress = GetHTTPFileProgress(myHttpConnection)
                rem verify that we haven't timed out
                if downloadTime >= pTimeout
                    rem cleanup
                    downloadTime = 0
                    rem set progress var to -1, that we timedout.
                    myReturn = DOWNLOAD_TIMEOUT
                endif
             else


                myReturn = DOWNLOAD_VERIFYING
             endif
        endif

        if debugMode = 1
            print("Download Time: " + str(downloadTime))
        endif
        SyncOverride()

    endwhile

    rem close the http connection since we don't need it anymore
    closehttpconnection(myHttpConnection)

    rem declare the fileID used to reference the file we just downloaded
    openFileID as integer

    rem verify the file downloaded correctly
    if myReturn = DOWNLOAD_VERIFYING
        rem open file to read

        if getfileexists(pFileLocal) = 1
            openFileID as integer
            openFileID = 1
            opentoread(openFileID, pFileLocal)
            `message(str(fileeof(openFileID)))
            rem if the file size is greater than zero, it downloaded correctly

            if getfilesize(openFileID) > 128 and fileEOF(openFileID) = 0
                myReturn = DOWNLOAD_SUCCESS
                closefile(openFileID)
            else
                rem if not, it is an empty file and failed
                closefile(openFileID)
                myReturn = DOWNLOAD_NOHOST
                rem delete the zero length file
                NullFile(pFileLocal)
            endif
        else
                myReturn = DOWNLOAD_NOHOST
                rem delete the zero length file
                NullFile(pFileLocal)
        endif
    else
        rem if the download is interrupted while downloading, it will time out
        myReturn = DOWNLOAD_TIMEOUT
        rem kill the file since we don't need it
        NullFile(pFileLocal)
    endif

endfunction myReturn

Function ExtractZipFile(pPath as string, pTarget as string, pKeep as integer)
    extractzip(pPath, pTarget)
    if pKeep = 0
        DeleteFile(pPath)
    endif
endfunction


function EmptyDownloadDirectory()
    tPath as string
    tExit as integer

    DeleteFile("listings.zip")
    DeleteFile("download.zip")
    DeleteFile("download/listings.txt")
    DeleteFile("download/imageList.txt")
    DeleteFile("download/map.rrc")

    exitfunction
endfunction

Function NullFile(pPath as string)
    DeleteFile(pPath)
endfunction
