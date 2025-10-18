{
  enable = true;
  skhdConfig = ''
    # movement
    alt - j : yabai -m window --focus south
    alt - k : yabai -m window --focus north
    alt - h : yabai -m window --focus west
    alt - l : yabai -m window --focus east

    # float toggles
    shift + alt - t : yabai -m window --toggle float

    # swap windows OR cycle between them if in stack mode
    shift + alt - h : yabai -m window --swap west
    shift + alt - k : yabai -m window --focus stack.next || yabai -m window --focus stack.first || yabai -m window --swap north
    shift + alt - j : yabai -m window --focus stack.prev || yabai -m window --focus stack.last || yabai -m window --swap south
    shift + alt - l : yabai -m window --swap east

    # bring last selected window
    shift + alt - w : yabai -m window --warp recent

    # toggle stack vs bsp
    shift + alt - n : yabai -m space --layout $(yabai -m query --spaces --space | jq -r 'if .type == "bsp" then "stack" else "bsp" end')

    # resize
    shift + alt - left : yabai -m window --resize right:-20:0 2> /dev/null || yabai -m window --resize left:-20:0 2> /dev/null
    shift + alt - down : yabai  -m window --resize bottom:0:20 2> /dev/null || yabai -m window --resize top:0:20 2> /dev/null
    shift + alt - up : yabai -m window --resize bottom:0:-20 2> /dev/null || yabai -m window --resize top:0:-20 2> /dev/null
    shift + alt - right : yabai -m window --resize right:20:0 2> /dev/null || yabai -m window --resize left:20:0 2> /dev/null

    # 1/3 - 2/3 alternating splits
    shift + alt - d : /Users/xetera/.config/skhd/toggle_split.sh

    # move window to a new space
    shift + alt - s : yabai -m space --create && index="$(yabai -m query --displays --display | jq '.spaces[-1]')" && yabai -m window --space "''${index}" && yabai -m space --focus "''${index}"
  '';
}
