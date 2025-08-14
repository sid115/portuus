{ inputs, config, ... }:

let
  domain = config.networking.domain;
in
{
  imports = [ inputs.core.nixosModules.nextcloud ];

  services.nextcloud = {
    enable = true;
    datadir = "/data/nextcloud";
    subdomain = "cloud";
    extraApps = {
      inherit (config.services.nextcloud.package.packages.apps)
        bookmarks
        calendar
        contacts
        polls
        richdocuments
        tasks
        # whiteboard # FIXME: https://github.com/sid115/portuus/issues/6
        ;
    };
    settings = {
      richdocuments = {
        wopi_url = "https://office.${domain}";
      };
    };
  };

  # TODO: add to nextcloud nix-core nixos module
  services.collabora-online = {
    enable = true;
    port = 9980;
    settings = {
      # rely on reverse proxy for SSL
      ssl = {
        enable = false;
        termination = true;
      };
      storage.wopi = {
        "@allow" = true;
        host = [ "cloud.${domain}" ];
      };
      server_name = "office.${domain}";
    };
  };

  services.nginx.virtualHosts."office.${domain}" = {
    forceSSL = true;
    enableACME = true;
    locations."/" = {
      proxyPass = "http://127.0.0.1:${toString config.services.collabora-online.port}";
      proxyWebsockets = true;
    };
  };
}
