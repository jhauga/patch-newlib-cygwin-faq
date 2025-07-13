@echo off & title "CLOSE AFTER SANDBOX CLOSED - cygwin"
REM cygwin
:: Set the path for InstallWinget.wsb
:: useage: cygwin [1]
::  [1]  =  custome_script | initalize | mapped_script
::  custome_script =  Files in "scripts" folder used as "_customScript.bat" in sandbox.
::  initalize      =  Run only installing cygwin, and not winget.
::  mapped_script  =  Files mapped (usually with support repo) in "mapped
::                    NOTE - mapped files will have option appeded with "_runInstall.bat", 
::                           and/or "_current.bat" i.e. "curl_runInstall.bat".
:: Usage Example:
::  > cygwin "cygwin-htdocs"
::    - Use cygwin-htdocs as "_customScript.bat" in sandbox.
::  > cygwin "curl"
::    - Use mapped scripts for "curl" in sandbox environment.
::      i.e. "curl_runInstall.bat" and "curl_current.bat".
set "_helpLinesCygwin=16" & rem change as needed

:: Change to current folder where file is located.
cd /D "%~dp0"

:: Default or current sandbox run.
set "_defaultRun=newlib-cygwin"

set "_parOneCygwin=%~1"
set "_checkParOneCygwin=-%_parOneCygwin%-"
set "_parTwoCygwin=%~2"
set "_checkParTwoCygwin=-%_parTwoCygwin%-"
set "_parThreeCygwin=%~3"                                
set "_checkParThreeCygwin=-%_parThreeCygwin%-"
set "_parFourCygwin=%~4"                                        
set "_checkParFourCygwin=-%_parFourCygwin%-"
set "_parFiveCygwin=%~5"                                        
set "_checkParFiveCygwin=-%_parFiveCygwin%-"
set "_parSixCygwin=%~6"                                        
set "_checkParSixCygwin=-%_parSixCygwin%-"
set "_parSevenCygwin=%~7"                                        
set "_checkParSevenCygwin=-%_parSevenCygwin%-"
set "_parEightCygwin=%~8"                                        
set "_checkParEightCygwin=-%_parEightCygwin%-"
set "_parNineCygwin=%~9"                                        
set "_checkParNineCygwin=-%_parNineCygwin%-"

if "%_parOneCygwin%"=="-h" (
 call :_makeShiftHelpCygwin 1 & goto:eof
 goto _removeBatchVariablesCygwin
) else if "%_parOneCygwin%"=="/?" (
 call :_makeShiftHelpCygwin 1 & goto:eof
 goto _removeBatchVariablesCygwin
)

:: Process to ensure path is correct for config.
cd> tmpFileCygwinInstall.txt
sed -i "s/\\/-:-/g" tmpFileCygwinInstall.txt

:: Store current directory in variable - see cmdVar.bat
call cmdVar "type tmpFileCygwinInstall.txt" _curDir

:: Check if custom script passed as parOne.
if EXIST "scripts\%_parOneCygwin%.bat" (
 copy "scripts\%_parOneCygwin%.bat" "map\_customScript.bat" >nul 2>nul
 if EXIST "scripts\%_parOneCygwin%-install.bat" (
  copy "scripts\%_parOneCygwin%-install.bat" "map\install.bat"
 )
 if EXIST "scripts\%_parOneCygwin%-current.bat" (
  copy "scripts\%_parOneCygwin%-current.bat" "map\current.bat"
 )
 rem Add "scripts\current_A.bat" as needed
) else if EXIST "scripts\%_defaultRun%.bat" (
 copy "scripts\%_defaultRun%.bat" "map\_customScript.bat" >nul 2>nul
 if EXIST "scripts\%_defaultRun%-install.bat" (
  copy "scripts\%_defaultRun%-install.bat" "map\install.bat"
 )
 if EXIST "scripts\%_defaultRun%-current.bat" (
  copy "scripts\%_defaultRun%-current.bat" "map\current.bat"
 )
 rem Add "scripts\current_A.bat" as needed
)

:: Copy any include files.
if EXIST "include\*" (
 if NOT EXIST "map\include" mkdir map\include
 copy "include\*" map\include
)

:: Remove prior config if exists.
call :_prepForNewRun 1 start

if "%_checkParOneCygwin%"=="--" (
 set "_noParCygwin=1"
)

