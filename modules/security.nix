{
  lib,
  pkgs,
  ...
}:
with lib; {
  options = {};

  config = {
    services.gnome.gnome-keyring.enable = true;
    security.pam.services.gdm.enableGnomeKeyring = true;
    security.pam.services.gdm-password.enableGnomeKeyring = true;
    programs.seahorse.enable = true;

    security.polkit.enable = true;

    services.fprintd.enable = true;

    security.pam.services.swaylock = {
      text = ''
        auth include login
      '';
      fprintAuth = true;
    };

    environment.systemPackages = with pkgs; [
      polkit
      polkit_gnome
    ];

    environment.pathsToLink = [
      "/libexec"
    ];

    programs.wireshark.enable = true;
    programs.gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };
  };
}
