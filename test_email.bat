@ECHO off

FOR /f "tokens=2 delims==" %%a IN ('wmic OS Get localdatetime /value') DO SET "dt=%%a"
SET "YY=%dt:~2,2%" & SET "YYYY=%dt:~0,4%" & SET "MM=%dt:~4,2%" & SET "DD=%dt:~6,2%"
SET "HH=%dt:~8,2%" & SET "Min=%dt:~10,2%" & SET "Sec=%dt:~12,2%"
SET "fullstamp=%YYYY%-%MM%-%DD%_%HH%-%Min%-%Sec%"

SET commitNumber=lerbflwebl33n543
SET result=FAILED

IF %result%==FAILED blat.exe -p gmailsmtp -to "%1" -subject "Build Failure" -body "Timestamp: %fullstamp%|Commit Number: %commitNumber%" -server 127.0.0.1:1099