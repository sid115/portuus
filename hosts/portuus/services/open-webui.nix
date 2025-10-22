{
  inputs,
  pkgs,
  lib,
  ...
}:

{
  imports = [
    inputs.core.nixosModules.open-webui
    inputs.core.nixosModules.mcpo
  ];

  services.open-webui = {
    enable = true;
    package = pkgs.core.open-webui;
  };

  services.ollama = {
    # enable = true; # TODO: add gpu to portuus?
    acceleration = "rocm";
    loadModels = [
      "deepseek-r1:7b"
      "mistral:7b"
    ];
  };

  services.mcpo = {
    enable = true;
    package = pkgs.core.mcpo;
    settings = {
      mcpServers = {
        nixos = {
          command = lib.getExe inputs.mcp-nixos.packages.${pkgs.system}.mcp-nixos;
        };
        fetcher = {
          command = lib.getExe pkgs.core.fetcher-mcp;
        };
        gitingest = {
          command = lib.getExe pkgs.core.trelis-gitingest-mcp;
        };
        arxiv = {
          command = lib.getExe pkgs.core.arxiv-mcp-server;
        };
      };
    };
  };
}
