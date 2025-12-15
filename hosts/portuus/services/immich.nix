{ inputs, ... }:

{
  imports = [ inputs.core.nixosModules.immich ];

  services.immich = {
    enable = true;
    mediaLocation = "/data/immich";
    accelerationDevices = null; # all devices
  };

  services.nginx.virtualHosts."gallery.portuus.de" = {
    extraConfig = ''
      client_max_body_size 5G;
    '';
  };
}
