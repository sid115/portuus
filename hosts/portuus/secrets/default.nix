{ inputs, config, ... }:

{
  imports = [ inputs.core.nixosModules.sops ];

  sops.secrets."mailserver/accounts/ig" = { };
  sops.secrets."mailserver/accounts/info" = { };
  sops.secrets."mailserver/accounts/sid" = { };
  sops.secrets."mailserver/accounts/steffen" = { };
  sops.secrets."mailserver/accounts/jfk" = { };
  sops.secrets."mailserver/accounts/lissy" = { };
  sops.secrets."mailserver/accounts/ulm" = { };

  sops.secrets."github-runners/portuus" = { };

  sops.secrets."rustdesk-server/key" = {
    owner = "rustdesk";
    group = "rustdesk";
    mode = "0440";
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
}
