{ config, pkgs, ... }:
{
  require = [
    ./system/hardware.nix
    ./system/users.nix
  ];

  networking = {
    hostName = "cm4router";
  };

  services.openssh.enable = true;

  system.stateVersion = "23.11";
}