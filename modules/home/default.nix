{
  config,
  inputs,
  lib,
  pkgs,
  ...
}:
with lib; {
  options = {
    machshev.user.enable = mkOption {
      type = types.bool;
      default = false;
      description = "Create user with home manager config";
    };
    machshev.user.username = mkOption {
      type = types.str;
      default = "david";
      description = "Username";
    };
    machshev.user.fullName = mkOption {
      type = types.str;
      default = "David James McCorrie";
      description = "Full name";
    };
    machshev.user.email = mkOption {
      type = types.str;
      default = "djmccorrie@gmail.com";
      description = "User email";
    };
  };

  config = let
      cfg = config.machshev.user;
    in mkIf cfg.enable {
    # Define a user account. Don't forget to set a password with ‘passwd’.
    users.users.${cfg.username} = {
      isNormalUser = true;
      description = "${cfg.fullName}";
      extraGroups = [
        "networkmanager"
        "wheel"
        "dialout"
        "plugdev"
        "wireshark"
        "tty"
        "audio"
        "video"
        "kvm"
        "docker"
        "libvirtd"
      ];
      shell = pkgs.fish;
    };

    programs.fish.enable = true;

    home-manager = {
      extraSpecialArgs = {inherit inputs;};
      useUserPackages = true;
      useGlobalPkgs = true;
      users = {
        "${cfg.username}" = import ./home.nix;
      };
    };
  };
}