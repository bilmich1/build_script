@ECHO off

REM Make sure git exist
IF NOT EXIST "%ProgramW6432%\Git\bin" GOTO gitNotFound
SET PATH=%PATH%;%ProgramW6432%\Git\bin

CD "%~dp0\.."

REM Clone the master into the directory, a valid ssh key must be present
IF NOT EXIST "%cd%\optel_codebase" CALL git clone git@github.com:optelgroup/optel_codebase.git

REM Get the date to name the output file to create
FOR /f "tokens=2 delims==" %%a IN ('wmic OS Get localdatetime /value') DO SET "dt=%%a"
SET "YY=%dt:~2,2%" & SET "YYYY=%dt:~0,4%" & SET "MM=%dt:~4,2%" & SET "DD=%dt:~6,2%"
SET "HH=%dt:~8,2%" & SET "Min=%dt:~10,2%" & SET "Sec=%dt:~12,2%"
SET "fullstamp=%YYYY%-%MM%-%DD%_%HH%-%Min%-%Sec%"
REM echo fullstamp: "%fullstamp%"
MKDIR "%cd%\%fullstamp%"

CD "%cd%\optel_codebase"
CALL git pull

IF EXIST "%cd%\.fbuild" CALL RMDIR /S /Q "%cd%\.fbuild"
REM Activate the environement
CALL optel_activate.bat

REM Build All + Test
CALL fastbuild -summary -ide All+Test-x86-Debug All+Test-x86-DebugUnicode > "%cd%\..\%fullstamp%\build_log.txt"

REM Test Run
CALL fastbuild -summary -ide All+TestRun-x86-Debug > "%cd%\..\%fullstamp%\testDebug_log.txt"
CALL fastbuild -summary -ide All+TestRun-x86-DebugUnicode > "%cd%\..\%fullstamp%\testDebugUnicode_log.txt"

REM Check output for each
REM In Build log
REM     FBuild: OK: All+Test-x86-Debug
REM     FBuild: OK: All+Test-x86-DebugUnicode
SET result=FAILED
SET x86DebugBuildResult=1
SET x86DebugUnicodeBuildResult=1
SET x86DebugTestResult=1
SET x86DebugUnicodeTestResult=1 

FINDSTR /C:"FBuild: OK: All+Test-x86-Debug" "%cd%\..\%fullstamp%\build_log.txt"
IF %ERRORLEVEL%==0 SET x86DebugBuildResult=0

FINDSTR /C:"FBuild: OK: All+Test-x86-DebugUnicode" "%cd%\..\%fullstamp%\build_log.txt"
IF %ERRORLEVEL%==0 SET x86DebugUnicodeBuildResult=0

REM In Test Log
REM     FBuild: OK: All+TestRun-x86-Debug
REM     FBuild: OK: All+TestRun-x86-DebugUnicode
FINDSTR /C:"FBuild: OK: All+TestRun-x86-Debug" "%cd%\..\%fullstamp%\testDebug_log.txt"
IF %ERRORLEVEL%==0 SET x86DebugTestResult=0

FINDSTR /C:"FBuild: OK: All+TestRun-x86-DebugUnicode"  "%cd%\..\%fullstamp%\testDebugUnicode_log.txt"
IF %ERRORLEVEL%==0 SET x86DebugUnicodeTestResult=0

IF %x86DebugBuildResult% == 0 IF %x86DebugUnicodeBuildResult% == 0 IF %x86DebugTestResult% == 0 IF %x86DebugUnicodeTestResult% == 0 SET result=PASSED
ECHO result=%result%

REM Check for commit number
REM git log -n1 --format="%h"
FOR /F "USEBACKQ" %%F IN (`CALL git log -n1 --format^=\"%%h\"`) DO SET commitNumber=%%~F
ECHO commitNumber=%commitNumber%

CALL optel_deactivate.bat
CD ..

REM Rename the current ouput folder with the build result and commit number
REN "%fullstamp%" "%fullstamp%_%commitNumber%_%result%"

GOTO:EOF

:gitNotFound
    ECHO Git executable could not be found under "%ProgramW6432%\Git\bin"
    GOTO:EOF
ENDLOCAL