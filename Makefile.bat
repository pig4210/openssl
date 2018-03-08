@echo off

:begin
    setlocal
    set MyPath=%~dp0

:checkenvironment
    echo ==== ==== ==== ==== Checking Building Environment...
    perl -h >nul 2>nul
    if not %errorlevel%==0 (
        echo !!!! Need ActivePerl, Please install it !!!!
        goto end
    )

    dmake -h >nul 2>nul
    if not %errorlevel%==255 (
        echo !!!! Need ActivePerl with dmake, Please install it !!!!
        echo "set ACTIVEPERL_PPM_HOME=.\Perl\tmp"
        echo "ppm install dmake"
        goto end
    )

:config
    if "%1" == "" (
      set PLAT=x64
    ) else (
      set PLAT=x86
    )

    set VCPATH=C:\Program Files (x86)\Microsoft Visual Studio\2017\Community\VC\Auxiliary\Build
    set VPATH=%MyPath%\\openssl-1.1.0g
    set GPATH=%MyPath%\\%PLAT%

:start
    echo ==== ==== ==== ==== Start compiling %PLAT%...

    echo ==== ==== ==== ==== Prepare environment(%PLAT%)...
    cd /d %VCPATH%
    if "%1" == "" (
        call vcvarsall.bat amd64 >nul
        set PLATCFG=VC-WIN64A
    ) else (
        call vcvarsall.bat x86 >nul
        set PLATCFG=VC-WIN32
    )

    cd /d %VPATH%

:configure
    perl Configure %PlatCfg% shared no-asm no-shared

:libs
    echo ==== ==== ==== ==== Building(%PLAT%)...
    nmake build_libs

:copylibs
    echo ==== ==== ==== ==== Copy libs...
    if not exist "%GPATH%" mkdir %GPATH%
    del /q "%GPATH%\\*.*"

    copy libcrypto.lib "%GPATH%"
    copy libssl.lib "%GPATH%"

:makeinclude
    set IncludePath=%MyPath%\\include
    if "%1" == "" (
        echo ==== ==== ==== ==== Prepare Include Folder and Files...
        rd /S /Q "%IncludePath%"
        mkdir "%IncludePath%\\openssl"
        copy "%VPATH%\\include\openssl\*.h" "%IncludePath%\\openssl"
    )

:clean
    echo ==== ==== ==== ==== Clean...
    nmake clean

:done
    echo.

    endlocal

    if "%1" == "" (
        cmd /C %~f0 x86
    ) else (
        exit /B 0
    )

    echo done.

:end
    pause >nul