{ inputs, ... }:

{
  imports = [ inputs.core.nixosModules.radicale ];

  services.radicale = {
    enable = true;
    reverseProxy.enable = true;
    users = [
      "sid"
      "susagi"
      "ulm"
    ];
  };
}
