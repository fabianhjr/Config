{ pkgs, ... }:

{
  nixpkgs.overlays = [
    (import (builtins.fetchTarball {
      url = https://github.com/nix-community/emacs-overlay/archive/master.tar.gz;
    }))
  ];
  
  home = {
    username = "fabian";
    homeDirectory = "/home/fabian";

    stateVersion = "21.03";

    packages = with pkgs;
      [
        aspell aspellDicts.en aspellDicts.es
        bat
        bind
        calibre
        celluloid
        darcs
        darktable
        discord
        firefox
        git git-lfs
      ];
  };

  programs = {
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
