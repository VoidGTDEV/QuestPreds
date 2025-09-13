@echo off
REM ===== Pred Slider Live SwapInterval Script =====
REM Make sure your Quest 3S is connected via Wi-Fi

set "ADB="

REM --- Try to find adb.exe in PATH ---
for %%i in (adb.exe) do if "%%~$PATH:i" neq "" set "ADB=%%~$PATH:i"

REM --- Check common install locations if not found ---
if "%ADB%"=="" if exist "%USERPROFILE%\AppData\Local\Android\Sdk\platform-tools\adb.exe" set "ADB=%USERPROFILE%\AppData\Local\Android\Sdk\platform-tools\adb.exe"
if "%ADB%"=="" if exist "%USERPROFILE%\Downloads\platform-tools\adb.exe" set "ADB=%USERPROFILE%\Downloads\platform-tools\adb.exe"
if "%ADB%"=="" if exist "%USERPROFILE%\Documents\platform-tools\adb.exe" set "ADB=%USERPROFILE%\Documents\platform-tools\adb.exe"
if "%ADB%"=="" if exist "%USERPROFILE%\Desktop\platform-tools\adb.exe" set "ADB=%USERPROFILE%\Desktop\platform-tools\adb.exe"
if "%ADB%"=="" if exist "C:\platform-tools\adb.exe" set "ADB=C:\platform-tools\adb.exe"
if "%ADB%"=="" if exist "D:\platform-tools\adb.exe" set "ADB=D:\platform-tools\adb.exe"


REM --- Ask user manually if still not found ---
if "%ADB%"=="" (
    echo adb.exe not found. Please enter the full path manually:
    set /p ADB=Path to adb.exe: 
)

set "LASTVAL="

REM --- Connect to Quest (replace [IP] with your headset's IP) ---
"%ADB%" connect [IP]:5555
echo Connected devices:
"%ADB%" devices


:loop
REM Initialize VAL as empty
set "VAL="

REM Read slider value from Downloads/PredSlider
for /f "usebackq delims=" %%i in (`"%ADB%" shell cat /sdcard/Download/PredSlider/swap_interval.txt 2^>nul`) do (
    set "VAL=%%i"
)

REM If a value exists and it changed, apply swapInterval
if defined VAL (
    if not "%VAL%"=="%LASTVAL%" (
        "%ADB%" shell setprop debug.oculus.swapInterval %VAL%
        echo Current swapInterval updated: %VAL%
        set "LASTVAL=%VAL%"
    )
) else (
    echo No value found yet.
)

REM Wait 1 second before repeating
timeout /t 1 >nul
goto loop
