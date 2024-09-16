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

    stateVersion = "24.05";

    packages = with pkgs;
      let
        idea-ultimate-fhs = (buildFHSUserEnv {
          name = "idea";
          targetPkgs = pkgs: (with pkgs; [
            maven
            jdk21
            nodejs
            yarn
            jetbrains.idea-ultimate
            python312
            zlib
          ]);
          runScript = "idea";
        });
        webstorm-fhs = (buildFHSUserEnv {
          name = "webstorm";
          targetPkgs = pkgs: (with pkgs; [
            maven
            jdk21
            nodejs
            yarn
            jetbrains.webstorm
            python312
            zlib
          ]);
          runScript = "webstorm";
        });
        communications = [
          discord
          gtkcord4
          keybase-gui
          tdesktop
          slack
          zoom-us
        ];
        extensions = with gnomeExtensions; [
          freon
          gsconnect
        ];
        media = [
          calibre
          darktable
          # digikam
          ffmpeg-full
          fira-code
          gimp
          mpv
          rhythmbox
          tidal-hifi
          vlc
        ];
        spell = [ aspell aspellDicts.en aspellDicts.es aspellDicts.eo ];
        tools = [
          amdgpu_top
          anki-bin
          devenv
          dbeaver-bin
          exercism
          gh
          gnome-tweaks
          gnupg
          idea-ultimate-fhs
          webstorm-fhs
          lm_sensors
          lutris
          nix-tree
          nixpkgs-lint
          nixpkgs-review
          nmap
          nvme-cli
          obs-studio
          pandoc
          pass
          protege-distribution
          protontricks
          python3
          qbittorrent
          ripgrep
          smartmontools
          sqlite
          tree
          tmate
          vim
          visualvm
          vulnix
          wine
          winetricks
          zeal
          zed-editor
        ];
        vc = [
          git
          git-extras
          git-filter-repo
          git-lfs
          pijul
        ];
      in communications ++ extensions ++ media ++ spell ++ tools ++ vc;
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
    atuin.enable = true;
    bat.enable = true;
    browserpass.enable = true;

    chromium = {
      enable = true;
      package = pkgs.google-chrome;
    };

    direnv = {
      enable = true;
      nix-direnv.enable = true;
    };

    emacs = {
      enable = true;
      package = pkgs.emacs29-pgtk;
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
    gpg-agent = {
      enable = true;
      pinentryPackage = pkgs.pinentry-gnome3;
    };
    kbfs.enable = true;
    keybase.enable = true;

    recoll = {
      enable = true;
      settings = {
        topdirs = [ "~/Documents" "/run/media/fabian/Data/Documents" ];
        indexstemminglanguages = [ "english" "french" "german" "spanish" ];
        followLinks = 0;
      };
    };
  };
}
