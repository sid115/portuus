{ inputs, ... }:

{
  imports = [ inputs.core.nixosModules.nix-serve ];

  services.nix-serve = {
    enable = true;
    reverseProxy = {
      enable = true;
      subdomain = "cache";
    };
  };
}
