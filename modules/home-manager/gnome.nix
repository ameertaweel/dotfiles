# Convert dconf files (e.g. GNOME Shell) to Nix, as expected by Home Manager
# https://github.com/nix-community/dconf2nix
{
  lib,
  params,
  ...
}: let
  uint32 = lib.hm.gvariant.mkUint32;
  tuple = lib.hm.gvariant.mkTuple;
in {
  # Set GNOME GSettings
  dconf.settings = {
    "org/gnome/desktop/interface" = {
      # Use dark theme
      color-scheme = "prefer-dark";
      # Disable hot corner
      # Touch the top-left corner to open the Activities Overview
      enable-hot-corners = false;
      # Top Bar
      clock-show-weekday = true;
      show-battery-percentage = false;
    };

    "org/gnome/mutter" = {
      # Active Screen Edges
      # Drag windows against screen edges to resize them
      edge-tiling = true;
      dynamic-workspaces = true;
      center-new-windows = true;
    };

    "org/gnome/desktop/input-sources" = {
      sources = map (lang: (tuple ["xkb" lang])) params.langs;
    };

    # Keybindings
    "org/gnome/desktop/wm/keybindings" = {
      # Don't group windows of the same application type
      switch-applications = [];
      switch-applications-backward = [];
      switch-windows = ["<Super>Tab"];
      switch-windows-backward = ["<Shift><Super>Tab"];
    };

    "org/gnome/desktop/notifications" = {
      # Disable lock screen notifications
      show-in-lock-screen = false;
    };

    "org/gnome/desktop/input-sources" = {
      # Use capslock as ctrl
      xkb-options = ["ctrl:nocaps"];
    };

    "org/gnome/desktop/peripherals/keyboard" = {
      # Enable numlock by default
      numlock-state = true;
    };

    "org/gnome/desktop/peripherals/touchpad" = {
      click-method = "areas";
      natural-scroll = false;
      tap-to-click = true;
      two-finger-scrolling-enabled = true;
    };

    "org/gnome/desktop/privacy" = {
      remember-recent-files = true;
      # Remember file history for the last 30 days
      recent-files-max-age = 30;

      remove-old-temp-files = true;
      remove-old-trash-files = true;
      # Auto delete after 30 days
      old-files-age = uint32 30;
    };

    "org/gnome/desktop/screensaver" = {
      # Auto lock immediately
      lock-delay = uint32 0;
      # Auto screen lock
      lock-enabled = true;
    };

    "org/gnome/desktop/session" = {
      # Disable blank screen on inactivity
      idle-delay = uint32 0;
    };

    "org/gnome/desktop/sound" = {
      allow-volume-above-100-percent = true;
    };

    "org/gnome/settings-daemon/plugins/power" = {
      # Dim screen on inactivity
      idle-dim = false;

      # Disable auto suspend when charging
      sleep-inactive-ac-type = "nothing";

      # Auto suspend after 30 minutes of inactivity if on battery power
      sleep-inactive-battery-type = "suspend";
      sleep-inactive-battery-timeout = 1800;

      # Auto power saver on low battery
      power-saver-profile-on-low-battery = true;
    };

    "org/gnome/shell" = {
      disable-user-extensions = false;
      enabled-extensions = [
        "appindicatorsupport@rgcjonas.gmail.com"
        "drive-menu@gnome-shell-extensions.gcampax.github.com"
        "clipboard-history@alexsaveau.dev"
        "hibernate-status@dromi"
        "just-perfection-desktop@just-perfection"
      ];
      disabled-extensions = [
        "places-menu@gnome-shell-extensions.gcampax.github.com"
        "window-list@gnome-shell-extensions.gcampax.github.com"
        "windowsNavigator@gnome-shell-extensions.gcampax.github.com"
        "workspace-indicator@gnome-shell-extensions.gcampax.github.com"
        "apps-menu@gnome-shell-extensions.gcampax.github.com"
        "native-window-placement@gnome-shell-extensions.gcampax.github.com"
      ];
    };

    "org/gnome/shell/app-switcher" = {
      # Include apps from current workspace when switching apps
      current-workspace-only = true;
    };

    "org/gnome/shell/extensions/just-perfection" = {
      activities-button = false;
      events-button = false;
      world-clock = false;
      support-notifier-type = 0;
    };

    # Clipboard Manager
    "org/gnome/shell/extensions/clipboard-history" = {
      clear-history = [];
      ignore-password-mimes = false;
      next-entry = [];
      paste-on-selection = false;
      prev-entry = [];
      private-mode = false;
    };
  };
}
