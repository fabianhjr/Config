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

    stateVersion = "23.05";

    packages = with pkgs;
      let
        idea-community-fhs = (buildFHSUserEnv {
          name = "idea-community";
          targetPkgs = pkgs: (with pkgs; [
            maven
            jdk17
            nodejs
            yarn
            jetbrains.idea-community
            python311
            zlib  # needed for NumPy
          ]);
          runScript = "idea-community";
        });
        communications = [
          discord
          tdesktop
          slack
          zoom-us
        ];
        extensions = with gnomeExtensions; [ freon gsconnect ];
        media = [
          calibre
          darktable
          digikam
          ffmpeg-full
          fira-code
          gimp
          minecraft
          nur.repos.wolfangaukang.vdhcoapp
          rhythmbox
          vlc
        ];
        spell = [ aspell aspellDicts.en aspellDicts.es aspellDicts.eo ];
        tools = [
          anki-bin
          dbeaver
          direnv
          gh
          gnome.gnome-tweaks
          gnupg
          idea-community-fhs
          lm_sensors
          nixpkgs-lint
          nixpkgs-review
          obs-studio
          openrgb
          pass
          pinentry
          protontricks
          python3
          qbittorrent
          ripgrep
          sqlite
          tree
          tmate
          vim
          visualvm
          winetricks
          zeal-qt6
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
    bat.enable = true;
    browserpass.enable = true;

    chromium = {
      enable = false;
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
    gpg-agent.enable = true;
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
