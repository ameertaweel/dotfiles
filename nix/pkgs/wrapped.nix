{ nix-wrapper-modules }:

{
  tmux = import ../../tmux { inherit nix-wrapper-modules; };
}
