{
  inputs,
  ...
}:

let
  vHosts =
    let
      domain = "portuus.de";
      portuus = "100.64.0.x";
    in
    [
      {
        fqdn = "ai." + domain;
        host = portuus;
        port = "8083";
      }
    ];

  mkVHost = host: port: {
    enableACME = true;
    forceSSL = true;
    locations."/" = {
      proxyPass = "http://${host}:${port}";
    };
  };

  mkVHosts =
    vHosts:
    builtins.listToAttrs (
      map (vHost: {
        name = vHost.fqdn;
        value = mkVHost vHost.host vHost.port;
      }) vHosts
    );
in
{
  imports = [
    inputs.core.nixosModules.nginx
  ];

  services.nginx = {
    enable = true;
    virtualHosts = mkVHosts vHosts;
  };
}
