{
  persistDirLogs ? null,
  persistDirData ? null,
  environmentFile,
  ...
}: {
  config,
  lib,
  pkgs,
  ...
}: {
  ##############################################################################
  # Service Configuration                                                      #
  ##############################################################################

  services.caddy = {
    enable = true;

    package = pkgs.caddy.withPlugins {
      plugins = ["github.com/caddy-dns/porkbun@v0.3.1"];
      hash = "sha256-1UyHT1Nhe1FliL2udRjWC1OGUpOewcKRVT89Q5trVdA=";
    };

    inherit environmentFile;

    extraConfig = ''
      (acme_dns_01_porkbun) {
        tls {
          dns porkbun {
            api_key {$PORKBUN_API_KEY}
            api_secret_key {$PORKBUN_API_SECRET_KEY}
          }
          resolvers 1.1.1.1
        }
      }
    '';
  };

  ##############################################################################
  # Impermanence Integration                                                   #
  ##############################################################################

  # The check for `persistDirLogs != persistDirData` is to prevent an error due
  # to duplicate attribute in attrset.
  environment.persistence =
    if (persistDirLogs != persistDirData)
    then {
      ${persistDirLogs}.directories = lib.mkIf (persistDirLogs != null) [config.services.caddy.logDir];
      ${persistDirData}.directories = lib.mkIf (persistDirData != null) [config.services.caddy.dataDir];
    }
    else {
      ${persistDirLogs}.directories = lib.mkIf (persistDirLogs != null) [
        config.services.caddy.logDir
        config.services.caddy.dataDir
      ];
    };
}
