{
  config,
  lib,
  pkgs,
  ...
}:
with lib; {
  options = {
    machshev.graphics.intel = mkOption {
      type = types.bool;
      default = false;
      description = "Enable intel graphics.";
    };

    machshev.graphics.nvidia = mkOption {
      type = types.bool;
      default = false;
      description = "Enable nvidia graphics.";
    };
  };

  config = lib.mkMerge [
    (mkIf config.machshev.graphics.intel {
      # Required because the intel GPU isn't supported well, does it work with the
      # latest?
      boot.kernelPackages = lib.mkForce pkgs.linuxPackages_latest;

      boot.kernelParams = [
        "i915.enable_psr=0"
      ];

      hardware.graphics = {
        enable = true;
        enable32Bit = true;
      };
    })

    (mkIf config.machshev.graphics.nvidia {
      # nvidia legacy drivers don't build on 6.10
      boot.kernelPackages = lib.mkForce pkgs.linuxPackages_6_9;

      # environment.systemPackages = [ nvidia-offload ];
      services.xserver.videoDrivers = lib.mkDefault ["intel" "nvidia"];
      hardware.opengl = {
        enable = true;
        driSupport32Bit = true;
        extraPackages = with pkgs; [vaapiVdpau];
      };

      nixpkgs.config.nvidia.acceptLicense = true;
      programs.sway.extraOptions = ["--unsupported-gpu"];

      hardware.nvidia = {
        modesetting.enable = true;

        powerManagement.enable = false;
        powerManagement.finegrained = false;
        forceFullCompositionPipeline = true;

        open = false; # not supported for legacy drivers
        nvidiaSettings = true;

        package = config.boot.kernelPackages.nvidiaPackages.legacy_470;
      };
    })
  ];
}
