# cm4router
Nixos configuration for DFRobot Compute Module 4 IoT Router Carrier Board

## Initialization
```bash
sudo sh -c 'HOME=$(mktemp -d) nix-shell --command fish --packages fish git vim'

# In nix-shell
cd /etc/nixos && git clone https://github.com/fancl20/cm4router.git .

nixos-rebuild boot

# Cleanup and reboot
rm -rf /root/.* && reboot
```

## Updating
```base
nix flake update
nixos-rebuild switch --flake .
```

## Debugging Utilities
```bash
tcpdump -nn -i any

nft -f - <<EOF
table ip filter {
  chain trace_chain {
    type filter hook prerouting priority raw; policy accept;
    ip protocol udp meta nftrace set 1
  }
}
EOF
nft monitor trace
```