{
  inputs,
  pkgs,
  lib,
  ...
}:

let
  inherit (lib) mkDefault;
in
{
  imports = [ inputs.nix-minecraft.nixosModules.minecraft-servers ];

  config = {
    environment.systemPackages = with pkgs; [
      kitty # This is a bad idea, but fixes `missing or unsuitable terminal: xterm-kitty` when using tmux
      tmux
    ];

    nixpkgs.overlays = [ inputs.nix-minecraft.overlay ];

    services.minecraft-servers = {
      enable = mkDefault true;
      eula = mkDefault true;
      openFirewall = mkDefault true;
    };
  };
}
