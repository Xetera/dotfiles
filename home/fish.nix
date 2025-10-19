{ pkgs, rootDir }:
{
  enable = true;
  preferAbbrs = true;
  shellAbbrs = {
    k = "kubectl";
    ls = "eza --icons always $1";
    vim = "nvim";
    lg = "lazygit";
    # https://github.com/nix-community/home-manager/issues/1088
    reloadzsh = "rm -f $HOME/${rootDir}/.zshrc.zwc && zcompile $HOME/${rootDir}/.zshrc && . $HOME/${rootDir}/.zshrc";
    editc = "nvim ~/.config/nix";
    ee = "nvim ~/.config/nix";
    update = "nixfmt ~/.config/nix/flake.nix && sudo darwin-rebuild switch --flake ~/.config/nix#tim";
    dlp = "yt-dlp --no-mtime";
    psql = "nix shell nixpkgs#postgresql --command psql";
  };
  shellInit = ''
    # make sure homebrew is in path
    eval "$(/opt/homebrew/bin/brew shellenv)"
    if [[ $(${pkgs.procps}/bin/ps --no-header --pid=$PPID --format=comm) != "fish" && -z ''${BASH_EXECUTION_STRING} ]]
    then
      shopt -q login_shell && LOGIN_OPTION='--login' || LOGIN_OPTION=""
      exec ${pkgs.fish}/bin/fish $LOGIN_OPTION
    fi

    # needed by unixorn/fzf-zsh-plugin
    source <(fzf --fish)

    # so this is necessary
    export PNPM_HOME="/Users/xetera/Library/pnpm"
    case ":$PATH:" in
      *":$PNPM_HOME:"*) ;;
      *) export PATH="$PNPM_HOME:$PATH" ;;
    esac
    export ANDROID_HOME="/Users/xetera/Library/Android/sdk"
    export PATH="$PATH:/Users/xetera/.ghcup/hls/2.9.0.1/bin"
    export PATH="$PATH:/Users/xetera/.cargo/bin"
    export PATH="$PATH:/Users/xetera/.local/bin"
    source /Users/xetera/.ghcup/env
    export BUN_INSTALL="$HOME/.bun"
    export PATH="$BUN_INSTALL/bin:$PATH"

    export NVM_DIR="$HOME/.nvm"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
    [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

    # flux
    . <(flux completion fish)

    hurl() {
      curl https://tls.lynx-toad.ts.net/api/forward -H 'x-api-key: 4jmVoWNGHGhpenWt4' "$@"
    }
    mongodb() {
      kubectl port-forward -n offload svc/mongodb 27017 27017
    }
  '';
}
