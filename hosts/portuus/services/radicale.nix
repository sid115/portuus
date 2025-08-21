{ inputs, ... }:

{
  imports = [ inputs.core.nixosModules.radicale ];

  services.radicale = {
    enable = true;
    users = [
      "sid"
      "ulm"
    ];
  };
}
