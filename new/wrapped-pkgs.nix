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
      if [ -f "$HOME/.profile" ]; then
        . "$HOME/.profile"
      fi

      # ignorespace: lines which begin with a space character are not saved in the history list
      export HISTCONTROL='ignoredups:erasedups:ignorespace'
      export HISTIGNORE='cd:cd *:ls:ls *:exit:exit *'
      set -o vi

      set -o noclobber

      shopt -s histappend
      shopt -s autocd

      # Prefix a command with '\' to ignore aliases (e.g. \ls)
      alias ls='ls -lah --color=auto --group-directories-first'
      alias rm='rm --interactive --preserve-root'
      alias cp='cp --interactive'
      alias mv='mv --interactive'
      alias mkdir='mkdir --parents --verbose'
      alias ping='ping -c 5'
      alias grep='grep --color=auto'
      alias egrep='egrep --color=auto'
      alias fgrep='fgrep --color=auto'
    '';
  });
}
