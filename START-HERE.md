# START HERE — Put ScrollPress on your iPhone from Windows

**You do not need to know GitHub already.**  
**You do not need to own a Mac.**  

This guide assumes you have never used GitHub. Follow every step in order. Do not skip steps.

---

## What is GitHub? (30-second explanation)

**GitHub** is a free website (like Google Drive, but for computer programs).

We use it for two things:

1. **Store** your ScrollPress project online  
2. **Build** the iPhone app for you on Apple’s computers in the cloud (this is called **Actions**)

When the build finishes, GitHub gives you a file called **`ScrollPress.ipa`**.  
That file is the app. Then a free Windows program called **Sideloadly** puts that file onto your iPhone.

```
You (Windows PC)
   → upload project to GitHub
   → GitHub builds ScrollPress.ipa (cloud Mac)
   → you download the .ipa
   → Sideloadly installs it on your iPhone
```

---

## Checklist — create these first

Do these **before** anything else.

### ☐ 1. A free GitHub account

1. Open your browser  
2. Go to: https://github.com/signup  
3. Enter email, password, username  
4. Verify your email if GitHub asks  
5. You do **not** need to pay. Stay on the free plan.

Write down:

- GitHub username: ________________  
- GitHub email: ________________  

### ☐ 2. An Apple ID (you probably already have one)

**You do NOT need to create a new Apple ID.**

Apple now often requires a **cell phone number** for new accounts, and **one number can usually only be tied to one Apple ID**. If your number is already on another account, skip making a new one.

Use the Apple ID you **already use on this iPhone** (Settings → [your name] at the top). That same account works for Sideloadly.

Write down:

- Apple ID email (the one already on your iPhone): ________________  
- Password: (you already know it — don’t write it in a shared file)

#### If you somehow have no Apple ID at all

Then you must create one at https://appleid.apple.com — and Apple will ask for a phone number. Options if your main number is taken:

| Option | Notes |
|--------|--------|
| Use a family member’s number | They get the verification text; ask them first |
| Cheap prepaid SIM / second phone | Dedicated number for a second Apple ID |
| Landline (if Apple offers voice call verify) | Sometimes available instead of SMS |

Do **not** buy random “Apple ID for sale” accounts — they get locked and can lock your device.

**For ScrollPress install: existing Apple ID = correct choice.**

### ☐ 3. Your iPhone + cable

- iPhone unlocked  
- Lightning or USB‑C cable that can transfer data (not charge-only)  
- Your Windows PC  

### ☐ 4. Know where the project is on your PC

Your project folder should be here:

```
C:\Users\steve\OneDrive\Documents\Desktop\text\ScrollPress
```

Open File Explorer and confirm you can see these **inside** that folder:

- `ScrollPress.xcodeproj` (a folder/file for Xcode)  
- `ScrollPress` (another folder with the Swift code)  
- `.github` (folder — if you don’t see it, in File Explorer turn on **View → Hidden items**)  
- `INSTALL-WINDOWS-OR-MAC.md`  
- `START-HERE.md` (this file)  

If that path is different on your PC, use **your** real path everywhere below.

---

# PART A — Put the project on GitHub

**Use Part A‑WEB below** (browser only — no GitHub Desktop).  
Part A‑DESKTOP is optional if Desktop works for you later.

---

## PART A‑WEB — Upload from the GitHub website

### Picture this

You will have **two windows**:

1. **Browser** = GitHub website (where files go)  
2. **File Explorer** = your PC folders (where files are now)

You move copies of your project files from File Explorer → into GitHub.

---

### A-WEB 1. Create the empty box on GitHub

1. Open **Chrome** or **Edge**  
2. Go to https://github.com and sign in  
3. Click **+** (top right) → **New repository**  
4. Repository name: `ScrollPress`  
5. Select **Private**  
6. Do **not** check “Add a README”  
7. Click green **Create repository**

You now have an empty project page on the internet. That is correct.

---

### A-WEB 2. Open GitHub’s upload screen

On that empty page, find and click **either**:

- the words **uploading an existing file**, **or**  
- **Add file** (button) → **Upload files**

You should see a large empty area that says roughly:

**“Drag files here to add them to your repository”**

and a link **choose your files**.

Leave this browser tab open.

---

### A-WEB 3. Open your project on the PC

1. Click the yellow **File Explorer** icon on your Windows taskbar  
2. Click the address bar at the top, paste this, press Enter:

```
C:\Users\steve\OneDrive\Documents\Desktop\text\ScrollPress
```

3. Click **View** → turn on **Hidden items**  
4. You should see folders named:

