{
  domain,
  port,
  version,
  adminPasswordFile,
  appSecretFile,
  persistDir ? null,
  ...
}: {
  config,
  lib,
  outputs,
  ...
}: {
  assertions = [
    (outputs.lib.assertPkgVersion {
      displayName = "Davis";
      versionExpected = version;
      versionActual = config.services.davis.package.version;
    })
  ];

  ##############################################################################
  # Service Configuration                                                      #
  ##############################################################################

  services.davis = {
    enable = true;
    config = {
      CALDAV_ENABLED = lib.mkForce false;
      CARDDAV_ENABLED = true;
      WEBDAV_ENABLED = false;
    };
    hostname = domain;
    adminLogin = "admin";
    inherit adminPasswordFile appSecretFile;
    nginx = {
      listen = [
        {
          addr = "localhost";
          inherit port;
        }
      ];
    };
  };

  ##############################################################################
  # Impermanence Integration                                                   #
  ##############################################################################

  environment.persistence = lib.mkIf (persistDir != null) {
    ${persistDir}.directories = [
      {
        directory = config.services.davis.dataDir;
        user = config.services.davis.user;
        group = config.services.davis.group;
      }
    ];
  };

  ##############################################################################
  # Reverse Proxy Configuration                                                #
  ##############################################################################

  services.caddy.virtualHosts.${domain}.extraConfig = ''
    import acme_dns_01_porkbun
    reverse_proxy http://localhost:${builtins.toString port}
  '';
}
