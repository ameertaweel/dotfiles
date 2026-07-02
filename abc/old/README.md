# dotfiles

This is my personal dotfiles configuration for NixOS using flakes.

## Usage Instructions

1. Clone this repository to your home directory.
2. `cd` into the repository's directory.
3. Run `sudo nixos-rebuild switch --flake .`.
4. Run `home-manager switch --flake .#USERNAME@HOSTNAME`.
4. Setup SSH configuration.

## Useful Resources

+ [NixOS Manual](https://nixos.org/manual/nixos/stable/)
  Can be replaced with: `nixos-help`
+ [NixOS Package Search](https://search.nixos.org/packages)
+ [NixOS Option Search](https://search.nixos.org/options)
+ [NixOS Manual - Options Appendix](https://nixos.org/manual/nixos/stable/options.html)\
  Can be replaced with: `man configuration.nix`
+ [HomeManager Manual - Options Appendix](https://nix-community.github.io/home-manager/options.html)\
  Can be replaced with: `man home-configuration.nix`
+ [Nixpkgs Pull Request Tracker](https://nixpk.gs/pr-tracker.html)

## Long Term TODOs

| TODO                                  | Waiting For                   |
|---------------------------------------|-------------------------------|
| Game Emulator Support                 | Better GPU Support            |
| Steam Game Configuration              | Better GPU Support [[1]]      |
| Legendary Game Launcher Configuration | Better GPU Support            |
| Wine Configuration                    | Better GPU Support            |
| Fix Discord screensharing sound issue | Proper Discord Solution [[2]] |
| Setup Printer and Scanner [[3]] [[4]] | Having Access Back            |
| Use Neorg instead of Emacs Org Mode   | Neorg Becomes Ready [[5]]     |

[1]: https://youtu.be/v9tb1gTTbJE
[2]: https://support.discord.com/hc/en-us/community/posts/360050971374-Linux-Screen-Share-Sound-Support
[3]: https://nixos.wiki/wiki/Printing
[4]: https://nixos.wiki/wiki/Scanners
[5]: https://github.com/nvim-neorg/neorg
