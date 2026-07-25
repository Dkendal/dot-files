# Home Manager module that builds tree-sitter parsers from source as pure Nix
# derivations and installs the compiled `.so` files where Neovim can find them.
#
# Layout under the user's home directory:
#   ~/.local/share/treesitter-parsers/downloads/<name>   <- fetched grammar source
#   ~/.local/share/treesitter-parsers/parser/<lang>.so  <- compiled parser
#
# Add `~/.local/share/treesitter-parsers/` to Neovim's runtimepath to load them. Note
# that Neovim auto-discovers parsers in a `parser/` directory on the rtp; this
# module installs to `parser/` per the requested layout, so either symlink/load
# them explicitly (vim.treesitter.language.add) or adjust the path below.
{ config, pkgs, lib, ... }:
let
  cfg = config.programs.treesitter-parsers;

  baseDir = ".local/share/treesitter-parsers";

  # Build a single parser into a derivation containing `<lang>.so`.
  buildParser = name: parser:
    let
      lang = if parser.language != null then parser.language else name;
    in
    pkgs.stdenv.mkDerivation {
      pname = "treesitter-parser-${name}";
      version = parser.ref;

      src = pkgs.fetchgit {
        inherit (parser) url;
        rev = parser.ref;
        hash = parser.hash;
        fetchSubmodules = parser.fetchSubmodules;
      };

      nativeBuildInputs = [ pkgs.tree-sitter ] ++ lib.optional parser.generate pkgs.nodejs;

      # Compile parser.c (+ optional scanner) into a shared object named after
      # the language. Handles both C and C++ scanners and grammars that need
      # `tree-sitter generate` to produce src/parser.c.
      buildPhase = ''
        runHook preBuild

        cd "${parser.location}"

        if [ "${lib.boolToString parser.generate}" = "true" ] || [ ! -f src/parser.c ]; then
          tree-sitter generate --no-bindings || tree-sitter generate
        fi

        files="src/parser.c"
        compiler="$CC"
        if [ -f src/scanner.c ]; then
          files="$files src/scanner.c"
        elif [ -f src/scanner.cc ]; then
          files="$files src/scanner.cc"
          compiler="$CXX"
        fi

        echo "Building ${lang}.so from: $files"
        $compiler -fPIC -shared -Os -I src -o "${lang}.so" $files

        runHook postBuild
      '';

      installPhase = ''
        runHook preInstall
        install -Dm444 "${lang}.so" "$out/${lang}.so"
        runHook postInstall
      '';

      passthru = { inherit lang; };
    };

  builtParsers = lib.mapAttrs buildParser cfg.parsers;

  # Symlink each compiled `.so` into ~/.local/share/treesitter-parsers/parser/.
  parserFiles = lib.mapAttrs'
    (name: parser:
      let pkg = builtParsers.${name}; in
      lib.nameValuePair
        "${baseDir}/parser/${pkg.lang}.so"
        { source = "${pkg}/${pkg.lang}.so"; })
    cfg.parsers;

  # Symlink each fetched source tree into ~/.local/share/treesitter-parsers/downloads/.
  downloadFiles = lib.mapAttrs'
    (name: _parser:
      lib.nameValuePair
        "${baseDir}/downloads/${name}"
        { source = builtParsers.${name}.src; })
    cfg.parsers;

  parserModule = lib.types.submodule ({ ... }: {
    options = {
      url = lib.mkOption {
        type = lib.types.str;
        description = "Git URL of the tree-sitter grammar repository.";
        example = "https://github.com/tree-sitter-grammars/tree-sitter-markdown";
      };

      ref = lib.mkOption {
        type = lib.types.str;
        default = "main";
        description = "Git revision, tag, or branch to fetch.";
      };

      hash = lib.mkOption {
        type = lib.types.str;
        description = ''
          SRI hash of the fetched source. Required for pure Nix fetching.
          Leave as lib.fakeHash on first build to discover the real value.
        '';
        default = lib.fakeHash;
      };

      location = lib.mkOption {
        type = lib.types.str;
        default = ".";
        description = ''
          Subdirectory within the repo containing the grammar's `src/`
          (e.g. "tree-sitter-markdown-inline" for split grammars).
        '';
      };

      language = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = null;
        description = ''
          Parser/language name used for the output `<lang>.so`. Defaults to
          the attribute name. Use this when the filetype differs from the
          repo name (e.g. "markdown_inline").
        '';
      };

      generate = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Run `tree-sitter generate` before compiling.";
      };

      fetchSubmodules = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Whether to fetch git submodules of the grammar repo.";
      };
    };
  });
in
{
  options.programs.treesitter-parsers = {
    enable = lib.mkEnableOption "tree-sitter parsers built from source";

    parsers = lib.mkOption {
      type = lib.types.attrsOf parserModule;
      default = { };
      description = "Tree-sitter grammars to build, keyed by parser name.";
      example = lib.literalExpression ''
        {
          markdown = {
            url = "https://github.com/tree-sitter-grammars/tree-sitter-markdown";
            ref = "main";
            hash = "sha256-...";
            location = "tree-sitter-markdown";
          };
        }
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    home.file = parserFiles // downloadFiles;
  };
}
