{ inputs, ... }:

{
  imports = [ inputs.core.nixosModules.gitea ];

  services.gitea = {
    enable = true;
    reverseProxy.enable = true;
    stateDir = "/data/gitea";
  };
}
