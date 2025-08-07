{ inputs, ... }:

{
  imports = [ inputs.core.nixosModules.normalUsers ];

  normalUsers = {
    steffen = {
      extraGroups = [
        "wheel"
        "jellyfin"
      ];
      sshKeyFiles = [
        ../../users/steffen/pubkeys/L13G2.pub
        ../../users/steffen/pubkeys/X670E.pub
      ];
    };
    sid = {
      extraGroups = [
        "wheel"
        "jellyfin"
        "adbusers"
        "kvm"
      ];
      sshKeyFiles = [ ../../users/sid/pubkeys/gpg.pub ];
    };
  };
}
