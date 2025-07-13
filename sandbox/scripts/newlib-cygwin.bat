@echo off
REM newlib-cygwin
:: Script to download cygwin packages for newlib docs.
::
:: useage: newlib-cygwin [1] [2] [3]
::  [1]  =  string
::  [2]  =  string
::  [3]  =  string
::  
:: Usage Example:
::  > newlib-cygwin "one" "two" "three"
::    - Use arguments "one", "two", and "three" to do something.
:: 
set "_helpLinesNewlib-cygwin=5" & rem change as needed

:: Config variables
set "_debugNewlib-cygwin=0"        & rem 0 (default)
set "_quitePackageNewlib-cygwin=1" & rem 1 (default) 0 startu gui install

:: Define varibales from arguments.
set "_parOneNewlib-cygwin=%~1"
set "_checkParOneNewlib-cygwin=-%_parOneNewlib-cygwin%-"
set "_parTwoNewlib-cygwin=%~2"
set "_checkParTwoNewlib-cygwin=-%_parTwoNewlib-cygwin%-"
set "_parThreeNewlib-cygwin=%~3"                                
set "_checkParThreeNewlib-cygwin=-%_parThreeNewlib-cygwin%-"
set "_parFourNewlib-cygwin=%~4"                                        
set "_checkParFourNewlib-cygwin=-%_parFourNewlib-cygwin%-"
set "_parFiveNewlib-cygwin=%~5"                                        
set "_checkParFiveNewlib-cygwin=-%_parFiveNewlib-cygwin%-"
set "_parSixNewlib-cygwin=%~6"                                        
set "_checkParSixNewlib-cygwin=-%_parSixNewlib-cygwin%-"
set "_parSevenNewlib-cygwin=%~7"                                        
set "_checkParSevenNewlib-cygwin=-%_parSevenNewlib-cygwin%-"
set "_parEightNewlib-cygwin=%~8"                                        
set "_checkParEightNewlib-cygwin=-%_parEightNewlib-cygwin%-"
set "_parNineNewlib-cygwin=%~9"                                        
set "_checkParNineNewlib-cygwin=-%_parNineNewlib-cygwin%-"

set "_tmpDirNineNewlib-cygwin=.tmp\%~n0"
set "_hasOptionsNewlib-cygwin=%_parOneNewlib-cygwin:~0,2%%"
set "_checkOptionsNewlib-cygwin=%_parOneNewlib-cygwin:~0,1%%"

if "%_parOneNewlib-cygwin%"=="-e" (
 rem Get the date with librarty getDate
 call callLibrary "getDate\getDate"
 call callLibrary editBatchFile "%~n0"
 if "%_parTwoNewlib-cygwin%"=="--edit-all" (
  echo File Using MakeShift Help: & rem
 )
 goto _removeBatchVariablesNewlib-cygwin 
)

if "%_parOneNewlib-cygwin%"=="-h" (
 call :_makeShiftHelpNewlib-cygwin 1 & goto:eof
) else if "%_parOneNewlib-cygwin%"=="/?" (
 call :_makeShiftHelpNewlib-cygwin 1 & goto:eof
)

if "%_checkParOneNewlib-cygwin%"=="--" (
 REM Commands if no parameter. 
 rem call callLibrary syntaxErr %~n0 --par 1
 rem goto _removeBatchVariablesNewlib-cygwin 
 call :_startNewlib-cygwinConditions 1 
) else (
 call :_startNewlib-cygwinConditions 1
)

goto:eof

