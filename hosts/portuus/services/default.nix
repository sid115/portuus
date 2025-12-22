{
  outputs,
  ...
}:

{
  imports = [
    ./firefly-iii.nix
    ./gitea.nix
    ./github-runners.nix
    ./hydra.nix
    ./immich.nix
    ./jellyfin.nix
    ./jirafeau.nix
    ./mailserver.nix
    ./matrix-synapse.nix
    ./minecraft-servers.nix
    ./miniflux.nix
    ./nextcloud.nix
    ./nginx.nix
    ./nix-serve.nix
    ./open-webui-oci.nix
    ./openssh.nix
    ./peertube.nix
    ./radicale.nix
    ./rss-bridge.nix
    ./rustdesk-server.nix
    ./searx.nix
    ./vaultwarden.nix
    ./vde.nix
    ./zfs.nix

    # outputs.nixosModules.tailscale

    # ./ig.nix # FIXME
    # ./spliit.nix # FIXME
    # ./jitsi-meet.nix
  ];
}
