{ ... }:
{
  # Disable macOS Spotlight hotkeys so Raycast can claim Cmd-Space.
  # nix cannot set Raycast's own binding -- open Raycast once after the
  # rebuild and it will take over Cmd-Space now that Spotlight has released it.
  #
  # symbolichotkeys IDs:
  #   64 = Show Spotlight search        (Cmd-Space)
  #   65 = Show Finder search window    (Option-Cmd-Space)
  # https://daiderd.com/nix-darwin/manual/index.html#opt-system.defaults.CustomUserPreferences
  system.defaults.CustomUserPreferences = {
    "com.apple.symbolichotkeys" = {
      AppleSymbolicHotKeys = {
        "64" = {
          enabled = false;
        };
        "65" = {
          enabled = false;
        };
      };
    };
  };
}
