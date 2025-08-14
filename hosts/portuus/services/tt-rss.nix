{ inputs, ... }:

{
  imports = [ inputs.core.nixosModules.tt-rss ];

  services.tt-rss = {
    enable = true;
    root = "/data/tt-rss";
  };
}
