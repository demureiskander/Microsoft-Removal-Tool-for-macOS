#!/bin/bash

# Microsoft Removal Tool for macOS
# Removes all Microsoft components, including licenses and system services.
# Use only if you are absolutely sure you want to completely remove Microsoft from your Mac.
# Based on official Microsoft documentation and community discussions.

echo "🚽 Starting full Microsoft removal from Mac"

# 1. Kill all Microsoft processes
echo "🛑 Terminating Microsoft processes..."
pkill -f "Microsoft Word" 2>/dev/null
pkill -f "Microsoft Excel" 2>/dev/null
pkill -f "Microsoft PowerPoint" 2>/dev/null
pkill -f "Microsoft Outlook" 2>/dev/null
pkill -f "Microsoft OneNote" 2>/dev/null
pkill -f "Microsoft OneDrive" 2>/dev/null
pkill -f "Microsoft AutoUpdate" 2>/dev/null
pkill -f "Microsoft Defender" 2>/dev/null
pkill -f "OfficeLicense" 2>/dev/null

# 2. Remove applications from /Applications
echo "🗑️ Removing applications from /Applications..."
sudo rm -rf "/Applications/Microsoft Word.app" 2>/dev/null
sudo rm -rf "/Applications/Microsoft Excel.app" 2>/dev/null
sudo rm -rf "/Applications/Microsoft PowerPoint.app" 2>/dev/null
sudo rm -rf "/Applications/Microsoft Outlook.app" 2>/dev/null
sudo rm -rf "/Applications/Microsoft OneNote.app" 2>/dev/null
sudo rm -rf "/Applications/Microsoft OneDrive.app" 2>/dev/null
sudo rm -rf "/Applications/Microsoft AutoUpdate.app" 2>/dev/null
sudo rm -rf "/Applications/Microsoft Defender.app" 2>/dev/null
sudo rm -rf "/Applications/Microsoft Teams.app" 2>/dev/null
sudo rm -rf "/Applications/OneDrive.app" 2>/dev/null

# 3. Remove system services and daemons
echo "⚙️ Cleaning system services..."
sudo rm -f /Library/LaunchDaemons/com.microsoft.office.licensingV2.helper.plist 2>/dev/null
sudo rm -f /Library/LaunchDaemons/com.microsoft.autoupdate.helper.plist 2>/dev/null
sudo rm -f /Library/LaunchDaemons/com.microsoft.onedriveupdaterdaemon.plist 2>/dev/null
sudo rm -f /Library/LaunchAgents/com.microsoft.update.agent.plist 2>/dev/null
sudo rm -rf /Library/PrivilegedHelperTools/com.microsoft.office.licensingV2.helper 2>/dev/null
sudo rm -rf /Library/PrivilegedHelperTools/com.microsoft.autoupdate.helper 2>/dev/null
sudo rm -f /Library/Preferences/com.microsoft.office.licensingV2.plist 2>/dev/null

# 4. Remove user containers (settings)
echo "📦 Cleaning user containers..."
for user in /Users/*; do
  if [ -d "$user/Library/Containers" ]; then
    rm -rf "$user/Library/Containers/com.microsoft."* 2>/dev/null
    rm -rf "$user/Library/Containers/com.microsoft.onedrive."* 2>/dev/null
  fi
  if [ -d "$user/Library/Group Containers" ]; then
    rm -rf "$user/Library/Group Containers/UBF8T346G9."* 2>/dev/null
  fi
  if [ -d "$user/Library/Preferences" ]; then
    rm -f "$user/Library/Preferences/com.microsoft."* 2>/dev/null
  fi
done

# 5. Clean common caches and support files
echo "🧹 Removing shared support files..."
sudo rm -rf /Library/Application\ Support/Microsoft/ 2>/dev/null
sudo rm -rf /Library/Caches/com.microsoft.* 2>/dev/null
rm -rf ~/Library/Caches/com.microsoft.* 2>/dev/null
rm -rf ~/Library/Application\ Support/Microsoft\ AutoUpdate 2>/dev/null

# 6. Clean Keychain of all Microsoft entries
echo "🔑 Cleaning Keychain..."
security delete-internet-password -s "microsoft.com" 2>/dev/null
security delete-internet-password -s "office.com" 2>/dev/null
security delete-internet-password -s "live.com" 2>/dev/null
security delete-generic-password -l "Microsoft" 2>/dev/null
security delete-generic-password -l "Office" 2>/dev/null

# 7. Final cleanup – forget package receipts
echo "♻️ Finalizing..."
sudo pkgutil --forget com.microsoft.package.* 2>/dev/null
sudo pkgutil --forget com.microsoft.office.* 2>/dev/null

echo "✅ Done! Microsoft has been completely removed."
echo "❗ Now restart your Mac."
