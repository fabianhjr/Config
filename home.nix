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
        url = https://github.com/nix-community/emacs-overlay/archive/master.tar.gz;
      }))
    ];
  };
  
  home = {
    username = "fabian";
    homeDirectory = "/home/fabian";

    stateVersion = "21.03";

    packages = with pkgs;
      let
        llvm = llvmPackages_11;
        pythonPackages = python38Packages;
        communications = [ discord tdesktop ];
        extensions = with gnomeExtensions; [ gsconnect ];
        functional = [
          agda agda-pkg
          ghc haskellPackages.apply-refact cabal-install
          nix-linter nixpkgs-lint
          sbcl
        ];
        gaming = [ lutris steamOverriden wine-staging ];
        imperative = [
          llvm.clang
          crystal
          nim
          nodejs
          perl
          pythonPackages.python
          ruby
          rustc cargo rust-analyzer
          scala
        ];
        lisps = [
          chez
        ];
        media = [ calibre celluloid darktable shotwell];
        spell = [ aspell aspellDicts.en aspellDicts.es ];
        steamOverriden = steam.override {
        };
        tools = [ bind llvm.bintools cmake ripgrep tree youtube-dl zeal ];
        vc = [ darcs git git-lfs pijul ];
      in
        communications ++ extensions ++ functional ++ gaming ++ imperative ++
          lisps ++ media ++ spell ++ tools ++ vc;
  };

  dconf.settings."org/gnome/shell".enabled-extensions = with pkgs.gnomeExtensions; [
    gsconnect.uuid
  ];

  programs = {
    bat.enable = true;
    browserpass.enable = true;

    emacs = {
      enable = true;
      package = pkgs.emacsGcc.override { nativeComp = true; };  
      extraPackages =  epkgs: with epkgs;
        [
          # General
          async
          buttercup
          company company-lsp
          dash
          doom-modeline
          dumb-jump
          emojify
          evil
          flycheck
          flx
          general
          helm helm-projectile
          helpful
          lsp-mode lsp-ui lsp-treemacs
          magit forge
          paredit
          pdf-tools
          polymode
          popup
          projectile
          proof-general
          org orgit org-journal org-noter org-projectile org-roam
          smartparens
          swiper
          tablist
          transient
          treemacs treemacs-projectile
          vterm
          yasnippet
          # Language Specific
          agda2-mode # Needs to be from same build as agda
          cider
          ess
          markdown-mode
          rtags
          sly
          tuareg
        ];
    };

    firefox = {
      enable = true;
      enableGnomeExtensions = true;
    };
    home-manager.enable = true;
  };

  services = {
    emacs = {
      enable = true;
    };
    
    gpg-agent = {
      enable              = true;
    };
  };
}
