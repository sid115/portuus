{ inputs, pkgs, ... }:

{
  imports = [
    inputs.core.nixosModules.instaloader
    inputs.ig.nixosModules.ig
  ];

  services.ig = {
    enable = true;
  };

  services.instaloader = {
    # enable = true; # FIXME: rate limits
    package =
      with pkgs;
      (instaloader.overridePythonAttrs (oldAttrs: {
        propagatedBuildInputs = (oldAttrs.propagatedBuildInputs or [ ]) ++ [
          python3Packages.browser-cookie3
        ];
      }));
    login = "igportuus";
    # extraArgs = [ "--post-filter='date_utc>=datetime(2025,1,1)'" ]; # FIXME
    profiles = [
      "kalteliebelive"
      "kukocologne"
      "tham.bln"
    ];
  };
}
