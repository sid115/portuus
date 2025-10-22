{
  inputs = {
    # nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    # do not enter a commit newer than 7109802e4ee30b0f4aaccc0fbddf21fb44c303d3 before finding an alternative to tt-rss
    nixpkgs.url = "github:nixos/nixpkgs/434ad86be8f88924e6c36e2530b5e3f1d1b397eb"; # matrix-synapse v1.138.2
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-25.05";
    nixpkgs-old-stable.url = "github:nixos/nixpkgs/nixos-24.11";

    core.url = "github:sid115/nix-core/develop";
    core.inputs.nixpkgs.follows = "nixpkgs";

    git-hooks.url = "github:cachix/git-hooks.nix";
    git-hooks.inputs.nixpkgs.follows = "nixpkgs";

    nixos-mailserver.url = "gitlab:simple-nixos-mailserver/nixos-mailserver";
    nixos-mailserver.inputs.nixpkgs.follows = "nixpkgs";

    nix-minecraft.url = "github:Infinidoge/nix-minecraft";
    nix-minecraft.inputs.nixpkgs.follows = "nixpkgs";

    sops-nix.url = "github:Mic92/sops-nix";
    sops-nix.inputs.nixpkgs.follows = "nixpkgs";

    toggle-web-app.url = "github:sid115/toggle-web-app";

    mcp-nixos.url = "github:utensils/mcp-nixos";
    mcp-nixos.inputs.nixpkgs.follows = "nixpkgs";

    nuschtos-search.url = "github:NuschtOS/search";
    nuschtos-search.inputs.nixpkgs.follows = "nixpkgs";

    ig.url = "github:sid115/instaloader-web-frontend";
    ig.inputs.nixpkgs.follows = "nixpkgs";

    # for NuschtOS search
    # disko.url = "github:nix-community/disko";
    # nixos-hardware.url = "github:NixOS/nixos-hardware";
    # stylix.url = "github:nix-community/stylix";
    # nix-flatpak.url = "github:gmodena/nix-flatpak/?ref=v0.6.0";
  };

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      ...
    }@inputs:
    let
      inherit (self) outputs;
      supportedSystems = [
        "x86_64-linux"
      ];
      forAllSystems = nixpkgs.lib.genAttrs supportedSystems;
    in
    {
      apps = forAllSystems (
        system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
        in
        {
          default = self.apps.${system}.rebuild;
          rebuild = {
            type = "app";
            program =
              let
                pkg = pkgs.callPackage ./apps/rebuild { };
              in
              "${pkg}/bin/rebuild";
            meta.description = "Rebuild NixOS configuration for portuus.";
          };
        }
      );

      packages = forAllSystems (system: import ./pkgs nixpkgs.legacyPackages.${system});

      overlays = import ./overlays { inherit inputs; };

      nixosModules = import ./modules/nixos;

      nixosConfigurations = {
        portuus = nixpkgs.lib.nixosSystem {
          specialArgs = {
            inherit inputs outputs;
          };
          modules = [ ./hosts/portuus ];
        };
      };

      checks = forAllSystems (
        system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
          flakePkgs = self.packages.${system};
          overlaidPkgs = import nixpkgs {
            inherit system;
            overlays = [ self.overlays.modifications ];
          };
        in
        {
          pre-commit-check = inputs.git-hooks.lib.${system}.run {
            src = ./.;
            hooks = {
              # TODO: Change to nixfmt-tree when git-hooks supports it
              nixfmt-rfc-style = {
                enable = true;
                package = pkgs.nixfmt-tree;
                entry = "${pkgs.nixfmt-tree}/bin/treefmt --no-cache";
              };
            };
          };
          # build-packages = pkgs.linkFarm "flake-packages-${system}" flakePkgs;
          # build-overlays = pkgs.linkFarm "flake-overlays-${system}" { };
        }
      );
    };
}
