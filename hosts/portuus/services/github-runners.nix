{ config, pkgs, ... }:

let
  tokenFile = config.sops.secrets."github-runners/portuus/token".path;
  deployKeyFile = config.sops.secrets."github-runners/portuus/deploy-key".path;
  user = "github-runner-portuus";
  home = "/var/lib/github-runner/portuus";
in
{
  services.github-runners = {
    portuus = {
      enable = true;
      url = "https://github.com/sid115/portuus";
      user = user;
      group = user;
      inherit tokenFile;

      extraPackages = with pkgs; [
        deploy-rs
        git
        nix
        openssh
      ];

      extraEnvironment = {
        DEPLOY_KEY_PATH = deployKeyFile;
      };
    };
  };

  users.groups.${user} = { };

  users.users.${user} = {
    isSystemUser = true;
    group = user;
    description = "Github Runner for Portuus";
    home = home;
    createHome = true;
  };

  nix.settings.trusted-users = [ user ];

  sops =
    let
      owner = user;
      group = user;
      mode = "0600";
    in
    {
      secrets."github-runners/portuus/token" = {
        inherit owner group mode;
      };
      secrets."github-runners/portuus/deploy-key" = {
        inherit owner group mode;
      };
    };
}
