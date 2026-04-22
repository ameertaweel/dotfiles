{
  pkgs ? (import (import ./nix/tamal {}).nixpkgs {}),
  nix-wrapper-modules ? (import (import ./nix/tamal {}).nix-wrapper-modules { inherit pkgs; }),
}:

let
  callWrappedPkg = path: extraParams: import path (extraParams // { inherit nix-wrapper-modules pkgs; });
in {
  btop = (callWrappedPkg ./btop.nix {}).wrap ({...}: {
    inherit pkgs;
  });
  tealdeer = (callWrappedPkg ./tealdeer.nix {}).wrap ({...}: {
    inherit pkgs;
  });
  tmux = (callWrappedPkg ./tmux {}).wrap ({...}: {
    inherit pkgs;
  });
  vim = (callWrappedPkg ./vim {}).wrap ({...}: {
    inherit pkgs;
  });
  wezterm = (callWrappedPkg ./wezterm {}).wrap ({...}: {
    inherit pkgs;
  });
  bash = (import ./bash.nix { inherit nix-wrapper-modules; }).config.wrap({...}: {
    config.pkgs = pkgs;

    config.bashrc = ''
      export HISTCONTROL='ignoredups:erasedups'
      set -o vi
    '';
  });
}
