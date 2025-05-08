{ config, ... }:

# Setup:
# Generate server token with: openssl genrsa -traditional 4096 | base64 -w0
# Generate JWT tokens with: sudo atticd-atticadm make-token --validity '3 months' --sub USER

let
  cfg = config.services.atticd;
  fqdn = "attic.portuus.de";
  port = "5667";
in
{
  services.atticd = {
    enable = true;
    environmentFile = config.sops.templates."attic/environment-file".path;
    settings = {
      listen = "127.0.0.1:${port}";
      allowed-hosts = [
        config.networking.domain
        fqdn
      ];
      api-endpoint = "https://${fqdn}/";
      garbage-collection.interval = "24 hours";
    };
  };

  services.nginx.virtualHosts."${fqdn}" = {
    enableACME = true;
    forceSSL = true;
    locations."/".proxyPass = "http://localhost:${port}";
  };

  sops =
    let
      owner = "root";
      group = "root";
      mode = "0440";
    in
    {
      secrets."attic/server-token" = {
        inherit owner group mode;
      };
      templates."attic/environment-file" = {
        inherit owner group mode;
        content = ''
          ATTIC_SERVER_TOKEN_RS256_SECRET_BASE64=${config.sops.placeholder."attic/server-token"}
        '';
      };
    };
}
