{
  inputs,
  config,
  ...
}:

{
  imports = [
    inputs.core.nixosModules.firefly-iii
    inputs.core.nixosModules.gitea
    inputs.core.nixosModules.jellyfin
    inputs.core.nixosModules.jirafeau
    inputs.core.nixosModules.mailserver
    inputs.core.nixosModules.matrix-synapse
    inputs.core.nixosModules.nextcloud
    inputs.core.nixosModules.nginx
    inputs.core.nixosModules.open-webui
    inputs.core.nixosModules.openssh
    inputs.core.nixosModules.peertube
    inputs.core.nixosModules.rss-bridge
    inputs.core.nixosModules.tt-rss
    inputs.core.nixosModules.vaultwarden
  ];

  mailserver = {
    enable = true;
    loginAccounts = {
      "info@${config.networking.domain}" = {
        hashedPasswordFile = config.sops.secrets."mailserver/accounts/info".path;
        aliases = [ "postmaster@${config.networking.domain}" ];
      };
      "sid@${config.networking.domain}" = {
        hashedPasswordFile = config.sops.secrets."mailserver/accounts/sid".path;
        aliases = [ "postmaster@${config.networking.domain}" ];
      };
      "steffen@${config.networking.domain}" = {
        hashedPasswordFile = config.sops.secrets."mailserver/accounts/steffen".path;
        aliases = [ "postmaster@${config.networking.domain}" ];
      };
    };
  };
  sops.secrets."mailserver/accounts/info" = { };
  sops.secrets."mailserver/accounts/sid" = { };
  sops.secrets."mailserver/accounts/steffen" = { };

  services.firefly-iii = {
    enable = true;
    subdomain = "finance";
    dataDir = "/data/firefly-iii";
  };
  services.gitea = {
    enable = true;
    stateDir = "/data/gitea";
  };
  services.jellyfin = {
    enable = true;
    dataDir = "/data/jellyfin";
    cacheDir = "${config.services.jellyfin.dataDir}/cache";
    subdomain = "media";
  };
  services.jirafeau = {
    enable = true;
    dataDir = "/data/jirafeau";
    subdomain = "share";
  };
  services.matrix-synapse = {
    enable = true;
    dataDir = "/data/matrix-synapse";
  };
  services.nextcloud = {
    enable = true;
    datadir = "/data/nextcloud";
    subdomain = "cloud";
    extraApps = {
      inherit (config.services.nextcloud.package.packages.apps)
        bookmarks
        calendar
        contacts
        mail
        tasks
        ;
    };
  };
  services.vaultwarden = {
    enable = true;
    subdomain = "vault";
  };
  services.peertube = {
    enable = true;
    subdomain = "videos";
    dataDirs = [ "/data/peertube" ];
  };
  services.nginx.enable = true;
  services.openssh.enable = true;
  services.ollama = {
    enable = true;
    acceleration = "rocm"; # does not work on intel :( we need nvidia for cuda
    loadModels = [ "mistral" ];
  };
  services.open-webui.enable = true;
  services.rss-bridge = {
    enable = true;
    dataDir = "/data/rss-bridge";
    subdomain = "rss-bridge";
  };
  services.tt-rss = {
    enable = true;
    root = "/data/tt-rss";
  };
}
