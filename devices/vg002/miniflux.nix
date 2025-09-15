{
  baseURL,
  port,
  version,
  environmentFile,
  ...
}: {config, ...}: {
  ##################
  # Service Config #
  ##################

  services.miniflux = {
    enable = assert config.services.miniflux.package.version == version; true;
    config = {
      BASE_URL = baseURL;
      LISTEN_ADDR = "localhost:${builtins.toString port}";

      # Do not automatically create an admin account
      CREATE_ADMIN = 0;

      # Do not mark read entries as removed
      CLEANUP_ARCHIVE_READ_DAYS = -1;
      # Do not mark unread entries as removed
      CLEANUP_ARCHIVE_UNREAD_DAYS = -1;
      # Use video duration as reading time
      FETCH_YOUTUBE_WATCH_TIME = 1;
      # Display the date and time in log messages
      LOG_DATE_TIME = 1;
    };
    adminCredentialsFile = environmentFile;
  };

  ########################
  # Reverse Proxy Config #
  ########################

  services.caddy.virtualHosts."miniflux.ts.taweel.me".extraConfig = ''
    import acme_dns_01_porkbun
    reverse_proxy http://localhost:${builtins.toString port}
  '';

  ###################
  # Periodic Backup #
  ###################

  services.postgresqlBackup.databases = ["miniflux"];
}
