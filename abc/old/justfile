fg001-build:
  cd {{justfile_directory()}}
  nixos-rebuild --flake "{{justfile_directory()}}/devices/fg001#fg001" build

fg001-boot:
  cd {{justfile_directory()}}
  sudo nixos-rebuild --flake "{{justfile_directory()}}/devices/fg001#fg001" boot && nixos-rebuild-summary

fg001-switch:
  cd {{justfile_directory()}}
  sudo nixos-rebuild --flake "{{justfile_directory()}}/devices/fg001#fg001" switch && nixos-rebuild-summary

vg001-build:
  cd {{justfile_directory()}}
  nixos-rebuild --flake ./devices/vg001#vg001 --build-host labmem001@vg001 --target-host labmem001@vg001 --use-substitutes build

vg001-boot:
  cd {{justfile_directory()}}
  nixos-rebuild --flake ./devices/vg001#vg001 --build-host labmem001@vg001 --target-host labmem001@vg001 --sudo --no-reexec --ask-sudo-password --use-substitutes boot

vg001-switch:
  cd {{justfile_directory()}}
  nixos-rebuild --flake ./devices/vg001#vg001 --build-host labmem001@vg001 --target-host labmem001@vg001 --sudo --no-reexec --ask-sudo-password --use-substitutes switch

format:
  cd {{justfile_directory()}}
  nix fmt .
