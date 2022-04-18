# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
{ config, lib, pkgs, ... }:

{
  imports = [ <nixpkgs/nixos/modules/installer/scan/not-detected.nix> ];

  networking.hostName = "fabian-tower";

  # nixpkgs.localSystem = {
  #   gcc.arch = "znver2";
  #   gcc.tune = "znver2";
  #   system = "x86_64-linux";
  # };

  hardware.nvidia = {
    modesetting.enable = true;
    # nvidiaPersistenced = true;
    # package = config.boot.kernelPackages.nvidiaPackages.beta;
    powerManagement.enable = true;
  };

  services.xserver = {
    videoDrivers = [ "nvidia" ];
    screenSection = ''
      Option "metamodes" "nvidia-auto-select +0+0 {ForceCompositionPipeline=On, ForceFullCompositionPipeline=On, AllowGSYNCCompatible=On}"
    '';
  };

  boot = {
    initrd = {
      availableKernelModules = [ "nvme" "xhci_pci" "ahci" "usbhid" "usb_storage" "sd_mod" ];
      kernelModules = [ "dm_raid" "dm-snapshot" ];
      luks.devices = {
        lvm = {
          device = "/dev/nvme0n1p2";
          preLVM = true;
        };
      };
    };
    kernelModules = [ "kvm-amd" ];
    blacklistedKernelModules = [ "acpi_cpufreq_init" ];
    loader.grub.memtest86.enable = true;
    loader.systemd-boot.memtest86.enable = true;
    extraModulePackages = [ ];
  };

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/41ab814d-ffd3-4ffd-b1a9-e4f7d4c73a91";
    fsType = "ext4";
  };

  fileSystems."/home" = {
    device = "/dev/disk/by-uuid/485efd60-c21d-49fb-b6fc-7cd64fb1cf3e";
    fsType = "ext4";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/5712-1E85";
    fsType = "vfat";
  };

  swapDevices = [
    { device = "/dev/disk/by-uuid/7f4f1bd5-6012-4ac5-8256-a4b0979539c1"; }
  ];

  nix.settings.max-jobs = lib.mkDefault 4;
}
