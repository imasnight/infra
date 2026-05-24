{ agentLib, claude-code-templates }:
let
  sources = {
    claude-code-templates = {
      path = claude-code-templates;
      subdir = "cli-tool/components";
    };
  };

  skillDefs = {
    git-commit-helper = {
      from = "claude-code-templates";
      path = "skills/development/git-commit-helper";
    };
    commit-smart = {
      from = "claude-code-templates";
      path = "skills/git/commit-smart";
    };
  };

  mkSelection =
    skillAttrs:
    agentLib.selectSkills {
      catalog = { };
      allowlist = [ ];
      inherit sources;
      skills = skillAttrs;
    };

  selection = mkSelection skillDefs;

  selections = builtins.mapAttrs (name: def: mkSelection { ${name} = def; }) skillDefs;

  localTarget = {
    claude = agentLib.defaultLocalTargets.claude // { enable = true; };
    opencode = agentLib.defaultLocalTargets.opencode // { enable = true; };
  };
in
{
  inherit selection selections localTarget skillDefs mkSelection;
}
