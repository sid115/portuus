{
  outputs,
  config,
  pkgs,
  ...
}:

let
  cfg = config.services.minecraft-servers;
in
{
  imports = [ outputs.nixosModules.minecraft-servers ];

  services.minecraft-servers = {
    servers = {
      survival = {
        enable = true;
        package = pkgs.fabricServers.fabric-1_21_1;
        jvmOpts = "-Xms4G -Xmx16G -XX:+UseG1GC";
        serverProperties = {
          gamemode = "survival";
          difficulty = "hard";
          simulation-distance = "16";
          level-seed = "5985476155519575998";
          server-port = 25565;
        };
        whitelist = {
          Angiiiii = "956a108f-1b34-411b-97ea-08ab14484d4f";
          JonShakespeare = "8578f586-dcaa-46c7-992b-77c98737b226";
          Morschlitz98 = "ec39f163-1cae-4673-8d7e-a626f706eac1";
          N3071GHT = "f4fc9eb2-8d82-49a6-8061-72c490ea5f9a";
          PureAcid = "cea52bd2-fabb-43cd-81d9-aeb0978a620b";
          Sutaneko = "6c7e30b0-48ff-492a-8224-b6aa09346e7a";
          Xerion42 = "7f7112c3-4089-4510-a94f-78955aa1c205";
        };
      };

      creative = {
        enable = false;
        package = pkgs.vanillaServers.vanilla-1_21;
        serverProperties = {
          gamemode = "creative";
          level-seed = cfg.servers.survival.serverProperties.level-seed;
          server-port = 25566;
        };
      };

      survival2 = {
        enable = true;
        package = pkgs.vanillaServers.vanilla-1_21_10;
        jvmOpts = "-Xms3G -Xmx12G -XX:+UseG1GC";
        serverProperties = {
          gamemode = "survival";
          difficulty = "hard";
          simulation-distance = "12";
          server-port = 25566;
        };
        whitelist = {
          Aaronimore97 = "77848340-8780-448a-a843-89c1ceac02c2";
          Sharpac96 = "0bd560b6-24f7-43cf-a716-97be448cadbc";
        };
      };
    };
  };
}
