{persistDir ? null, ...}: let
  hostKeysDir = "/etc/ssh/host_keys";

  hostKeyRSA = "${hostKeysDir}/ssh_host_rsa_key";
  hostKeyED25519 = "${hostKeysDir}/ssh_host_ed25519_key";
in
  {lib, ...}: {
    # Setup Host Keys
    services.openssh.hostKeys = [
      {
        bits = 4096;
        path = hostKeyRSA;
        type = "rsa";
      }
      {
        path = hostKeyED25519;
        type = "ed25519";
      }
    ];

    services.openssh = {
      enable = true;
      allowSFTP = false; # Don't set this if you need sftp
      settings = {
        PasswordAuthentication = false;
        KbdInteractiveAuthentication = false;
        AllowTcpForwarding = false;
        X11Forwarding = false;
        AllowAgentForwarding = false;
        AllowStreamLocalForwarding = false;
        AuthenticationMethods = "publickey";
      };
    };

    # Impermanence Integration
    environment.persistence = lib.mkIf (persistDir != null) {
      ${persistDir}.directories = [hostKeysDir];
    };
  }
