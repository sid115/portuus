{
  inputs,
  config,
  pkgs,
  lib,
  ...
}:

let
  domain = config.networking.domain;
in
{
  imports = [
    inputs.core.nixosModules.firefly-iii
    inputs.core.nixosModules.gitea
    inputs.core.nixosModules.grafana
    inputs.core.nixosModules.hydra
    inputs.core.nixosModules.jellyfin
    inputs.core.nixosModules.jirafeau
    inputs.core.nixosModules.mailserver
    inputs.core.nixosModules.matrix-synapse
    inputs.core.nixosModules.mcpo
    inputs.core.nixosModules.nextcloud
    inputs.core.nixosModules.nginx
    inputs.core.nixosModules.nix-serve
    inputs.core.nixosModules.open-webui
    inputs.core.nixosModules.openssh
    inputs.core.nixosModules.peertube
    inputs.core.nixosModules.rss-bridge
    inputs.core.nixosModules.searx
    inputs.core.nixosModules.tt-rss
    inputs.core.nixosModules.vaultwarden
  ];

  mailserver = {
    enable = true;
    stateVersion = 3;
    loginAccounts = {
      "ig@${domain}" = {
        hashedPasswordFile = config.sops.secrets."mailserver/accounts/ig".path;
      };
      "info@${domain}" = {
        hashedPasswordFile = config.sops.secrets."mailserver/accounts/info".path;
        aliases = [ "postmaster@${domain}" ];
      };
      "sid@${domain}" = {
        hashedPasswordFile = config.sops.secrets."mailserver/accounts/sid".path;
        aliases = [
          "postmaster@${domain}"
          "ig@${domain}"
        ];
      };
      "steffen@${domain}" = {
        hashedPasswordFile = config.sops.secrets."mailserver/accounts/steffen".path;
        aliases = [ "postmaster@${domain}" ];
      };
    };
  };
  sops.secrets."mailserver/accounts/ig" = { };
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

  services.github-runners = {
    nix-core = {
      enable = true;
      url = "https://github.com/sid115/nix-core";
      tokenFile = config.sops.secrets."github-runners/nix-core".path;
    };
  };
  sops.secrets."github-runners/nix-core" = { };

  services.grafana = {
    enable = true;
    dataDir = "/data/grafana";
  };

  services.hydra.enable = true;

  services.jellyfin = {
    enable = true;
    dataDir = "/data/jellyfin";
    cacheDir = "${config.services.jellyfin.dataDir}/cache";
    subdomain = "media";
    libraries = [
      "books/audiobooks"
      "movies"
      "music"
      "shows"
    ];
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
  services.coturn.extraConfig = ''
    no-ipv6
  '';

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
        whiteboard
        ;
    };
    settings = {
      richdocuments = {
        wopi_url = "https://office.${domain}";
      };
    };
  };
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

  services.nix-serve.enable = true;

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
    acceleration = "rocm"; # does not work on intel
    loadModels = [
      "deepseek-r1:7b"
      "mistral:7b"
    ];
  };

  services.open-webui = {
    enable = true;
  };
  services.mcpo = {
    enable = true;
    package = pkgs.core.mcpo;
    settings = {
      mcpServers = {
        nixos = {
          command = lib.getExe inputs.mcp-nixos.packages.${pkgs.system}.mcp-nixos;
        };
        fetcher = {
          command = lib.getExe pkgs.core.fetcher-mcp;
        };
        gitingest = {
          command = lib.getExe pkgs.core.trelis-gitingest-mcp;
        };
        arxiv = {
          command = lib.getExe pkgs.core.arxiv-mcp-server;
        };
      };
    };
  };

  services.rustdesk-server =
    let
      extraArgs = [
        "--key"
        "\"$(cat ${config.sops.secrets."rustdesk-server/key".path})\""
      ];
    in
    {
      enable = true;
      openFirewall = true;
      signal = {
        enable = true;
        relayHosts = [ "portuus.de" ];
        inherit extraArgs;
      };
      relay = {
        enable = true;
        inherit extraArgs;
      };
    };
  sops.secrets."rustdesk-server/key" = {
    owner = "rustdesk";
    group = "rustdesk";
    mode = "0440";
  };

  services.rss-bridge = {
    enable = true;
    dataDir = "/data/rss-bridge";
    subdomain = "rss-bridge";
  };
  sops.templates."rss-bridge/ig" = {
    owner = config.services.rss-bridge.user;
    group = config.services.rss-bridge.group;
    mode = "0440";
    content = ''
      [InstagramBridge]
      session_id = ${config.sops.placeholder."rss-bridge/ig/session_id"}
      ds_user_id = ${config.sops.placeholder."rss-bridge/ig/ds_user_id"}
      cache_timeout = 3600
    '';
    path = "${config.services.rss-bridge.dataDir}/config.ini.php";
  };
  sops.secrets."rss-bridge/ig/session_id" = {
    owner = config.services.rss-bridge.user;
    group = config.services.rss-bridge.group;
    mode = "0440";
  };
  sops.secrets."rss-bridge/ig/ds_user_id" = {
    owner = config.services.rss-bridge.user;
    group = config.services.rss-bridge.group;
    mode = "0440";
  };

  services.searx = {
    enable = true;
    subdomain = "search";
  };

  services.tt-rss = {
    enable = true;
    root = "/data/tt-rss";
  };
}
