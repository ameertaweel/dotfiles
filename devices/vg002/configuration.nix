{
  config,
  lib,
  outputs,
  pkgs,
  params,
  ...
}: let
  modules = {
    hardware = import ./hardware.nix {
      inherit (params) system hostId diskEncryptionKeyFile persistDirBackup persistDirNoBackup;
    };
    impermanence = import ./impermanence.nix {
      inherit (params) persistDirBackup persistDirNoBackup;
      secretsDir = params.secrets.dir;
    };
    users = import ./users.nix {
      inherit (params) username sshKey userHashedPassword rootHashedPassword;
    };
    ssh = import ./ssh.nix {
      persistDir = params.persistDirNoBackup;
    };
    sshInitrd = import ./ssh-initrd.nix {
      enable = !params.isBeforeInstall;
      sshPort = params.initrdSSHPort;
      authorizedKey = params.sshKey;
      persistDir = params.persistDirNoBackup;
    };
    postgres = import ./postgres.nix {
      persistDir = params.persistDirNoBackup;
    };
    postgresBackup = import ./postgres-backup.nix {
      persistDir = params.persistDirBackup;
    };
    tailscale = import ./tailscale.nix {
      persistDir = params.persistDirNoBackup;
    };
    caddy = import ./caddy.nix {
      persistDirLogs = params.persistDirBackup;
      persistDirData = params.persistDirNoBackup;
      environmentFile = params.secrets.caddyEnvFile;
    };
    ntfy = import ./ntfy.nix {
      inherit (params.ntfy) domain port version;
      persistDir = params.persistDirNoBackup;
      environmentFile = params.secrets.ntfyEnvFile;
    };
    miniflux = import ./miniflux.nix {
      inherit (params.miniflux) domain port version;
      environmentFile = params.secrets.minifluxEnvFile;
    };
    searxng = import ./searxng.nix {
      inherit (params.searxng) domain port version;
      environmentFile = params.secrets.searxngEnvFile;
    };
    stirlingPDF = import ./stirling-pdf.nix {
      inherit (params.stirlingPDF) domain port version;
    };
  };

  commonImports = [
    modules.hardware
    modules.impermanence
    modules.users
    modules.ssh
    modules.sshInitrd

    ../../modules/nixos/nix.nix
    ../../modules/nixos/nix-index.nix
  ];

  postInstallImports =
    if !params.isBeforeInstall
    then [
      modules.postgres
      modules.postgresBackup
      modules.caddy
      modules.ntfy
      modules.miniflux
      modules.searxng
      modules.stirlingPDF
      modules.tailscale
    ]
    else [];
in {
  imports = commonImports ++ postInstallImports;
  nix.settings = {
    download-buffer-size = 4 * 524288000; # 500 MiB
  };
  environment.systemPackages = map lib.lowPrio [
    pkgs.vim
    pkgs.curl
    (config.programs.git.package or pkgs.gitMinimal)
    pkgs.tmux
    pkgs.jq
    pkgs.curl
    pkgs.wget
    (pkgs.writeShellScriptBin "service-exec" (outputs.lib.readShellScript ./service-exec.sh))
  ];
  environment.variables = {
    PAGER = "less -S";
  };

  documentation.man.generateCaches = true;
  networking.hostName = params.hostname;

  system.stateVersion = params.state-version;
}
