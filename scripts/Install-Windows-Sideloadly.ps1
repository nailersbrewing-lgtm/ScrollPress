# Install ScrollPress from Windows with Sideloadly
#
# Prerequisites:
# 1. Free Apple ID (appleid.apple.com)
# 2. iPhone USB cable + iTunes / Apple Devices app for Windows
# 3. Sideloadly: https://sideloadly.io/
# 4. ScrollPress.ipa (from GitHub Actions artifact — see INSTALL-WINDOWS-OR-MAC.md)

param(
    [string]$IpaPath = ".\ScrollPress.ipa",
    [string]$SideloadlyPath = "$env:LOCALAPPDATA\Sideloadly\sideloadly.exe"
)

Write-Host ""
Write-Host "ScrollPress — Windows install helper" -ForegroundColor Cyan
Write-Host "====================================="
Write-Host ""

if (-not (Test-Path $IpaPath)) {
    Write-Host "IPA not found at: $IpaPath" -ForegroundColor Red
    Write-Host "Download ScrollPress.ipa from your GitHub Actions run (Artifacts → ScrollPress-ipa)."
    Write-Host "Then re-run:"
    Write-Host '  .\scripts\Install-Windows-Sideloadly.ps1 -IpaPath "C:\path\to\ScrollPress.ipa"'
    exit 1
}

Write-Host "IPA found: $((Resolve-Path $IpaPath).Path)"
Write-Host ""
Write-Host "Manual Sideloadly steps (recommended):" -ForegroundColor Yellow
Write-Host "  1. Install Sideloadly from https://sideloadly.io/"
Write-Host "  2. Plug iPhone into this PC and unlock it. Tap Trust if asked."
Write-Host "  3. Open Sideloadly."
Write-Host "  4. Drag ScrollPress.ipa into Sideloadly."
Write-Host "  5. Enter your Apple ID (used only to sign the app for YOUR device)."
Write-Host "  6. Click Start and wait until install finishes."
Write-Host "  7. On iPhone: Settings → General → VPN & Device Management"
Write-Host "     → trust your Apple ID developer profile."
Write-Host "  8. Open ScrollPress."
Write-Host ""
Write-Host "Note: Free Apple ID installs expire about every 7 days." -ForegroundColor DarkYellow
Write-Host "Re-run Sideloadly with the same IPA to refresh."
Write-Host ""

if (Test-Path $SideloadlyPath) {
    Write-Host "Opening Sideloadly..."
    Start-Process $SideloadlyPath
} else {
    Write-Host "Sideloadly not found at default path. Open it yourself after install." -ForegroundColor DarkYellow
}

# Reveal IPA in Explorer for easy drag-drop
Invoke-Item (Split-Path -Parent (Resolve-Path $IpaPath))