- `.github`  
- `ScrollPress`  
- `ScrollPress.xcodeproj`  
- `scripts`  

and files like `START-HERE.md`, `README.md`

---

### A-WEB 4. Put files onto GitHub (one at a time)

Ignore Ctrl+A. Do this slowly:

1. Make the **browser** and **File Explorer** both visible (side by side if you can)  
2. In File Explorer, put the mouse on the folder **`.github`**  
3. Press and **hold** the left mouse button  
4. Move the mouse onto the big GitHub upload area in the browser  
5. **Release** the mouse button  
6. Wait until GitHub shows that folder/files in the list  

Repeat for each of these, one by one:

| Drag this from File Explorer | Onto GitHub |
|------------------------------|-------------|
| `.github` folder | yes |
| `ScrollPress` folder | yes |
| `ScrollPress.xcodeproj` folder | yes |
| `scripts` folder | yes |
| `START-HERE.md` file | yes |
| `README.md` file | yes |
| `INSTALL-WINDOWS-OR-MAC.md` file | yes |

That is all “upload” means: copy those items into the website box.

---

### A-WEB 5. Save it on GitHub

1. Scroll to the **bottom** of the GitHub page  
2. Find **Commit changes**  
3. In the box, type: `First upload of ScrollPress`  
4. Click the green **Commit changes** button  
5. Wait a few seconds  

You should now see your folders listed on the normal GitHub repo page (not the upload page anymore).

---

### A-WEB 6. Check

You should see `.github`, `ScrollPress`, `ScrollPress.xcodeproj`, `scripts`.

Click `.github` → `workflows` → file **`build-ipa.yml`** must be there.

If something is missing: **Add file → Upload files** again, drag only what’s missing, Commit again.

**Next: PART B** (build the IPA).

---

## PART A‑DESKTOP — skip this

GitHub Desktop is optional. You are using the website only.

---

# PART B — Build the iPhone app file (IPA) on GitHub

GitHub will compile the app for you.

## B1. Open Actions

1. On your repo page (`github.com/YOUR_USERNAME/ScrollPress`)  
2. Click the **Actions** tab at the top  

### If you see “Get started with GitHub Actions” or workflows are disabled

1. Click **I understand my workflows, go ahead and enable them**  
   (wording may vary slightly)  
2. Or open **Settings → Actions → General** → allow actions → **Save**

## B2. Run the build

1. In the left sidebar under Actions, click **Build ScrollPress IPA**  
2. Click **Run workflow** (right side)  
3. Branch should be **main** (or **master**)  
4. Click the green **Run workflow** button  
5. Wait 1–2 seconds, then refresh the page  
6. Click the newest running workflow (it will say “Build ScrollPress IPA”)  

## B3. Wait for the green check

- Yellow circle / spinning = still working (often **5–15 minutes**)  
- **Green check** = success  
- **Red X** = failed  

### If it failed (red X)

1. Click the failed run  
2. Click the job **build-ipa**  
3. Expand the red step and read the error  
4. Copy the error text and ask for help (paste it into chat)  

Common first-time issues:

- Actions not enabled → fix in Settings → Actions  
- Workflow file missing → make sure `.github/workflows/build-ipa.yml` is on GitHub (check in the Code tab)

## B4. Download `ScrollPress.ipa`

1. Open the **successful** (green) workflow run  
2. Scroll to the bottom to **Artifacts**  
3. Click **ScrollPress-ipa**  
4. Your browser downloads a zip (sometimes named `ScrollPress-ipa.zip`)  
5. Open your **Downloads** folder  
6. Right-click the zip → **Extract All…** → Extract  
7. Inside you should find **`ScrollPress.ipa`**  

Put it somewhere easy, for example:

```
C:\Users\steve\Downloads\ScrollPress.ipa
```

or

```
C:\Users\steve\Desktop\ScrollPress.ipa
```

**Do not lose this file.** Sideloadly needs it.

---

# PART C — Install on your iPhone from Windows (Sideloadly)

## C1. Install Apple’s Windows driver (so the PC sees the iPhone)

Pick **one**:

### Option 1 (recommended on Windows 11)

1. Open Microsoft Store  
2. Search **Apple Devices**  
3. Install **Apple Devices**  
4. Open it once  

### Option 2

1. Install iTunes for Windows from Apple: https://www.apple.com/itunes/  

## C2. Install Sideloadly

1. Go to: https://sideloadly.io/  
2. Download the **Windows** version  
3. Install and open **Sideloadly**  
4. If Windows Firewall asks, allow it  

