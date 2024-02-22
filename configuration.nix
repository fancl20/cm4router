{ config, pkgs, ... }:
{
  imports = [
    ./system/hardware.nix
    ./system/users.nix
    ./system/network.nix

    ./services/dae.nix
  ];

  networking = {
    hostName = "cm4router";
  };

  services.openssh.enable = true;

  environment.systemPackages = [ (pkgs.writeShellScriptBin "configure" ''
    cd /etc/nixos && sudo sh -c 'HOME=$(mktemp -d) nix-shell --command fish --packages fish git vim dnsutils tcpdump'
  '') ];

  system.stateVersion = "23.11";
}
