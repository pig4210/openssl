
@echo off
setlocal
set VCPath=D:\Program Files (x86)\Microsoft Visual Studio 12.0\VC
set SrcPath=.\openssl-1.1.0g

perl -h >nul
if not %errorlevel%==0 echo openssl������ҪActivePerl֧�֣��밲װ֮ && goto end

dmake -h >nul
if not %errorlevel%==255 echo openssl������Ҫdmake֧�֣���ʹ��"set ACTIVEPERL_PPM_HOME=.\Perl\tmp && ppm install dmake"��װ֮ && goto end

set MyPath=%~dp0
set IncludePath=%MyPath%\include

if "%1" == "" echo ׼��include�ļ�...
if "%1" == "" rd /S /Q "%IncludePath%"
if "%1" == "" mklink /H /J "%IncludePath%" "%MyPath%\%SrcPath%\include"

cd /d %VCPath%

if "%1" == "" set PLAT=x64
if not "%1" == "" set PLAT=x86

if "%1" == "" call vcvarsall.bat amd64
if not "%1" == "" call vcvarsall.bat x86

cd /d %MyPath%\%SrcPath%

echo ����%PLAT%...

if "%1" == "" set PlatCfg=VC-WIN64A
if not "%1" == "" set PlatCfg=VC-WIN32

perl Configure %PlatCfg% shared no-asm no-shared

echo ��ʼ����%PLAT%...

nmake

echo ��ɱ��롣׼�����...

set DestPath=%MyPath%\%PLAT%

rd /S /Q "%DestPath%"
mkdir "%DestPath%"

copy libcrypto.lib "%DestPath%\"
copy libssl.lib "%DestPath%\"

nmake clean

endlocal

if not "%1" == "" exit /B 0

if "%1" == "" cmd /C %~f0 x86

echo ���
:end

pause >nul