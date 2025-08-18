# Windows 11 Installation Playbook

## BIOS Settings

- Disable Intel AMT (Active Management Technology).

## Account Password

Change default account password.

## Activation

Activate the system if it's not already activated.

## Windows Update

Perform all available Windows updates.

## Settings

- Set Display Resolution: `1920 x 1080`
- Enable Hibernation
- Use best performance power profile
- Enable Clipboard History
- Use Dark Theme
- Set Desktop Background

### Start Menu

- Show recently added apps.
- Do not show most used apps.
- Do not show recommended files.
- Do not show websites from browsing history.
- Do not show recommendations for tips, shortcuts, and apps.
- Do not show account-related notifications.

### Time and Language

- Set correct timezone.
- Set Windows display language to English (United States).
- Set preferred languages to English (United States) and Arabic (Saudi Arabia).
- Set country to Palestinian Authority.
- Set regional format to English (Europe).

## Install PowerShell 7

- Install via WinGet:
  ```powershell
  winget install Microsoft.PowerShell
  ```
- Set PowerShell 7 as the default profile in Windows Terminal.

## Install Editors

```powershell
winget install Microsoft.Edit
winget install vim.vim
winget install Neovim.Neovim
winget install Microsoft.VisualStudioCode
```

## Install Git

- Install via WinGet:
  ```powershell
  winget install Git.Git
  ```
- Configure Git:
  ```powershell
  git config --global user.email "$EMAIL"
  git config --global user.name "$FULL_NAME"
  git config --global init.defaultBranch master
  ```
- Generate SSH Key:
  ```powershell
  ssh-keygen -t ed25519 -C "$USERNAME@$HOSTNAME"
  ```

## Install Software via WinGet

```powershell
winget install Brave.Brave
winget install Mozilla.Firefox

winget install Klocman.BulkCrapUninstaller

winget install VideoLAN.VLC

winget install SumatraPDF.SumatraPDF

winget install Proton.ProtonPass

winget install 9NKSQGP7F2NH # WhatsApp From Microsoft Store
winget install Telegram.TelegramDesktop
winget install Discord.Discord

winget install Valve.Steam

winget install Terminals.Terminals # Remote Desktop Client
```

## Default Apps

- Set VLC as default media player
- Set Firefox as default browser
- Set Firefox as default PDF viewer

## Don't Launch on Startup

- Disable launch on startup in Discord
- Disable launch on startup in Steam
- Disable launch on startup in EA App
- Disable launch on startup for Radmin VPN in Task Manager
- Disable launch on startup for Brave Software Update in Task Manager

## Install NVIDIA App

- Download executable from:
  https://www.nvidia.com/en-eu/software/nvidia-app
- Install latest NVIDIA driver.

## Install HP Support Assistant

- Download executable from:
  https://support.hp.com/us-en/help/hp-support-assistant
- Install available updates.

## Install HP PC Hardware Diagnostic Tools

- Download executable from:
  https://support.hp.com/nz-en/help/hp-pc-hardware-diagnostics
- Run quick tests.

## Microsoft PowerToys

- Install via WinGet:
  ```powershell
  winget install Microsoft.PowerToys
  ```
- Enable preview pane in file explorer.
- Enable the following modules:
  - Command Not Found
  - Environment Variables
  - File Locksmith
  - Hosts File Editor
  - Image Resizer
  - PowerRename
  - Registry Preview
  - Keyboard Manager

### Keybindings

- Map "Caps Lock" to "Control (Left)"

### Environment Variables

- Set `HOME` to `%USERPROFILE%`.
- Set `XDG_CONFIG_HOME` to `%HOME%\.config`.

## Fonts

- Download "Hack Nerd Font" from:
  https://www.nerdfonts.com/font-downloads
- Install "Hack Nerd Font".

## WezTerm

- Install via Winget:
  ```powershell
  winget install wez.wezterm
  ```
- Copy WezTerm config to `$XDG_CONFIG_HOME/wezterm`.

### WezTerm SSH

- Create a Desktop shortcut for WezTerm.
- Right-click on the shortcut.
- From the menu, choose "Properties"
- Modify the "Target" to become:
  `"C:\Program Files\WezTerm\wezterm-gui.exe" ssh $USERNAME@$REMOTENAME`

## Games

### Need for Speed: Most Wanted (2005)

Copy game files.

### Command and Conquer Generals Zero Hour

- Install the EA App:
  ```powershell
  winget install ElectronicArts.EADesktop
  ```
- Install Command and Conquer Generals Zero Hour from the EA App.
- Download GenPatcher executable from:
  https://legi.cc/genpatcher
- Run GenPatcher.
- Apply Fixes.
- Install GenTool.
- Install Community Map Pack.
- Install Radmin VPN.

## Install WSL (Windows Subsystem for Linux)

- Restart computer
- Install WSL:
  ```powershell
  wsl --install
  ```
