{ config, pkgs, lib, ... }:
let
  inherit (pkgs.stdenv.hostPlatform) isDarwin;
  home = config.home.homeDirectory;
  dotFilesDir = "${home}/dot-files";
  gh = "git@github.com:Dkendal";
  mySrc = "${home}/src/dkendal";
  ln = config.lib.file.mkOutOfStoreSymlink;
  identityAgent =
    if isDarwin then
      "~/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock"
    else
      "~/.1password/agent.sock";
  jsonFormat = pkgs.formats.json { };
in
{
  imports = [ ./modules/tree-sitter-parsers.nix ];

  home.stateVersion = "24.05";

  home.packages = with pkgs; [
    nushellPlugins.formats
    nushellPlugins.polars
    nushellPlugins.query
    nushellPlugins.skim
    just
    just-formatter
    just-lsp
  ];

  home.activation.makeRepos =
    let
      repos = {
        "dot-files" = dotFilesDir;
        "newtype" = "${mySrc}/newtype";
        "nvim-treeclimber" = "${mySrc}/nvim-treeclimber";
        "nvim-kitty" = "${mySrc}/nvim-kitty";
        "nvim-alternate" = "${mySrc}/nvim-alternate";
        "nvim-coverage" = "${mySrc}/nvim-coverage";
      };
      cloneRepo = name: path: ''
        if [ ! -d "${path}" ]; then
          echo "Cloning ${name}"
          $DRY_RUN_CMD ${pkgs.git}/bin/git clone $VERBOSE_ARG "${gh}/${name}.git" "${path}"
        fi
      '';
    in
    lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      $DRY_RUN_CMD mkdir -p "${mySrc}"
      ${lib.concatStringsSep "\n" (lib.mapAttrsToList cloneRepo repos)}
    '';

  xdg.enable = true;

  xdg.configFile."fish".source = ln "${dotFilesDir}/xdg_config/fish";
  xdg.configFile."nvim".source = ln "${dotFilesDir}/xdg_config/nvim";
  xdg.configFile."jj/config.toml".source = ln "${dotFilesDir}/xdg_config/jj";
  xdg.configFile."nix-darwin".source = ln "${dotFilesDir}/xdg_config/nix-darwin";
  xdg.configFile."kitty".source = ln "${dotFilesDir}/xdg_config/kitty";
  xdg.configFile."git".source = ln "${dotFilesDir}/xdg_config/git";

  home.file."Library/Application Support/nushell".source = ln "${dotFilesDir}/xdg_config/nushell";

  home.file.".pi/agent/models.json".source = 
    jsonFormat.generate "pi-models.json" {
      default = "claude-opus-5";
    };

  home.file.".claude/output-styles/eli5.md".source =
    pkgs.writeText "claude-output-styles-eli5.md" ''
      ---
      name: ELI5
      description: keep it simple pls
      keep-coding-instructions: true
      ---

      It's been a long day and my brain is fried, talk to me like I'm 5.

      Small words, short sentences, short paragraphs. If you have to use
      a big word, explain it right after. Only return what's actually necessary.

      Just tell me what you did, did it work, what do I do now.

      If I have to decide something: 2 options max, the context I need to pick fast,
      and which one you'd go with.

      Keep paths and commands exact. I have no brain cells left for the rest.
      '';

  home.file.".claude/output-styles/ste.md".source =
    pkgs.writeText "claude-output-styles-ste.md" ''
      ---
      name: ASD-STE100
      description: Simplified Technical English
      keep-coding-instructions: true
      ---

      Write all English in ASD-STE100 Simplified Technical English. STE is a controlled
      language. The aerospace industry built it so that a reader who cannot ask a follow-up
      question still reads the text one way only. Its rules are countable, so check your
      prose against them as you write it.

      ## Precedence

      These rules set the default shape of the English you write. Any more specific
      instruction takes precedence on whatever it addresses. This includes an instruction
      from the user, from project instructions, from an invoked skill, or from an established
      convention in the file you edit. Where the more specific instruction is silent, these
      rules apply.

      Follow the more specific instruction without comment. Do not cite this style as a
      reason to override it. Do not ask permission.

      This exception applies to an explicit instruction only. Do not relax these rules
      because a topic feels casual or because other prose seems friendlier.

      ## Never apply these rules to

      - Code. This includes identifiers, syntax, and string literals.
      - Quoted material. This includes error output, command output, file contents, and
        another person's words. To rewrite a quotation is falsification, not simplification.
      - Text where the exact wording carries the meaning. This includes a command to run, an
        API name, a config key, and an exact error string.

      ## Rules

      | Rule | Limit |
      | --- | --- |
      | Noun clusters | Maximum 3 words stacked as a modifier. Break a longer stack apart and name the relationship. |
      | Sentence length | Maximum 20 words for an instruction or a procedure. Maximum 25 words for descriptive text. |
      | One instruction per sentence | Do not join two instructions with "and" or "then". |
      | Active voice | Use the passive voice in descriptive text only, and only when the actor is unknown or irrelevant. |
      | Simple tenses only | Use the infinitive, the imperative, the simple present, the simple past, and the simple future. Use a past participle as an adjective only. Do not use the present perfect, the past perfect, or a compound auxiliary. |
      | No `-ing` verb forms | Use an `-ing` word as a technical noun, or as part of one, only. |
      | No hedge stacking | Do not chain modal verbs, as in "may have been caused by". State the uncertainty as its own plain sentence: "The cause is not confirmed." |
      | One word, one meaning | Use one term for one concept and repeat it. Do not rotate synonyms for the same idea. |
      | Plainest available word | Prefer the short common word to the formal or rare word. |
      | Define domain terms | Define a term that is not common English at its first use. Do not carry undefined shorthand forward. |
      | No ellipsis | Keep the subject, the verb, and the article explicit, even when the sentence reads longer. |
      | Paragraphs | One topic. Maximum 6 sentences. |
      | Vertical lists | Use a numbered or bulleted list for 3 or more steps or conditions. |

      ## Project vocabulary

      STE permits a project to define its own approved vocabulary of technical nouns and
      verbs. A `CONTEXT.md` file at a repository root is that vocabulary.

      If the project has a `CONTEXT.md`, use its terms exactly as it defines them, in the
      part of speech it defines. Never substitute a synonym for a term it defines. Never use
      a word that its `_Avoid_` lines reject. Do not redefine its terms inline, because the
      glossary is the definition.

      If the project has no `CONTEXT.md`, do not invent one. Do not present any term as
      already established. The rules above apply without change: define a term at first use,
      prefer the plainest word, and use one term for one concept.

      ## Length is not terseness

      The caps apply to each sentence, not to the response. Clarity is the goal, not
      concision. A long answer in short sentences is correct.

      Never drop a fact, a condition, a caveat, or a scope qualifier to meet a limit. Split
      the sentence instead.
      '';


  programs.treesitter-parsers = {
    enable = true;
    parsers = {
      luadoc = {
        url = "https://github.com/tree-sitter-grammars/tree-sitter-luadoc";
        ref = "873612aadd3f684dd4e631bdf42ea8990c57634e";
        hash = "sha256-ttGBB9sn+xd9jWzjNAzpo/lwYVYZGSUGEip4K3PfBP0=";
      };
      csv = {
        url = "https://github.com/tree-sitter-grammars/tree-sitter-csv";
        ref = "f6bf6e35eb0b95fbadea4bb39cb9709507fcb181";
        hash = "sha256-9mW0kT4av/ULFqLXdMuyLrMPtQxrIOKY60GQ4QDB33o=";
        location = "csv";
      };
      vim = {
        url = "https://github.com/tree-sitter-grammars/tree-sitter-vim";
        ref = "3092fcd99eb87bbd0fc434aa03650ba58bd5b43b";
        hash = "sha256-MnLBFuJCJbetcS07fG5fkCwHtf/EcNP+Syf0Gn0K39c=";
      };
      query = {
        url = "https://github.com/tree-sitter-grammars/tree-sitter-query";
        ref = "15e00db655cf1708cf8e4b172b2f321d9b7b98c1";
        hash = "sha256-gZangrC4Nn6JLz9kY7WXYRiKtRowtlvUD6+pDP8HTzM=";
      };
      diff = {
        url = "https://github.com/tree-sitter-grammars/tree-sitter-diff";
        ref = "2520c3f934b3179bb540d23e0ef45f75304b5fed";
        hash = "sha256-8rYLNGgoZSvvfqO2++nAgFKmvbkKJ3m+9B8bTXp6Us4=";
      };
      haskell = {
        url = "https://github.com/tree-sitter-grammars/tree-sitter-haskell";
        ref = "98aedbd2d6947a168ba3ba3755d70b0cb6b78395";
        hash = "sha256-eunizglx3nye3LZIAndBX/hf0BvFOWmThQwxvvjqcfU=";
      };
      markdown = {
        url = "https://github.com/tree-sitter-grammars/tree-sitter-markdown";
        ref = "c3570720f7f7bbad22fe96603f106276618e0cf5";
        hash = "sha256-wQKcqU0V6gHj84qOkUwdXsBW3f6MNfJMFxuGTucAgh8=";
        location = "tree-sitter-markdown";
      };
      markdown-inline = {
        url = "https://github.com/tree-sitter-grammars/tree-sitter-markdown";
        ref = "c3570720f7f7bbad22fe96603f106276618e0cf5";
        hash = "sha256-wQKcqU0V6gHj84qOkUwdXsBW3f6MNfJMFxuGTucAgh8=";
        location = "tree-sitter-markdown-inline";
        language = "markdown_inline";
      };
      typescript = {
        url = "https://github.com/tree-sitter/tree-sitter-typescript";
        ref = "75b3874edb2dc714fb1fd77a32013d0f8699989f";
        hash = "sha256-A0M6IBoY87ekSV4DfGHDU5zzFWdLjGqSyVr6VENgA+s=";
        location = "typescript";
      };
      tsx = {
        url = "https://github.com/tree-sitter/tree-sitter-typescript";
        ref = "75b3874edb2dc714fb1fd77a32013d0f8699989f";
        hash = "sha256-A0M6IBoY87ekSV4DfGHDU5zzFWdLjGqSyVr6VENgA+s=";
        location = "tsx";
      };
      lua = {
        url = "https://github.com/tree-sitter-grammars/tree-sitter-lua";
        ref = "10fe0054734eec83049514ea2e718b2a56acd0c9";
        hash = "sha256-VzaaN5pj7jMAb/u1fyyH6XmLI+yJpsTlkwpLReTlFNY=";
      };
      rust = {
        url = "https://github.com/tree-sitter/tree-sitter-rust";
        ref = "77a3747266f4d621d0757825e6b11edcbf991ca5";
        hash = "sha256-Ls6tB6IxXDQDWwx0BJ7RgbheelC4MH8z97E7wwhkDcY=";
      };
      toml = {
        url = "https://github.com/tree-sitter/tree-sitter-toml";
        ref = "64b56832c2cffe41758f28e05c756a3a98d16f41";
        hash = "sha256-m9RlGkHiOL/PNENrdEPqtPlahSqGymsx7gZrCoN/Lsk=";
      };
      c_sharp = {
        url = "https://github.com/tree-sitter/tree-sitter-c-sharp";
        ref = "af29416d729b7a6603101b513604392d8f675e3b";
        hash = "sha256-3iTkgG4eitny4VHI+IwJaVvkVKN/PzotYXFCWbJ4TPU=";
      };
    };
  };

  programs.bat.enable = true;

  programs.direnv = {
    enable = true;
    enableNushellIntegration = true;
    enableFishIntegration = true;
    enableBashIntegration = true;
  };

  programs.gh = {
    enable = true;
    settings = {
      editor = "${pkgs.neovim}/bin/nvim";
      git_protocol = "ssh";
    };
  };

  programs.fzf.enable = true;

  programs.nushell = {
    enable = true;
    package = pkgs.nushell;
    settings = {
      buffer_editor = "nvim";
      edit_mode = "vi";
      use_kitty_protocol = true;
      highlight_resolved_externals = true;
      show_banner = false;
    };
    plugins = with pkgs.nushellPlugins; [
      formats
      # highlight disabled: incompatible nushell version (0.110.0 vs 0.113.1)
      # highlight
      polars
      query
      skim
    ];
  };

  programs.mise = (import ./home/programs/mise.nix);

  programs.starship =
    {
      enable = true;
      settings = {
        git_status = {
          disabled = true;
        };
        elixir = {
          disabled = true;
        };
        nodejs = {
          disabled = true;
        };
        python = {
          disabled = true;
        };
        custom = {
          jj = {
            command = "prompt";
            format = "$output";
            ignore_timeout = true;
            shell = [ "starship-jj" "--ignore-working-copy" "starship" ];
            use_stdin = false;
            when = true;
          };
        };
      };
    };

  programs.broot = {
    enable = true;
    enableNushellIntegration = true;
    enableFishIntegration = true;
    enableBashIntegration = true;
  };

  programs.nix-index.enable = true;

  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
    # matchBlocks."*".identityAgent = ''"${identityAgent}"'';
    settings."*".identityAgent = ''"${identityAgent}"'';
  };
}
