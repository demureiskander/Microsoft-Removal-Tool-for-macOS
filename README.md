# Microsoft Removal Tool for macOS

This script completely removes all Microsoft applications and components from your Mac, including licenses, services, settings, and keychain entries. Perfect for a clean reinstall of Office or if you want to erase every trace of Microsoft software from your system.

## 🔥 What the script removes

- **Applications:** Word, Excel, PowerPoint, Outlook, OneNote, OneDrive, AutoUpdate, **Microsoft Defender**, Teams (if present)
- **System services:** LaunchDaemons, LaunchAgents, PrivilegedHelperTools
- **Containers and settings:** folders in `~/Library/Containers`, `~/Library/Group Containers`, `~/Library/Preferences`
- **Caches and support files:** `/Library/Caches`, `~/Library/Caches`, `/Library/Application Support/Microsoft`
- **Keychain:** all entries related to `microsoft`, `office`, `live.com`
- **Package receipts:** forgets `pkgutil` records so the system considers the software completely removed

## 🚀 How to use

1. **Download the script** (or copy the code below into a file named `uninstall_ms.sh`).
2. Open **Terminal** and navigate to the folder containing the script:
   ```bash
   cd /path/to/folder
   ```
3. Make the script executable:
   ```bash
   chmod +x uninstall_ms.sh
   ```
4. Run it with administrator privileges:
   ```bash
   sudo ./uninstall_ms.sh
   ```
5. Restart your Mac after completion – this is mandatory for a full cleanup (optional / recomded).

## ⚠️ Important warnings

Irreversible: after running the script, all Microsoft applications and data will be permanently deleted. Files in iCloud/OneDrive remain in the cloud, but local copies are erased.

Backup: it is strongly recommended to create a Time Machine backup before proceeding.

Microsoft Defender quirk: the script attempts to remove Microsoft Defender.app, but sometimes a stub application remains (clicking it opens a browser). If after reboot the Defender icon still appears in the Applications folder, delete it manually (drag to Trash) or use AppCleaner to find and remove any leftover files. The script already covers the main Defender files, but manual intervention may be needed for the stub.

Licenses: yes, the script deletes all license files and keychain entries, so you will have a completely fresh state for any future Microsoft software installation.

Compatibility: tested on macOS Ventura, Sonoma, Sequoia (both Apple Silicon and Intel).

## ❓ Why might Defender remain? / What to do if Defender doesn't get removed?

Why might Defender remain?
Even after running the main script, some associated files of Microsoft Defender can be left behind because they are stored in multiple protected system folders. A standard removal script might not catch all of them.

What to do if Defender doesn't get removed?
We strongly recommend using AppCleaner. It’s a free tool that scans for every file related to an application and removes them completely. Just drag Microsoft Defender.app into AppCleaner, and it will do the rest.

- Download AppCleaner from freemacsoft.net/appcleaner

- Or install via Homebrew:
  ```bash
  brew install --cask appcleaner
  ```
