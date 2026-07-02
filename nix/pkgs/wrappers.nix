{ nix-wrapper-modules }:

let
  importWrapped =
    name:
    import ../../src/${name} {
      inherit nix-wrapper-modules;
    };
in
{
  btop = importWrapped "btop";
  tealdeer = importWrapped "tealdeer";
  tmux = importWrapped "tmux";
  vim = importWrapped "vim";
}
