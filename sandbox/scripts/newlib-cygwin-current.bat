@echo off
REM newlinCygwin
:: Additional step to start cygwin-htdocs local server.
::
:: useage: newlinCygwin
set "_helpLinesNewlibCygwinCurrent=5"

:: Note that current has been run.
cd /D "%~dp0"
echo complete > "%~dp0current_ran.txt"

:: Config variables
set "_debugNewlibCygwinCurrent=0" & rem 0 (default)

:: Define varibales from arguments.
set "_parOneNewlibCygwinCurrent=%~1"
set "_checkParOneNewlibCygwinCurrent=-%_parOneNewlibCygwinCurrent%-"
set "_parTwoNewlibCygwinCurrent=%~2"
set "_checkParTwoNewlibCygwinCurrent=-%_parTwoNewlibCygwinCurrent%-"
set "_parThreeNewlibCygwinCurrent=%~3"                                
set "_checkParThreeNewlibCygwinCurrent=-%_parThreeNewlibCygwinCurrent%-"
set "_parFourNewlibCygwinCurrent=%~4"                                        
set "_checkParFourNewlibCygwinCurrent=-%_parFourNewlibCygwinCurrent%-"
set "_parFiveNewlibCygwinCurrent=%~5"                                        
set "_checkParFiveNewlibCygwinCurrent=-%_parFiveNewlibCygwinCurrent%-"
set "_parSixNewlibCygwinCurrent=%~6"                                        
set "_checkParSixNewlibCygwinCurrent=-%_parSixNewlibCygwinCurrent%-"
set "_parSevenNewlibCygwinCurrent=%~7"                                        
set "_checkParSevenNewlibCygwinCurrent=-%_parSevenNewlibCygwinCurrent%-"
set "_parEightNewlibCygwinCurrent=%~8"                                        
set "_checkParEightNewlibCygwinCurrent=-%_parEightNewlibCygwinCurrent%-"
set "_parNineNewlibCygwinCurrent=%~9"                                        
set "_checkParNineNewlibCygwinCurrent=-%_parNineNewlibCygwinCurrent%-"

set "_tmpDirNineNewlibCygwinCurrent=.tmp\%~n0"
set "_hasOptionsNewlibCygwinCurrent=%_parOneNewlibCygwinCurrent:~0,2%%"
set "_checkOptionsNewlibCygwinCurrent=%_parOneNewlibCygwinCurrent:~0,1%%"

set "_buildDir=C:\cygwin64\oss\src\newlib-cygwin\build\x86_64-pc-cygwin\winsup\doc"

if "%_parOneNewlibCygwinCurrent%"=="-e" (
 notepad++ "%~dp0%~n0.bat"
 goto _removeBatchVariablesNewlibCygwinCurrent 
)

if "%_parOneNewlibCygwinCurrent%"=="-h" (
 call :_makeShiftHelpNewlibCygwinCurrent 1 & goto:eof
) else if "%_parOneNewlibCygwinCurrent%"=="/?" (
 call :_makeShiftHelpNewlibCygwinCurrent 1 & goto:eof
)

rem ready variables for use
which httpd > .tmp_httpd.txt
set "_dashUser=%USERPROFILE:\=\/%%"

rem ensure expansion and start process
call :_startNewlibCygwinCurrentConditions 1
goto:eof

:: ***************************************************************************
:: START SCRIPT
:_startNewlibCygwinCurrentConditions
 if "%1"=="1" (
  sed -i -e "s/\/cygdrive\/c\/Users\/WDAGUtilityAccount/%_dashUser%/" -e "s/bin\/httpd/bin/" .tmp_httpd.txt
  rem ready to make variables
  type .tmp_httpd.txt | sed "s/bin/modules/" > .tmp_modules.txt
  type .tmp_httpd.txt | sed "s/bin/conf/" > .tmp_conf.txt
  
  call :_startNewlibCygwinCurrentConditions 2 & goto:eof
 )
 if "%1"=="2" (
  rem define variables using cmdVar tool
  call "%cmdVar%" "type .tmp_httpd.txt" _apacheBin
  call "%cmdVar%" "type .tmp_modules.txt" _apacheModule
  call "%cmdVar%" "type .tmp_conf.txt" _apacheConf
  
  rem run process to get built docs and create httpd.conf
  call :_runNewlibCygwinCurrent 1 & goto:eof
 )
 rem else
 goto _removeBatchVariablesNewlibCygwinCurrent
goto:eof

