{ config, pkgs, ... }:

{
  imports = [ ./hardware-configuration.nix ];

  #
  # Nix
  #

  nix = {
    settings = {
      trusted-users = [ "root" "@wheel" ];
    };

    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };

  nixpkgs = {
    config = {
      allowUnfree = true;
    };
  };

  system = {
    stateVersion = "24.05";
    replaceRuntimeDependencies = [];
  };

  #
  # General Hardware
  #

  hardware = {
    bluetooth = {
      settings = {
        General = {
          Experimental = true;
        };
      };
    };
    keyboard = {
      zsa.enable = true;
    };
    graphics = {
      extraPackages = with pkgs; [ mangohud ];
      extraPackages32 = with pkgs; [ mangohud ];
    };

    pulseaudio.enable = false;
  };

  powerManagement.cpuFreqGovernor = "ondemand";

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

    kernelPackages = pkgs.linuxKernel.packages.linux_6_10;
    kernelParams = [];
    blacklistedKernelModules = [];
    kernel.sysctl."kernel.unprivileged_userns_clone" = true;
  };

  security = {
    allowUserNamespaces = true;
    apparmor.enable = true;
    rtkit.enable = true;
  };

  networking = {
    firewall = {
      allowedTCPPorts = [
        9090 # Calibre
      ];
      allowedTCPPortRanges = [
        { from = 1714; to = 1764; } # GSConnect
      ];
      allowedUDPPorts = [
      ];
      allowedUDPPortRanges = [
        { from = 1714; to = 1764; } # GSConnect
      ];
    };

    networkmanager = {
      plugins = with pkgs; [
        networkmanager-openvpn
      ];
    };
  };

  #
  # Extra
  #

  time.timeZone = "America/Mexico_City";

  programs = {
    fish.enable = true;
    steam.enable = true;
  };

  services = {
    dbus.packages = with pkgs; [ dconf ];

    fstrim = {
      enable = true;
      interval = "daily";
    };

    gnome = {
      gnome-browser-connector.enable = true;
      gnome-keyring.enable = true;
      gnome-online-accounts.enable = true;
    };

    netbird.enable = true;

    pipewire = {
      enable = true;
      alsa.enable = true;
      pulse.enable = true;
    };

    udev = {
      packages = with pkgs; [ libfido2 fuse ];
    };

    xserver = {
      desktopManager.gnome.enable = true;
      displayManager.gdm.enable = true;

      enable = true;
      xkb.layout = "us";
    };

    # EXTRA

    kubo = {
      enable   = true;
      enableGC = true;

      settings = {
        Addresses = {
          API = [
            "/ip4/127.0.0.1/tcp/5001"
          ];
        };
        Swarm = {
          ConnMgr = {
            LowWater = 500;
            HighWater = 1000;
          };
          Transports.Network = {
            TCP = false;
            Websocket = false;
            WebTransport = false;
          };
        };
      };
      localDiscovery  = true;
    };
  };

  virtualisation = {
    podman = {
      enable = true;

      autoPrune = {
        enable = true;
        dates  = "daily";
      };

      dockerCompat = true;
    };
  };

  environment = {
    gnome.excludePackages = with pkgs; [
      orca
      yelp
    ];
  };

  users.users = {
    fabian = {
      isNormalUser = true;
      extraGroups  = [ "audio" "docker" "podman" "wheel" config.services.kubo.group ];
      shell        = pkgs.fish;
    };
  };
}

