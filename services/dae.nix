{ config, pkgs, ... }:
{
  imports = [ ./dae/module.nix ];

  services.dae = {
      enable = true;
      assets = with pkgs; [ v2ray-geoip v2ray-domain-list-community ];
  };
}