:: Start process for Sandbox.
call :_startCygwinInstall 1 & goto:eof

:: ***************************************************************************
:: START SCRIPT
:: Main subroutine of procedure.
:_startCygwinInstall
 if "%1"=="1" (
  rem update with current path
  sed -i -E -e "s/(<HostFolder>)(.*)(<\/HostFolder>)/\1%_curDir%\\sandbox\3/" -e "s/-:-/\\/g" runStartSandbox.wsb
  
  rem update with config option
  if "%_parOneCygwin%"=="curl" (
   sed -i -E "0,/(_configOption=).*/{s/(_configOption=).*/\1%_configOption%/}" sandbox\curl_current.bat
  )
  
  if DEFINED _noParCygwin (
   call :_startCygwinInstall --default
  ) else (
   if "%_parOneCygwin%"=="curl" (
    set "_runFileCygwin=curl_runInstall.bat"
    call :_startCygwinInstall --out-run
    call instructLine /I "Do you also want to install Notepad++ for debugging in Sandox?"
    call instructLine /I " input - yes or no"
    call instructLine /B
    set /P _installNotepad=
   ) 
   rem *** CUSTOM SCRIPTS - add new conditions as needed ***
   if EXIST "map\_customScript.bat" (
    call :_startCygwinInstall --default
    set "_customScriptCygwin=1"
   ) else (
    call :_startCygwinInstall --default
   )
  )

  call :_checkInstallNotepad 1
  echo:
  
  rem ****************************************************************************
  rem ****************************** SANDBOX STARTS ******************************
  rem ****************************************************************************
  rem start sandbox, mapping clean sandbox folder
  runStartSandbox.wsb
  
  rem remove tmp file for windows command line variable
  del tmpFileCygwinInstall.txt

  rem next part of process
  call :_startCygwinInstall 2 & goto:eof
 )
 if "%1"=="2" (
  rem output final notes on process
  call instructLine /I "Wait for Sandbox Process to Finish, then Press Enter to Close this Window:"       & rem
  TIMEOUT /T 3 >nul 2>nul
  if "%_parOneCygwin%"=="curl" (
   call instructLine /I "NOTE - closing after Sandbox session has ended will remove temp files of build." & rem
   call instructLine /I "NOTE - the entire install process should take around 15 minutes."                & rem
   call instructLine /I "NOTE - if needed delete runStartSandbox.wsb and sandbox folder after install."   & rem
  )
  call instructLine /B
  pause
  call instructLine /I "Delay of 15 seconds for Sandbox Task to Close"
  Timeout 15 >nul 2>nul
  call instructLine /B
  rem next part of process
  call :_startCygwinInstall 3 & goto:eof
 )
 if "%1"=="3" (
  rem if no sandbox process, delete folders used for build, keeping install
  call instructLine /I "Cleaning Sandbox:" & rem
  
  rem ensure sandbox is not running
  tasklist /fi "imagename eq WindowsSandboxServer.exe" | findstr "WindowsSandboxServer.exe" >nul 2>nul
  if ERRORLEVEL 1 (
   if "%_parOneCygwin%"=="curl" (
    if EXIST "sandbox\curl" move "sandbox\curl" curl >nul 2>nul
   )
   call :_prepForNewRun 1 close
  ) else (
   rem remove variables for process
   goto _removeBatchVariablesCygwin
  )
 )
 if "%1"=="--default" (
  set "_runFileCygwin=customInstall.bat"
  set _installNotepad=yes
  call :_startCygwinInstall --out-run
  goto:eof
 )
 if "%1"=="--out-run" (
  call instructLine /H "INSTRUCTIONS:"  
  call instructLine /I "When Sandbox Opens, open the mapped folder and double click '%_runFileCygwin%'." & rem
  call instructLine /B
  TIMEOUT /T 3 >nul 2>nul
  goto:eof
 )
goto:eof

