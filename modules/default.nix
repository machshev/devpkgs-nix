{
  inputs,
  self,
}: {lib, ...}: {
  imports = [
    ./nix.nix
    ./common.nix
    ./boot.nix
    ./graphics.nix
    ./net.nix
    ./dev-udev-rules.nix
    ./printing.nix
    ./sound.nix
    ./auto-update.nix
    ./jlink.nix
    ./display.nix
    ./security.nix
    ./btrfs.nix
    ./sdr.nix
    ./home
  ];
  config = {
    nixpkgs.overlays = [
      # repositories so they can be used in modules.
      (final: prev: {
        machshev = self.packages.${prev.system};
      })
    ];
  };
  options = {
    machshev = {
    };
  };
}
