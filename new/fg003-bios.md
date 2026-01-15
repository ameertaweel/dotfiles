# FG003 BIOS Setup

The [HP BIOS Guide](https://kaas.hpcloud.hp.com/pdf-public/pdf_12904670_en-US-1.pdf)
is a useful resource for understanding BIOS options.

## Useful Functions

- Main | Replicated Setup
  \
  Allows exporting/importing BIOS settings to/from a USB
- Security | Hard Drive Utilities | Secure Erasure
  \
  Uses hardware-based methods to safely erase all data from a selected Hard Drive.

## Chosen Configuration

- Main | Update System BIOS | BIOS Update Preferences
  - Automatic BIOS Update Setting
    \
    Check for BIOS updates automatically, but let me decide whether to install them
  - BIOS Update Frequency
    \
    Weekly
- Main | Update System BIOS | Network Configuration Settings
  - Force HTTP `no-cache`
    \
    Enable
- Security
  - Create BIOS Administrator Password
- Security | Password Policies
  - Prompt for Admin password on F9 (Boot Menu)
    \
    Enable
  - Prompt for Admin password on F11 (System Recovery)
    \
    Enable
  - Prompt for Admin password on F12 (Network Boot)
    \
    Enable
  - Prompt for Admin password on Capsule Update
    \
    Enable
- Security | TPM Embedded Security
  - TPM State
    \
    Enable
- Security | BIOS SureStart
  - Verify Boot Block on every boot
    \
    Enable
  - Prompt on Network Controller Configuration Change
    \
    Enable
- Security
  - System Management Command
    \
    Disable
- Advanced | Boot Options
  - CD-ROM Boot
    \
    Disable
  - Network (PXE) Boot
    \
    Disable
  - Prompt on Memory Size Change
    \
    Enable
  - Prompt on Fixed Storage Change
    \
    Enable
  - NumLock om at boot
    \
    Enable
  - Legacy Boot Order
    \
    Disable
  - UEFI Boot Order
    - SSD containing Linux
    - SSD containing Windows
    - Disable other options
- Advanced | System Options
  - Configure Storage Controller for RAID
    \
    Disable
  - Virtualization Technology (VTx)
    \
    Enable
  - Virtualization Technology for Directed I/O (VTd)
    \
    Enable
- Advanced | Built-In Device Options
  - Wake On LAN
    \
    Disable
- Advanced | Option ROM Launch Policy
  - Configure Option ROM Launch Policy
    \
    All UEFI
- Advanced | Remote Management Options
  - Active Management (AMT)
    \
    Disable
