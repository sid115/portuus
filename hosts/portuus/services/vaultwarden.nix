{ inputs, ... }:

{
  imports = [ inputs.core.nixosModules.vaultwarden ];

  services.vaultwarden = {
    enable = true;
    reverseProxy = {
      enable = true;
      subdomain = "vault";
    };
    # backupDir = "/data/backup/vaultwarden"; # FIXME
  };
}
