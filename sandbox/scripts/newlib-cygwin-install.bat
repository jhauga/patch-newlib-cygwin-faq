@echo off
REM newlib-cygwin-install
::  Create the documentation from newlib-cygwin.

set "_currentInstall=docs"  & rem install (default) docs make docs
set "_copyToCygwinHtdocs=1" & rem 0 (default) 1 if testing site doc edit
set "_cd=1"                 & rem 1 (defeault) 0 stays in cygwin
set "_curSandbox=%USERPROFILE%\Desktop\sandbox"
set "_include=%_curSandbox%\include"

rem -------------------------------------------------------------------------------------------------
rem INSTALL NEWLIB-CYGWIN
cd /D \cygwin64

mkdir oss\src
cd oss\src

git clone https://cygwin.com/git/newlib-cygwin.git

if EXIST "%_include%" (
 copy /Y "%_include%\"* newlib-cygwin\winsup\doc\ >nul 2>nul
)

call :_startNewlib-cygwin-install 1
goto:eof

:_startNewlib-cygwin-install
 if "%1"=="1" (
  cd ..\..

  mkdir oss\src\newlib-cygwin\build
  mkdir oss\install

  cd oss\src\newlib-cygwin\winsup
  sh ./autogen.sh

  cd ..\build

  if "%_currentInstall%"=="docs" (
   sh /oss/src/newlib-cygwin/configure --disable-dumper --without-cross-bootstrap
   make
   rem INSTALL NEWLIB-CYGWIN
   rem -------------------------------------------------------------------------------------------------
  ) else (
   sh /oss/src/newlib-cygwin/configure --prefix=/oss/install
   make
   make install
  )
  if "%_copyToCygwinHtdocs%"=="1" (
   call :_startNewlib-cygwin-install --cygwin-htdocs 1 & goto:eof
  ) else (
   call :_startNewlib-cygwin-install --complete & goto:eof
  )
 )
 if "%1"=="--cygwin-htdocs" (
  if "%2"=="1" (
   cd /D "%~dp0"
   echo ************************************************************************
   echo * IMPORTANT - httpd will install, and take several minutes.            *
   echo *                                                                      *
   echo * After which File Explorer will open. Double click current to continue.
   echo *                                                                      *
   pause
   echo *                                                                      *

   winget install ApacheLounge.httpd --source winget
   echo *                                                                      *
   call :_startNewlib-cygwin-install --retry-current & goto:eof
  ) 
 )
 if "%1"=="--retry-current" (
  echo * IMPORTANT - Double click current in File Explorer for local build    *
  echo * to correctly configure httpd.conf, ensuring it is in path.           *
  echo *                                                                      *
  start .
  pause 
  if NOT EXIST "%~dp0current_ran.txt" (
   call :_startNewlib-cygwin-install --retry-current & goto:eof
  ) else (
   call :_startNewlib-cygwin-install --complete & goto:eof
  )
 )
 if "%1"=="--complete" (
  echo:
  echo CYGWIN newlib-cygwin INSTAL COMPLETE:
  echo *************************************
  echo:
  if "%_cd%"=="1" (
   cd "%~dp0"
  )
)
goto:eof