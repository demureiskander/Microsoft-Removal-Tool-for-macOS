#!/bin/bash

# Microsoft Removal Tool for macOS – расширенная версия
# Удаляет все компоненты Microsoft, включая скрытые остатки, но сохраняет:
# - Visual Studio Code
# - системные файлы macOS
# - Homebrew, X11, LibreOffice и т.п.
# Основан на официальной документации Microsoft и опыте сообщества.

echo "🚽 Начинаем полное выпиливание Microsoft с Mac (с защитой VS Code)"

# ---------- Функция безопасного удаления с исключением VS Code ----------
safe_rm() {
    # $1: путь к файлу/папке
    if [[ -e "$1" && ! "$1" =~ "VSCode" && ! "$1" =~ "Visual Studio Code" ]]; then
        sudo rm -rf "$1" 2>/dev/null || true
    fi
}

# ---------- 1. Убиваем все процессы Microsoft (безопасно) ----------
echo "🛑 Завершаем процессы Microsoft..."
pkill -f "Microsoft Word" 2>/dev/null
pkill -f "Microsoft Excel" 2>/dev/null
pkill -f "Microsoft PowerPoint" 2>/dev/null
pkill -f "Microsoft Outlook" 2>/dev/null
pkill -f "Microsoft OneNote" 2>/dev/null
pkill -f "Microsoft OneDrive" 2>/dev/null
pkill -f "Microsoft AutoUpdate" 2>/dev/null
pkill -f "Microsoft Defender" 2>/dev/null
pkill -f "OfficeLicense" 2>/dev/null

# ---------- 2. Удаляем приложения из /Applications ----------
echo "🗑️ Удаляем приложения из /Applications..."
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

# ---------- 3. Удаляем системные службы и демоны (LaunchAgents + LaunchDaemons) ----------
echo "⚙️ Чистим системные службы..."
# LaunchDaemons
for f in \
    /Library/LaunchDaemons/com.microsoft.office.licensingV2.helper.plist \
    /Library/LaunchDaemons/com.microsoft.autoupdate.helper.plist \
    /Library/LaunchDaemons/com.microsoft.onedriveupdaterdaemon.plist \
    /Library/LaunchDaemons/com.microsoft.OneDriveStandaloneUpdaterDaemon.plist \
    /Library/LaunchDaemons/com.microsoft.fresno.uninstall.plist \
    /Library/LaunchDaemons/com.microsoft.wdav.tracer_install_monitor.plist
do
    sudo rm -f "$f" 2>/dev/null
done

# LaunchAgents
for f in \
    /Library/LaunchAgents/com.microsoft.update.agent.plist \
    /Library/LaunchAgents/com.microsoft.SyncReporter.plist \
    /Library/LaunchAgents/com.microsoft.OneDriveStandaloneUpdater.plist
do
    sudo rm -f "$f" 2>/dev/null
done

sudo rm -rf /Library/PrivilegedHelperTools/com.microsoft.office.licensingV2.helper 2>/dev/null
sudo rm -rf /Library/PrivilegedHelperTools/com.microsoft.autoupdate.helper 2>/dev/null

# ---------- 4. Удаляем контейнеры и настройки пользователей (с защитой VSCode) ----------
echo "📦 Чистим контейнеры пользователя..."
for user in /Users/*; do
    if [ -d "$user/Library/Containers" ]; then
        # Удаляем все папки com.microsoft.*, кроме тех, что содержат VSCode
        find "$user/Library/Containers" -maxdepth 1 -name "com.microsoft.*" -type d ! -name "*VSCode*" -exec sudo rm -rf {} + 2>/dev/null || true
        find "$user/Library/Containers" -maxdepth 1 -name "com.microsoft.onedrive.*" -type d -exec sudo rm -rf {} + 2>/dev/null || true
    fi
    if [ -d "$user/Library/Group Containers" ]; then
        # Удаляем все папки UBF8T346G9.*
        find "$user/Library/Group Containers" -maxdepth 1 -name "UBF8T346G9.*" -type d -exec sudo rm -rf {} + 2>/dev/null || true
    fi
    if [ -d "$user/Library/Preferences" ]; then
        # Удаляем все plist com.microsoft.*, кроме VSCode
        find "$user/Library/Preferences" -maxdepth 1 -name "com.microsoft.*.plist" ! -name "*VSCode*" -exec sudo rm -f {} + 2>/dev/null || true
    fi
done

# Дополнительно удаляем известные одиночные файлы (без цикла)
sudo rm -f /Library/Preferences/com.microsoft.autoupdate2.plist 2>/dev/null
sudo rm -f /Library/Preferences/com.microsoft.office.licensingV2.plist.bak 2>/dev/null

# ---------- 5. Чистим общие кэши и поддержку (с защитой VSCode) ----------
echo "🧹 Удаляем общие файлы поддержки..."
sudo rm -rf /Library/Application\ Support/Microsoft/ 2>/dev/null

# Осторожно удаляем кэши в /Library/Caches (исключая VSCode)
find /Library/Caches -maxdepth 1 -name "com.microsoft.*" ! -name "*VSCode*" -exec sudo rm -rf {} + 2>/dev/null || true

# В домашней папке
find ~/Library/Caches -maxdepth 1 -name "com.microsoft.*" ! -name "*VSCode*" -exec rm -rf {} + 2>/dev/null || true
rm -rf ~/Library/Application\ Support/Microsoft\ AutoUpdate 2>/dev/null

# ---------- 6. Удаляем остатки в /private/var/root ----------
echo "👑 Чистим остатки от root..."
safe_rm /private/var/root/Library/Preferences/com.microsoft.msa-login-hint.plist
safe_rm /private/var/root/Library/HTTPStorages/com.microsoft.OneDrivePkgTelemetry
safe_rm /private/var/root/Library/Group\ Containers/UBF8T346G9.com.microsoft.wdav
safe_rm /private/var/root/Library/Caches/com.microsoft.OneDrivePkgTelemetry

# ---------- 7. Чистим кэши в /private/var/folders (только com.microsoft.* без VSCode) ----------
echo "🧽 Чистим временные кэши..."
find /private/var/folders -type d -name "com.microsoft.*" ! -name "*VSCode*" -exec sudo rm -rf {} + 2>/dev/null || true

# ---------- 8. Удаляем пакетные рецепты (receipts) ----------
echo "📦 Забываем установленные пакеты..."
for pkg in $(pkgutil --pkgs | grep -i microsoft | grep -v VSCode); do
    sudo pkgutil --forget "$pkg" 2>/dev/null
done

# ---------- 9. Чистим Связку ключей (Keychain) от всего Microsoft ----------
echo "🔑 Чистим Связку ключей..."
security delete-internet-password -s "microsoft.com" 2>/dev/null
security delete-internet-password -s "office.com" 2>/dev/null
security delete-internet-password -s "live.com" 2>/dev/null
security delete-generic-password -l "Microsoft" 2>/dev/null
security delete-generic-password -l "Office" 2>/dev/null

# ---------- 10. Финальное сообщение ----------
echo "✅ Готово! Microsoft выпилен под корень (VS Code сохранён)."
echo "❗ Теперь перезагрузи Mac обязательно."
