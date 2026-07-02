{pkgs, ...}: {
  # Enable the GNOME Desktop Environment
  services.displayManager.gdm.enable = true;
  services.desktopManager.gnome.enable = true;

  # Exclude default GNOME packages
  environment.gnome.excludePackages = with pkgs; [
    epiphany # web browser
    evince # document viewer
    geary # email reader
    gedit # text editor
    gnome-calendar
    gnome-console
    gnome-photos
    gnome-terminal
    gnome-tour
    totem # video player
    yelp # help viewer
    gnome-characters
    gnome-contacts
    gnome-maps
    gnome-music
    gnome-weather
  ];

  # Install GNOME extensions
  environment.systemPackages =
    [pkgs.gnome-tweaks]
    ++ (with pkgs.gnomeExtensions; [
      hibernate-status-button # Hibernate in Power Options
      appindicator # System Tray
      clipboard-history # Clipboard Manager
      just-perfection
    ]);

  # Ensure gnome-settings-daemon udev rules are enabled
  services.udev.packages = [pkgs.gnome-settings-daemon];
}
