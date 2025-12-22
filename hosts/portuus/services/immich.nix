{ inputs, ... }:

{
  imports = [ inputs.core.nixosModules.immich ];

  services.immich = {
    enable = true;
    reverseProxy.enable = true;
    mediaLocation = "/data/immich";
    accelerationDevices = null; # all devices
  };
}
