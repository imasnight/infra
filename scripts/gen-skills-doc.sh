#!/usr/bin/env bash
set -euo pipefail

SKILL_DEFS=$(nix eval --json '.#lib.skillDefs')

# Derive table and first skill in a single jq invocation.
# Output: first line = first skill name, separated from table by "---"
jq_out=$(echo "$SKILL_DEFS" | jq -r '
  (keys | sort | first),
  "---",
  ("| Name | Source | Path |\n|------|--------|------|\n" +
    (to_entries | sort_by(.key) | map(
      "| `" + .key + "` | " + .value.from + " | `" + .value.path + "` |"
    ) | join("\n")))
')

SEPARATOR_LINE=$(echo "$jq_out" | grep -n "^---$" | cut -d: -f1)
FIRST_SKILL=$(echo "$jq_out" | head -1)
TABLE=$(echo "$jq_out" | tail -n +$((SEPARATOR_LINE + 1)))

mkdir -p docs
cat > docs/skills.md << EOF
# Skills

> Auto-generated from \`skills.nix\`. Do not edit manually.

${TABLE}

## Usage

Add \`imasnight/infra\` to your flake inputs:

\`\`\`nix
inputs.infra.url = "github:imasnight/infra";
\`\`\`

\`\`\`nix
perSystem = { system, ... }:
  let
    pkgs = import inputs.nixpkgs { inherit system; };
    skills = [
        "${FIRST_SKILL}"
        # "other-skill"
      ];
  in {
    devShells.default = pkgs.mkShell {
      shellHook = inputs.infra.lib.mkShellHooks pkgs skills;
    };
  };
\`\`\`
EOF
