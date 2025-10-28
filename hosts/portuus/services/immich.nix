{ inputs, ... }:

{
  imports = [ inputs.core.nixosModules.immich ];

  services.immich = {
    enable = true;
    mediaLocation = "/data/immich";
    accelerationDevices = null; # all devices
  };
}
