{ inputs, config, ... }:

{
  imports = [ inputs.core.nixosModules.jellyfin ];

  services.jellyfin = {
    enable = true;
    reverseProxy = {
      enable = true;
      subdomain = "media";
    };
    dataDir = "/data/jellyfin";
    cacheDir = "${config.services.jellyfin.dataDir}/cache";
    libraries = [
      "books/audiobooks"
      "movies"
      "music"
      "shows"
    ];
  };
}
