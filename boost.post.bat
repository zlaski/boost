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

call "%AKIBLD%\build-event-env.bat" post %_arg01% %_arg02% %_arg03% %_arg04% %_arg05% %_arg06% %_arg07% %_arg08% %_arg09% %_arg10% %_arg11% %_arg12% %_arg13% %_arg14% %_arg15% %_arg16%
:: boost.vcxproj post-build 
 
exit 0

:::: don't need this stuff any more'

echo **** Installing Boost headers ****
echo.

set "QDIR=%OutDir%\..\include\boost"
:: msgbox "CD=%CD%"
:: msgbox "QDIR=%QDIR%"
xcopy /d /y /r /s /i /f boost "%QDIR%" >nul
if errorlevel 1 msgbox "XCOPY error %ERRORLEVEL%"
pushd "%QDIR%"
attrib +R /S
popd
