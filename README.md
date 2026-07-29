# ScrollPress

**Scroll your chat. Press print.**

A free iPhone app that turns a screen recording or screenshots of a Messages thread into a printable PDF — with simple steps and help balloons on every screen.

---

## ★ START HERE (Windows users — read this first)

If you have **never used GitHub** and want the app on your iPhone **without the App Store**, open this file and follow it from top to bottom:

### → [START-HERE.md](START-HERE.md)

It explains:

- What GitHub is (in plain English)  
- Creating free GitHub + Apple ID accounts  
- Uploading this project with **GitHub Desktop** (buttons, no coding)  
- Building `ScrollPress.ipa` in the cloud  
- Installing with **Sideloadly** on Windows  
- Trusting the app on your iPhone  
- Refreshing every ~7 days  

Shorter reference later: [INSTALL-WINDOWS-OR-MAC.md](INSTALL-WINDOWS-OR-MAC.md)

---

## What the app does

ScrollPress does **not** open the Messages app or read Apple’s private message database. Like other App Store exporters, it reads text from **captures you provide**, using on-device Vision OCR.

### User flow

1. **Welcome** — what the app does  
2. **Label** — paste phone number / contact name for the PDF title  
3. **Capture** — step-by-step screen recording (or screenshot) instructions  
4. **Import** — add screenshots or a screen recording  
5. **Reading** — on-device OCR progress  
6. **Review** — fix text, flip sides, remove junk lines  
7. **Print** — free PDF → Print / Files / Mail / AirDrop  

### English / Español

Tap the **EN ↔ ES** button in the top bar anytime. That is the only way language changes. No automatic fallback.

---

## What makes it different

| ScrollPress | Typical paid exporters |
|-------------|------------------------|
| Free for everyone — no account, no paywall | Often subscription / IAP |
| “Print press” flow: Label → Capture → Import → Review → Print | Marketing-heavy branding |
| Help balloons on every step (tap **Help** anytime) | Sparse or none |
| Seafoam + paper visual identity | Usually generic dark/purple UI |
| Edit bubbles + flip Sent/Received before export | Often OCR-only with less review |

---

## App Store later (optional)

Personal install (START-HERE) does **not** put the app on the public App Store.

To publish publicly later you need:

- Apple Developer Program ($99/year)  
- A Mac (owned, rented, or a freelancer’s) for final App Store upload  

---

## Privacy / legal

> ScrollPress never accesses the Messages database. Users import their own screenshots or screen recordings. All text recognition runs on device with Apple Vision. No account. No paywall.

Only export conversations you have a right to keep.

---

## Project layout

```
ScrollPress/
├── START-HERE.md              ← beginners start here
├── INSTALL-WINDOWS-OR-MAC.md
├── README.md
├── .github/workflows/         ← cloud build for Windows users
├── scripts/                   ← Sideloadly helpers
├── ScrollPress.xcodeproj
└── ScrollPress/               ← app source code
```
