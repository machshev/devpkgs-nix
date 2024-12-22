{...}: {
  imports = [
    ./fs.nix
    ../../config/wol.nix
  ];

  networking.hostName = "machshev";
  networking.hostId = "3eee9f68";

  machshev = {
    user = {
      enable = true;
    };
    applyUdevRules = true;
    autoupdate.enable = true;
    closedFirmwareUpdates = true;
  };

  system.stateVersion = "24.11";
}
