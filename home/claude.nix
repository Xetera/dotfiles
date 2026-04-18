let
  rules = import ./ai-rules.nix;
in
{
  enable = true;
  settings = {
    alwaysThinkingEnabled = false;
    promptSuggestionEnabled = false;
    permissions = {
      defaultMode = "acceptEdits";
      allow = [
        "Read"
        "Glob"
        "Search"
        "Bash(docker logs *)"
        "Bash(go mod init *)"
        "Bash(go get *)"
        "Bash(which *)"
        "Bash(git status)"
        "Bash(git log *)"
        "Bash(git diff *)"
        "Bash(git branch *)"
        "Bash(git show *)"
        "Bash(git blame *)"
        "Bash(git stash list)"
        "WebFetch(domain:github.com)"
        "WebFetch(domain:mozilla.org)"
        "Bash(lsof *)"
        "Bash(netstat *)"
        "Bash(ifconfig *)"
        "Bash(ping *)"
        "Bash(type *)"
        "Bash(find *)"
      ];
      deny = [
        "Read(./.env)"
        "Read(./.env.*)"
        "Read(~/.ssh/**)"
        "Bash(chmod 777 *)"
      ];
    };
  };
  context = rules.text;
}
