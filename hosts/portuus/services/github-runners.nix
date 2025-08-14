{ config, ... }:

{
  services.github-runners = {
    nix-core = {
      enable = true;
      url = "https://github.com/sid115/nix-core";
      tokenFile = config.sops.secrets."github-runners/nix-core".path;
    };
  };
}
