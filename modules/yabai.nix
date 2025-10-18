{
  enable = true;
  enableScriptingAddition = true;
  config = {
    layout = "stack";
    top_padding = 15;
    bottom_padding = 15;
    left_padding = 15;
    right_padding = 15;
    window_gap = 15;
    auto_balance = "on";
    window_shadow = "float";
    window_opacity = "on";
    insert_feedback_color = "0xff66b4ff";
  };
  extraConfig = ''
    yabai -m rule --add app="^System Settings$" manage=off
    yabai -m rule --add app="^Finder$" manage=off
    yabai -m signal --add event=dock_did_restart action="sudo yabai --load-sa"
  '';
}
