{
  port,
  version,
  domain,
  ...
}: {config, ...}: {
  assertions = let
    versionExpected = version;
    versionActual = config.services.stirling-pdf.package.version;
  in [
    {
      assertion = versionActual == versionExpected;
      message = "Miniflux version mismatch. Expected `${versionExpected}`. Found `${versionActual}`.";
    }
  ];

  ##############################################################################
  # Service Configuration                                                      #
  ##############################################################################

  services.stirling-pdf = {
    enable = true;
    environment = {
      SERVER_PORT = port;
      SYSTEM_ENABLEANALYTICS = "false";
      SYSTEM_SHOWUPDATE = "false";
      SYSTEM_FILEUPLOADLIMIT = "100MB";
      METRICS_ENABLED = "false";
    };
  };

  ##############################################################################
  # Reverse Proxy Configuration                                                #
  ##############################################################################

  services.caddy.virtualHosts.${domain}.extraConfig = ''
    import acme_dns_01_porkbun
    reverse_proxy http://localhost:${builtins.toString port}
  '';
}
