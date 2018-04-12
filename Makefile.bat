@echo off

::begin
    setlocal
    pushd "%~dp0"

::checkenvironment
    echo ==== ==== ==== ==== Checking building environment...
    perl -h >nul 2>nul
    if not %errorlevel%==0 (
        echo !!!!!!!! Need ActivePerl, Please install it !!!!!!!!
        goto end
    )

    dmake -h >nul 2>nul
    if not %errorlevel%==255 (
        echo !!!!!!!! Need ActivePerl with dmake, Please install it !!!!!!!!
        echo "set ACTIVEPERL_PPM_HOME=.\Perl\tmp"
        echo "ppm install dmake"
        goto end
    )

::baseconfig
    set VCPATH=C:\Program Files (x86)\Microsoft Visual Studio\2017\Community\VC\Auxiliary\Build
    set MyPath=%CD%

    for /d %%P in (.) do set ProjectName=%%~nP
    if "%ProjectName%"=="" (
        echo !!!!!!!! Empty project name !!!!!!!!
        goto end
    )
    echo ==== ==== ==== ==== Got project name [ %ProjectName% ]
    setlocal enabledelayedexpansion
    for %%I in (a b c d e f g h i j k l m n o p q r s t u v w x y z) do set ProjectName=!ProjectName:%%I=%%I!
    setlocal disabledelayedexpansion

    for /d %%P in ("%MyPath%\\%ProjectName%*") do set VPATH=%%~fP
    if "%VPATH%"=="" (
        echo !!!!!!!! Src no found !!!!!!!!
        goto end
    )
    echo ==== ==== ==== ==== Got source folder [ %VPATH% ]
    echo.

::main
    echo.
    cl >nul 2>&1
    if %errorlevel%==0 (
        echo ==== ==== ==== ==== Build %Platform% ==== ==== ==== ==== 
        echo.
        call :do || goto end
    ) else (
        echo ==== ==== ==== ==== Build x64 ^& x86 ==== ==== ==== ==== 
        echo.
        call :do x64 || goto end
        call :do x86 || goto end
    )

    popd
    endlocal
    echo.
    echo ==== ==== ==== ==== Done ==== ==== ==== ====
    cl >nul 2>&1 || pause >nul
    exit /B 0

:end
    popd
    endlocal
    echo.
    echo ==== ==== ==== ==== Done ==== ==== ==== ====
    cl >nul 2>&1 || pause >nul
    exit /B 1


:do
    setlocal

    if "%1"=="" (
        set PLAT=%Platform%
        set SUF=
    ) else (
        set PLAT=%1
        set SUF=^>nul
    )
    if "%PLAT%"=="" (
        echo !!!!!!!! Need arg with x64/x86 !!!!!!!!
        goto done
    )
    set GPATH=%MyPath%\\%PLAT%

    echo.

::prepare
    if not "%1"=="" (
        echo ==== ==== ==== ==== Prepare environment^(%PLAT%^)...
        
        cd /d "%VCPath%"
        if "%PLAT%"=="x64" (
            call vcvarsall.bat amd64 >nul
        ) else (
            call vcvarsall.bat x86 >nul
        )
    )

    echo ==== ==== ==== ==== Prepare dest folder(%PLAT%)...

    if exist "%GPATH%" rd /s /q "%GPATH%" >nul
    if exist "%GPATH%" (
        echo !!!!!!!! Can't clear dest folder !!!!!!!!
        goto done
    )
    md "%GPATH%" >nul

    echo.

    cd /d "%VPATH%"

::configure
    echo ==== ==== ==== ==== Configure(%PLAT%)...

    if "%PLAT%"=="x64" (
        perl Configure VC-WIN64A shared no-asm no-shared
    ) else (
        perl Configure VC-WIN32 shared no-asm no-shared
    )

::buildlibs
    echo ==== ==== ==== ==== Building(%PLAT%)...

    nmake build_libs

::copylibs
    echo ==== ==== ==== ==== Copy libs(%PLAT%)...

    copy libcrypto.lib      "%GPATH%" >nul
    copy libssl.lib         "%GPATH%" >nul
    copy ossl_static.pdb    "%GPATH%" >nul

::makeinclude
    if "%1"=="x86" goto clean

    echo ==== ==== ==== ==== Prepare include folder ^& files...
    set IncludePath=%MyPath%\\include

    if exist "%IncludePath%" rd /s /q "%IncludePath%" >nul
    if exist "%IncludePath%" (
        echo !!!!!!!! Can't clear include folder !!!!!!!!
        goto done
    )

    set IncludePath=%MyPath%\\include\\%ProjectName%
    set SIncludePath=%VPATH%\\include\\%ProjectName%

    md "%IncludePath%" >nul

    copy "%SIncludePath%\\*.h" "%IncludePath%" >nul

:clean
    echo ==== ==== ==== ==== Clean(%PLAT%)...

    nmake clean

::ok
    endlocal
    echo.
    exit /B 0

:done
    endlocal
    echo.
    exit /B 1