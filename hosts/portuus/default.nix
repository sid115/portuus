{ inputs, outputs, ... }:

{
  imports = [
    ./boot.nix
    ./hardware.nix
    ./networking.nix
    ./packages.nix
    ./programs.nix
    ./secrets
    ./services
    ./users.nix

    inputs.core.nixosModules.common

    outputs.nixosModules.common
  ];

  system.stateVersion = "24.11";
}
