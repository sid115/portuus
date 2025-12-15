{
  outputs,
  ...
}:

{
  imports = [
    # ./headplane.nix
    # ./headscale.nix
    # ./nginx.nix
    ./openssh.nix

    # outputs.nixosModules.tailscale
  ];
}
