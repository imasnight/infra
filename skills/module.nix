# flake-parts module that is self-contained (no dependency on root flake's `inputs`).
# Called with { agentLib, claude-code-templates } so it can be used from both
# the subflake (skills/flake.nix) and the root flake.
{
  agentLib,
  claude-code-templates,
}:
let
  skills = import ./skills.nix {
    inherit agentLib claude-code-templates;
  };
in
{ ... }:
{
  perSystem =
    { pkgs, ... }:
    {
      _module.args.skillBundles = builtins.mapAttrs (
        name: _:
        agentLib.mkBundle {
          inherit pkgs;
          selection = skills.selections.${name};
          name = name;
        }
      ) skills.skillDefs;
    };

  flake.lib = {
    inherit (skills) selection selections localTarget skillDefs;

    mkSkillBundle =
      pkgs: skillName:
      agentLib.mkBundle {
        inherit pkgs;
        selection = skills.selections.${skillName};
        name = skillName;
      };

    mkBundleFromNames =
      pkgs: names:
      let
        filteredDefs = builtins.intersectAttrs
          (builtins.listToAttrs (map (n: { name = n; value = null; }) names))
          skills.skillDefs;
      in
      agentLib.mkBundle {
        inherit pkgs;
        selection = skills.mkSelection filteredDefs;
        name = builtins.concatStringsSep "-" (builtins.sort builtins.lessThan names);
      };

    mkShellHook =
      pkgs: bundle:
      agentLib.mkShellHook {
        inherit pkgs bundle;
        targets = skills.localTarget;
      };

    mkShellHooks =
      pkgs: skillNames:
      builtins.concatStringsSep "" (
        map (
          name:
          agentLib.mkShellHook {
            inherit pkgs;
            bundle = agentLib.mkBundle {
              inherit pkgs;
              selection = skills.selections.${name};
              name = name;
            };
            targets = skills.localTarget;
          }
        ) skillNames
      );
  };
}
