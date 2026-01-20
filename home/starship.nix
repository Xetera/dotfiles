{ ... }:
{
  enable = true;
  settings = {
    nix_shell = {
      format = "via [ $name](bold blue) ";
      impure_msg = "";
    };
  };
}
