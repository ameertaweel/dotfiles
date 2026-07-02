{params, ...}: {
  programs.git = {
    enable = true;
    userName = params.name;
    userEmail = params.email;
    extraConfig = {
      init.defaultBranch = "master";
      column.ui = "auto";
      branch.sort = "-committerdate";
      tag.sort = "version:refname";
      diff = {
        algorithm = "histogram";
        colorMoved = "plain";
        mnemonicPrefix = true;
        renames = true;
      };
      push.autoSetupRemote = true;
      fetch = {
        all = true;
        prune = true;
        pruneTags = true;
      };
      help.autocorrect = "prompt";
      commit.verbose = true;
      merge.conflictstyle = "zdiff3";
      pull.rebase = true;
    };
  };
}
