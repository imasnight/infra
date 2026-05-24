# Skills

> Auto-generated from `skills.nix`. Do not edit manually.

| Name | Source | Path |
|------|--------|------|
| `commit-smart` | claude-code-templates | `skills/git/commit-smart` |
| `git-commit-helper` | claude-code-templates | `skills/development/git-commit-helper` |

## Usage

Add `imasnight/infra` to your flake inputs:

```nix
inputs.infra.url = "github:imasnight/infra";
```

```nix
perSystem = { system, ... }:
  let
    pkgs = import inputs.nixpkgs { inherit system; };
    skills = [
        "commit-smart"
        # "other-skill"
      ];
  in {
    devShells.default = pkgs.mkShell {
      shellHook = inputs.infra.lib.mkShellHooks pkgs skills;
    };
  };
```
