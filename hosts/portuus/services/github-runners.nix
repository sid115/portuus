{ config, ... }:

let
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
  };
}
