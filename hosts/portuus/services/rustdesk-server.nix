{ config, ... }:

# TODO: turn into nixos module for nix-core
let
  extraArgs = [
    "--key"
    "\"$(cat ${config.sops.secrets."rustdesk-server/key".path})\""
  ];
in
{
  services.rustdesk-server = {
    enable = true;
    openFirewall = true;
    signal = {
      enable = true;
      relayHosts = [ config.networking.domain ];
      inherit extraArgs;
    };
    relay = {
      enable = true;
      inherit extraArgs;
    };
  };
}
