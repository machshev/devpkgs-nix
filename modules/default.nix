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
      # Use an overlay to expose packages from lowrisc-nix and lowrisc-it
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
