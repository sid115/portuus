{ inputs, pkgs, ... }:

{
  imports = [ inputs.core.nixosModules.tailscale ];

  services.tailscale = {
    enable = true;
    enableSSH = true;
    loginServer = "https://hs.portuus.de";
  };

  environment.systemPackages = with pkgs; [
    kitty # to be able to copy term info
  ];
}
