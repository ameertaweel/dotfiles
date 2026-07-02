{persistDir ? null, ...}: {lib, ...}: {
  ##############################################################################
  # Service Configuration                                                      #
  ##############################################################################

  services.tailscale.enable = true;

  ##############################################################################
  # Impermanence Integration                                                   #
  ##############################################################################

  environment.persistence = lib.mkIf (persistDir != null) {
    ${persistDir}.directories = ["/var/lib/tailscale"];
  };
}
