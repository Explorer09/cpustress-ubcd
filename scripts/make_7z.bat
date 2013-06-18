REM
REM Script to make a 7z package for CPUstress release.
REM
SET ARCHIVE_NAME=cpustress-2.3.4

CD ..

SET P7ZIP=
REM Poor man's 'which' command for batch script.
FOR %%i IN (7z.exe 7za.exe 7zr.exe) DO (
    IF "X%P7ZIP%"=="X" (
        SET P7ZIP=%%~$PATH:i
    )
)

IF "X%P7ZIP%"=="X" (
    ECHO ERROR: 7-zip is not found. Please download and install 7-zip here
    ECHO ^(http://www.7-zip.org/^).
    GOTO :EOF
)

IF EXIST "%ARCHIVE_NAME%" (
    DEL /P "%ARCHIVE_NAME%"
)
COPY cpustress "%ARCHIVE_NAME%"
"%P7ZIP%" a -t7z -mx=9 "%ARCHIVE_NAME%.7z" "%ARCHIVE_NAME%\*" -xr-!"%ARCHIVE_NAME%\build" -xr!*.txz -xr!*.gz -xr!bzImage
"%P7ZIP%" a -t7z -mx=0 "%ARCHIVE_NAME%.7z" "%ARCHIVE_NAME%\build.txz" "%ARCHIVE_NAME%\initrd.gz" "%ARCHIVE_NAME%\bzImage"
REM Delete the temp directory.
DEL /F "%ARCHIVE_NAME%"

ECHO Done.
