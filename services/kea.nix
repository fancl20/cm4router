{ config, lib, pkgs, ... }:
{
  services.kea.dhcp4 = {
    enable = true;
    settings = {
      interfaces-config = {
        interfaces = [ "br0" ];
      };
      lease-database = {
        type = "memfile";
      };

      subnet4 = [{
        "option-data": [
          { "name": "routers", "data": "192.168.100.2" }
          { "name": "domain-name-servers", "data": "192.168.100.2" }
        ],
        pools = [
          { pool = "192.168.100.5 - 192.168.100.245"; }
        ];
        subnet = "192.168.100.0/24";
      }];
    };
  };
}