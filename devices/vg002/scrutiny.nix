{
  domain,
  port,
  influxDB2Port,
  version,
  environmentFile,
  persistDir ? null,
  ...
}: {
  config,
  lib,
  outputs,
  ...
}: let
  baseDir = "/var/lib/private/scrutiny";
  influxDB2BaseDir = "/var/lib/influxdb2";
in {
  assertions = [
    (outputs.lib.assertPkgVersion {
      displayName = "Scrutiny";
      versionExpected = version;
      versionActual = config.services.scrutiny.package.version;
    })
  ];

  ##############################################################################
  # Service Configuration                                                      #
  ##############################################################################

  services.scrutiny = {
    enable = true;
    collector.enable = false;
    influxdb.enable = true;
    settings.web = {
      influxdb = {
        host = "localhost";
        org = "scrutiny";
        port = influxDB2Port;
      };
      database.location = "${baseDir}/scrutiny.db";
      listen = {
        host = "localhost";
        inherit port;
      };
    };
  };

  systemd.services.scrutiny.serviceConfig.EnvironmentFile = environmentFile;

  services.influxdb2.settings = {
    http-bind-address = "localhost:${builtins.toString influxDB2Port}";
  };

  ##############################################################################
  # Reverse Proxy Configuration                                                #
  ##############################################################################

  services.caddy.virtualHosts.${domain}.extraConfig = ''
    import acme_dns_01_porkbun
    reverse_proxy http://localhost:${builtins.toString port}
  '';

  ##############################################################################
  # Impermanence Integration                                                   #
  ##############################################################################

  environment.persistence = lib.mkIf (persistDir != null) {
    ${persistDir}.directories = [baseDir influxDB2BaseDir];
  };
}
