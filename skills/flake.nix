{
  description = "Agent skills as a minimal flake-parts module (no dev tooling dependencies)";

  inputs = {
    agent-skills-nix.url = "github:Kyure-A/agent-skills-nix";
    claude-code-templates = {
      url = "github:davila7/claude-code-templates";
      flake = false;
    };
  };

  outputs =
    { agent-skills-nix, claude-code-templates, ... }:
    let
      agentLib = agent-skills-nix.lib.agent-skills;
    in
    {
      flakeModules.default = import ./module.nix {
        inherit agentLib claude-code-templates;
      };
    };
}
