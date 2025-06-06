{ inputs, ... }:

{
  imports = [ inputs.core.nixosModules.normalUsers ];

  normalUsers = {
    steffen = {
      extraGroups = [ "wheel" ];
      sshKeyFiles = [
        ../../users/steffen/pubkeys/L13G2.pub
        ../../users/steffen/pubkeys/X670E.pub
        ../../users/steffen/pubkeys/handy.pub
      ];
    };
    sid = {
      extraGroups = [
        "wheel"
        "jellyfin"
      ];
      sshKeyFiles = [ ../../users/sid/pubkeys/gpg.pub ];
    };
  };
}
