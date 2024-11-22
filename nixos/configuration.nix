{ config, pkgs, ... }:

{
  imports = [
    ./nix-configuration.nix
    ./hardware-configuration.nix
  ];

  system = {
    stateVersion = "24.05";

    replaceDependencies.replacements = [];
    systemBuilderArgs.disallowedRequisites = with pkgs; [
      cdrtools # License issues
    ];
  };

  #
  # General Hardware
  #

  hardware = {
    amdgpu.opencl.enable = true;
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
      extraPackages   = with pkgs; [ mangohud ];
      extraPackages32 = with pkgs.pkgsi686Linux; [ mangohud ];
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

    kernelPackages = pkgs.linuxKernel.packages.linux_6_11_hardened;
    kernel.sysctl = {
      "kernel.unprivileged_userns_clone" = true;
    };
  };

  security = {
    apparmor.enable = true;
    rtkit.enable = true;
  };

  networking = {
    hostName = "fabian-desktop";

    firewall = {
      allowedTCPPorts = [
        9090 # Calibre
        11434 # Ollama
      ];
      allowedTCPPortRanges = [
        { from = 1714; to = 1764; } # GSConnect
      ];
      allowedUDPPorts = [];
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
    ollama = {
      enable = true;

      acceleration = "rocm";
      environmentVariables = {
        HSA_OVERRIDE_GFX_VERSION = "11.0.0";
      };
    };

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
      extraPackages = with pkgs; [ podman-compose ];
    };
  };

  environment = {
    gnome.excludePackages = with pkgs; [
      orca
      yelp
    ];

    systemPackages = with pkgs.rocmPackages; [
      clr
      rocminfo
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
