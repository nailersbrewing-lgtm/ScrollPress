# Install ScrollPress on Mac (no App Store)

set -euo pipefail

IPA_PATH="${1:-./ScrollPress.ipa}"

echo ""
echo "ScrollPress — Mac install helper"
echo "================================"
echo ""

if [[ ! -f "$IPA_PATH" ]]; then
  echo "IPA not found: $IPA_PATH"
  echo "Download ScrollPress.ipa from GitHub Actions, or build with Xcode."
  exit 1
fi

echo "IPA: $IPA_PATH"
echo ""
echo "Option A — Xcode (easiest if this Mac has the project):"
echo "  open ScrollPress.xcodeproj → select your iPhone → Run"
echo ""
echo "Option B — Apple Configurator 2:"
echo "  1. Install Apple Configurator from the Mac App Store"
echo "  2. Plug in iPhone, select device"
echo "  3. Add → Apps → choose ScrollPress.ipa"
echo "  (May still need a proper signing identity depending on IPA)"
echo ""
echo "Option C — Same as Windows: use Sideloadly for Mac"
echo "  https://sideloadly.io/  → drag IPA → Apple ID → Start"
echo ""
echo "Then on iPhone: Settings → General → VPN & Device Management → Trust"
echo ""
