@echo off
REM ===== Pred Slider Live SwapInterval Script =====
REM Make sure your Quest 3S is connected via Wi-Fi

set "ADB=C:\Users\[User]\AppData\Local\Programs\SideQuest\resources\app.asar.unpacked\build\platform-tools\adb.exe"
set "LASTVAL="

REM Connect to Quest 3S (replace with your IP)
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
