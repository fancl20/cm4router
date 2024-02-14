{ config, pkgs, ... }:
{
  imports = [
    ./system/hardware.nix
    ./system/users.nix

    ./services/dae.nix
  ];

  networking = {
    hostName = "cm4router";
  };

  services.openssh.enable = true;

  system.stateVersion = "23.11";
}