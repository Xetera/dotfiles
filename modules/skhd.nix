{
  enable = true;
  skhdConfig = ''
    alt - j : yabai -m window --focus south
    alt - k : yabai -m window --focus north
    alt - h : yabai -m window --focus west
    alt - l : yabai -m window --focus east

    shift + alt - t : yabai -m window --toggle float

    shift + alt - h : yabai -m window --swap west
    shift + alt - k : yabai -m window --focus stack.next || yabai -m window --focus stack.first || yabai -m window --swap north
    shift + alt - j : yabai -m window --focus stack.prev || yabai -m window --focus stack.last || yabai -m window --swap south
    shift + alt - l : yabai -m window --swap east

    shift + alt - w : yabai -m window --warp recent
    shift + alt - n : yabai -m space --layout $(yabai -m query --spaces --space | jq -r 'if .type == "bsp" then "stack" else "bsp" end')

    shift + alt - left : yabai -m window --resize right:-20:0 2> /dev/null || yabai -m window --resize left:-20:0 2> /dev/null
    shift + alt - down : yabai  -m window --resize bottom:0:20 2> /dev/null || yabai -m window --resize top:0:20 2> /dev/null
    shift + alt - up : yabai -m window --resize bottom:0:-20 2> /dev/null || yabai -m window --resize top:0:-20 2> /dev/null
    shift + alt - right : yabai -m window --resize right:20:0 2> /dev/null || yabai -m window --resize left:20:0 2> /dev/null
    shift + alt - d : /Users/xetera/.config/skhd/toggle_split.sh

    shift + alt - s : yabai -m space --create && index="$(yabai -m query --displays --display | jq '.spaces[-1]')" && yabai -m window --space "$${index}" && yabai -m space --focus "$${index}"
  '';
}
