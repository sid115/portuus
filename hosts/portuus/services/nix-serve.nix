{ inputs, ... }:

{
  imports = [ inputs.core.nixosModules.nix-serve ];

  services.nix-serve.enable = true;
}
