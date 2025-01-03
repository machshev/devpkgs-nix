{...}: {
  imports = [
    ./fs.nix
  ];

  machshev = {
    hostName = "machshev";
    machineID = "127faeee905223190bb95dba67694307";
    user = {
      enable = true;
    };
    applyUdevRules = true;
    autoupdate.enable = true;
    closedFirmwareUpdates = true;
  };

  system.stateVersion = "24.11";
}
