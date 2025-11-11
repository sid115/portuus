{ inputs, config, ... }:

let
  acl = "headscale/acl.hujson";
in
{
  imports = [ inputs.core.nixosModules.headscale ];

  environment.etc.${acl} = {
    inherit (config.services.headscale) user group;
    text = "{}"; # https://headscale.net/stable/ref/acls/#simple-examples
  };

  services.headscale = {
    enable = true;
    openFirewall = true;
    settings.policy.path = "/etc/${acl}";
  };
}
