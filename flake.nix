{
  description = "A basic flake to with flake-parts";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixpkgs-unstable";
    treefmt-nix.url = "github:numtide/treefmt-nix";
    flake-parts.url = "github:hercules-ci/flake-parts";
    systems.url = "github:nix-systems/default";
    git-hooks-nix.url = "github:cachix/git-hooks.nix";
    process-compose-flake.url = "github:Platonic-Systems/process-compose-flake";
    services-flake.url = "github:juspay/services-flake";
    agent-skills-nix.url = "github:Kyure-A/agent-skills-nix";
    claude-code-templates = {
      url = "github:davila7/claude-code-templates";
      flake = false;
    };
  };

  outputs =
    inputs@{
      self,
      systems,
      nixpkgs,
      flake-parts,
      ...
    }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      imports = [
        ./skills-module.nix
        inputs.treefmt-nix.flakeModule
        inputs.git-hooks-nix.flakeModule
        inputs.process-compose-flake.flakeModule
      ];
      systems = import inputs.systems;

      perSystem =
        {
          config,
          system,
          skillBundles,
          ...
        }:
        let
          pkgs = import nixpkgs {
            inherit system;
            config.allowUnfree = true;
          };
        in
        {
          _module.args.pkgs = pkgs;
          # When execute `nix fmt`, formatting your code.

          treefmt = {
            projectRootFile = "flake.nix";
            programs = {
              nixfmt.enable = true;
              terraform.enable = true;
            };

            settings.formatter = { };
          };

          pre-commit = {
            check.enable = true;
            settings = {
              hooks = {
                treefmt.enable = true;
                ripsecrets.enable = true;
                gitleaks = {
                  enable = true;
                  entry = "${pkgs.gitleaks}/bin/gitleaks protect --staged";
                  language = "system";
                };
              };
            };
          };

          # To start the service, please run: nix run .#default-service
          process-compose."default-service" = {
            imports = [
              inputs.services-flake.processComposeModules.default
            ];
          };

          packages = skillBundles;

          devShells.default = pkgs.mkShell {
            inputsFrom = [
              config.process-compose."default-service".services.outputs.devShell
            ];

            packages = with pkgs; [
              nixd
              terraform
              tflint
              gh
            ];

            shellHook =
              ''
                export GITHUB_TOKEN=$(gh auth token 2>/dev/null || echo "")
              ''
              + self.lib.mkShellHook pkgs (self.lib.mkBundleFromNames pkgs [
                "commit-smart"
                "git-commit-helper"
              ]);
          };
        };
    };
}
