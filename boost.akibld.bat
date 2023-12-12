@echo off
setlocal EnableExtensions EnableDelayedExpansion
call "%AKIBLD%\akibld-setup.bat" %~f0 %* 

set Bitness=unknown
if /i [%Platform%] == ["Win32"] set Bitness=32
if /i [%Platform%] == ["x86"] set Bitness=32
if /i [%Platform%] == ["AMD64"] set Bitness=64
if /i [%Platform%] == ["x64"] set Bitness=64

set Variant=unknown
if /i [%Configuration%] == ["Debug"] set Variant=debug
if /i [%Configuration%] == ["Release"] set Variant=release

:: boost.vcxproj pre-build 

if [%RunMode%] == [clean] (
	echo ******** CLEANING BOOST LIBRARY
	pushd "%ProjectDir%"
	git clean -dxf -e .build
	git submodule update --init --recursive
	popd
)

if [%RunMode%] == [pre] (

    rem msgbox "OutDir=%OutDir% TargetFileName=%TargetFileName%"
	pushd "%ProjectDir%"

	echo ====== variant=%Variant% address-model=%Bitness% ======

	rem msgbox -k Variant: %Variant% or %Variant%

	if not exist b2.exe (
		echo ******** BUILDING B2 TOOL
		bootstrap
	)

	echo ******** BUILDING BOOST LIBRARY

	echo **** Cleaning . . .
	b2 --clean
	echo.

	echo ====== variant=%Variant% address-model=%Bitness% ======
	echo.

	echo **** Building . . .
	b2 install --prefix=%IntDir% --build-dir=%IntDir% --includedir=%OutDir%\..\include --libdir=%OutDir%\..\lib --toolset=msvc --no-cmake-config --layout=system variant=%Variant% address-model=%Bitness%
	echo.

	echo **** Finished.
	popd
)

:: msgbox "OutDir=%OutDir% TargetFileName=%TargetFileName%"

if [%RunMode%] == [post] (

	echo **** Installing Boost headers . . .
	echo.

	set "QDIR=%OutDir%\..\include\boost"
	rem msgbox "CD=%CD%"
	rem msgbox "QDIR=%QDIR%"
	xcopy /d /y /r /s /i /f boost "!QDIR!"
	if errorlevel 1 msgbox "XCOPY error %ERRORLEVEL%"
	pushd "!QDIR!"
	attrib +R /S
	echo.

	echo **** Finished.
	popd
)
