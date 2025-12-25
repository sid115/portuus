{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";
    nixpkgs-old-stable.url = "github:nixos/nixpkgs/nixos-25.05";

    core.url = "github:sid115/nix-core/release-25.11";
    core.inputs.nixpkgs.follows = "nixpkgs";

    deploy-rs.url = "github:serokell/deploy-rs";
    deploy-rs.inputs.nixpkgs.follows = "nixpkgs";

    git-hooks.url = "github:cachix/git-hooks.nix";
    git-hooks.inputs.nixpkgs.follows = "nixpkgs";

    nixos-mailserver.url = "gitlab:simple-nixos-mailserver/nixos-mailserver/nixos-25.11";
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
  };

  outputs =
    {
      self,
      nixpkgs,
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

      deploy = {
        nodes = {
          portuus = {
            hostname = "portuus.de";
            sshUser = "root";
            sshOpts = [
              "-p"
              "2299"
              "-o"
              "StrictHostKeyChecking=no"
              "-o"
              "UserKnownHostsFile=/dev/null"
            ];
            user = "root";
            autoRollback = true;
            magicRollback = true;
            profiles.system = {
              user = "root";
              path = inputs.deploy-rs.lib.x86_64-linux.activate.nixos self.nixosConfigurations.portuus;
            };
          };
        };
      };

      formatter = forAllSystems (
        system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
          config = self.checks.${system}.pre-commit-check.config;
          inherit (config) package configFile;
          script = ''
            ${pkgs.lib.getExe package} run --all-files --config ${configFile}
          '';
        in
        pkgs.writeShellScriptBin "pre-commit-run" script
      );

      checks = forAllSystems (
        system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
          flakePkgs = self.packages.${system};
          overlaidPkgs = import nixpkgs {
            inherit system;
            overlays = [ self.overlays.modifications ];
          };
          deployChecks = inputs.deploy-rs.lib.${system}.deployChecks self.deploy;
        in
        deployChecks
        // {
          pre-commit-check = inputs.git-hooks.lib.${system}.run {
            src = ./.;
            hooks = {
              nixfmt.enable = true;
            };
          };
          build-packages = pkgs.linkFarm "flake-packages-${system}" flakePkgs;
          build-overlays = pkgs.linkFarm "flake-overlays-${system}" {
            # package = overlaidPkgs.package;
          };
        }
      );
    };
}
