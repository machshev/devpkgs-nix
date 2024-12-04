{
  config,
  lib,
  inputs,
  ...
}:
with lib; {
  options = {
    machshev.autoupdate.enable = mkOption {
      type = types.bool;
      default = false;
      description = "Automatically update NixOS";
    };
  };

  config = mkIf config.machshev.autoupdate.enable {
    system.autoUpgrade = {
      enable = true;
      flake = inputs.self.outPath;
      flags = [
        "--update-input"
        "nixpkgs"
        "--no-write-lock-file"
        "-L" # print build logs
      ];
      dates = "02:00";
      randomizedDelaySec = "45min";
    };
  };
}
