{pkgs, lib, ...}:
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
      xsv
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
      # binsider -> broken?

      ## hacking ##
      # apkleaks

      ## productivity ##
      lazygit
      lazydocker
      thefuck
      btop
      jq
      jless

      ## network ##
      wireshark # -> installed in homebrew
      nmap
      tcpreplay

      ## VA ##
      ffmpeg
      # vlc unsupported?
      audacity

      # networking
      tailscale

      ## developer setup ##
      git
      neovim
      alacritty
      antidote
      pnpm
      # zed-editor broken for now

      # misc
      nixfmt-rfc-style
      restic
    ];
  };

  programs = {
    zsh = {
      enable = true;
      syntaxHighlighting.enable = true;
      autosuggestion.enable = true;
      shellAliases = {
        ls = "eza --icons always $1";
        vim = "nvim";
        lg = "lazygit";
        # https://github.com/nix-community/home-manager/issues/1088
        reloadzsh = "rm -f ~/.zshrc.zwc && zcompile ~/.zshrc";
        editc = "nvim ~/.config/nix";
        update = "nixfmt ~/.config/nix/flake.nix && darwin-rebuild switch --flake ~/.config/nix#tim";
        dlp = "yt-dlp --no-mtime";
        psql = "nix shell nixpkgs#postgresql --command psql";
      };
      initExtra = ''
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
          showIcons = true;
          branchColors = {
            ${lib.toLower gitName} = "#11aaff";
          };
          theme = {
            selectedLineBgColor = ["green" "bold"];
          };
        };
        git.paging = {
          colorArg = "always";
          pager = "${pkgs.delta}/bin/delta --paging=never --hyperlinks --hyperlinks-file-link-format=\"lazygit-edit://{path}:{line}\"";
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
        hints.enabled = [{
          command = "open"; # On macOS
          hyperlinks = true;
          post_processing = true;
          persist = false;
          mouse.enabled = true;
          binding = { key = "U"; mods = "Control|Shift"; };
          regex = "(ipfs:|ipns:|magnet:|mailto:|gemini://|gopher://|https://|http://|news:|file:|git://|ssh:|ftp://)[^\\u0000-\\u001F\\u007F-\\u009F<>\"\\\\s{-}\\\\^⟨⟩`]+";
        }];
        keyboard = {
        bindings = [
          # up down history
          { key = "K";     mods = "Control"; chars = "\\u001b[A";  }
          { key = "J";     mods = "Control"; chars = "\\u001b[B";  }
          # up down screen
          { key = "K"; mods = "Control|Command"; action = "ScrollLineUp";}
          { key = "J"; mods = "Control|Command"; action = "ScrollLineDown"; }
          # vim motions
          { key = "Left";  mods = "Command"; chars = "\\u001b[1~" ;  }
          { key = "Left";  mods = "Alt";     chars = "\\u001bB";   }
          { key = "Right"; mods = "Alt";     chars = "\\u001bF";   }
          { key = "Left";  mods = "Command"; chars = "\\u001bOH"  ;}
          { key = "Right"; mods = "Command"; chars =  "\\u001bOF" ;}
          { key = "Back";  mods = "Command"; chars = "\\u0015"    ;}
        ];
        };
      };
    };
    git = {
      enable = true;
      delta.enable = true;
      signing.key = "82B477CACDA27E1E756273A09852FA374C75F6FD";
      signing.signByDefault = true;
      userEmail = "contact@xetera.dev";
      userName = gitName;

      extraConfig = {
        pull.rebase = true;
        # needed for some bigger clones
        http.postBuffer = 524288000;
        init.defaultBranch = "main";
        rebase.updateRefs = true;

        # pager config
        # overridden by the previous config
        # core.pager = "delta";
        # interactive.diffFilter = "delta --color-only";
        diff.algorithm = "histogram";
        diff.colorMoved = "default";

        delta.navigate = true;
        delta.line-numbers = true;
        merge.conflictstyle = "diff3";
      };
    };
  };
}
