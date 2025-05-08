{ inputs, outputs, ... }:

{
  imports = [
    ./attic.nix
    ./boot.nix
    ./hardware.nix
    ./hydra.nix
    ./minecraft-servers
    ./networking.nix
    ./packages.nix
    ./services.nix
    ./users.nix
    ./vde.nix

    inputs.core.nixosModules.common
    inputs.core.nixosModules.sops

    outputs.nixosModules.common
  ];

  system.stateVersion = "24.11";
}
