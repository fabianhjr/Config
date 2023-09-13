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
    stateVersion = "23.05";
    replaceRuntimeDependencies = [];
  };

  #
  # General Hardware
  #

  hardware = {
    keyboard = {
      zsa.enable = true;
    };
    opengl = {
      driSupport32Bit = true;
      setLdLibraryPath = true;
    };

    pulseaudio.enable = false;
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

    kernelPackages = pkgs.linuxKernel.packages.linux_6_5; # _hardened;
    kernelParams = [
      "amd_pstate.enable=1"
      "amd_pstate.shared_mem=1"
    ];
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
        # 4444
      ];
      allowedTCPPortRanges = [
        { from = 1714; to = 1764; } # GSConnect
      ];
      allowedUDPPorts = [
      # 4444
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
    # Basic Services

    dbus.packages = with pkgs; [ dconf ];

    gnome = {
      gnome-browser-connector.enable = true;
      gnome-keyring.enable = true;
      gnome-online-accounts.enable = true;
    };

    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };

    udev = {
      packages = with pkgs; [ libu2f-host fuse ];
    };

    xserver = {
      desktopManager.gnome.enable = true;
      displayManager.gdm.enable = true;

      enable = true;
      layout = "us";
      # xkbVariant = "dvorak-intl";
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
          Gateway = [
            "/ip4/127.0.0.1/tcp/9000"
          ];
          Swarm = [
            "/ip6/::/udp/4001/quic-v1"
            "/ip6/::/udp/4001/quic-v1/webtransport"
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

    # Lightweight k8s
    k3s = {
      enable = true;
      role = "server";
    };

    keybase.enable = true;
    kbfs.enable    = true;

    postgresql = let
      postgres = pkgs.postgresql_15;
    in {
      enable = true;
      package = postgres;
      extraPlugins = with postgres.pkgs; [ ]; # postgis ];

      authentication =
        "
         local all all              trust
         host  all all 127.0.0.1/32 trust
         host  all all      ::1/128 trust
        ";
    };

    tiddlywiki.enable = false;
  };

  virtualisation = {
    podman = {
      enable = false;

      autoPrune = {
        enable = true;
        dates  = "daily";
      };

      dockerCompat = true;
    };
  };

  environment = {
    gnome.excludePackages = with pkgs; with gnome; [
      orca
      yelp
    ];
    systemPackages = with pkgs; with gnome; [
      keybase-gui
    ];
  };

  users.users = {
    fabian = {
      isNormalUser = true;
      extraGroups  = [ "wheel" "audio" "docker" config.services.kubo.group ];
      shell        = pkgs.fish;
    };
  };
}

