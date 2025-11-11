{ inputs, ... }:

{
  imports = [ inputs.core.nixosModules.headscale ];

  services.headscale = {
    enable = true;
    openFirewall = true;
  };
}
