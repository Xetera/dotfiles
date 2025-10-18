{
  enable = true;
  enableZshIntegration = true;
  extraConfig = builtins.readFile ./wezterm-config.lua;
}
