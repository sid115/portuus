{ inputs, ... }:

{
  imports = [ inputs.core.nixosModules.miniflux ];

  services.miniflux = {
    enable = true;
    reverseProxy = {
      enable = true;
      subdomain = "miniflux";
    };
    config = {
      ADMIN_USERNAME = "sid";
    };
  };
}
