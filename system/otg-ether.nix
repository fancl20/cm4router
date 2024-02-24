{ pkgs, ... }:
{
  boot.kernelModules = [ "libcomposite" "dwc2" "g_ether" ];
  hardware.deviceTree = {
    enable = true;
    overlays = [{
      # From https://github.com/NixOS/nixos-hardware/blob/master/raspberry-pi/4/dwc2.nix
      name = "dwc2-overlay";
      dtsText = ''
        /dts-v1/;
        /plugin/;

        / {
          compatible = "brcm,bcm2711";

          fragment@0 {
            target = <&usb>;
            #address-cells = <0x01>;
            #size-cells = <0x01>;

            __overlay__ {
              compatible = "brcm,bcm2835-usb";
              dr_mode = "peripheral";
              g-np-tx-fifo-size = <0x20>;
              g-rx-fifo-size = <0x22e>;
              g-tx-fifo-size = <0x200 0x200 0x200 0x200 0x200 0x100 0x100>;
              status = "okay";
              phandle = <0x01>;
            };
          };
        };
      '';
    }];
  };
}