:: ***************************************************************************
:: START SCRIPT
:_startNewlib-cygwinConditions
 if "%1"=="1" (
  if "%_quitePackageNewlib-cygwin%"=="0" (
   call :_startNewlib-cygwinConditions --pkg "Build Tools" "pkg -P autoconf,automake,cocom,gcc-g++,git,libtool,make,patch,perl"
   call :_startNewlib-cygwinConditions --pkg "Dumper Utilities" "pkg -P gettext-devel,libiconv,libiconv-devel,libiconv2,libzstd-devel,zlib-devel"
   call :_startNewlib-cygwinConditions --pkg "Cygwin Utilities" "pkg -P mingw64-x86_64-gcc-g++,mingw64-x86_64-zlib"
   call :_startNewlib-cygwinConditions --pkg "Documentation Packages" "pkg -P dblatex,docbook-utils,docbook-xml45,docbook-xsl,docbook2X,perl-XML-SAX-Expat,xmlto"   
  ) else (
   rem -------------------------------------------------------------------------------------------------
   rem INSTALL REQUIRED PACKAGES
   call :_startNewlib-cygwinConditions --pkg "Build Tools" "pkg -q -P autoconf,automake,cocom,gcc-g++,git,libtool,make,patch,perl"
   call :_startNewlib-cygwinConditions --pkg "Dumper Utilities" "pkg -q -P gettext-devel,libiconv,libiconv-devel,libiconv2,libzstd-devel,zlib-devel"
   call :_startNewlib-cygwinConditions --pkg "Cygwin Utilities" "pkg -q -P mingw64-x86_64-gcc-g++,mingw64-x86_64-zlib"
   call :_startNewlib-cygwinConditions --pkg "Documentation Packages" "pkg -q -P dblatex,docbook-utils,docbook-xml45,docbook-xsl,docbook2X,perl-XML-SAX-Expat,xmlto"
   rem INSTALL REQUIRED PACKAGES
   rem -------------------------------------------------------------------------------------------------
  )
  call :_startNewlib-cygwinConditions 2 & goto:eof
 )
 if "%1"=="2" (
  echo Beginning Installation: & rem
  echo:
  call :_runNewlib-cygwin 1 & goto:eof
 )
 if "%1"=="--pkg" (
  echo Download Necessary %~2: & rem
  %~3
  goto:eof
 )
 rem else
 goto _removeBatchVariablesNewlib-cygwin
goto:eof

:_runNewlib-cygwin
 if "%1"=="1" (
  call install.bat
  call :_runNewlib-cygwin 2 & goto:eof
 )
 if "%1"=="2" (  
  goto _removeBatchVariablesNewlib-cygwin
 )
 rem else 
 goto _removeBatchVariablesNewlib-cygwin
goto:eof

:_makeShiftHelpNewlib-cygwin
 if "%1"=="1" (
  echo:
  head -n %_helpLinesNewlib-cygwin% "%~dp0%~n0.bat" | sed -e 1d -e "s/REM /   /" -e "s/::/  /"
  echo:
  goto _removeBatchVariablesNewlib-cygwin
 )
goto:eof
:: END SCRIPT
:: ***************************************************************************
:: ***************************************************************************

:_removeBatchVariablesNewlib-cygwin
 rem Batch variables.
 set _callRootNewlib-cygwin=
 set _callLibraryNewlib-cygwin=
 set _newlib-cygwinPath=
 set _parOneNewlib-cygwin=
 set _checkParOneNewlib-cygwin=
 set _parTwoNewlib-cygwin=
 set _checkParTwoNewlib-cygwin=
 set _parThreeNewlib-cygwin=
 set _checkParThreeNewlib-cygwin=
 set _parFourNewlib-cygwin=
 set _checkParFourNewlib-cygwin=
 set _parFiveNewlib-cygwin=
 set _checkParFiveNewlib-cygwin=
 set _parSixNewlib-cygwin=
 set _checkParSixNewlib-cygwin=
 set _parSevenNewlib-cygwin=
 set _checkParSevenNewlib-cygwin=
 set _parEightNewlib-cygwin=
 set _checkParEightNewlib-cygwin=
 set _parNineNewlib-cygwin=
 set _checkParNineNewlib-cygwin=
 set _tmpDirNineNewlib-cygwin=
 set _hasOptionsNewlib-cygwin=
 set _checkOptionsNewlib-cygwin=
 set _debugNewlib-cygwin=
 set _helpLinesNewlib-cygwin=
 
 rem append new variables
 
 exit /b
goto:eof