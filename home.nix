{ pkgs, ... }:

{
  nixpkgs = {
    config = {
      allowUnfree = true;

      gcc.arch = "znver2";
      gcc.tune = "znver2";
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
        communications = [ discord fractal ssb-patchwork tdesktop ];
        extensions = with gnomeExtensions; [ gsconnect ];
        functional = [
          # agda
          # agda-pkg
          chez
          ghc
          (gradleGen.override {
            jdk = openjdk11;
            java = openjdk11;
          }).gradle_latest
          cabal-install
          kotlin
          metals
          (mill.override { jre = openjdk11; })
          nixpkgs-lint
          nixfmt
          nix-linter
          racket
          sbcl
          (scala.override { jre = openjdk11; })
        ];
        imperative =
          [ crystal nodejs openjdk11 perl python ruby rustup rust-analyzer ];
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
          vlc
        ];
        spell = [ aspell aspellDicts.en aspellDicts.es ];
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
          tree
          youtube-dl
          zeal
        ];

        vc = [ git git-lfs ];
      in communications ++ extensions ++ functional ++ imperative ++ math
      ++ media ++ spell ++ tools ++ vc;
  };

  dconf.settings."org/gnome/shell".enabled-extensions =
    with pkgs.gnomeExtensions; [
      "backslide@codeisland.org"
      "CoverflowAltTab@palatis.blogspot.com"
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
