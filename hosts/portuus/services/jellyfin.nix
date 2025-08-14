{ inputs, config, ... }:

{
  imports = [ inputs.core.nixosModules.jellyfin ];

  services.jellyfin = {
    enable = true;
    dataDir = "/data/jellyfin";
    cacheDir = "${config.services.jellyfin.dataDir}/cache";
    subdomain = "media";
    libraries = [
      "books/audiobooks"
      "movies"
      "music"
      "shows"
    ];
  };
}
