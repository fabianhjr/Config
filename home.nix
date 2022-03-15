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

      (import (builtins.fetchTarball {
        # From 2022-03-14
        url = https://github.com/nix-community/emacs-overlay/archive/0985a6dfa8918641e7c0bc7d86254c46bc103d2a.tar.gz;
      }))
    ];
  };

  home = {
    username = "fabian";
    homeDirectory = "/home/fabian";

    stateVersion = "21.03";

    packages = with pkgs;
      let
        ltsJava = openjdk11;
        communications = [ discord fractal ssb-patchwork tdesktop ];
        extensions = with gnomeExtensions; [ gsconnect ];
        functional = [
          agda
          agda-pkg
          cabal-install
          chez
          (dotty.override { jre = ltsJava; })
          haskell.compiler.ghc921
          # (haskell-language-server.override { supportedGhcVersions = [ "901" "921" ]; })
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
          texlive.combined.scheme-full
          vlc
        ];
        spell = [ aspell aspellDicts.en aspellDicts.es aspellDicts.eo ];
        tools = [
          androidStudioPackages.beta
          bind
          colmapWithCuda
          cmake
          dbeaver
          dbmate
          direnv
          exercism
          gettext
          gh
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
          python310Packages.opensfm
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
      "freon@UshakovVasilii_Github.yahoo.com"
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

    firefox.enable = true;
    home-manager.enable = true;
  };

  services = {
    emacs.enable = true;
    gpg-agent.enable = true;
  };
}
