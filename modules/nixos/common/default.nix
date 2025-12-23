{ lib, ... }:

{
  imports = [
    ./overlays.nix
  ];

  users.users.root.openssh.authorizedKeys.keyFiles = [
    ./deploy_key.pub
  ];

  nix.settings.trusted-users = [ "root" ];

  services.openssh.settings.PermitRootLogin = lib.mkForce "yes";
}
