@echo off & title "customInstall"
REM customInstall
::  Run install of winget, then install current script according to parameter or input.

cd /D "%~dp0"

set "_parOneCustomInstall=%~1"
set "_checkParOneCustomInstall=-%_parOneCustomInstall%-"
set "_parTwoCustomInstall=%~2"
set "_checkParTwoCustomInstall=-%_parTwoCustomInstall%-"
set "_parThreeCustomInstall=%~3"                                
set "_checkParThreeCustomInstall=-%_parThreeCustomInstall%-"
set "_parFourCustomInstall=%~4"                                        
set "_checkParFourCustomInstall=-%_parFourCustomInstall%-"
set "_parFiveCustomInstall=%~5"                                        
set "_checkParFiveCustomInstall=-%_parFiveCustomInstall%-"
set "_parSixCustomInstall=%~6"                                        
set "_checkParSixCustomInstall=-%_parSixCustomInstall%-"
set "_parSevenCustomInstall=%~7"                                        
set "_checkParSevenCustomInstall=-%_parSevenCustomInstall%-"
set "_parEightCustomInstall=%~8"                                        
set "_checkParEightCustomInstall=-%_parEightCustomInstall%-"
set "_parNineCustomInstall=%~9"                                        
set "_checkParNineCustomInstall=-%_parNineCustomInstall%-"

if EXIST "_customScript.bat" (
 set "_parOneCustomInstall=200"
 set "_checkParOneCustomInstall=-200-"
)

:: Set cmdVar full path in variable, ensuring it can be used outside folder.
set "cmdVar=%~dp0cmdVar.bat"
setx cmdVar "%~dp0cmdVar.bat" /M

call :_startCustomInstall 1
goto:eof

:_startCustomInstall
if "%1"=="1" (
 if NOT EXIST initalize.txt (
  echo Installing winget: & rem
  powershell.exe -ExecutionPolicy Bypass -File "C:\Users\WDAGUtilityAccount\Desktop\sandbox\install-winget.ps1"
  echo ready > initalize.txt
  rem include current folder in path
  customInstall.bat
 ) else (
  if NOT EXIST skip.txt (
   rem check if notepad set for install
   if EXIST "install_notepad.txt" (
    winget install Notepad++.Notepad++ --source winget
    setx PATH "C:\Program Files\Notepad++;%PATH%"
    del /Q install_notepad.txt
   )
   echo Installing cygwin: & rem
   winget install cygwin.cygwin --source winget
   
   echo Setting Temp Path for Session: & rem
   set PATH=C:\cygwin64\bin\;%PATH%
   
   echo Setting User Path to Include cygwin: & rem
   setx PATH "C:\cygwin64\bin\;%PATH%"
   
   if "%_checkParOneCustomInstall%"=="--" (
    call :_selectingCall 1 & goto:eof
   ) else (
    echo %_parOneCustomInstall% | findstr /R "[0-9]" >nul 2>nul
    if ERRORLEVEL 1 (
     rem output options for use
     call :_selectingCall 1 & goto:eof
    ) else (
     rem use number
     call :_selectingCall 2 & goto:eof
    )
   )
  ) else (
   if NOT EXIST "DEFAULT.txt" (
    echo Download and Install Cygwin: & rem
    curl https://www.cygwin.com/setup-x86_64.exe -o setup-x86_64.exe
    setup-x86_64.exe
    echo Install Complete & rem
    call :_cleanCustomInstall 1 & goto:eof
   )
  )
 )
)
goto:eof

:_runCustomInstall
 if "%1"=="1" (
  call env.bat "%_parOneCustomInstall%"
  call :_cleanCustomInstall 1
 )
goto:eof

:_selectingCall
 if "%1"=="1" (
  echo Choose Number:
  rem NOTE - ensure to update condition in :_selectingCall
  type install_options.txt
  rem   echo 0  -^>  exit
  rem   echo 1  -^>  run :_curl_cygwin in env.bat
  rem   echo 2  -^>  run :_cygwin_gcc  in env.bat
  echo:
  set /P _parOneCustomInstall=
  call :_selectingCall 2 & goto:eof
 )
 if "%1"=="2" (
  if "%_parOneCustomInstall%"=="0" (
   set "_parOneCustomInstall=:_out"
  ) else if "%_parOneCustomInstall%"=="1" (
   set "_parOneCustomInstall=:_default"
  ) else if "%_parOneCustomInstall%"=="2" (
   set "_parOneCustomInstall=:_cygwin_gcc"
  ) else if "%_parOneCustomInstall%"=="3" (
   set "_parOneCustomInstall=:_curl_cygwin"
  ) else if "%_parOneCustomInstall%"=="200" (
   if EXIST "_customScript.bat" (
    set "_parOneCustomInstall=:_call_script"
   ) else (
    set "_parOneCustomInstall=:_default"
   )
  ) else (
   rem add new else if as needed
   set "_parOneCustomInstall=:_default"
  )
  
  call :_runCustomInstall 1 & goto:eof
 )
goto:eof

:_cleanCustomInstall
 set _parOneCustomInstall=
 set _checkParOneCustomInstall=
 set _parTwoCustomInstall=
 set _checkParTwoCustomInstall=
 set _parThreeCustomInstall=
 set _checkParThreeCustomInstall=
 set _parFourCustomInstall=
 set _checkParFourCustomInstall=
 set _parFiveCustomInstall=
 set _checkParFiveCustomInstall=
 set _parSixCustomInstall=
 set _checkParSixCustomInstall=
 set _parSevenCustomInstall=
 set _checkParSevenCustomInstall=
 set _parEightCustomInstall=
 set _checkParEightCustomInstall=
 set _parNineCustomInstall=
 set _checkParNineCustomInstall=
 if "%1"=="1" (  
  cd "%~dp0"
  del initalize.txt
  rm -rf https*
  echo Run Install Complete: & rem
  echo:
  echo What Happened?
  pause
 )
 exit /b
goto:eof