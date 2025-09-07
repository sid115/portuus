{ inputs, config, ... }:

let
  domain = config.networking.domain;
in
{
  imports = [ inputs.core.nixosModules.mailserver ];

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
      "jfk@${domain}" = {
        hashedPasswordFile = config.sops.secrets."mailserver/accounts/jfk".path;
      };
      "lissy@${domain}" = {
        hashedPasswordFile = config.sops.secrets."mailserver/accounts/lissy".path;
      };
    };
  };
}
