{ inputs, ... }:

{
  imports = [ inputs.core.nixosModules.radicale ];

  services.radicale = {
    enable = true;
    reverseProxy = {
      enable = true;
      subdomain = "dav";
    };
    users = [
      "sid"
      "susagi"
      "ulm"
    ];
  };
}
