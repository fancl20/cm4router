{ config, lib, pkgs, ... }:
{
  services.dhcpd4 = {
    enable = true;
    interfaces = [ "br0" ];
    extraConfig = ''
      subnet 192.168.100.0 netmask 255.255.255.0 {
        option routers 192.168.100.2;
        option domain-name-servers 192.168.100.2;
        option subnet-mask 255.255.255.0;
        range 192.168.100.5 192.168.100.245;
      }
    '';
  };
}