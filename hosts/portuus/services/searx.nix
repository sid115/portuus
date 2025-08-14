{ inputs, ... }:

{
  imports = [ inputs.core.nixosModules.searx ];

  services.searx = {
    enable = true;
    subdomain = "search";
  };
}
