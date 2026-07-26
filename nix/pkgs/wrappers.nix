{ nix-wrapper-modules, nix-jetbrains-plugins }:

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
  wezterm = importWrapped "wezterm";
  pycharm = (importWrapped "jetbrains").apply (
    { pkgs, ... }: {
      inherit nix-jetbrains-plugins;
      jetbrainsIDE = pkgs.jetbrains.pycharm;
    }
  );
  pycharm-oss = (importWrapped "jetbrains").apply (
    { pkgs, ... }: {
      inherit nix-jetbrains-plugins;
      jetbrainsIDE = pkgs.jetbrains.pycharm-oss;
    }
  );
  idea = (importWrapped "jetbrains").apply (
    { pkgs, ... }: {
      inherit nix-jetbrains-plugins;
      jetbrainsIDE = pkgs.jetbrains.idea;
    }
  );
  idea-oss = (importWrapped "jetbrains").apply (
    { pkgs, ... }: {
      inherit nix-jetbrains-plugins;
      jetbrainsIDE = pkgs.jetbrains.idea-oss;
    }
  );
  rust-rover = (importWrapped "jetbrains").apply (
    { pkgs, ... }: {
      inherit nix-jetbrains-plugins;
      jetbrainsIDE = pkgs.jetbrains.rust-rover;
    }
  );
}
