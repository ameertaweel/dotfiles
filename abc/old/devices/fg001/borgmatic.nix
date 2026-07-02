{
  params,
  pkgs,
  ...
}: let
  mkBorgmaticNotification = {
    title,
    urgency ? "NORMAL",
  }: ''
    export $(${pkgs.coreutils}/bin/cat /proc/$(${pkgs.procps}/bin/pgrep "gnome-session" -u "${params.username}")/environ | ${pkgs.coreutils}/bin/grep -z '^DBUS_SESSION_BUS_ADDRESS=')
    ${pkgs.libnotify}/bin/notify-send -u "${urgency}" "${title}" "Run sudo journalctl _SYSTEMD_USER_UNIT=borgmatic.service for details"
  '';

  mkBorgmaticHooks = repo: {
    before_backup = [
      (mkBorgmaticNotification {
        title = "${repo}: Backup Started";
      })
    ];
    before_prune = [
      (mkBorgmaticNotification {
        title = "${repo}: Prune Started";
      })
    ];
    before_compact = [
      (mkBorgmaticNotification {
        title = "${repo}: Compact Started";
      })
    ];
    before_check = [
      (mkBorgmaticNotification {
        title = "${repo}: Check Started";
      })
    ];
    after_backup = [
      (mkBorgmaticNotification {
        title = "${repo}: Backup Finished";
      })
    ];
    after_prune = [
      (mkBorgmaticNotification {
        title = "${repo}: Prune Finished";
      })
    ];
    after_compact = [
      (mkBorgmaticNotification {
        title = "${repo}: Compact Finished";
      })
    ];
    after_check = [
      (mkBorgmaticNotification {
        title = "${repo}: Check Finished";
      })
    ];
    on_error = [
      (mkBorgmaticNotification {
        title = "${repo}: ERROR";
        urgency = "CRITICAL";
      })
    ];
  };
in {
  services.borgmatic = {
    enable = true;
    # Useful command for systemd calendar event validation
    # `systemd-analyze calendar "*-*-* 00/8:00:00"`
    frequency = "*-*-* 00/8:00:00";
  };
  systemd.user.services.borgmatic = {
    Service.EnvironmentFile = "/run/secrets/borgmatic-env-file";
  };

  programs.borgmatic = {
    enable = true;
    backups = {
      knowledge-base = {
        location = {
          sourceDirectories = ["/home/labmem001/knowledge-base"];
          repositories = [
            {
              label = "rsync.net";
              path = "ssh://\${BORGMATIC_HOST}/./knowledge-base";
            }
          ];
          extraConfig = {
            remote_path = "borg14";
            source_directories_must_exist = true;
          };
        };
        storage = {
          extraConfig = {
            encryption_passphrase = "\${BORGMATIC_KNOWLEDGE_BASE_PASSPHRASE}";
            compression = "zstd,22"; # higher compression and lower speed
            archive_name_format = "{hostname}_{now:%Y-%m-%d}_{now:%H:%M:%S}";
          };
        };
        retention = {
          keepWithin = "2m";
        };
        consistency.checks = [
          {
            name = "repository";
            frequency = "always";
          }
          {
            name = "archives";
            frequency = "always";
          }
          {
            name = "data";
            frequency = "always";
          }
          {
            name = "extract";
            frequency = "always";
          }
        ];
        hooks.extraConfig = mkBorgmaticHooks "Knowledge Base";
      };
      full-system = {
        location = {
          sourceDirectories = ["/persist-ssd" "/persist-hdd"];
          # NOTE: I currently have a huge torrent download
          # TODO: Remove once I figure it out
          extraConfig.exclude_patterns = [
            "/persist-hdd/home/labmem001/downloads"
          ];
          repositories = [
            {
              label = "rsync.net";
              path = "ssh://\${BORGMATIC_HOST}/./backups";
            }
          ];
          extraConfig = {
            remote_path = "borg14";
            source_directories_must_exist = true;
          };
        };
        storage = {
          extraConfig = {
            encryption_passphrase = "\${BORGMATIC_FULL_SYSTEM_PASSPHRASE}";
            compression = "zstd,22"; # higher compression and lower speed
            archive_name_format = "{hostname}_{now:%Y-%m-%d}_{now:%H:%M:%S}";
          };
        };
        retention = {
          keepWithin = "2m";
        };
        consistency.checks = [
          {
            name = "repository";
            frequency = "always";
          }
          {
            name = "archives";
            frequency = "always";
          }
        ];
        hooks.extraConfig = mkBorgmaticHooks "Full System";
      };
    };
  };
}
