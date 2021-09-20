{ pkgs, ... }:

{
  nixpkgs = {
    config = {
      allowUnfree = true;

      gcc.arch = "znver2";
      gcc.tune = "znver2";
    };

    overlays = [
      (import (builtins.fetchTarball {
        url =
          "https://github.com/nix-community/emacs-overlay/archive/master.tar.gz";
      }))
    ];
  };

  home = {
    username = "fabian";
    homeDirectory = "/home/fabian";

    stateVersion = "21.03";

    packages = with pkgs;
      let
        llvm = llvmPackages_12;
        pythonPackages = python39Packages;
        communications = [ tdesktop ];
        extensions = with gnomeExtensions; [ gsconnect ];
        functional = [
          agda
          agda-pkg
          ghc
          (gradleGen.override {
            jdk = openjdk11;
            java = openjdk11;
          }).gradle_latest
          cabal-install
          nixpkgs-lint
          nixfmt
          nix-linter
          racket
          sbcl
          (scala.override { jre = openjdk11; })
          (mill.override { jre = openjdk11; })
        ];
        imperative = [
          llvm.clang # llvm.bintools
          crystal
          nasm
          nim
          nodejs
          openjdk11
          perl
          pythonPackages.python
          ruby
          rustup
          rust-analyzer
        ];
        lisps = [ chez ];
        math = [
          # sage
        ];
        media = [ audacity calibre celluloid darktable digikam gimp shotwell ];
        spell = [ aspell aspellDicts.en aspellDicts.es ];
        tools = [ bind cmake ripgrep tree youtube-dl zeal ];

        vc = [ git git-lfs ];
      in communications ++ extensions ++ functional ++ imperative ++ lisps
      ++ math ++ media ++ spell ++ tools ++ vc;
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
      package = pkgs.emacsGcc.override { nativeComp = true; };
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
