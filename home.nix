{ config, pkgs, ... }:

let
  name  = "Fabián Heredia Montiel";
  email = "fabianhjr@protonmail.com";
in {
  home = {
    username = "fabian";
    homeDirectory = "/home/fabian";

    stateVersion = "24.11";

    packages = with pkgs;
      let
        communications = [
          discord
          # fractal
          keybase-gui
          telegram-desktop
          zoom-us
        ];
        media = [
          calibre
          darktable
          digikam
          ffmpeg-full
          fira-code
          rhythmbox
          tidal-hifi
          vlc
        ];
        spell = [ aspell aspellDicts.en aspellDicts.es aspellDicts.eo ];
        jetbrainsWithPlugins = (pkg: jetbrains.plugins.addPlugins pkg ["github-copilot"]);
        jbEditors = with jetbrains; builtins.map jetbrainsWithPlugins [
          clion
          datagrip
          idea-ultimate
          pycharm-professional
          ruby-mine
          rust-rover
          webstorm
        ];
        tools = [
          amdgpu_top
          anki-bin
          devenv
          exercism
          gnome-tweaks
          lm_sensors
          lutris
          nix-tree
          nixpkgs-review
          nmap
          protontricks
          qbittorrent
          qemu
          smartmontools
          tree
          tmate
          vulnix
          winetricks
          wireshark
          zeal-qt6
          zed-editor
        ];
        vc = [
          git-extras
          git-filter-repo
          pijul
        ];
      in communications ++ jbEditors ++ media ++ spell ++ tools ++ vc;
  };

  dconf.settings."org/gnome/shell".enabled-extensions =
    with pkgs.gnomeExtensions; [
      "backslide@codeisland.org"
      "CoverflowAltTab@dmo60.de"
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
      nativeMessagingHosts = with pkgs; [
        gnome-browser-connector
      ];
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

    gh.enable = true;

    git = {
      enable = true;
      difftastic.enable = true;
      lfs.enable = true;

      aliases = {
        # Abreviations
        amend   = "commit --amend";
        c       = "commit";
        co      = "checkout";
        del     = "branch -d";
        s       = "status";

        # Fancy Stuff
        incoming = "log HEAD..@{upstream}";
        outgoing = "log @{upstream}..HEAD";
        logline = "log --graph --abbrev-commit";
      };

      userName = name;
      userEmail = email;

      extraConfig = {
        init = {
          defaultBranch = "main";
        };
        merge = {
          conflictStyle = "diff3";
        };
        pull = {
          rebase = "true";
        };
        push = {
          default = "current";
        };
        rerere = {
          enabled = "true";
        };
      };
    };

    gpg.enable = true;

    gnome-shell = {
      enable = true;
      extensions = with pkgs.gnomeExtensions; [
        { package = freon; }
        { package = gsconnect; }
      ];
    };

    home-manager.enable = true;

    java = {
      enable = true;
      package = pkgs.jdk21;
    };

    jujutsu = {
      enable = true;
      settings = {
        user = {
          inherit name email;
        };
        # https://github.com/martinvonz/jj/discussions/3549
        experimental-advance-branches = {
          enabled-branches = ["glob:*"];
        };
      };
    };

    mpv.enable = true;
    obs-studio.enable = true;
    pandoc.enable = true;
    password-store.enable = true;
    ripgrep.enable = true;
    tmate.enable = true;
    vim.enable = true;
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
