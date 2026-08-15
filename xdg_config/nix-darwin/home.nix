{ config, pkgs, lib, unstable, ... }:
let
  home = config.home.homeDirectory;
  configHome = config.xdg.configHome;
  dotFilesDir = "${home}/dot-files";
  gh = "git@github.com:Dkendal";
  mySrc = "${home}/src/dkendal";
  ln = config.lib.file.mkOutOfStoreSymlink;
  jsonFormat = pkgs.formats.json { };
in
{
  home.stateVersion = "24.05";

  home.packages = with pkgs; [
    # just
    just
    just-formatter
    just-lsp
  ];

  home.activation.makeRepos = lib.hm.dag.entryAfter [ "installPackages" ] ''
    mkdir -p ${home}/src

    clone_repo() {
      local repo_name=$1
      local repo_path=$2
      if [ ! -d "$repo_path" ]; then
        echo "Cloning $repo_name"
        ${pkgs.git}/bin/git clone "$repo_name" "$repo_path"
      else
        echo "Skipping $repo_name: already cloned"
      fi
    }

    clone_repo "${gh}/dot-files.git" "${dotFilesDir}"
    clone_repo "${gh}/newtype.git" "${mySrc}/newtype"
    clone_repo "${gh}/nvim-treeclimber.git" "${mySrc}/nvim-treeclimber"
    clone_repo "${gh}/nvim-kitty.git" "${mySrc}/nvim-kitty"
    clone_repo "${gh}/nvim-alternate.git" "${mySrc}/nvim-alternate"
    clone_repo "${gh}/nvim-coverage.git" "${mySrc}/nvim-coverage"
  '';

  xdg.enable = true;

  xdg.configFile."fish".source = ln "${dotFilesDir}/xdg_config/fish";
  xdg.configFile."nvim".source = ln "${dotFilesDir}/xdg_config/nvim";
  xdg.configFile."jj".source = ln "${dotFilesDir}/xdg_config/jj";
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
      highlight
      polars
      query
      skim
    ];
  };

  programs.mise = {
    enable = true;
    package = unstable.mise;
    enableFishIntegration = true;
    enableBashIntegration = true;
    enableNushellIntegration = true;
    globalConfig = {
      tools = {
        node = "26.7.0";
        bun = "1.3.14";
        usage = "0.3";
        erlang = "27.3.4.2";
        elixir = "1.20.3";
        lua = "5.1";
        go = "1.26.5";
        watchexec = "2.5";
        jj = "0.44.0";
        gh = "2.97.0";
        opencode = "1.18.18";
        pi = "0.84.2";
        "github:can1357/oh-my-pi" = "17.3.4";
      };
    };
  };

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
}