:: Support subroutines.
:_prepForNewRun
 if "%1"=="1" (
  rem remove prior runStartSandbox if exists
  if EXIST runStartSandbox.wsb del /Q runStartSandbox.wsb >nul 2>nul
  if "%2"=="start" copy /Y StartSandbox.wsb runStartSandbox.wsb >nul 2>nul
  
  rem remove prior sandbox if exists
  if EXIST sandbox rmdir /S/Q sandbox >nul 2>nul
  if "%2"=="start" (
   xcopy /E/I map sandbox >nul 2>nul
   copy /Y cmdVar.bat sandbox\cmdVar.bat >nul 2>nul
  )
  
  rem if starting procedure, give option to specify config option
  if "%2"=="start" (
   if "%_checkParOneCygwin%"=="--" (
    set "_parOneCygwin=%_defaultRun%"
   ) else (
    if "%_parOneCygwin%"=="curl" (
     rem select configuration option
     call instructLine /I "Enter Corresponding DIGIT to Select Config Option:" & rem
     call instructLine /I "NOTE - press enter to use default --without-ssl option." & rem
     call instructLine /D
     call instructLine /B
     type config-options.txt
     call instructLine /B
     set /P _configOption=
     
     rem store number of lines in a variable
     FOR /F %%A in ('find /v /c "" ^< config-options.txt') DO set _numberOfOptions=%%A

     rem step 2 - allow batch to process variable change
     call :_prepForNewRun 2 & goto:eof
    )
    if "%_parOneCygwin%"=="initalize" (
     echo ready > sandbox\initalize.txt
     echo skip  > sandbox\skip.txt
    )
   )  
  ) else (
   rem remove variables for process
   goto _removeBatchVariablesCygwin
  )
 )
 if "%1"=="2" (
  if "%_parOneCygwin%"=="curl" (
   rem define config option per input
   if NOT DEFINED _configOption (
    set "_configOption=--without-ssl"
   ) else (
    rem ensure that correct digit was input
    echo %_configOption% | findstr /R [1-%_numberOfOptions%] >nul 2>nul
    if "%ERRORLEVEL%"=="0" (
     rem store appriopriate option in variable from input digit
     type config-options.txt | findstr "%_configOption%" | sed -E "s/^(%_configOption:~0,1%%)(.*)$/\2/" > _tmp-config-opt.txt
     call cmdVar "type _tmp-config-opt.txt" _configOption
     
     rem remove temp file
     del /Q _tmp-config-opt.txt >nul 2>nul
    ) else (
     echo Incorrect Input - Using Default --without-ssl & rem
     set "_configOption=--without-ssl"
    )
   )
  )
 )
goto:eof

:_checkInstallNotepad
 if "%1"=="1" (
  if /i "%_installNotepad%"=="yes" (
   echo yes> "sandbox\install_notepad.txt"
  )
 )
goto:eof

:_makeShiftHelpCygwin
 if "%1"=="1" (
  call instructLine /B
  setlocal EnableDelayedExpansion
  FOR /F "tokens=1* delims=:" %%a IN ('findstr /n "^" %~n0.bat') DO (
   if %%a LEQ %_helpLinesCygwin% (
    echo %%b
   )
  )  
  call instructLine /B
  set _muteOutCygwin=1
  endlocal
 )
 goto _removeBatchVariablesCygwin
goto:eof
:: END SCRIPT
:: ***************************************************************************
:: ***************************************************************************

:_removeBatchVariablesCygwin
 if NOT DEFINED _muteOutCygwin (
  call instructLine /I "Removing Variables from Process:" & rem
 ) else (
  set _muteOutCygwin=
 )
 set _parOneCygwin=
 set _checkParOneCygwin=
 set _parTwoCygwin=
 set _checkParTwoCygwin=
 set _parThreeCygwin=
 set _checkParThreeCygwin=
 set _parFourCygwin=
 set _checkParFourCygwin=
 set _parFiveCygwin=
 set _checkParFiveCygwin=
 set _parSixCygwin=
 set _checkParSixCygwin=
 set _parSevenCygwin=
 set _checkParSevenCygwin=
 set _parEightCygwin=
 set _checkParEightCygwin=
 set _parNineCygwin=
 set _checkParNineCygwin=
 set _curDir=
 set _configOption=
 set _numberOfOptions=
 
 rem append new variables
 set _noParCygwin=
 set _helpLinesCygwin=
 set _installNotepad=
 set _runFileCygwin=
 
 rem post call cleans
 if "%_customScriptCygwin%"=="1" (
  if EXIST "map\_customScript.bat" del "map\_customScript.bat" >nul 2>nul
  if EXIST "map\install.bat" del "map\install.bat"
  rem clean include files
  set _customScriptCygwin=
 )
 if EXIST "map\include\*" del /Q map\include\*
 
 
 exit /b
goto:eof