{...}: {
  imports = [
    ./fs.nix
  ];

  machshev = {
    hostName = "qatan";
    machineID = "92fe87dfa38d10d30eda16a267693da2";
    user = {
      enable = true;
    };
    applyUdevRules = true;
    autoupdate.enable = true;
    closedFirmwareUpdates = true;
  };

  system.stateVersion = "24.11";
}
