:: @echo off
setlocal EnableExtensions EnableDelayedExpansion
call "%AKIBLD%\build-event-env.bat" %~f0 %* 

:: boost.vcxproj pre-build 

if [%RunMode%] == [clean] (
	echo ******** CLEANING BOOST LIBRARY | tee -a "%AKILOG%"
	pushd "%ProjectDir%"
	git clean -dxf -e .build | tee -a "%AKILOG%"
	git submodule update --init --recursive | tee -a "%AKILOG%"
	popd
)

if [%RunMode%] == [pre] (

    rem msgbox "OutDir=%OutDir% TargetFileName=%TargetFileName%"
	pushd "%ProjectDir%"

	if not exist b2.exe (
		echo ******** BUILDING B2 TOOL | tee -a "%AKILOG%"
		bootstrap | tee -a "%AKILOG%"
		echo. | tee -a "%AKILOG%"
	)

	echo ******** BUILDING BOOST LIBRARY | tee -a "%AKILOG%"

	set Bitness=64
	if /i [%Platform%] == ["Win32"] set Bitness=32
	if /i [%Platform%] == ["x86"] set Bitness=32
	if /i [%Platform%] == ["AMD64"] set Bitness=64
	if /i [%Platform%] == ["x64"] set Bitness=64

	set Variant=release
	if /i [%Configuration%] == [Debug] set Variant=debug
	if /i [%Configuration%] == [Release] set Variant=release

	echo ====== variant=!Variant! address-model=!Bitness! ====== | tee -a "%AKILOG%"
	echo. | tee -a "%AKILOG%

	echo **** Cleaning . . . | tee -a "%AKILOG%"
	b2 --clean | tee -a "%AKILOG%"
	echo. | tee -a "%AKILOG%

	echo **** Building . . . | tee -a "%AKILOG%"
	b2 install --prefix=%IntDir% --build-dir=%IntDir% --includedir=%OutDir%\..\include --libdir=%OutDir%\..\lib --toolset=msvc --no-cmake-config --layout=system variant=!Variant! address-model=!Bitness! | tee -a "%AKILOG%"
	rmdir /s /q bin.v2 2>nul
	del /f %OutDir%\%TargetFileName% 2>nul
	echo. | tee -a "%AKILOG%

	echo **** Finished. | tee -a "%AKILOG%"
	popd
)

:: msgbox "OutDir=%OutDir% TargetFileName=%TargetFileName%"

if [%RunMode%] == [post] (

	echo **** Installing Boost headers . . . | tee -a "%AKILOG%"
	echo. | tee -a "%AKILOG%"

	set "QDIR=%OutDir%\..\include\boost"
	rem msgbox "CD=%CD%"
	rem msgbox "QDIR=%QDIR%"
	xcopy /d /y /r /s /i /f boost "!QDIR!" | tee -a "%AKILOG%"
	if errorlevel 1 msgbox "XCOPY error %ERRORLEVEL%"
	pushd "!QDIR!"
	attrib +R /S
	echo. | tee -a "%AKILOG%"

	echo **** Finished. | tee -a "%AKILOG%"
	popd
)
