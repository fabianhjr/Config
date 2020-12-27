{ config, pkgs, ... }:

{
  imports = [ ./hardware-configuration.nix ];

  #
  # Nix
  #

  nix.trustedUsers = [ "root" "@wheel" ];

  nixpkgs = {
    config = {
      allowUnfree = true;
    };

    overlays = [(self: super: {
      # too expensive
      # stdenv = super.impureUseNativeOptimizations super.stdenv;
    })];
  };

  system.stateVersion = "20.09";

  #
  # General Hardware
  #

  hardware = {
    opengl.driSupport32Bit = true;

    pulseaudio = {
      enable = true;
      package = pkgs.pulseaudioFull;
      support32Bit = true;
    };
  };

  powerManagement.cpuFreqGovernor = "ondemand";

  sound.enable = true;

  #
  # Boot/Kernel
  #

  boot = {
    loader = {
      efi.canTouchEfiVariables = true;
      grub.efiSupport = true;
      systemd-boot.enable = true;
      timeout = 3;
    };

    kernelPackages = pkgs.linuxPackages_latest;
  };

  security = {
    allowUserNamespaces = true;
    apparmor.enable = true;
  };

  networking = {
    firewall = {
      allowedTCPPorts = [      4001 8008 8010 8989 ];
      allowedTCPPortRanges = [
        { from = 1714; to = 1764; } # GSConnect
      ];
      allowedUDPPorts = [ 1900 4001 8008 8010 8989 ];
      allowedUDPPortRanges = [
        { from = 1714; to = 1764; } # GSConnect
      ];
    };
  };

  #
  # Extra
  #

  time.timeZone = "America/Mexico_City";

  # Cannot put in home.nix as it causes some config issues
  programs.fish.enable = true;

  services = {
    # Basic Services
    dbus.packages = with pkgs; [ gnome3.dconf ];

    flatpak.enable = true;

    gnome3 = {
      gnome-keyring.enable = true;
      gnome-online-accounts.enable = true;
    };

    udev.packages = [ pkgs.libu2f-host pkgs.fuse ];

    xserver = {
      desktopManager.gnome3.enable = true;

      displayManager.gdm = {
        enable = true;
        nvidiaWayland = true;
      };

      enable = true;
      layout = "us";
      xkbVariant = "dvorak-intl";
    };

    ipfs = {
      enable   = true;
      enableGC = true;
      extraConfig = {
        Swarm = {
          ConnMgr = {
            LowWater = 1000;
            HighWater = 2000;
          };
          Transports.Network = {
            TCP = false;
            Websocket = false;
          };
        };
      };
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

