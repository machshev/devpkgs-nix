{
  lib,
  pkgs,
  ...
}:
with lib; {
  options = {};

  config = {
    programs.direnv.enable = true;

    fonts.fontDir.enable = true;
    fonts.packages = with pkgs; [
      nerdfonts
      font-awesome
      google-fonts
      meslo-lgs-nf
      corefonts
      vistafonts
    ];

    services.devmon.enable = true;
    services.gvfs.enable = true;
    services.udisks2.enable = true;

    virtualisation.docker.enable = true;
    virtualisation.libvirtd.enable = true;

    # touchpad support
    services.libinput.enable = true;

    services.xserver.xkb.layout = "us,gb,il";
    services.xserver.xkb.variant = "";

    # Set your time zone.
    time.timeZone = "Europe/London";

    # Select internationalisation properties.
    i18n.defaultLocale = "en_GB.UTF-8";

    i18n.extraLocaleSettings = {
      LC_ADDRESS = "en_GB.UTF-8";
      LC_IDENTIFICATION = "en_GB.UTF-8";
      LC_MEASUREMENT = "en_GB.UTF-8";
      LC_MONETARY = "en_GB.UTF-8";
      LC_NAME = "en_GB.UTF-8";
      LC_NUMERIC = "en_GB.UTF-8";
      LC_PAPER = "en_GB.UTF-8";
      LC_TELEPHONE = "en_GB.UTF-8";
      LC_TIME = "en_GB.UTF-8";
    };
  };
}