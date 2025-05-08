{ config, ... }:

# Setup:
# Generate binary cache key pair:
# nix-store --generate-binary-cache-key cache.portuus.de cache-priv-key.pem cache-pub-key.pem
# Delete the files after saving their contents.

let
  cfg = config.services.nix-serve;
  fqdn = "cache.portuus.de";
in
{
  services.nix-serve = {
    enable = true;
    port = 5005;
    secretKeyFile = config.sops.templates."nix-serve/cache-priv-key".path;
  };

  users = {
    groups.nix-serve = { };
    users.nix-serve = {
      group = "nix-serve";
      home = "/var/nix-serve";
      createHome = true;
      isSystemUser = true;
    };
  };

  services.nginx.virtualHosts."${fqdn}" = {
    enableACME = true;
    forceSSL = true;
    locations."/".proxyPass = "http://${cfg.bindAddress}:${toString cfg.port}";
  };

  sops =
    let
      owner = "nix-serve";
      group = "nix-serve";
      pub.mode = "0644";
      priv.mode = "0600";
    in
    {
      secrets."nix-serve/cache-pub-key" = {
        inherit owner group;
        inherit (pub) mode;
      };
      templates."nix-serve/cache-pub-key" = {
        inherit owner group;
        inherit (pub) mode;
        content = ''
          ${fqdn}:${config.sops.placeholder."nix-serve/cache-pub-key"}=
        '';
      };
      secrets."nix-serve/cache-priv-key" = {
        inherit owner group;
        inherit (priv) mode;
      };
      templates."nix-serve/cache-priv-key" = {
        inherit owner group;
        inherit (priv) mode;
        content = ''
          ${fqdn}:${config.sops.placeholder."nix-serve/cache-priv-key"}==
        '';
      };
    };
}
