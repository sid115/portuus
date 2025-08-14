{ inputs, ... }:

{
  imports = [ inputs.core.nixosModules.hydra ];

  services.hydra.enable = true;
}
