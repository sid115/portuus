{ inputs, ... }:

{
  imports = [ inputs.core.nixosModules.normalUsers ];

  normalUsers = {
    steffen = {
      name = "steffen";
      extraGroups = [ "wheel" ];
      sshKeyFiles = [
        ../../users/steffen/pubkeys/L13G2.pub
        ../../users/steffen/pubkeys/X670E.pub
        ../../users/steffen/pubkeys/handy.pub
      ];
    };
    sid = {
      name = "sid";
      extraGroups = [ "wheel" ];
      sshKeyFiles = [ ../../users/sid/pubkeys/gpg.pub ];
    };
  };
}
