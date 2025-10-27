{ outputs, ... }:

{
  imports = [ outputs.nixosModules.immich ];

  services.immich = {
    enable = true;
    mediaLocation = "/data/immich";
    accelerationDevices = null; # all devices
  };
}
