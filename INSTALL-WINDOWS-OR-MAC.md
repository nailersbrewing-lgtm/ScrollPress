# Install ScrollPress (Windows or Mac)

## New to GitHub?

**Read this first — full click-by-click guide:**

# → [START-HERE.md](START-HERE.md)

That file explains what GitHub is and walks you through every step with nothing skipped.

---

## Short reminder (after you’ve done START-HERE once)

```
Windows PC → upload to GitHub → Actions builds ScrollPress.ipa
     → Sideloadly + Apple ID → iPhone → Trust developer
```

| Step | Tool |
|------|------|
| Upload project | [GitHub Desktop](https://desktop.github.com/) |
| Build IPA | GitHub → **Actions** → **Build ScrollPress IPA** |
| Install on iPhone | [Sideloadly](https://sideloadly.io/) |
| Trust app | iPhone **Settings → General → VPN & Device Management** |

Free Apple ID installs last ~**7 days** — run Sideloadly again with the same IPA to refresh.

Windows helper:

```powershell
cd "C:\Users\steve\OneDrive\Documents\Desktop\text\ScrollPress"
.\scripts\Install-Windows-Sideloadly.ps1 -IpaPath "C:\Users\steve\Downloads\ScrollPress.ipa"
```
