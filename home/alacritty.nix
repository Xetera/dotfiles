{
  enable = true;
  settings = {
    window = {
      blur = true;
      opacity = 1;
      padding.x = 0;
      padding.y = 0;
      decorations = "Full";
      decorations_theme_variant = "Light"; # "Dark"
    };
    cursor.style = "Beam";
    scrolling.multiplier = 3;
    font = {
      normal.family = "JetBrainsMono Nerd Font";
      normal.style = "Regular";

      bold.family = "JetBrainsMono Nerd Font";
      bold.style = "Bold";

      italic.family = "JetBrainsMono Nerd Font";
      italic.style = "Italic";

      bold_italic.family = "JetBrainsMono Nerd Font";
      bold_italic.style = "Bold Italic";
      size = 17.0;
    };
    hints.enabled = [
      {
        command = "open"; # On macOS
        hyperlinks = true;
        post_processing = true;
        persist = false;
        mouse.enabled = true;
        binding = {
          key = "U";
          mods = "Control|Shift";
        };
        regex = "(ipfs:|ipns:|magnet:|mailto:|gemini://|gopher://|https://|http://|news:|file:|git://|ssh:|ftp://)[^\\u0000-\\u001F\\u007F-\\u009F<>\"\\\\s{-}\\\\^⟨⟩`]+";
      }
    ];
    keyboard = {
      bindings = [
        # up down history
        {
          key = "K";
          mods = "Control";
          chars = "\\u001b[A";
        }
        {
          key = "J";
          mods = "Control";
          chars = "\\u001b[B";
        }
        # up down screen
        {
          key = "K";
          mods = "Control|Command";
          action = "ScrollLineUp";
        }
        {
          key = "J";
          mods = "Control|Command";
          action = "ScrollLineDown";
        }
        # vim motions
        {
          key = "Left";
          mods = "Command";
          chars = "\\u001b[1~";
        }
        {
          key = "Left";
          mods = "Alt";
          chars = "\\u001bB";
        }
        {
          key = "Right";
          mods = "Alt";
          chars = "\\u001bF";
        }
        {
          key = "Left";
          mods = "Command";
          chars = "\\u001bOH";
        }
        {
          key = "Right";
          mods = "Command";
          chars = "\\u001bOF";
        }
        {
          key = "Back";
          mods = "Command";
          chars = "\\u0015";
        }
      ];
    };
  };
}
