@ECHO OFF

@SET ARCHPATH=Archive
@SET PROGNAME=FAST
@SET ARCHNAME=FAST_v%1

@SET WINZIP="C:\Program Files (x86)\WinZip\WZZip"
@SET WINZIPSE="C:\Program Files (x86)\WinZip Self-Extractor\WZIPSE22\wzipse32.exe"

@SET TARZIP="C:\Program Files\7-Zip\7z.exe"

IF NOT "%1"==""  GOTO DeleteOld

@ECHO 
@ECHO  The syntax for creating an archive is "Archive <version>"
@ECHO.
@ECHO  Example:  "archive 7.01.00"

@GOTO Done

:DeleteOld
@IF EXIST ARCHTMP.zip DEL ARCHTMP.zip
@IF EXIST %ARCHNAME%.exe DEL %ARCHNAME%.exe
@IF EXIST %ARCHNAME%_all.exe DEL %ARCHNAME%_all.exe
@IF EXIST ARCHTMP.tar DEL ARCHTMP.tar
@IF EXIST %ARCHNAME%.tar.gz DEL %ARCHNAME%.tar.gz


:DoIt
@ECHO.
@ECHO --------------------------------------------------------------------------------------
@ECHO Archiving %PROGNAME% for general distribution on Windows.
@ECHO --------------------------------------------------------------------------------------
@ECHO.

@%WINZIP% -a -o -P ARCHTMP @ArcFiles.txt @ArcFilesWinOnly.txt
@%WINZIPSE% ARCHTMP.zip -d. -y -win32 -le -overwrite -st"Unzipping %PROGNAME%" -m Disclaimer.txt

@COPY ARCHTMP.exe %ARCHPATH%\%ARCHNAME%.exe
@DEL ARCHTMP.zip, ARCHTMP.exe

@ECHO.
@ECHO -------------------------------------------------------------------------------------
@ECHO Archiving %PROGNAME% for maintenance and internal use (including certification tests).
@ECHO --------------------------------------------------------------------------------------
@ECHO.

@%WINZIP% -a -o -P ARCHTMP @ArcFiles.txt @ArcFilesWinOnly.txt @ArcMaint.txt 
@%WINZIPSE% ARCHTMP.zip -d. -y -win32 -le -overwrite -st"Unzipping %PROGNAME%" -m Disclaimer.txt

@COPY ARCHTMP.exe %ARCHPATH%\%ARCHNAME%_all.exe
@DEL ARCHTMP.zip, ARCHTMP.exe


@ECHO --------------------------------------------------------------------------------------
@ECHO Archiving %PROGNAME% for general distribution (tar.gz).
@ECHO --------------------------------------------------------------------------------------
@ECHO.
@rem first create a tar file, then compress it (gzip allows only one file)
@%TARZIP% a -ttar ARCHTMP @ArcFiles.txt
@%TARZIP% a -tgzip ARCHTMP.tar.gz ARCHTMP.tar
@COPY ARCHTMP.tar.gz %ARCHPATH%\%ARCHNAME%.tar.gz
@DEL ARCHTMP.tar, ARCHTMP.tar.gz


:Done
@SET ARCHNAME=
@SET ARCHPATH=
@SET PROGNAME=
@SET WINZIP=
@SET WINZIPSE=
@SET TARZIP=