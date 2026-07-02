{
  domain,
  port,
  version,
  ...
}: {
  config,
  outputs,
  ...
}: {
  assertions = [
    (outputs.lib.assertPkgVersion {
      displayName = "qBittorrent";
      versionExpected = version;
      versionActual = config.services.qbittorrent.package.version;
    })
  ];

  ##############################################################################
  # Service Configuration                                                      #
  ##############################################################################

  services.qbittorrent = {
    enable = true;
    extraArgs = ["--confirm-legal-notice"];
    webuiPort = port;
    # Generate Password Hash:
    # https://gist.github.com/hastinbe/8b8d247f17481cfc262a98d661bc0fd5
    # serverConfig = {
    # };
  };

  ##############################################################################
  # Reverse Proxy Configuration                                                #
  ##############################################################################

  services.caddy.virtualHosts.${domain}.extraConfig = ''
    import acme_dns_01_porkbun
    reverse_proxy http://localhost:${builtins.toString port}
  '';
}
