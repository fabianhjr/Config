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
      experimental-features = [ "flakes" "nix-command" ];
      trusted-users = [ "root" "@wheel" ];
    };

    extraOptions = ''
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
