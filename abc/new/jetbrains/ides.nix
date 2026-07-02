{ ... }: {
  imports = [
    (import ./mk-ide-module.nix {
      ideName = "idea-oss";
      ideDisplayName = "IntelliJ IDEA OSS";
    })
    (import ./mk-ide-module.nix {
      ideName = "idea";
      ideDisplayName = "IntelliJ IDEA";
      unfree = true;
    })
    (import ./mk-ide-module.nix {
      ideName = "pycharm-oss";
      ideDisplayName = "PyCharm OSS";
    })
    (import ./mk-ide-module.nix {
      ideName = "pycharm";
      ideDisplayName = "PyCharm";
      unfree = true;
    })
  ];
}
