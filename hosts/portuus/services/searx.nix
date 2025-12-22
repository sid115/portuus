{ inputs, ... }:

{
  imports = [ inputs.core.nixosModules.searx ];

  services.searx = {
    enable = true;
    reverseProxy = {
      enable = true;
      subdomain = "search";
    };
    limiterSettings.botdetection.ip_lists.pass_ips = [
      "49.13.67.29" # sid.ovh. FIXME: still 429
    ];
  };
}
