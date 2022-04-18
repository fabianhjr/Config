{ pkgs, ... }:

{
  nixpkgs = {
    config = {
      allowUnfree = true;

      gcc.arch = "znver2";
      gcc.tune = "znver2";

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

      # 2022-04-15
      (import (builtins.fetchTarball {
        url = https://github.com/nix-community/emacs-overlay/archive/d0ef2cfa729bab6adacf6461d48a4fb83618c047.tar.gz;
      }))
    ];
  };

  home = {
    username = "fabian";
    homeDirectory = "/home/fabian";

    stateVersion = "22.05";

    packages = with pkgs;
      let
        ltsJava = openjdk11;
        communications = [ discord fractal ssb-patchwork tdesktop ];
        extensions = with gnomeExtensions; [ freon gsconnect ];
        functional = [
          agda
          agda-pkg
          cabal-install
          chez
          (dotty.override { jre = ltsJava; })
          haskell.compiler.ghc922
          # (haskell-language-server.override { supportedGhcVersions = [ "902" "922" ]; })
          gradle_7
          kotlin
          kotlin-language-server
          kotlin-native
          ktlint
          metals
          (mill.override { jre = ltsJava; })
          racket
          sbcl
          sbt
          scalafmt
        ];
        imperative = [
          nodejs
          ltsJava
          (python310.withPackages (ps: with ps; [
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
          celluloid
          darktable
          # digikam
          ffmpeg-full
          fira-code
          gimp
          inkscape
          kdenlive
          mpv
          nur.repos.wolfangaukang.vdhcoapp
          pandoc
          rhythmbox
          texlive.combined.scheme-medium
          vlc
	];
	spell = [ aspell aspellDicts.en aspellDicts.es aspellDicts.eo ];
	tools = [
          androidStudioPackages.beta
          bind
          # colmapWithCuda
          cmake
          dbeaver
          dbmate
          direnv
          exercism
          gettext
          gh
          gnome.gnome-tweaks
          gnupg
          google-cloud-sdk
          jetbrains.idea-community
          jq
          kubectl
          kubernetes-helm
          libreoffice
          librsvg
          lm_sensors
          nix-linter
          nixpkgs-lint
          pass
          postgresql_13
          protontricks
          qbittorrent
          ripgrep
          sqlite
          stack
          tree
          vim
          visualvm
          winetricks
          zeal
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
      package = pkgs.emacsPgtkGcc;
      extraPackages = epkgs:
        with epkgs; [
          agda2-mode # Needs to be from same build as agda
          vterm
        ];
    };

    firefox = {
      enable = true;
    };

    home-manager.enable = true;
  };

  services = {
    emacs.enable = true;
    gpg-agent.enable = true;
  };
}
