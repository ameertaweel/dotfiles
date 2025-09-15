{persistDir ? null, ...}: {
  config,
  lib,
  ...
}: {
  ##############################################################################
  # Service Configuration                                                      #
  ##############################################################################

  services.postgresqlBackup = {
    enable = true;
    compression = "zstd";
    compressionLevel = 19;
    startAt = "*-*-* 03:00:00";
  };

  ##############################################################################
  # Impermanence Integration                                                   #
  ##############################################################################

  environment.persistence = lib.mkIf (persistDir != null) {
    ${persistDir}.directories = [config.services.postgresqlBackup.location];
  };
}
