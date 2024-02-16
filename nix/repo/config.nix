/*
This file holds configuration data for repo dotfiles.

Q: Why not just put the put the file there?

A: (1) dotfile proliferation
   (2) have all the things in one place / fromat
   (3) potentially share / re-use configuration data - keeping it in sync
*/
{
  # Tool Homepage: https://editorconfig.org/
  editorconfig = {
    data = {
      root = true;
      "*" = {
        end_of_line = "lf";
        insert_final_newline = true;
        trim_trailing_whitespace = true;
        charset = "utf-8";
        indent_style = "space";
        indent_size = 2;
      };
      "*.md" = {
        max_line_length = "off";
        trim_trailing_whitespace = false;
      };
      "*.xml" = {
        indent_style = "tab";
      };
    };
  };

  # Tool Homepage: https://numtide.github.io/treefmt/
  treefmt = {
    packages = let
      modify-unless-unchanged-or-error =
        inputs.nixpkgs.writeShellScriptBin "modify-unless-unchanged-or-error"
        ''
          PROG=$1
          FILEPATH=$2
          if OUTPUT=$($PROG "$FILEPATH"); then
            echo "$OUTPUT" | diff -q "$FILEPATH" - > /dev/null || echo "$OUTPUT" > "$FILEPATH"
          fi
        '';
      xmllint = inputs.nixpkgs.writeShellApplication {
        name = "xmllint-forall";
        runtimeInputs = [
          inputs.nixpkgs.libxml2
          modify-unless-unchanged-or-error
        ];
        text = ''
          for file in "$@"; do
            # Use the modify-unless-unchanged hack until this is implemented:
            # https://github.com/bram209/leptosfmt/issues/64
            modify-unless-unchanged-or-error "xmllint --nsclean --format" "$file"
          done
        '';
      };
    in [
      inputs.nixpkgs.alejandra
      inputs.nixpkgs.shfmt
      inputs.nixpkgs.libxml2
      inputs.nixpkgs.python3Packages.mdformat
      xmllint
    ];
    data = {
      formatter = {
        nix = {
          command = "alejandra";
          includes = ["*.nix"];
        };
        md = {
          command = "mdformat";
          includes = ["*.md"];
        };
        xml = {
          command = "xmllint-forall";
          includes = ["*.xml"];
        };
        shell = {
          command = "shfmt";
          options = ["-i" "2" "-s" "-w"];
          includes = ["*.sh"];
        };
      };
    };
  };

  # Tool Homepage: https://github.com/evilmartians/lefthook
  lefthook = {
    data = {
      commit-msg = {
        commands = {
          conform = {
            # allow WIP, fixup!/squash! commits locally
            run = ''
              [[ "$(head -n 1 {1})" =~ ^WIP(:.*)?$|^wip(:.*)?$|fixup\!.*|squash\!.* ]] ||
              conform enforce --commit-msg-file {1}'';
            skip = ["merge" "rebase"];
          };
        };
      };
      pre-commit = {
        commands = {
          treefmt = {
            run = "treefmt --fail-on-change {staged_files}";
            skip = ["merge" "rebase"];
          };
        };
      };
    };
  };

  # Tool Homepage: https://rust-lang.github.io/mdBook/
  mdbook = {
    # add preprocessor packages here
    packages = [
      inputs.nixpkgs.mdbook-linkcheck
    ];
    data = {
      # Configuration Reference: https://rust-lang.github.io/mdBook/format/configuration/index.html
      book = {
        language = "es";
        multilingual = true;
        title = "Manual de Factura Electronica";
        src = "docs";
      };
      build.build-dir = "docs/build";
      preprocessor = {};
      output = {
        html = {};
        # Tool Homepage: https://github.com/Michael-F-Bryan/mdbook-linkcheck
        linkcheck = {};
      };
    };
    output = "book.toml";
    hook.mode = "copy"; # let CI pick it up outside of devshell
  };
}
