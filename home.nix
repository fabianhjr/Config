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
          # agda
          # agda-pkg
          chez
          (dotty.override { jre = ltsJava; })
          ghc
          (gradleGen.override {
            jdk = openjdk11;
            java = openjdk11;
          }).gradle_latest
          kotlin
          kotlin-native
          metals
          (mill.override { jre = ltsJava; })
          racket
          sbcl
          scalafmt
        ];
        imperative = [
          nodejs
          ltsJava
          python310
          python39Packages.mypy
          python39Packages.pytest
        ];
        math = [
          # sage
        ];
        media = [
          calibre
          celluloid
          darktable
          digikam
          ffmpeg-full
          fira-code
          gimp
          mpv
          nur.repos.wolfangaukang.vdhcoapp
          rhythmbox
          vlc
        ];
        spell = [ aspell aspellDicts.en aspellDicts.es aspellDicts.eo ];
        tools = [
          androidStudioPackages.beta
          bind
          cmake
          dbeaver
          dbmate
          direnv
          gh
          gnupg
          google-cloud-sdk
          jetbrains.idea-community
          nix-linter
          nixpkgs-lint
          postgresql_13
          protontricks
          ripgrep
          sqlite
          tree
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
      extraPackages = epkgs:
        with epkgs; [
          # agda2-mode # Needs to be from same build as agda
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
