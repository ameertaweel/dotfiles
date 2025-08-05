###############################################################################
#
# Create NixOS WSL Distro
#
# Quickly setup NixOS on Windows via WSL.
# https://github.com/nix-community/NixOS-WSL
#
# Usage:
# .\create-nixos-wsl.ps1 -DistroName <Name> [-NoRedownload]
#
# Parameters:
#   - DistroName (string, required)
#     Name for the new WSL distribution (e.g., NixOS).
#   - NoRedownload (switch, optional)
#     If specified, skips re-downloading nixos.wsl if it already exists locally.
#
# What the script does:
#   - Ensures WSL is installed.
#   - Verifies WSL version is ≥ 2.4.4.
#   - Download latest NixOS WSL image from GitHub.
#     Skips download if file exists and -NoRedownload is specified.
#   - Install NixOS distribution
#   - Copy SSH keys from host Windows system
#   - Copy Git config from host Windows system
#   - Update NixOS system
#
###############################################################################

###############################################################################
# Init
###############################################################################

param (
    [Parameter(Mandatory=$true)]
    [string]$DistroName,
    [switch]$NoRedownload
)

# Ensure script stops on error
$ErrorActionPreference = "Stop"

function Convert-WindowsPathToWSL {
    param (
        [string]$WindowsPath
    )

    # Replace backslashes with forward slashes
    $Path = $WindowsPath -replace "\\", "/"

    # Extract drive letter (before colon)
    if ($Path -match "^([a-zA-Z]):(.*)") {
        $Drive = $matches[1].ToLower()
        $Rest = $matches[2]
        return "/mnt/$drive$rest"
    } else {
        Write-Error "Invalid Windows path format."
    }
}

###############################################################################
# Check WSL Setup
###############################################################################

Write-Host "Checking if WSL is installed..."

if (-not (Get-Command wsl -ErrorAction SilentlyContinue)) {
    Write-Error "WSL 2 is not installed. Please install it first."
    exit 1
}

$WSLVersion = (wsl --version 2>&1 | Where-Object { $_ -ne "" })[0] -replace "`0", ""
if ($WSLVersion -match "^WSL version: (.*)$") {
    $CurVersion = [version]$matches[1]
    $MinVersion = [version]"2.4.4"
    if ($CurVersion -lt $MinVersion) {
        Write-Error "WSL version should be at least $MinVersion. You have $CurVersion."
        exit 1
    }
}

Write-Host "WSL 2 is installed and set as default."

###############################################################################
# Download NixOS WSL Image
###############################################################################

$DownloadFile = Join-Path (Get-Location) "nixos.wsl"

if ((Test-Path $DownloadFile -PathType Leaf) -and $NoRedownload) {
    Write-Host "Found ``$DownloadFile``. Skipping NixOS WSL download."
} else {
    Write-Host "Finding the latest release of NixOS-WSL on GitHub..."

    $RepoAPI = "https://api.github.com/repos/nix-community/NixOS-WSL/releases/latest"
    $Response = Invoke-RestMethod -Uri $RepoAPI

    # Find the `nixos.wsl` file
    $Asset = $Response.assets | Where-Object { $_.name -match "^nixos.wsl$" }
    if (-not $Asset) {
        Write-Error "No valid NixOS-WSL release archive found in the latest GitHub release."
        exit 1
    }

    $DownloadURL = $Asset.browser_download_url
    Write-Host "Downloading: $DownloadURL..."

    Invoke-WebRequest -Uri $DownloadURL -OutFile $DownloadFile
}

###############################################################################
# Create NixOS WSL Distro
###############################################################################

$InstallDirectory = Join-Path (Get-Location) $DistroName

if (!(Test-Path $InstallDirectory)) {
    Write-Host "Creating installation directory at ``$InstallDirectory``"
    New-Item -Path $InstallDirectory -ItemType Directory | Out-Null
}

Write-Host "Importing NixOS WSL into WSL as distribution ``$DistroName``..."

wsl --install `
    --from-file $DownloadFile `
    --name $DistroName `
    --location $InstallDirectory `
    --vhd-size 100GB `
    --no-launch

###############################################################################
# Copy SSH Keys From Windows Host
###############################################################################

$SSHDir = "$HOME\.ssh"

$PossiblePrivateKeys = (Get-ChildItem -Path $sshDir -File).Where{
    $_.Name -notlike "*.pub"
}

$KeyNames = @()

foreach ($Key in $PossiblePrivateKeys) {
    $PublicKeyPath = Join-Path $SSHDir ($Key.Name + ".pub")
    if (Test-Path $PublicKeyPath) {
        $KeyNames += $Key.Name
    }
}

wsl --distribution $DistroName -- `
    bash -c "[ -d ~/.ssh ] || (mkdir -p ~/.ssh && chmod 700 ~/.ssh)"

$KeyNames | ForEach-Object {
    $PrivateKeyPath = Join-Path $SSHDir $_
    $PublicKeyPath = Join-Path $SSHDir ($_ + ".pub")

    wsl --distribution $DistroName -- `
        bash -c "cp `"$(Convert-WindowsPathToWSL $PrivateKeyPath)`" ~/.ssh"
    wsl --distribution $DistroName -- `
        bash -c "chmod 600 ~/.ssh/$_"
    wsl --distribution $DistroName -- `
        bash -c "cp `"$(Convert-WindowsPathToWSL $PublicKeyPath)`" ~/.ssh"
    wsl --distribution $DistroName -- `
        bash -c "chmod 644 ~/.ssh/$_.pub"

    Write-Host "Copied SSH key: ``$_``."
}

###############################################################################
# Copy Git Config From Windows Host
###############################################################################

$GitName = git config --global user.name
$GitMail = git config --global user.email

wsl --distribution $DistroName -- `
    bash -c "nix-shell --packages git --run 'git config --global user.name `"$GitName`"'"
wsl --distribution $DistroName -- `
    bash -c "nix-shell --packages git --run 'git config --global user.email `"$GitMail`"'"
wsl --distribution $DistroName -- `
    bash -c "nix-shell --packages git --run 'git config --global init.defaultBranch master'"

Write-Host "Copied Git config."

###############################################################################
# Update NixOS
###############################################################################

wsl --distribution $DistroName -- `
    bash -c "sudo nix-channel --update"
wsl --distribution $DistroName -- `
    bash -c "sudo nixos-rebuild switch"

###############################################################################
# Finish
###############################################################################

Write-Host "Done! NixOS WSL is now installed as ``$DistroName`` in ``$InstallDirectory``."
