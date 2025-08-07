{ inputs, ... }:

{
  imports = [
    inputs.core.nixosModules.vpn-server
  ];

  networking.vpn-server = {
    enable = true;
    externalInterface = "enp10s0";
    peers = {
      "sid@rv2" = {
        publicKey = "vqssHIV8GhiULFsyUdCfJ5gVPV3Mxh9069dWha/MJmo=";
        allowedIP = "10.100.0.2";
      };
    };
  };
}
