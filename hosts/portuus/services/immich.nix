{ inputs, ... }:

let
  subdomain = "gallery";
in
{
  imports = [ inputs.core.nixosModules.immich ];

  services.immich = {
    enable = true;
    reverseProxy = {
      enable = true;
      inherit subdomain;
    };
    mediaLocation = "/data/immich";
    accelerationDevices = null; # all devices
  };
}
