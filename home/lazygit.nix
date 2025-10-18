{
  gitName,
  lib,
  pkgs,
}:
{
  enable = true;
  settings = {
    gui = {
      nerdFontsVersion = "3";
      branchColors = {
        ${lib.toLower gitName} = "#11aaff";
      };
      theme = {
        selectedLineBgColor = [
          "reverse"
        ];
      };
    };
    git = {
      overrideGpg = true;
      paging = {
        pager = "${pkgs.delta}/bin/delta --paging never --color-only $(defaults read -g AppleInterfaceStyle &>/dev/null || echo --light) --line-numbers --hyperlinks --hyperlinks-file-link-format=\"lazygit-edit://{path}:{line}\"";
      };
      log = {
        showGraph = "always";
        showWholeGraph = true;
      };
    };
  };
}
