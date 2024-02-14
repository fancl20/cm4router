{ config, pkgs, ... }:
{
  fileSystems = {
    "/home/nixos" = {
      depends = [ "/" ];
      device = "/home/nixos";
      options = [ "bind" "ro" "noatime" ];
    };
     "/root" = {
      depends = [ "/" ];
      device = "/root";
      options = [ "bind" "ro" "noatime" ];
    };
  };

  users = {
    mutableUsers = false;
    users.nixos = {
      isNormalUser = true;
      extraGroups = [ "wheel" ];
      openssh.authorizedKeys.keys  = [ "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIr9Oso7bpcVMmtkYFtD9KkZ/lwoM0/SiRUrAsvSgZGt fancl20@gmail.com" ];
    };
  };

  security.sudo.wheelNeedsPassword = false;
}
