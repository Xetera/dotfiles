let rules = import ./ai-rules.nix;
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
        "Bash(git log:*)"
        "Bash(docker logs:*)"
        "Bash(go mod init:*)"
        "Bash(go get:*)"
        "Bash(which:*)"
        "WebFetch(domain:github.com)"
      ];
      deny = [
        "Bash(curl:*)"
        "Bash(git:*)"
        "Bash(rm:*)"
        "Read(./.env)"
        "Read(./.env.*)"
      ];
    };
  };
  memory = {
    text = rules.text;
  };
}
