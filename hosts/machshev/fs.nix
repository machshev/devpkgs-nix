{
  config,
  inputs,
  lib,
  ...
}: {
  imports = [
    inputs.disko.nixosModules.disko
  ];

  disko.devices = {
    disk = {
      disk1 = {
        device = "/dev/sda";
        type = "disk";
        content = {
          type = "gpt";
          partitions = {
            EFI = {
              size = "1G";
              type = "EF00";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
              };
            };
            zfs = {
              end = "-8G";
              content = {
                type = "zfs";
                pool = "pool";
              };
            };
            swap = {
              size = "100%";
              content = {
                type = "swap";
                randomEncryption = true;
              };
            };
          };
        };
      };
    };
    zpool = {
      zpool = {
        type = "zpool";
        options = {
          ashift = "12";
          autotrim = "on";
        };
        mountpoint = null;
        rootFsOptions = {
          acltype = "posixacl";
          xattr = "sa";
          dnodesize = "auto";
          compression = "lz4";
          normalization = "formD";
          canmount = "off";
          mountpoint = "none";
          "com.sun:auto-snapshot" = "false";

          encryption = "aes-256-gcm";
          keyformat = "passphrase";
          # Used at installation-time, passed to nixos-anywhere
          keylocation = "file:///tmp/disk.key";
        };

        postCreateHook = ''
          zfs set keylocation="prompt" pool
        '';

        datasets = {
          root = {
            type = "zfs_fs";
            mountpoint = "/";
          };

          nix = {
            type = "zfs_fs";
            mountpoint = "/nix";
            options.mountpoint = "/nix";
          };

          var = {
            type = "zfs_fs";
            mountpoint = "/var";
            options.mountpoint = "/var";
          };

          home = {
            type = "zfs_fs";
            mountpoint = "/home";
            options = {
              mountpoint = "/home";
              "com.sun:auto-snapshot" = "true";
            };
          };

          DISK = {
            type = "zfs_fs";
            options.mountpoint = "none";
          };
        };
      };
    };
  };

  services.zfs = {
    autoScrub.enable = true;
    trim.enable = true;
    autoSnapshot = {
      enable = true;
      daily = 31;
      weekly = 8;
    };
  };
}