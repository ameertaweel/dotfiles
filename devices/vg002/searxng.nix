{
  domain,
  port,
  version,
  environmentFile,
  ...
}: {config, ...}: {
  assertions = let
    versionExpected = version;
    versionActual = config.services.searx.package.version;
  in [
    {
      assertion = versionActual == versionExpected;
      message = "SearXNG version mismatch. Expected `${versionExpected}`. Found `${versionActual}`.";
    }
  ];

  ##############################################################################
  # Service Configuration                                                      #
  ##############################################################################

  services.searx = {
    enable = true;
    inherit environmentFile;
    settings = {
      use_default_settings = true;

      search = {
        autocomplete = "brave";
        favicon_resolver = "duckduckgo";
        default_lang = "en";
        languages = ["en" "ar"];
      };

      server = {
        base_url = "https://${domain}";
        inherit port;
        bind_address = "127.0.0.1";
        secret_key = "$SEARXNG_SECRET_KEY";
        public_instance = false;
        image_proxy = true;
      };

      ui = {
        center_alignment = true;
        infinite_scroll = true;
        results_on_new_tab = false;
        hotkeys = "vim";
        url_formatting = "pretty";
      };

      plugins = {
        "searx.plugins.calculator.SXNGPlugin" = {active = true;};
        "searx.plugins.hash_plugin.SXNGPlugin" = {active = true;};
        "searx.plugins.self_info.SXNGPlugin" = {active = true;};
        "searx.plugins.tracker_url_remover.SXNGPlugin" = {active = true;};
        "searx.plugins.unit_converter.SXNGPlugin" = {active = true;};
        "searx.plugins.hostnames.SXNGPlugin" = {active = true;};
      };

      hostnames.remove = ["nixos.wiki"];
      hostnames.high_priority = ["wiki.nixos.org"];
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
