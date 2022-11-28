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
      keep-outputs = true
      keep-derivations = true
    '';
  };

  nixpkgs = {
    config = {
      allowUnfree = true;
    };

    overlays = [(self: super: {
      # too expensive
      # stdenv = super.impureUseNativeOptimizations super.stdenv;
    })];
  };

  system = {
    stateVersion = "22.05";
    replaceRuntimeDependencies = [];
  };

  #
  # General Hardware
  #

  hardware = {
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

    kernelPackages = pkgs.linuxKernel.packages.linux_6_0_hardened;
    kernelParams = [ "amd_pstate.enable=1" "amd_pstate.shared_mem=1" ];
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
  };

  #
  # Extra
  #

  time.timeZone = "America/Mexico_City";

  # Cannot put in home.nix as it causes some config issues
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

    udev.packages = with pkgs; [ libu2f-host fuse ];

    xserver = {
      desktopManager.gnome.enable = true;

      displayManager.gdm = {
        enable = true;
      };

      enable = true;
      layout = "us";
      xkbVariant = "dvorak-intl";
    };

    # EXTRA

    kubo = {
      enable   = true;
      enableGC = true;
      settings = {
        Swarm = {
          ConnMgr = {
            LowWater = 1000;
            HighWater = 2000;
          };
          Transports.Network = {
            TCP = true;
            Websocket = false;
          };
        };
      };
      localDiscovery  = true;
      startWhenNeeded = true;
    };

    # Lightweight k8s
    k3s = {
      enable = false;
      role = "server";
    };

    keybase.enable = true;
    kbfs.enable    = true;

    postgresql = {
      enable = true;
      package = pkgs.postgresql_13;
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
    gnome.excludePackages = with pkgs; [
      gnome.gnome-maps
      gnome-photos
    ]; 
    systemPackages = with pkgs; with gnome; [
      gnome-boxes
      libgnome-keyring
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

