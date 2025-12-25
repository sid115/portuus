{ inputs, ... }:

{
  imports = [ inputs.core.nixosModules.firefly-iii ];

  services.firefly-iii = {
    enable = true;
    reverseProxy = {
      enable = true;
      subdomain = "finance";
      importerSubdomain = "import.finance";
    };
    dataDir = "/data/firefly-iii";
  };
}
