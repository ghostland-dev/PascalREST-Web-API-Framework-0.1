@echo off
SET THEFILE=C:\Users\imouy\Desktop\Playground\FreePascal - Playground\REST-API\FreePascalAPI.exe
echo Linking %THEFILE%
C:\lazarus\fpc\3.2.2\bin\x86_64-win64\ld.exe -b pei-x86-64  --gc-sections    --entry=_mainCRTStartup    -o "C:\Users\imouy\Desktop\Playground\FreePascal - Playground\REST-API\FreePascalAPI.exe" "C:\Users\imouy\Desktop\Playground\FreePascal - Playground\REST-API\link16780.res"
if errorlevel 1 goto linkend
goto end
:asmend
echo An error occurred while assembling %THEFILE%
goto end
:linkend
echo An error occurred while linking %THEFILE%
:end
