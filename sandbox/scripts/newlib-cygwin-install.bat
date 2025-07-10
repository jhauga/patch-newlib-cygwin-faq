@echo off
REM newlib-cygwin-install
::  Create the documentation from newlib-cygwin.

set "_currentInstall=docs"  & rem install (default) docs make docs
set "_copyToCygwinHtdocs=1" & rem 0 (default) 1 if testing site doc edit
set "_cd=1"                 & rem 1 (defeault) 0 stays in cygwin
set "_include=C:\Users\WDAGUtilityAccount\Desktop\sandbox\include"

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
  sh /oss/src/newlib-cygwin/configure --prefix=/oss/install

  if "%_currentInstall%"=="docs" (
   make
  ) else (
   make
   make install
  )
  if "%_copyToCygwinHtdocs%"=="1" (
   set "_buildDir=%cd%\x86_64-pc-cygwin\winsup\doc"
   call :_startNewlib-cygwin-install --cygwin-htdocs 1 & goto:eof
  ) else (
   call :_startNewlib-cygwin-install --complete & goto:eof
  )
 )
 if "%1"=="--cygwin-htdocs" (
  if "%2"=="1" (
   cd /D "%~dp0"
   winget install ApacheLounge.httpd --source winget
   which httpd > .tmp_httpd.txt
   
   rem configure paths for httpd.conf
   sed -i -e "s/\/cygdrive\/c\/Users\/WDAGUtilityAccount/%USERPROFILE%/" -e "s/bin\/httpd/bin/" .tmp_httpd.txt
   type .tmp_httpd.txt | sed "s/bin/modules/" > .tmp_modules.txt
   type .tmp_httpd.txt | sed "s/bin/conf/"    > .tmp_conf.txt
   
   rem store in variable
   call cmdVar "type .tmp_httpd.txt" _apacheBin
   call cmdVar "type .tmp_modules.txt" _apacheModule
   call cmdVar "type .tmp_conf.txt" _apacheConf
   
   rem let expand
   call :_startNewlib-cygwin-install --cygwin-htdocs 2 & goto:eof
  )
  if "%2"=="2" (
   git clone https://cygwin.com/git/cygwin-htdocs.git/
   cd cygwin-htdocs
   rem get doc html files
   mkdir -p "doc/preview/cygwin-api" "doc/preview/cygwin-ug-net" "doc/preview/faq"
   copy "%_buildDir%\cygwin-api\"*.html "doc\preview\cygwin-api\" >nul 2>nul
   copy "%_buildDir%\cygwin-ug-net\"*.html "doc\preview\cygwin-ug-net\" >nul 2>nul
   copy "%_buildDir%\faq\"*.html "doc\preview\faq\" >nul 2>nul
   rem start process to make httpd.conf
   call :_startNewlib-cygwin-install --cygwin-htdocs 3 & goto:eof
  )
  if "%2"=="3" (
   echo # httpd.conf ^(in current folder^) > httpd.conf
   echo ServerRoot "%_apacheBin%" >> httpd.conf
   echo Listen 8000 >> httpd.conf
   echo ServerName localhost >> httpd.conf
   echo DocumentRoot "C:/Users/NAME/cygwin-htdocs" >> httpd.conf
   echo: >> httpd.conf
   echo LoadModule rewrite_module "%_apacheModule%/mod_rewrite.so" >> httpd.conf
   echo LoadModule alias_module "%_apacheModule%/mod_alias.so" >> httpd.conf
   echo LoadModule mime_module "%_apacheModule%/mod_mime.so" >> httpd.conf
   echo LoadModule dir_module "%_apacheModule%/mod_dir.so" >> httpd.conf
   echo LoadModule include_module "%_apacheModule%/mod_include.so" >> httpd.conf
   echo LoadModule authz_core_module "%_apacheModule%/mod_authz_core.so" >> httpd.conf
   echo LoadModule log_config_module "%_apacheModule%/mod_log_config.so" >> httpd.conf
   echo: >> httpd.conf
   echo ^<Directory "/"^> >> httpd.conf
   echo     AllowOverride None >> httpd.conf
   echo ^</Directory^> >> httpd.conf
   echo: >> httpd.conf
   echo AddType text/html .html >> httpd.conf
   echo AddOutputFilter INCLUDES .html >> httpd.conf
   echo Options +Includes >> httpd.conf
   echo: >> httpd.conf
   echo DirectoryIndex index.html >> httpd.conf
   echo: >> httpd.conf
   echo TypesConfig "C:/Users/NAME/path/to/Apache24/conf/mime.types" >> httpd.conf
   echo PidFile "C:/Users/NAME/cygwin-htdocs/httpd.pid" >> httpd.conf
   echo: >> httpd.conf
   echo ErrorLog "C:/Users/NAME/cygwin-htdocs/error.log" >> httpd.conf
   echo CustomLog "C:/Users/NAME/cygwin-htdocs/access.log" common >> httpd.conf
   rem start server and open browser
   call :_startNewlib-cygwin-install --cygwin-htdocs 4 & goto:eof
  )
  if "%2"=="4" (
   start http://localhost:8000
   httpd.exe -f "%cd%\httpd.conf" -DFOREGROUND
   call :_startNewlib-cygwin-install --complete & goto:eof
  )
 )
 if "%1"=="--complete" (
  echo:
  echo CYGWIN newlib-cygwin INSTAL COMPLETE:
  echo *************************************
  echo:
  if "%_cd%"=="1" (
   cd /D "%~dp0"
  )
 )
goto:eof