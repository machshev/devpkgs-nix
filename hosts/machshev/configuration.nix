{...}: {
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ../../config/zfs.nix
    ../../config/wol.nix
  ];

  networking.hostName = "machshev";
  networking.hostId = "3eee9f68";

  machshev = {
    user = {
      enable = true;
      username = "jamesm";
      fullName = "David James McCorrie";
    };
    graphics.intel = true;
    graphics.nvidia = true;
    applyUdevRules = true;
    autoupdate.enable = true;
    closedFirmwareUpdates = true;
  };


  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.11"; # Did you read the comment?
}
