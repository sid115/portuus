{ inputs, outputs, ... }:

{
  imports = [
    ./boot.nix
    ./hardware.nix
    ./minecraft-servers
    ./networking.nix
    ./packages.nix
    ./services.nix
    ./users.nix

    inputs.core.nixosModules.common
    inputs.core.nixosModules.sops

    outputs.nixosModules.common
  ];

  system.stateVersion = "24.11";
}
