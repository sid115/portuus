{ inputs, ... }:

{
  imports = [ inputs.core.nixosModules.hydra ];

  services.hydra = {
    enable = true;
    reverseProxy = {
      enable = true;
      subdomain = "hydra";
    };
  };
}
