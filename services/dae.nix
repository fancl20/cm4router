{ config, lib, pkgs, inputs, ... }:
{
  imports = [ ./dae/module.nix ];

  services.dae = {
    enable = true;
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
