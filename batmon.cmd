@echo off
cls
cd /d %~dp0
set dt=%date%
set tm=%time%
set serial=%dt:~0,4%%dt:~5,2%%dt:~8,2%%tm:~0,2%%tm:~3,2%%tm:~6,2%

set LOG_FOLDER=.\Logs
set REPORT=%LOG_FOLDER%Battery_Report_%serial%.csv
set COMP_FILEPATH=.\data.zip
set LOG_FILES_WIN1=.\battery-report.html
set LOG_FILES_WIN2=.\energy-report.html
set LOG_FOLDER_HPBC_LOG=C:\ProgramData\Hewlett-Packard\HP Support Framework\Logs\Application\BatteryCheck
set BATMON_LOG=.\Logs\batmon.log
set xmlHPBCRep=.\sample.xml

:START
echo.
echo ============================================
echo  HP Battery Monitor Tool ver. 0.5
echo. 
echo    1. Start Battery Status logger
echo    2. Make report and compress all logs
echo    3. Exit
echo.
echo ============================================
set choice=
set /p choice=Select the number: 
if not '%choice%'=='' set choice=%choice:~0,1%
if '%choice%'=='1' goto LOGGER
if '%choice%'=='2' goto COMPRESS
if '%choice%'=='3' goto EXIT
echo "%choice%" is not valid please try again
echo.
goto START

:LOGGER
set interval=5
set /p interval=Sampling interval (min.) :
set /a "interval = interval*60"
echo Strat logging... > %BATMON_LOG%
echo. >> %BATMON_LOG%
powercfg /energy 
move %LOG_FILES_WIN2% %LOG_FOLDER% >> %BATMON_LOG%

echo Current Interval: %interval% >> %BATMON_LOG%
:ENDLESS
.\HPBC\HPBC.exe /s
timeout /nobreak /t %interval%
goto ENDLESS

:COMPRESS
echo =============================================== >> %BATMON_LOG%
echo -- Make report and compress all logs >> %BATMON_LOG%
echo -- Phase 1 - Copy all HPBC report  -- >> %BATMON_LOG%
echo. >> %BATMON_LOG%
robocopy %LOG_FOLDER_HPBC_LOG% %LOG_FOLDER% >> %BATMON_LOG%

echo. >> %BATMON_LOG%
echo -- Make report and compress all logs >> %BATMON_LOG%
echo -- Phase 2 - Capture Windows battery report  -- >> %BATMON_LOG%
echo. >> %BATMON_LOG%
powercfg /batteryreport
move %LOG_FILES_WIN1% %LOG_FOLDER% >> %BATMON_LOG%

echo. >> %BATMON_LOG%
echo -- Phase 3 - Making battery report -- >> %BATMON_LOG%
echo. >> %BATMON_LOG%
rem gawk -f .\script_awk.awk battery_report%date%.csv
rem HPBC report header
set xmlHEADER=id,author,price
echo %xmlHEADER% > %REPORT%
rem for /f "usebackq" %%i in ('dir /B /S C:\ProgramData\Hewlett-Packard\HP Support Framework\Logs\Application\BatteryCheck\*.xml') do (
rem	HPBC report field you want
rem	xml sel -t -v "//attribute/@*" -n %%i >> temp.1

rem )
echo. >> %BATMON_LOG%
echo -- Phase 4 - Compress -- >> %BATMON_LOG%
echo. >> %BATMON_LOG%
rem powershell set-ExecutionPolicy RemoteSigned
rem powershell .\zipper.ps1 %COMP_FILEPATH%

goto EXIT

:EXIT
echo EXIT
goto END

:END