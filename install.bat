@echo off
:: ═══════════════════════════════════════════════════════════════════════════════
:: DeltaNode Business AI Installer v1.0 - Windows Launcher
:: ═══════════════════════════════════════════════════════════════════════════════

title DeltaNode Business AI Installer

echo.
echo ╔══════════════════════════════════════════════╗
echo ║        DeltaNode Business AI v1.0           ║
echo ║        Your AI assistant. Zero config.      ║
echo ╚══════════════════════════════════════════════╝
echo.

:: Run PowerShell installer
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0install.ps1"

echo.
echo Press any key to close this window...
pause >nul
