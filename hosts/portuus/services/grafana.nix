{ inputs, ... }:

{
  imports = [ inputs.core.nixosModules.grafana ];

  services.grafana = {
    enable = true;
    dataDir = "/data/grafana";
  };
}
