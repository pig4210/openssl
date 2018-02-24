
@echo off
setlocal
set VCPath=D:\Program Files (x86)\Microsoft Visual Studio 12.0\VC
set SrcPath=.\openssl-1.1.0g

perl -h >nul
if not %errorlevel%==0 echo openssl编译需要ActivePerl支持，请安装之 && goto end

dmake -h >nul
if not %errorlevel%==255 echo openssl编译需要dmake支持，请使用"set ACTIVEPERL_PPM_HOME=.\Perl\tmp && ppm install dmake"安装之 && goto end

set MyPath=%~dp0
set IncludePath=%MyPath%\include

if "%1" == "" echo 准备include文件...
if "%1" == "" rd /S /Q "%IncludePath%"
if "%1" == "" mklink /H /J "%IncludePath%" "%MyPath%\%SrcPath%\include"

cd /d %VCPath%

if "%1" == "" set PLAT=x64
if not "%1" == "" set PLAT=x86

if "%1" == "" call vcvarsall.bat amd64
if not "%1" == "" call vcvarsall.bat x86

cd /d %MyPath%\%SrcPath%

echo 配置%PLAT%...

if "%1" == "" set PlatCfg=VC-WIN64A
if not "%1" == "" set PlatCfg=VC-WIN32

perl Configure %PlatCfg% shared no-asm no-shared

echo 开始编译%PLAT%...

nmake

echo 完成编译。准备结果...

set DestPath=%MyPath%\%PLAT%

rd /S /Q "%DestPath%"
mkdir "%DestPath%"

copy libcrypto.lib "%DestPath%\"
copy libssl.lib "%DestPath%\"

nmake clean

endlocal

if not "%1" == "" exit /B 0

if "%1" == "" cmd /C %~f0 x86

echo 完成
:end

pause >nul