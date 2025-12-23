{ config, pkgs, ... }:

let
  cfg = config.services.github-runners;
  tokenFile = config.sops.secrets."github-runners/portuus".path;
  user = "github-runner-portuus";
  home = "/var/lib/github-runner/portuus";
in
{
  services.github-runners = {
    nix-core = {
      enable = true;
      url = "https://github.com/sid115/nix-core";
      inherit tokenFile;
    };
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

      serviceOverrides = {
        BindReadOnlyPaths = [
          "${config.sops.secrets."github-runners/tailnet-deploy/deploy-key".path}:${home}/.ssh/id_ed25519"
        ];
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
      secrets."github-runners/tailnet-deploy/deploy-key" = {
        inherit owner group mode;
      };
    };
}
