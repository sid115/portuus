{ inputs, ... }:

{
  imports = [ inputs.core.nixosModules.nginx ];

  services.nginx.enable = true;
}
