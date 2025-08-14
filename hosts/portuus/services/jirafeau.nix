{ inputs, ... }:

{
  imports = [ inputs.core.nixosModules.jirafeau ];

  services.jirafeau = {
    enable = true;
    dataDir = "/data/jirafeau";
    subdomain = "share";
  };
}
