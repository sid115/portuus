{ inputs, ... }:

{
  imports = [ inputs.toggle-web-app.nixosModules.toggle-web-app ];

  services.nginx.virtualHosts."vde.portuus.de" = {
    enableACME = true;
    forceSSL = true;
    locations."/".proxyPass = ("http://localhost:8081");
  };
}
