@echo off
REM T-Beam Firmware Flash Script for Windows
REM Simple one-command flashing

setlocal enabledelayedexpansion

REM Configuration
set PORT=%1
if "!PORT!"=="" set PORT=COM3
set BAUD=%2
if "!BAUD!"=="" set BAUD=460800

echo.
echo ==================================================
echo   T-Beam Firmware Flasher for Windows
echo ==================================================
echo.
echo Port:      %PORT%
echo Baud:      %BAUD%
echo.

REM Check if esptool is available
python -m esptool version >nul 2>&1
if errorlevel 1 (
    echo [ERROR] esptool not found
    echo.
    echo Install with: pip install esptool
    echo.
    pause
    exit /b 1
)

REM Check firmware files
echo Checking firmware files...
for %%F in (bootloader.bin partitions.bin boot_app0.bin firmware.bin) do (
    if exist %%F (
        echo   [OK] %%F
    ) else (
        echo   [WARN] Missing: %%F
    )
)
echo.

REM Confirm
set /p CONFIRM="Ready to flash T-Beam? (Y/N): "
if /i not "%CONFIRM%"=="Y" (
    echo Cancelled
    exit /b 0
)

echo.
echo Starting flash (this may take 30 seconds)...
echo.

python -m esptool --port %PORT% -b %BAUD% --before default_reset --after hard_reset ^
    write_flash -z --flash_mode dio --flash_freq 80m --flash_size keep ^
    0x1000 bootloader.bin ^
    0x8000 partitions.bin ^
    0xe000 boot_app0.bin ^
    0x10000 firmware.bin

if errorlevel 1 (
    echo.
    echo [ERROR] Flash failed
    echo.
    echo Troubleshooting:
    echo   1. Check USB cable is connected
    echo   2. Try different USB port (COM3, COM4, etc.)
    echo   3. Close Arduino IDE if running
    echo   4. Try slower baud rate: flash.bat %PORT% 115200
    echo.
    pause
    exit /b 1
)

echo.
echo [SUCCESS] Firmware flashed successfully!
echo.
echo T-Beam will reboot automatically
echo.
echo Next steps:
echo   1. Wait 5 seconds for T-Beam to reboot
echo   2. Open Serial Monitor (115200 baud)
echo   3. Connect to T-Beam-Setup WiFi (pwd: 12345678)
echo   4. Visit 192.168.4.1 to configure network
echo.
pause