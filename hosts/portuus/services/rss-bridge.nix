{ inputs, config, ... }:

{
  imports = [ inputs.core.nixosModules.rss-bridge ];

  services.rss-bridge = {
    enable = true;
    dataDir = "/data/rss-bridge";
    subdomain = "rss-bridge";
  };

  # FIXME: bridge is broken
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
}
