@echo off
setlocal EnableExtensions EnableDelayedExpansion
call "%AKIBLD%\build-event-env.bat" %~f0 %* 

:: boost.vcxproj pre-build 

if [%RunMode%] == [clean] (
	rmdir /s /q %IntDir%
)

if [%RunMode%] == [pre] (

    rem msgbox "OutDir=%OutDir% TargetFileName=%TargetFileName%"
	pushd "%ProjectDir%"

	if not exist b2.exe (
		echo ******** BUILDING B2 TOOL
		bootstrap
	)

	echo ******** BUILDING BOOST LIBRARY

	set Bitness=64
	if /i [%Platform%] == ["Win32"] set Bitness=32
	if /i [%Platform%] == ["x86"] set Bitness=32
	if /i [%Platform%] == ["AMD64"] set Bitness=64
	if /i [%Platform%] == ["x64"] set Bitness=64

	set Variant=release
	if /i [%Configuration%] == [Debug] set Variant=debug
	if /i [%Configuration%] == [Release] set Variant=release

	echo ====== variant=!Variant! address-model=!Bitness! ======

	echo Cleaning . . .
	b2 --clean | tee "%AKILOG%"

	echo Building . . .
	b2 install --prefix=%IntDir% --build-dir=%IntDir% --includedir=%OutDir%\..\include --libdir=%OutDir%\..\lib --toolset=msvc --no-cmake-config --layout=system variant=!Variant! address-model=!Bitness! | tee "%AKILOG%"
	rmdir /s /q bin.v2 2>nul
	del /f %OutDir%\%TargetFileName% 2>nul

	echo Finished

	popd
)

:: msgbox "OutDir=%OutDir% TargetFileName=%TargetFileName%"

if [%RunMode%] == [post] (

	echo **** Installing Boost headers ****
	echo.

	set "QDIR=%OutDir%\..\include\boost"
	rem msgbox "CD=%CD%"
	rem msgbox "QDIR=%QDIR%"
	xcopy /d /y /r /s /i /f boost "!QDIR!" >nul
	if errorlevel 1 msgbox "XCOPY error %ERRORLEVEL%"
	pushd "!QDIR!"
	attrib +R /S
	popd
)