## C3. Connect your iPhone

1. Unlock your iPhone  
2. Plug it into the PC with the cable  
3. On the iPhone, tap **Trust** if asked, enter your passcode  
4. In Sideloadly, your iPhone should appear in the device list  

If it does not appear:

- Try another cable  
- Unlock the phone  
- Unplug/replug  
- Restart Sideloadly  
- Open Apple Devices / iTunes once so drivers load  

## C4. Install ScrollPress with Sideloadly

1. Open Sideloadly  
2. Drag **`ScrollPress.ipa`** into the Sideloadly window  
   (or click the IPA box and browse to the file)  
3. In **Apple ID**, type the **same Apple ID email already on your iPhone**  
   (Settings → tap your name at the top — that email)  
4. Click **Start**  
5. Enter that Apple ID password when asked  
6. If Apple sends a **two-factor code** to your iPhone, type that code into Sideloadly  
7. Wait until Sideloadly says the install finished (can take several minutes)  

**You do not need a second Apple ID.** Your existing account is enough. New accounts needing a second cell number are unnecessary for this install.

### Optional helper script

If you want Windows to open Sideloadly and the IPA folder for you:

1. Open PowerShell  
2. Run:

```powershell
cd "C:\Users\steve\OneDrive\Documents\Desktop\text\ScrollPress"
.\scripts\Install-Windows-Sideloadly.ps1 -IpaPath "C:\Users\steve\Downloads\ScrollPress.ipa"
```

(Change the `-IpaPath` if your IPA is somewhere else.)

## C5. Trust the app on the iPhone (required)

The app may appear on the home screen but refuse to open until you trust it.

1. On iPhone open **Settings**  
2. Tap **General**  
3. Tap **VPN & Device Management**  
   (on older iOS it may say **Device Management** or **Profiles & Device Management**)  
4. Tap your Apple ID / developer entry  
5. Tap **Trust …**  
6. Confirm **Trust**  

## C6. Open ScrollPress

1. Find the **ScrollPress** icon on your home screen  
2. Open it  
3. Use the **EN ↔ ES** button at the top to switch language  
4. Follow the help balloons  

---

# PART D — Every ~7 days (free Apple ID)

Apple free developer installs expire about every **7 days**.

When ScrollPress says it cannot open / integrity could not be verified:

1. Connect iPhone to PC  
2. Open Sideloadly  
3. Use the **same** `ScrollPress.ipa` again  
4. Same Apple ID → **Start**  
5. Trust again only if iOS asks  

You do **not** need to rebuild on GitHub unless you changed the code.

---

# PART E — If you have a Mac instead

You can still use the same GitHub IPA + Sideloadly for Mac: https://sideloadly.io/

Or on the Mac:

1. Install Xcode from the Mac App Store  
2. Open `ScrollPress.xcodeproj`  
3. Plug in iPhone  
4. Signing → your Apple ID  
5. Press **Run** ▶  

---

## Quick “where am I?” map

| Step | You should have… |
|------|-------------------|
| After Part A | Repo visible at `github.com/YOU/ScrollPress` |
| After Part B | File `ScrollPress.ipa` on your PC |
| After Part C | ScrollPress icon on iPhone, opens after Trust |
| After Part D | App refreshed when the 7‑day timer hits |

---

## FAQ

### Is this the App Store?

No. This installs **only on your iPhone** with your Apple ID. Other people cannot download it from the App Store this way.

### Is this illegal / hacking?

No. You are signing the app with **your own** Apple ID using a normal sideload tool. Do not use stolen accounts or cracked certificates.

### Do I pay GitHub?

No, free account is enough for personal builds. GitHub limits free “Actions minutes”; one ScrollPress build usually fits easily.

### Do I pay Apple?

Not for this personal install method.  
App Store public release later would need the paid Apple Developer Program ($99/year).

### I got stuck. What do I send for help?

Send:

1. Which Part letter you are on (A / B / C / D)  
2. A screenshot of the error  
3. If Part B failed: the red error text from Actions  

---

## File map (what each important thing is)

| File / folder | Purpose |
|---------------|---------|
| `START-HERE.md` | This walkthrough |
| `INSTALL-WINDOWS-OR-MAC.md` | Shorter reference (same process) |
| `.github/workflows/build-ipa.yml` | Tells GitHub how to build the IPA |
| `scripts/Install-Windows-Sideloadly.ps1` | Helper for Windows |
| `ScrollPress.xcodeproj` | The Xcode project GitHub builds |
| `ScrollPress/` | The actual app source code |
