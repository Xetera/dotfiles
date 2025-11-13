{ gitName, pkgs }:
{
  enable = true;
  signing.key = "82B477CACDA27E1E756273A09852FA374C75F6FD";
  signing.signByDefault = true;
  settings = {
    user = {
      name = gitName;
      email = "contact@xetera.dev";
    };
    pull.rebase = true;
    # needed for some bigger clones
    http.postBuffer = 524288000;
    init.defaultBranch = "main";
    rebase.updateRefs = true;
    delta = {
      navigate = true;
      true-color = "always";
      line-numbers = true;
      hyperlinks = true;
      whitespace-error-style = "22 reverse";
    };
    core.pager = "${pkgs.delta}/bin/delta --color-only $(defaults read -g AppleInterfaceStyle &>/dev/null || echo --light)";
    interactive.diffFilter = "${pkgs.delta}/bin/delta --color-only $(defaults read -g AppleInterfaceStyle &>/dev/null || echo --light)";
    diff.algorithm = "histogram";
    diff.colorMoved = "default";

    merge.conflictstyle = "diff3";
  };
}
