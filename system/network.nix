{ config, pkgs, ... }:
{
  boot.kernel.sysctl = {
    "net.ipv4.conf.all.forwarding" = 1;
  };

  networking = {
    useNetworkd = true;
    firewall.checkReversePath = false;
    nftables = {
      enable = true;
      ruleset = ''
        table ip nat {
          chain postrouting {
            type nat hook postrouting priority srcnat; policy accept;
            ip saddr 192.168.100.0/24 oifname "end0" masquerade
          }
          chain prerouting {
            type nat hook prerouting priority dstnat; policy accept;
            iifname "end0" udp dport 53 dnat to 192.168.100.2
          }
        }
      '';
    };
  };

  systemd.network = {
    enable = true;
    netdevs = {
      "20-lan-br0" = {
        netdevConfig = {
          Name = "br0";
          Kind = "bridge";
        };
      };
    };
    networks = {
      "10-wan" = {
        matchConfig.Name = "end0";
        DHCP = "ipv4";
        linkConfig.RequiredForOnline = "routable";
      };
      "10-lan" = {
        matchConfig.Name = "enp1s0";
        bridge = [ "br0" ];
      };
      "20-lan-br0" = {
        matchConfig.Name = "br0";
        address = [ "192.168.100.1/24" ];
        routes = [
          { routeConfig = { Table = 10; Gateway = "192.168.100.2"; }; }
        ];
        routingPolicyRules = [
          { routingPolicyRuleConfig = { Table = 10; IncomingInterface = "end0"; }; }
        ];
      };
    };
  };

  systemd.services."netns@" = {
    description = "%I network namespace";
    before = [ "network.target" ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      ExecStart = "${pkgs.iproute}/bin/ip netns add %I";
      ExecStop = "${pkgs.iproute}/bin/ip netns del %I";
    };
  };
}
