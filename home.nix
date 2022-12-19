{ pkgs, ... }:

{
  nixpkgs = {
    config = {
      allowUnfree = true;

      # gcc.arch = "znver2";
      # gcc.tune = "znver2";

      packageOverrides = pkgs: {
        nur = import (builtins.fetchTarball
          "https://github.com/nix-community/NUR/archive/master.tar.gz") {
            inherit pkgs;
          };
      };
    };

    overlays = [
      (self: super:
        {
          # too expensive
          # stdenv = super.impureUseNativeOptimizations super.stdenv;
        })
    ];
  };

  home = {
    username = "fabian";
    homeDirectory = "/home/fabian";

    stateVersion = "22.05";

    packages = with pkgs;
      let
        communications = [ discord fractal tdesktop ];
        extensions = with gnomeExtensions; [ freon gsconnect ];
        functional = [
          dotty
          metals
          mill
          sbt
          scalafmt
        ];
        imperative = [
          llvmPackages_latest.clang
          nodejs
          (python311.withPackages (ps: with ps; [
            build
            mypy
            pip
            pytest
            pytest-cov
            setuptools
          ]))
        ];
        math = [
          # sage
        ];
        media = [
          calibre
          darktable
          # digikam
          ffmpeg-full
          fira-code
          gimp
          kdenlive
          nur.repos.wolfangaukang.vdhcoapp
          pandoc
          rhythmbox
          # texlive.combined.scheme-medium
          vlc
	];
	spell = [ aspell aspellDicts.en aspellDicts.es aspellDicts.eo ];
	tools = [
          anki-bin
          dbeaver
          dbmate
          direnv
          exercism
          gh
          # gnome.gnome-books
          gnome.gnome-tweaks
          # gns3-gui
          # gns3-server
          gnupg
          google-cloud-sdk
          jetbrains.idea-community
          jq
          kubeaudit
          kubectl
          kubernetes-helm
          # libreoffice
          librsvg
          lm_sensors
          nix-linter
          nixpkgs-lint
          nmap
          # obs-studio
          # openrgb
          pass
          protontricks
          qbittorrent
          qemu
          ripgrep
          sonar-scanner-cli
          sqlite
          tree
          trivy
          vim
          visualvm
          winetricks
          wireshark
          zeal-qt6
        ];
        vc = [ git git-lfs pijul ];
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

    home-manager.enable = true;
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
