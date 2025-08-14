{ inputs, ... }:

{
  imports = [ inputs.core.nixosModules.firefly-iii ];

  services.firefly-iii = {
    enable = true;
    subdomain = "finance";
    dataDir = "/data/firefly-iii";
  };
}
