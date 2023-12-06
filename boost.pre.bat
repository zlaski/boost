@echo off
setlocal EnableExtensions EnableDelayedExpansion
set "_arg01=%0" & shift
set "_arg02=%0" & shift
set "_arg03=%0" & shift
set "_arg04=%0" & shift
set "_arg05=%0" & shift
set "_arg06=%0" & shift
set "_arg07=%0" & shift
set "_arg08=%0" & shift
set "_arg09=%0" & shift
set "_arg10=%0" & shift
set "_arg11=%0" & shift
set "_arg12=%0" & shift
set "_arg13=%0" & shift
set "_arg14=%0" & shift
set "_arg15=%0" & shift
set "_arg16=%0" & shift

call "%AKIBLD%\build-event-env.bat" pre %_arg01% %_arg02% %_arg03% %_arg04% %_arg05% %_arg06% %_arg07% %_arg08% %_arg09% %_arg10% %_arg11% %_arg12% %_arg13% %_arg14% %_arg15% %_arg16%

:: boost.vcxproj pre-build 

pushd "%ProjectDir%"

if not exist b2.exe (
	echo ******** BUILDING B2 TOOL
	bootstrap
)

echo ******** BUILDING BOOST LIBRARY

if /i [%Platform%]==["Win32"] set Bitness=32
if /i [%Platform%]==["x86"] set Bitness=32
if /i [%Platform%]==["AMD64"] set Bitness=64
if /i [%Platform%]==["x64"] set Bitness=64

if /i [%Configuration%]==["Debug"] set Variant=debug
if /i [%Configuration%]==["Release"] set Variant=release

echo ====== variant=%Variant% address-model=%Bitness% ======

b2 --clean -d0
echo.
echo This will take a while . . .
b2 install --prefix=%IntDir% --build-dir=%IntDir% --includedir=%OutDir%\..\include --libdir=%OutDir%\..\lib --toolset=msvc --no-cmake-config --layout=system -d0 variant=%Variant% address-model=%Bitness%

popd
