{ config, lib, pkgs, ... }:
{
  imports = [
    ./system/hardware.nix
    ./system/users.nix
    ./system/network.nix

    ./services/avahi.nix
    ./services/dae.nix
    ./services/kea.nix
  ];

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  networking.hostName = "cm4router";
  services.openssh.enable = true;

  environment.systemPackages = [ (pkgs.writeShellScriptBin "configure" ''
    cd /etc/nixos && \
    sudo sh -ec '
      HOME=$(mktemp -d) nix-shell \
      --packages fish git vim dnsutils tcpdump \
      --command "EDITOR=vim EMAIL=fancl20@gmail.com fish"
    '
  '') ];

  system.stateVersion = "23.11";
}
