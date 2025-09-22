{
  domain,
  port,
  version,
  environmentFile,
  persistDir ? null,
  ...
}: let
  baseDir = "/var/lib/ntfy-sh";
in
  {
    config,
    lib,
    outputs,
    ...
  }: {
    assertions = [
      (outputs.lib.assertPkgVersion {
        displayName = "Ntfy";
        versionExpected = version;
        versionActual = config.services.ntfy-sh.package.version;
      })
    ];

    ##############################################################################
    # Service Configuration                                                      #
    ##############################################################################

    services.ntfy-sh = {
      enable = true;
      inherit environmentFile;
      settings = {
        base-url = "https://${domain}";
        listen-http = "localhost:${builtins.toString port}";
        behind-proxy = true;
        cache-file = "${baseDir}/cache.db";
        cache-duration = "24h";
        attachment-cache-dir = "${baseDir}/attachments";
        attachment-total-size-limit = "5G";
        attachment-file-size-limit = "15M";
        attachment-expiry-duration = "24h";
        auth-file = "${baseDir}/user.db";
        auth-default-access = "deny-all";
        enable-login = true;
      };
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
      ${persistDir}.directories = [baseDir];
    };
  }
