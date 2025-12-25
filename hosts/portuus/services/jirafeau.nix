{ inputs, ... }:

{
  imports = [ inputs.core.nixosModules.jirafeau ];

  services.jirafeau = {
    enable = true;
    dataDir = "/data/jirafeau";
    reverseProxy = {
      enable = true;
      subdomain = "share";
    };
  };
}
