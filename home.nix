{ pkgs, ... }:

{
  nixpkgs = {
    config = {
      allowUnfree = true;

      packageOverrides = pkgs: {
        nur = import (builtins.fetchTarball
          "https://github.com/nix-community/NUR/archive/master.tar.gz") {
            inherit pkgs;
          };
      };
    };
  };

  home = {
    username = "fabian";
    homeDirectory = "/home/fabian";

    stateVersion = "23.05";

    packages = with pkgs;
      let
        idea-community-fhs = (buildFHSUserEnv {
          name = "idea-community";
          targetPkgs = pkgs: (with pkgs; [
            maven
            jdk17
            nodejs-18_x
            yarn
            jetbrains.idea-community
            python311
            zlib  # needed for NumPy
          ]);
          runScript = "idea-community";
        });
        communications = [ discord fractal-next tdesktop zoom-us ];
        extensions = with gnomeExtensions; [ freon gsconnect ];
        functional = [
          dotty
          metals
          (sbt.override {
            jre = jdk17;
          })
          scalafmt
        ];
        imperative = [
          go
          jdk17
          llvmPackages_latest.clang
          nodejs
        ];
        math = [
          # sage
        ];
        media = [
          calibre
          darktable
          digikam
          ffmpeg-full
          fira-code
          gimp
          kdenlive
          librsvg
          nur.repos.wolfangaukang.vdhcoapp
          pandoc
          haskellPackages.pandoc-crossref
          rhythmbox
          texlive.combined.scheme-full
          vlc
	];
	spell = [ aspell aspellDicts.en aspellDicts.es aspellDicts.eo ];
	tools = [
          alloy6
          anki-bin
          async-profiler
          bazel
          ciscoPacketTracer8
          dbeaver
          direnv
          exercism
          gh
          gnome.gnome-tweaks
          gnupg
          idea-community-fhs
          jq
          kubectl
          kubernetes-helm
          # libreoffice
          lm_sensors
          nixpkgs-lint
          nixpkgs-review
          nmap
          obs-studio
          openrgb
          pass
          protontricks
          qbittorrent
          qemu
          ripgrep
          sonar-scanner-cli
          sqlite
          tree
          tmate
          vim
          visualvm
          winetricks
          wireshark
          zeal-qt6
        ];
        vc = [
          git
          git-extras
          git-lfs
          pijul
        ];
      in communications ++ extensions ++ functional ++ imperative ++ math
      ++ media ++ spell ++ tools ++ vc;
  };

  dconf.settings."org/gnome/shell".enabled-extensions =
    with pkgs.gnomeExtensions; [
      "backslide@codeisland.org"
      "CoverflowAltTab@dmo60.de"
      freon.extensionUuid
      gsconnect.extensionUuid
      "launch-new-instance@gnome-shell-extensions.gcampax.github.com"
      "vertical-overview@RensAlthuis.github.com"
    ];

  programs = {
    bat.enable = true;
    browserpass.enable = true;

    emacs = {
      enable = true;
      package = pkgs.emacs28NativeComp;
      extraPackages = epkgs:
        with epkgs; [
          # agda2-mode # Needs to be from same build as agda
          vterm
        ];
    };

    firefox = {
      enable = true;
      package = pkgs.firefox.override {
        cfg = {
          enableGnomeExtensions = true;
        };
      };
    };

    fish = {
      enable = true;
      shellInit = ''
        set -gx EDITOR emacsclient

        set -gx PATH ~/.local/node/bin/ $PATH
        set -gx PATH ~/.cargo/bin $PATH
        set -gx PATH ~/.local/bin $PATH
      '';
    };

    home-manager.enable = true;

    java = {
      enable = true;
      package = pkgs.jdk17;
    };
  };

  services = {
    emacs.enable = true;
    gpg-agent.enable = true;

    recoll = {
      enable = false;
      settings = {
        topdirs = [ "~/Documents" "/run/media/fabian/Data/Documents" ];
        indexstemminglanguages = [ "english" "french" "german" "spanish" ];
        followLinks = 0;
      };
    };
  };
}
