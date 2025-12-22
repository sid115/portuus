{ config, pkgs, ... }:

let
  cfg = config.services.github-runners;
  tokenFile = config.sops.secrets."github-runners/portuus".path;
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
      inherit tokenFile;
    };
    tailnet-deploy = {
      enable = true;
      url = "https://github.com/sid115/portuus";
      user = "runner-tailnet-deploy";
      group = "runner-tailnet-deploy";
      inherit tokenFile;

      extraPackages = with pkgs; [
        deploy-rs
        git
        nix
        openssh
      ];

      serviceOverrides = {
        BindReadOnlyPaths = [
          "${config.sops.secrets."github-runners/tailnet-deploy/deploy-key".path}:/root/.ssh/id_ed25519"
        ];
      };

      nix.settings.trusted-users = [ cfg.tailnet-deploy.user ];
    };

    sops =
      let
        owner = cfg.tailnet-deploy.user;
        group = cfg.tailnet-deploy.group;
        mode = "0600";
      in
      {
        secrets."github-runners/tailnet-deploy/deploy-key" = {
          inherit owner group mode;
        };
      };

  };
}
