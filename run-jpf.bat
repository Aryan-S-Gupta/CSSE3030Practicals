@echo off
setlocal enabledelayedexpansion

set "SCRIPT_DIR=%~dp0"
set "JPF_DIR=%SCRIPT_DIR%jpf"

if not exist "%JPF_DIR%\jpf-core\build\jpf.jar" (
    echo ERROR: jpf-core/jpf-symbc not found under "%JPF_DIR%".
    echo Run this script from the repo root.
    exit /b 1
)

if "%~1"=="" (
    echo Usage: run-jpf.bat ^<YourConfig.jpf^>
    echo Example: run-jpf.bat Roots.jpf
    exit /b 1
)

REM JPF needs an actual JDK 8 (its VM model uses internal APIs, like
REM sun.misc.SharedSecrets, that were removed/restricted in JDK 9+). Don't
REM just trust an existing JAVA_HOME - it may point at a newer JDK (this is
REM a common gotcha since many machines already have JAVA_HOME set globally
REM for other coursework). Verify the version; if it's not 8, fall back to
REM auto-detecting an Eclipse Adoptium JDK 8 install.
set "ORIGINAL_JAVA_HOME=%JAVA_HOME%"
set "JDK8_OK="
if not "%JAVA_HOME%"=="" if exist "%JAVA_HOME%\bin\java.exe" (
    "%JAVA_HOME%\bin\java.exe" -version 2>&1 | findstr /C:"1.8.0" >nul
    if not errorlevel 1 set "JDK8_OK=1"
)

if not defined JDK8_OK (
    for /d %%D in ("C:\Program Files\Eclipse Adoptium\jdk-8*") do set "JAVA_HOME=%%D"
    if not "!JAVA_HOME!"=="" if exist "!JAVA_HOME!\bin\java.exe" (
        "!JAVA_HOME!\bin\java.exe" -version 2>&1 | findstr /C:"1.8.0" >nul
        if not errorlevel 1 set "JDK8_OK=1"
    )
)

if not defined JDK8_OK (
    echo ERROR: could not find a JDK 8 java.exe.
    echo.
    if not "%ORIGINAL_JAVA_HOME%"=="" (
        echo JAVA_HOME is currently set to "%ORIGINAL_JAVA_HOME%", which is not JDK 8.
        echo JPF requires JDK 8 specifically - newer JDKs will not work.
        echo.
    )
    echo Install JDK 8, e.g.:
    echo   winget install --id EclipseAdoptium.Temurin.8.JDK
    echo.
    echo Then either open a new terminal, or explicitly set JAVA_HOME to the
    echo JDK 8 install before rerunning this script, e.g.:
    echo   set JAVA_HOME=C:\Program Files\Eclipse Adoptium\jdk-8.0.502.7-hotspot
    exit /b 1
)

REM Regenerate site.properties with this machine's absolute paths, so the
REM repo works regardless of where it was cloned to. Use forward slashes:
REM Java .properties files treat backslash as an escape character, so a
REM literal "C:\Users\..." path corrupts parsing (e.g. "\U" looks like a
REM broken unicode escape).
set "JPF_DIR_FWD=%JPF_DIR:\=/%"
> "%JPF_DIR%\site.properties" (
    echo jpf-core = %JPF_DIR_FWD%/jpf-core
    echo jpf-symbc = %JPF_DIR_FWD%/jpf-symbc
    echo extensions=${jpf-core},${jpf-symbc}
)

set "PATH=%JAVA_HOME%\bin;%JPF_DIR%\jpf-symbc\lib;%PATH%"

"%JPF_DIR%\jpf-core\bin\jpf.bat" "+site=%JPF_DIR%\site.properties" %*
