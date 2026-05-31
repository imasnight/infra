# Skills

> Auto-generated from `skills/skills.nix`. Do not edit manually.

| Name | Source | Path |
|------|--------|------|
| `commit-smart` | claude-code-templates | `skills/git/commit-smart` |
| `git-commit-helper` | claude-code-templates | `skills/development/git-commit-helper` |

## Usage

### Minimal dependencies (recommended)

Use `?dir=skills` to pull in only `agent-skills-nix` and `claude-code-templates`,
without dev tooling (`treefmt-nix`, `git-hooks-nix`, `process-compose-flake`, etc.).

```nix
inputs.infra-skills.url = "github:imasnight/infra?dir=skills";
```

```nix
outputs = inputs@{ self, flake-parts, infra-skills, ... }:
  flake-parts.lib.mkFlake { inherit inputs; } {
    imports = [ infra-skills.flakeModules.default ];

    perSystem = { pkgs, ... }: {
      devShells.default = pkgs.mkShell {
        shellHook = self.lib.mkShellHook pkgs (self.lib.mkBundleFromNames pkgs [
          "commit-smart"
          # "git-commit-helper"
        ]);
      };
    };
  };
```

### Root flake (all dependencies)

If you are already using this flake for other purposes, `lib` is directly available
as a flake output (no flake-parts import needed):

```nix
inputs.infra.url = "github:imasnight/infra";
```

```nix
perSystem = { pkgs, ... }: {
  devShells.default = pkgs.mkShell {
    shellHook = inputs.infra.lib.mkShellHook pkgs (inputs.infra.lib.mkBundleFromNames pkgs [
      "commit-smart"
      # "git-commit-helper"
    ]);
  };
};
```
