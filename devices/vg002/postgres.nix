{persistDir ? null, ...}: {
  config,
  lib,
  ...
}: {
  ##############################################################################
  # Service Configuration                                                      #
  ##############################################################################

  services.postgresql = {
    enable = true;
  };

  ##############################################################################
  # Impermanence Integration                                                   #
  ##############################################################################

  environment.persistence = lib.mkIf (persistDir != null) {
    ${persistDir}.directories = [config.services.postgresql.dataDir];
  };
}
