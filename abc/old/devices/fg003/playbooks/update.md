# Windows 11 Update Playbook

## Windows Update

Perform any available updates.

## WinGet

- List available updates via:
  ```powershell
  winget upgrade
  ```
- Perform update:
  ```powershell
  winget upgrade --all
  ```
- Force update when WinGet refuses to update:
  ```powershell
  winget install --id $PKG_ID -s winget -v $PKG_VERSION --uninstall-previous --force
  ```
  Example:
  ```powershell
  winget install --id Microsoft.PowerShell -s winget -v 7.5.4.0 --uninstall-previous --force
  ```


## NVIDIA

Perform any available driver updates in NVIDIA App.

## HP Support Assistant

Perform any available updates in HP Support Assistant.
