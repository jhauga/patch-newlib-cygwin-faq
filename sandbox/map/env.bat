@echo off & title "Sandbox"
REM env
::  Run env script using parameter to call function.
::  NOTE - using _parOneEnv to call main subroutine as
::         this could be used with additional subroutines to
::         test different builds of curl.
 
:: Global variables.
set _configOption=--without-ssl
set "_parOneEnv=%~1"
set "_checkParOneEnv=-%_parOneEnv%-"
set "_parTwoEnv=%~2"
set "_checkParTwoEnv=-%_parTwoEnv%-"

:: Safety condition before beginning process.
if "%_checkParOneEnv%"=="--" (
 echo Using Default Sandbox:
 set "_parOneEnv=:_default"
 call :_startEnv 1
) else (
 rem start installation
 call :_startEnv 1
)
goto:eof

:_startEnv
 if "%1"=="1" (
  curl https://www.cygwin.com/setup-x86_64.exe -o "C:\cygwin64\bin\pkg.exe"
  call %_parOneEnv% 1 & goto:eof
 )
goto:eof

rem option 1
:_default
 if "%1"=="1" (
  echo Running Sandbx with cygwin Installed:
  start
  call :_default 2 & goto:eof
 )
 rem KEEP - delete comment when default subroutine changes
 if "%1"=="2" (
  call :_out 1 & goto:eof
 )
goto:eof
rem option 2
:_cygwin_gcc
 if "%1"=="1" (
  rem download makeshift package management executable from cygwin
  echo Preparing to Install Required cygwin Packages: & rem

  cls
  echo SEARCH PACKAGES IN CYGWIN SELECT PACKAGES WINDOW:
  echo *************************************************
  echo:
  echo gcc-core
  
  rem use condensed name to get packages
  pkg -P gcc-core
  
  rem next part of process
  call %_parOneEnv% 2 & goto:eof
 )
 if "%1"=="2" (
  call :_out 1 & goto:eof
 )
goto:eof
rem option 3
:_curl_cygwin
 if "%1"=="1" (  
  curl -s https://curl.se/download.html | findstr "https://mirrors.kernel.org/sources.redhat.com/cygwin/x86_64/release/curl/curl-" | head -n 1 | sed -E "s/^(.*) href=\"(.*)\"(.*)$/\2/" > curl_download_uri.txt
  call cmdVar "type curl_download_uri.txt" _curlDownload
  del /Q curl_download_uri.txt
  call %_parOneEnv% 2 & goto:eof
 )
 if "%1"=="2" ( 
  rem download makeshift package management executable from cygwin
  echo Preparing to Install Required cygwin Packages: & rem
  cls
  echo SEARCH PACKAGES IN CYGWIN SELECT PACKAGES WINDOW:
  echo *************************************************
  echo:
  echo binutils
  echo gcc-core
  echo libpsl-devel
  echo libtool
  echo perl
  echo make
  echo:
  
  rem use condensed name to get packages
  pkg -P binutils -P gcc-core -P libpsl-devel -P libtool -P perl -P make
  
  rem next part of process
  call %_parOneEnv% 3 & goto:eof
 )
 if "%1"=="3" (
  echo Installing curl: & rem
  mkdir dump
  cd dump
  
  rem download for cygwin build
  rem use variable from start of process to get most recent
  curl %_curlDownload% -o src.tar.xz
  
  rem extract files and specify install for curl
  tar -xJf src.tar.xz & rm src.tar.xz
  move curl* tmp
  move tmp\curl-*.tar.xz curl.tar.xz
  
  rem extract install files for curl
  tar -xJf curl.tar.xz & rm curl.tar.xz
  move curl* ..\curl
  rm -rf tmp
  
  rem begin install process
  cd ..
  cd curl
  sh configure %_configOption%
  make
  
  rem next part of process
  call %_parOneEnv% 4 & goto:eof
 )
 if "%1"=="4" (
  echo Running Basic Commands to Test Install: & rem
  src\curl --help
  src\curl http://example.com
  src\curl -I http://example.com
  src\curl -H "accept-language: en-US,en;q=0.9" http://example.com
  src\curl -L http://example.com
  goto _removeBatchhVariablesEnv
 )
goto:eof
rem option 200
:_call_script
 if "%1"=="1" (
  echo Checking Custom Script: & rem
  if EXIST "_customScript.bat" (
   echo Using Custom Script: & rem
   call _customScript.bat
  ) else (
   echo Something Unexpected Happened:
   echo Custom script was not found.
   echo:
  )
  call :_out 1 & goto:eof
 )
 if "%1"=="2" (
  call :_out 1 & goto:eof
 )
goto:eof

:_out
 if "%1"=="1" (
  echo CONTINUE PROCESS AS NEEDED: & rem
  echo:
  pause
  start "CONTINUE TEST"
 )
 goto _removeBatchhVariablesEnv
goto:eof

:: Clean variables from process.
:_removeBatchhVariablesEnv
 set _parOneEnv=
 set _checkParOneEnv=
 set _parTwoEnv=
 set _checkParTwoEnv=
 set _configOption=
 set _curlDownload=
 
 exit /b
goto:eof
