{ inputs, ... }:

{
  imports = [ inputs.core.nixosModules.peertube ];

  services.peertube = {
    enable = true;
    reverseProxy = {
      enable = true;
      subdomain = "videos";
    };
    dataDirs = [ "/data/peertube" ];
  };
}
