{...}: {
  imports = [
    (import ./jet-mod.nix {
      ideName = "idea-oss";
      ideDisplayName = "IntelliJ IDEA OSS";
    })
    (import ./jet-mod.nix {
      ideName = "idea";
      ideDisplayName = "IntelliJ IDEA";
      unfree = true;
    })
    (import ./jet-mod.nix {
      ideName = "pycharm-oss";
      ideDisplayName = "PyCharm OSS";
    })
    (import ./jet-mod.nix {
      ideName = "pycharm";
      ideDisplayName = "PyCharm";
      unfree = true;
    })
  ];
}

