{ inputs, ... }:

{
  imports = [ inputs.core.nixosModules.matrix-synapse ];

  services.matrix-synapse = {
    enable = true;
    dataDir = "/data/matrix-synapse";
  };

  services.coturn.extraConfig = ''
    no-ipv6
  '';
}
