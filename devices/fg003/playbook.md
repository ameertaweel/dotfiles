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

## Install Software via WinGet

```powershell
winget install Microsoft.PowerShell

winget install Microsoft.Edit
winget install vim.vim
winget install Neovim.Neovim
winget install Microsoft.VisualStudioCode

winget install Git.Git

winget install wez.wezterm

winget install Brave.Brave
winget install Mozilla.Firefox

winget install Klocman.BulkCrapUninstaller

winget install VideoLAN.VLC

winget install SumatraPDF.SumatraPDF

winget install Proton.ProtonPass

winget install Discord.Discord

winget install Valve.Steam
```

## Install WSL (Windows Subsystem for Linux)

```powershell
wsl --install
```

## Install NVIDIA App

- Download executable from:
  https://www.nvidia.com/en-eu/software/nvidia-app
- Install latest NVIDIA driver.

## Install HP Support Assistant

- Download executable from:
  https://support.hp.com/us-en/help/hp-support-assistant
- Install available updates.

## Microsoft PowerToys

Install Microsoft PowerToys:

```powershell
winget install Microsoft.PowerToys
```

Enable the following modules:

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

## Generate SSH Key

```powershell
ssh-keygen -t ed25519 -C "$USERNAME@$HOSTNAME"
```

## Install Need for Speed: Most Wanted (2005)

Apply widescreen fix.

## Install Command and Conquer Generals Zero Hour

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
