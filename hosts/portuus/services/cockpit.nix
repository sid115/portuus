{ inputs, ... }:

{
  imports = [ inputs.core.nixosModules.cockpit ];

  services.cockpit = {
    enable = true;
    port = 9091;
  };
}
