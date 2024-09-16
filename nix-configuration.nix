{ config, pkgs, ... }:

{
  nix = {
    gc = {
      automatic = true;
      dates = "daily";
      options = "--delete-older-than 7d";
    };

    settings = {
      auto-optimise-store = true;
      trusted-users = [ "root" "@wheel" ];
    };

    extraOptions = ''
      experimental-features = nix-command flakes
      keep-derivations = true
      keep-outputs = true
    '';
  };

  nixpkgs = {
    config = {
      allowUnfree = true;
    };
  };
}
