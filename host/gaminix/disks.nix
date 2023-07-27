{disks ? ["/dev/nvme0n1"], ...}: let
  cryptroot = "cryptroot";
  defaultBtrfsOpts = ["defaults" "compress=zstd:1" "ssd" "noatime" "nodiratime"];
in {
  boot.initrd.luks.devices.${cryptroot} = {
    allowDiscards = true;
    preLVM = true;
  };

  disko.devices = {
    disk = {
      # 1TB root/boot drive. Configured with:
      # - A FAT32 ESP partition for systemd-boot
      # - A LUKS container which containers multiple btrfs subvolumes for nixos install
      nvme0 = {
        device = builtins.elemAt disks 0;
        type = "disk";
        content = {
          type = "table";
          format = "gpt";
          partitions = [
            {
              name = "boot";
              start = "0%";
              end = "1024MiB";
              bootable = true;
              fs-type = "fat32";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
              };
            }
            {
              name = "luks";
              start = "1024MiB";
              end = "100%";
              content = {
                type = "luks";
                name = "${cryptroot}";
                extraOpenArgs = ["--allow-discards"];

                content = {
                  type = "btrfs";
                  # Override existing partition
                  extraArgs = ["-f"];
                  subvolumes = {
                    "@" = {
                      mountpoint = "/";
                      mountOptions = defaultBtrfsOpts;
                    };
                    "@nix" = {
                      mountpoint = "/nix";
                      mountOptions = defaultBtrfsOpts;
                    };
                    "@home" = {
                      mountpoint = "/home";
                      mountOptions = defaultBtrfsOpts;
                    };
                    "@var" = {
                      mountpoint = "/var";
                      mountOptions = defaultBtrfsOpts;
                    };
                    "@snapshots" = {
                      mountpoint = "/.snapshots";
                      mountOptions = defaultBtrfsOpts;
                    };
                    "@swap" = {
                      mountpoint = "/.swap";
                      mountOptions = ["defaults" "x-mount.mkdir" "ssd" "noatime" "nodiratime"];
                    };
                  };
                };
              };
            }
          ];
        };
      };
    };
  };
}
