{ config, lib, pkgs, ... }:
{
  imports = [ ./dae/module.nix ];

  services.dae = {
    enable = true;
    config = ''
      global{
        lan_interface: veth0
        auto_config_kernel_parameter: true
      }
      dns {
        upstream {
          googledns: 'tcp+udp://dns.google.com:53'
          alidns: 'udp://dns.alidns.com:53'
        }
        routing {
          request {
            fallback: alidns
          }
          response {
            upstream(googledns) -> accept

            ip(geoip:private) && !qname(geosite:cn) -> googledns
            fallback: accept
          }
        }
      }
      routing{
        dip(geoip:private) -> direct

        dip(geoip:cn) -> direct
        domain(geosite:cn) -> direct

        dip(geoip:jp) -> jp

        fallback: all
      }
      group {
        all {
          policy: min_moving_avg
        }
        jp {
          filter: name(CN-JP2)
          policy: min_moving_avg
        }
      }
      node {
      }
    '';
  };
  systemd.services = {
    dae = {
      bindsTo = [ "netns@dae.service" ];
      requires = [ "network-online.target" ];
      after = [ "netns@wg.service" ];
      serviceConfig = {
        NetworkNamespacePath = "/var/run/netns/dae";
        ExecStartPre = with pkgs; lib.mkAfter [ (writers.writeBash "dae-ns-up" ''
          set -e
          ${libuuid}/bin/nsenter -t 1 -n ${iproute}/bin/ip link add dev veth0 type veth peer name veth0 netns dae
          ${libuuid}/bin/nsenter -t 1 -n ${iproute}/bin/ip link set veth0 master br0 up
          ${iproute}/bin/ip link set veth0 up
          ${iproute}/bin/ip addr add 192.168.100.2/24 dev veth0
          ${iproute}/bin/ip route add default via 192.168.100.1 dev veth0
          ${iproute}/bin/ip link set lo up
        '') ];
        ExecStopPost = with pkgs; lib.mkAfter [ (writers.writeBash "dae-ns-down" ''
          set -e
          ${iproute}/bin/ip route del default via 192.168.100.1 dev veth0
          ${iproute}/bin/ip link del dev veth0
        '') ];
      };
    };
  };
}
