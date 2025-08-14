{
  inputs,
  pkgs,
  lib,
  ...
}:

{
  services.nginx.virtualHosts."search.nixos.portuus.de" = {
    forceSSL = true;
    enableACME = true;
    locations."/".root = inputs.nuschtos-search.packages.${pkgs.stdenv.system}.mkMultiSearch {
      scopes = [
        # disko
        {
          modules = [ inputs.disko.nixosModules.default ];
          name = "disko";
          specialArgs.modulesPath = inputs.nixpkgs + "/nixos/modules";
          urlPrefix = "https://github.com/nix-community/disko/blob/master/";
        }
        # home-manager
        {
          optionsJSON =
            inputs.home-manager.packages.${pkgs.system}.docs-json + /share/doc/home-manager/options.json;
          optionsPrefix = "home-manager.users.<name>";
          name = "Home Manager";
          urlPrefix = "https://github.com/nix-community/home-manager/tree/master/";
        }
        # microvm.nix
        # {
        #   modules = [
        #     inputs.microvm.nixosModules.host
        #     inputs.microvm.nixosModules.microvm
        #     { _module.args = { inherit pkgs; }; }
        #   ];
        #   name = "MicroVM.nix";
        #   urlPrefix = "https://github.com/astro/microvm.nix/blob/main/";
        # }
        # nix-darwin
        # {
        #   optionsJSON = inputs.nix-darwin.packages.${pkgs.system}.optionsJSON + /share/doc/darwin/options.json;
        #   name = "nix-darwin";
        #   urlPrefix = "https://github.com/LnL7/nix-darwin/tree/master/";
        # }
        # NixOS
        {
          optionsJSON =
            (import "${inputs.nixpkgs}/nixos/release.nix" { }).options + /share/doc/nixos/options.json;
          name = "NixOS";
          urlPrefix = "https://github.com/NixOS/nixpkgs/tree/master/";
        }
        # nixos-hardware
        {
          modules =
            [
              {
                _module.args = { inherit pkgs; };

                hardware.rockchip.platformFirmware = pkgs.hello; # fake that the package is missing on stable
              }
            ]
            ++ lib.filter (x: (builtins.tryEval (x)).success) (
              lib.attrValues inputs.nixos-hardware.nixosModules
            );
          name = "nixos-hardware";
          specialArgs.modulesPath = pkgs.path + "/nixos/modules";
          urlPrefix = "https://github.com/NixOS/nixos-hardware/blob/master/";
        }
        # nixvim
        {
          optionsJSON = inputs.nixvim.packages.${pkgs.system}.options-json + /share/doc/nixos/options.json;
          optionsPrefix = "programs.nixvim";
          name = "NixVim";
          urlPrefix = "https://github.com/nix-community/nixvim/tree/main/";
        }
        # simple-nixos-mailserver
        {
          modules = [
            inputs.nixos-mailserver.nixosModules.default
            # based on https://gitlab.com/simple-nixos-mailserver/nixos-mailserver/-/blob/290a995de5c3d3f08468fa548f0d55ab2efc7b6b/flake.nix#L61-73
            {
              mailserver = {
                fqdn = "mx.example.com";
                domains = [ "example.com" ];
                dmarcReporting = {
                  organizationName = "Example Corp";
                  domain = "example.com";
                };
              };
            }
          ];
          name = "simple-nixos-mailserver";
          urlPrefix = "https://gitlab.com/simple-nixos-mailserver/nixos-mailserver/-/blob/master/";
        }
        # sops-nix
        {
          modules = [ inputs.sops-nix.nixosModules.default ];
          name = "sops-nix";
          urlPrefix = "https://github.com/Mic92/sops-nix/blob/master/";
        }
        # stylix # FIXME
        # {
        #   modules = [ inputs.stylix.nixosModules.stylix ];
        #   name = "stylix";
        #   urlPrefix = "https://github.com/nix-community/stylix/blob/master/";
        # }
        # nix-flatpak
        {
          modules = [ inputs.nix-flatpak.nixosModules.nix-flatpak ];
          name = "nix-flatpak";
          urlPrefix = "https://github.com/gmodena/nix-flatpak/blob/main/";
        }
        # nix-core
        {
          modules = [
            {
              _module.args = { inherit pkgs; };
            }
            # ] ++ lib.filter (x: (builtins.tryEval (x)).success) (lib.attrValues inputs.core.nixosModules);
          ] ++ [ inputs.core.nixosModules.krdpserver ];
          name = "nix-core";
          urlPrefix = "https://github.com/sid115/nix-core/blob/main/";
        }
      ];
    };
  };
}