:_runNewlibCygwinCurrent
 if "%1"=="1" (
  git clone https://cygwin.com/git/cygwin-htdocs.git/
  cd cygwin-htdocs
  
  rem get doc html files
  mkdir -p "doc/preview/cygwin-api" "doc/preview/cygwin-ug-net" "doc/preview/faq"
  copy "%_buildDir%\cygwin-api\"*.html "doc\preview\cygwin-api\" >nul 2>nul
  copy "%_buildDir%\cygwin-ug-net\"*.html "doc\preview\cygwin-ug-net\" >nul 2>nul
  copy "%_buildDir%\faq\"*.html "doc\preview\faq\" >nul 2>nul
  
  rem start process to make httpd.conf
  call :_runNewlibCygwinCurrent 2 & goto:eof
 )
 if "%1"=="2" (  
  rem -------------------------------------------------------------------------------------------------
  rem EXAMPLE HTTPD.CONF
  echo # httpd.conf ^(in current folder^) > httpd.conf
  echo ServerRoot "%_apacheBin%" >> httpd.conf
  echo Listen 8000 >> httpd.conf
  echo ServerName localhost >> httpd.conf
  echo DocumentRoot "C:/Users/%USERNAME%/Desktop/sandbox/cygwin-htdocs" >> httpd.conf
  echo LoadModule rewrite_module "%_apacheModule%/mod_rewrite.so" >> httpd.conf
  echo LoadModule alias_module "%_apacheModule%/mod_alias.so ">> httpd.conf
  echo LoadModule mime_module "%_apacheModule%/mod_mime.so" >> httpd.conf
  echo LoadModule dir_module "%_apacheModule%/mod_dir.so" >> httpd.conf
  echo LoadModule include_module "%_apacheModule%/mod_include.so" >> httpd.conf
  echo LoadModule authz_core_module "%_apacheModule%/mod_authz_core.so" >> httpd.conf
  echo LoadModule log_config_module "%_apacheModule%/mod_log_config.so" >> httpd.conf
  
  echo ^<Directory "/"^> >> httpd.conf
  echo AllowOverride None >> httpd.conf
  echo ^</Directory^> >> httpd.conf

  echo AddType text/html .html >> httpd.conf
  echo AddOutputFilter INCLUDES .html >> httpd.conf
  echo Options +Includes >> httpd.conf
  
  echo DirectoryIndex index.html >> httpd.conf
  
  echo TypesConfig "%_apacheConf%/mime.types" >> httpd.conf
  echo PidFile "C:/Users/%USERNAME%/Desktop/sandbox/cygwin-htdocs/httpd.pid" >> httpd.conf
  
  echo ErrorLog "C:/Users/%USERNAME%/Desktop/sandbox/cygwin-htdocs/error.log" >> httpd.conf
  echo CustomLog "C:/Users/%USERNAME%/Desktop/sandbox/cygwin-htdocs/access.log" common >> httpd.conf
  rem EXAMPLE HTTPD.CONF
  rem -------------------------------------------------------------------------------------------------
  
  rem start server and open browser
  call :_runNewlibCygwinCurrent 3 & goto:eof
 )
 if "%1"=="3" ( 
  rem -------------------------------------------------------------------------------------------------  
  rem RUN LOCAL SITE
  start http://localhost:8000
  httpd.exe -f "%cd%\httpd.conf" -DFOREGROUND
  rem RUN LOCAL SITE
  rem -------------------------------------------------------------------------------------------------  
 )
 goto _removeBatchVariablesNewlibCygwinCurrent
goto:eof

:_makeShiftHelpNewlibCygwinCurrent
 if "%1"=="1" (
  echo:
  head -n %_helpLinesNewlibCygwinCurrent% "%~dp0%~n0.bat" | sed -e 1d -e "s/REM /   /" -e "s/::/  /"
  echo:
  goto _removeBatchVariablesNewlibCygwinCurrent
 )
goto:eof
:: END SCRIPT
:: ***************************************************************************
:: ***************************************************************************

:_removeBatchVariablesNewlibCygwinCurrent
 rem Batch variables.
 set _callRootNewlibCygwinCurrent=
 set _callLibraryNewlibCygwinCurrent=
 set _newlinCygwinPath=
 set _parOneNewlibCygwinCurrent=
 set _checkParOneNewlibCygwinCurrent=
 set _parTwoNewlibCygwinCurrent=
 set _checkParTwoNewlibCygwinCurrent=
 set _parThreeNewlibCygwinCurrent=
 set _checkParThreeNewlibCygwinCurrent=
 set _parFourNewlibCygwinCurrent=
 set _checkParFourNewlibCygwinCurrent=
 set _parFiveNewlibCygwinCurrent=
 set _checkParFiveNewlibCygwinCurrent=
 set _parSixNewlibCygwinCurrent=
 set _checkParSixNewlibCygwinCurrent=
 set _parSevenNewlibCygwinCurrent=
 set _checkParSevenNewlibCygwinCurrent=
 set _parEightNewlibCygwinCurrent=
 set _checkParEightNewlibCygwinCurrent=
 set _parNineNewlibCygwinCurrent=
 set _checkParNineNewlibCygwinCurrent=
 set _tmpDirNineNewlibCygwinCurrent=
 set _hasOptionsNewlibCygwinCurrent=
 set _checkOptionsNewlibCygwinCurrent=
 set _debugNewlibCygwinCurrent=
 set _helpLinesNewlibCygwinCurrent=
 
 rem append new variables
 
 exit /b
goto:eof