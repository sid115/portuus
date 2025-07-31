{ inputs, outputs, ... }:

{
  imports = [
    ./boot.nix
    ./hardware.nix
    # ./jitsi-meet.nix
    ./minecraft-servers
    ./networking.nix
    # ./nuschtos-search.nix
    ./packages.nix
    ./programs.nix
    ./services.nix
    ./users.nix
    ./vde.nix

    inputs.core.nixosModules.common
    inputs.core.nixosModules.sops

    outputs.nixosModules.common
  ];

  system.stateVersion = "24.11";
}
