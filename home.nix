{ pkgs, ... }:

{
  nixpkgs = {
    config = {
      allowUnfree = true;

      gcc.arch = "znver2";
      gcc.tune = "znver2";

      packageOverrides = pkgs: {
        nur = import (builtins.fetchTarball "https://github.com/nix-community/NUR/archive/master.tar.gz") {
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
        communications = [
          discord
          fractal
          ssb-patchwork
          tdesktop
        ];
        extensions = with gnomeExtensions; [ gsconnect ];
        functional = [
          agda
          agda-pkg
          chez
          ghc
          (gradleGen.override {
            jdk = openjdk11;
            java = openjdk11;
          }).gradle_latest
          cabal-install
          kotlin
          (metals.override { jdk = ltsJava; jre = ltsJava; })
          (mill.override { jre = ltsJava; })
          nixpkgs-lint
          nixfmt
          nix-linter
          racket
          sbcl
          (scala.override { jre = ltsJava; })
        ];
        imperative = [
          crystal
          nodejs
          ltsJava
          perl
          python3
          ruby
          rustup
          rust-analyzer
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
          gimp
          mpv
          nur.repos.wolfangaukang.vdhcoapp
          rhythmbox
          vlc
        ];
        spell = [ aspell aspellDicts.en aspellDicts.es aspellDicts.eo ];
        tools = [
          androidStudioPackages.stable
          androidStudioPackages.beta
          bind
          cmake
          dbeaver
          dbmate
          direnv
          gnupg
          jetbrains.idea-community
          postgresql_13
          ripgrep
          sqlite
          tree
          youtube-dl
          zeal
        ];
        vc = [ git git-lfs pijul ];
      in communications ++ extensions ++ functional ++ imperative ++ math ++
         media ++ spell ++ tools ++ vc;
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
        with epkgs;
        [
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
