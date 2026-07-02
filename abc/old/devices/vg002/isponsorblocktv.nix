{
  version,
  persistDir ? null,
  ...
}: {
  pkgs,
  lib,
  outputs,
  ...
}: let
  stateDir = "isponsorblocktv";
  baseDir = "/var/lib/${stateDir}";
  package = pkgs.isponsorblocktv;
  user = "isponsorblocktv";
  group = "isponsorblocktv";
in {
  assertions = [
    (outputs.lib.assertPkgVersion {
      displayName = "iSponsorBlockTV";
      versionExpected = version;
      versionActual = package.version;
    })
  ];

  ##############################################################################
  # Service Configuration                                                      #
  ##############################################################################

  systemd.services.isponsorblocktv = {
    description = "SponsorBlock client for all YouTube TV clients";

    wantedBy = ["multi-user.target"];
    after = ["network.target"];

    serviceConfig = {
      ExecStart = "${package}/bin/iSponsorBlockTV -d ${baseDir}";
      User = user;
      StateDirectory = stateDir;

      PrivateTmp = true;
      NoNewPrivileges = true;
      CapabilityBoundingSet = "CAP_NET_BIND_SERVICE";
      ProtectSystem = "full";
      ProtectKernelTunables = true;
      ProtectKernelModules = true;
      ProtectKernelLogs = true;
      ProtectControlGroups = true;
      PrivateDevices = true;
      RestrictSUIDSGID = true;
      RestrictNamespaces = true;
      RestrictRealtime = true;
      MemoryDenyWriteExecute = true;
    };
  };

  users.groups.${group} = {};
  users.users.${user} = {
    isSystemUser = true;
    inherit group;
  };

  ##############################################################################
  # Impermanence Integration                                                   #
  ##############################################################################

  environment.persistence = lib.mkIf (persistDir != null) {
    ${persistDir}.directories = [
      {
        directory = baseDir;
        inherit user group;
      }
    ];
  };
}
