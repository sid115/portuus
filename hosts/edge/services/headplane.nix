{
  inputs,
  ...
}:

{
  imports = [
    inputs.core.nixosModules.headplane
  ];

  services.headplane = {
    enable = true;
    reverseProxy = {
      enable = true;
      subdomain = "hp";
    };
  };
}
