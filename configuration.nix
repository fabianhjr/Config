{ config, pkgs, ... }:

{
  imports = [ ./hardware-configuration.nix ./cachix.nix ];

  system.stateVersion = "20.09";

  nix.trustedUsers = [ "root" "@wheel" ];

  nixpkgs.config = {
    allowUnfree = true;
    firefox.enableGnomeExtensions = true;
  };

  # Use the systemd-boot EFI boot loader.
  boot = {
    loader = {
      systemd-boot.enable      = true;
      efi.canTouchEfiVariables = true;
      grub = {
        efiSupport = true;
      };
    };

    kernelPackages = pkgs.linuxPackages_latest_hardened;

    kernel.sysctl."kernel.unprivileged_userns_clone" = 1;

    # Taken from the NixOS Hardened Profile
    blacklistedKernelModules = [
      # Obscure network protocols
      "ax25"
      "netrom"
      "rose"

      # Old or rare or insufficiently audited filesystems
      "adfs"
      "affs"
      "bfs"
      "befs"
      "cramfs"
      "efs"
      "erofs"
      "exofs"
      "freevxfs"
      "f2fs"
      "hfs"
      "hpfs"
      "jfs"
      "minix"
      "nilfs2"
      "omfs"
      "qnx4"
      "qnx6"
      "sysv"
      "ufs"
    ];
  };

  hardware = {
    opengl.driSupport32Bit = true;

    # Enable sound.
    pulseaudio = {
      enable = true;
      package = pkgs.pulseaudioFull;
      support32Bit = true;
    };
  };

  sound.enable = true;

  security = {
    allowUserNamespaces = true;
    apparmor.enable = true;
    chromiumSuidSandbox.enable = true;
  };

  networking = {
    hostName = "fabian-tower"; # Define your hostname.
    firewall = {
      allowedTCPPorts = [      4001 8008 8010 8989 ];
      allowedUDPPorts = [ 1900 4001 8008 8010 8989 ];
    };
  };

  time.timeZone = "America/Mexico_City";

  # Cannot put in home.nix as it causes some config issues
  programs.fish.enable = true;

  services = {
    # Basic Services
    dbus.packages = with pkgs; [ gnome3.dconf ];

    gnome3 = {
      chrome-gnome-shell.enable = true;
      gnome-keyring.enable = true;
      gnome-online-accounts.enable = true;
    };

    udev.packages = [ pkgs.libu2f-host pkgs.fuse ];

    xserver = {
      desktopManager.gnome3.enable = true;
      displayManager.gdm.enable = true;
      enable       = true;
      videoDrivers = [ "nvidia" ];
      layout = "us";
      xkbVariant = "dvorak-intl";
    };

    ipfs = {
      enable   = true;
      # package  = pkgs.ipfs_latest;
      enableGC = true;
      localDiscovery  = true;
      startWhenNeeded = true;
    };

    keybase.enable = true;
    kbfs.enable    = true;

    postgresql = {
      enable = true;
      authentication =
        "
         local all all              trust
         host  all all 127.0.0.1/32 trust
         host  all all      ::1/128 trust
         host  all all    localhost trust
        ";
    };
  };

  virtualisation = {
    docker.enable = true;
  };

  environment = {
    gnome3.excludePackages = [ ]; 
    systemPackages = with pkgs; [
      gnome3.libgnome-keyring
      # To keey in sync with the daemon version
      keybase
      keybase-gui
    ];
  };

  users.users = {
    fabian = {
      isNormalUser = true;
      extraGroups  = [ "wheel" "audio" "docker" ];
      shell        = pkgs.fish;
    };
  };
}

