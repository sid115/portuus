{ inputs, ... }:

{
  imports = [ inputs.core.nixosModules.gitea ];

  services.gitea = {
    enable = true;
    reverseProxy = {
      enable = true;
      subdomain = "git";
    };
    stateDir = "/data/gitea";
  };
}
