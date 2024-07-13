{
  inputs,
  self,
}: {lib, ...}:
{
  imports = [
    ./dev-udev-rules.nix
  ];
  config = {
    nixpkgs.overlays = [
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
