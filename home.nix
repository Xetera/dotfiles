{
  pkgs,
  lib,
  inputs,
  ...
}:
let
  gitName = "Xetera";
in
{
  home = {
    stateVersion = "24.05";
    sessionVariables = {
      EDITOR = "nvim";
    };
    packages = with pkgs; [
      ## tooling ##
      eza
      bat
      tokei
      fd
      ripgrep
      semgrep
      dust
      fzf
      delta
      docker
      hexyl
      yt-dlp
      trippy
      stripe-cli
      # binsider -> broken?

      ## hacking ##
      # apkleaks

      ## productivity ##
      lazygit
      lazydocker
      btop
      jq
      jless
      postgresql
      numbat
      glances
      dive

      ## network ##
      wireshark # -> installed in homebrew
      nmap
      tcpreplay

      ## VA ##
      ffmpeg
      # vlc unsupported?
      audacity

      # networking
      # tailscale

      ## developer setup ##
      git
      neovim
      antidote
      pnpm
      elixir
      erlang
      zig
      # zed-editor broken for now

      # misc
      nixfmt-rfc-style
      restic
    ];
  };

  nixpkgs.config.allowUnfreePredicate =
    pkg:
    builtins.elem (lib.getName pkg) [
      "1password-cli"
    ];
  imports = [ inputs._1password-shell-plugins.hmModules.default ];

  programs = {
    zsh = {
      enable = true;
      dotDir = ".config/zsh";
      syntaxHighlighting.enable = true;
      autosuggestion.enable = true;
      shellAliases = {
        k = "kubectl";
        ls = "eza --icons always $1";
        vim = "nvim";
        lg = "lazygit";
        # https://github.com/nix-community/home-manager/issues/1088
        reloadzsh = "rm -f ~/.config/zsh/.zshrc.zwc && zcompile ~/.config/zsh/.zshrc && . ~/.config/zsh/.zshrc";
        editc = "nvim ~/.config/nix";
        update = "nixfmt ~/.config/nix/flake.nix && sudo darwin-rebuild switch --flake ~/.config/nix#tim";
        dlp = "yt-dlp --no-mtime";
        psql = "nix shell nixpkgs#postgresql --command psql";
      };
      initContent = ''
        # make sure homebrew is in path
        eval "$(/opt/homebrew/bin/brew shellenv)"
        source ${./p10k-config/.p10k.zsh}

        # needed by unixorn/fzf-zsh-plugin
        source <(fzf --zsh)

        # I don't want to use nix to manage node but I use nix to use manage .zshrc
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
        export BAT_THEME="Catpuccin Frappe"
        [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
        [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

        # flux
        . <(flux completion zsh)
        sudo yabai --load-sa

        hurl() {
          curl https://tls.lynx-toad.ts.net/api/forward -H 'x-api-key: 4jmVoWNGHGhpenWt4' "$@"
        }
        mongodb() {
          kubectl port-forward -n offload svc/mongodb 27017 27017
        }
      '';

      antidote = {
        enable = true;
        useFriendlyNames = true;
        plugins = [
          "romkatv/powerlevel10k"
          "Aloxaf/fzf-tab"
          "unixorn/fzf-zsh-plugin"
        ];
      };
    };
    lazygit = {
      enable = true;
      settings = {
        gui = {
          nerdFontsVersion = "3";
          branchColors = {
            ${lib.toLower gitName} = "#11aaff";
          };
          theme = {
            selectedLineBgColor = [
              "reverse"
            ];
          };
        };
        git = {
          overrideGpg = true;
          pagers = [
            {
              pager = "${pkgs.delta}/bin/delta --paging never --color-only $(defaults read -g AppleInterfaceStyle &>/dev/null || echo --light) --line-numbers --hyperlinks --hyperlinks-file-link-format=\"lazygit-edit://{path}:{line}\"";
            }
          ];
          log = {
            showGraph = "always";
            showWholeGraph = true;
          };
        };
      };
    };
    alacritty = {
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
    };
    git = {
      enable = true;
      signing.key = "82B477CACDA27E1E756273A09852FA374C75F6FD";
      signing.signByDefault = true;
      userEmail = "contact@xetera.dev";
      userName = gitName;
      # delta = {
      #   enable = false;
      #   options = {
      #     true-color = "always";
      #     line-numbers = true;
      #     hyperlinks = true;
      #     whitespace-error-style = "22 reverse";
      #   };
      # };
      extraConfig = {
        pull.rebase = true;
        # needed for some bigger clones
        http.postBuffer = 524288000;
        init.defaultBranch = "main";
        rebase.updateRefs = true;
        delta = {
          navigate = true;
          true-color = "always";
          line-numbers = true;
          hyperlinks = true;
          whitespace-error-style = "22 reverse";
        };
        core.pager = "${pkgs.delta}/bin/delta --color-only $(defaults read -g AppleInterfaceStyle &>/dev/null || echo --light)";
        interactive.diffFilter = "${pkgs.delta}/bin/delta --color-only $(defaults read -g AppleInterfaceStyle &>/dev/null || echo --light)";
        diff.algorithm = "histogram";
        diff.colorMoved = "default";

        merge.conflictstyle = "diff3";
      };
    };
    _1password-shell-plugins = {
      enable = true;
      plugins = with pkgs; [ gh ];
    };
  };
}
