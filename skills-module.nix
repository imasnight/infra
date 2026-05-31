{ inputs, ... }@moduleArgs:
let
  subModule = import ./skills/module.nix {
    agentLib = inputs.agent-skills-nix.lib.agent-skills;
    claude-code-templates = inputs.claude-code-templates;
  };
in
subModule moduleArgs
