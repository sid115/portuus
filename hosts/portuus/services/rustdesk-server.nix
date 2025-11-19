{ config, ... }:

# TODO: turn into nixos module for nix-core
# FIXME: implement an authentication mechanism
let
  extraArgs = [
    "--key"
    "_"
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
