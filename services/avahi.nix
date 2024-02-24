{ config, lib, pkgs, ... }:
{
  services.avahi = {
    enable = true;
    publish = {
      enable = true;
      addresses = true;
      workstation = true;
    };
    # https://github.com/avahi/avahi/issues/117#issuecomment-442201162
    cacheEntriesMax = 0;
  };
}
