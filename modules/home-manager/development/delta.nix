{ config, lib, ... }:
let
  cfg = config.jpcenteno-home.development.delta;

  # FIXME move this to a theming module.
  base16TerminalColors = {
          base00 = "0";
          base01 = "10";
          base02 = "11";
          base03 = "8";
          base04 = "12";
          base05 = "7";
          base06 = "13";
          base07 = "15";
          base08 = "1";
          base09 = "9";
          base0A = "3";
          base0B = "2";
          base0C = "6";
          base0D = "4";
          base0E = "5";
          base0F = "14";
  };
  
  colors = {
    highlight = base16TerminalColors.base03;
    decorations = base16TerminalColors.base04;
    lineNumbers = base16TerminalColors.base04;
    # FIXME base0E should correspond with diffdeleted, but for some reason it's
    # red in my current colorscheme. Should use base08 instead.
    diffDeleted = base16TerminalColors.base0E;
    diffInserted = base16TerminalColors.base0B;
  };

in {
  options.jpcenteno-home.development.delta = {
    enable = lib.mkEnableOption "the Delta syntax highlighter";
  };

  config = lib.mkIf cfg.enable {
    programs.git.delta = {
      enable = true;

      # The `[delta]` section of `~/.config/git/config`.
      options = {
        side-by-side = true;

        # Had to disable syntax highlighting because the colors it uses conflict
        # with the background colors used for diff added/deleted lines (Both
        # from the terminal emulator base-16 colorscheme).
        syntax-theme = "none";
        dark = true; # FIXME compute this based on the user's colorscheme.

        # Color for the box-drawing characters surrounding the left line numbers
        # column.
        line-numbers-left-style = colors.lineNumbers;

        # Color for the box-drawing characters surrounding the left line numbers
        # column.
        line-numbers-right-style = colors.lineNumbers;

        # Color for the numbers of unchanged lines.
        line-numbers-zero-style = colors.lineNumbers;

        line-numbers-minus-style = colors.diffDeleted;
        line-numbers-plus-style = colors.diffInserted;

        minus-style = "syntax";
        minus-emph-style = "syntax bold ${colors.highlight}";
        plus-style = "syntax";
        plus-emph-style = "syntax bold ${colors.highlight}";

        # File decorations:
        #
        # Delta will display the filename followed by a _decoration_ line before
        # all the diffs for that file.
        #
        # ```
        # modules/home-manager/development/delta.nix <- `file-style`
        # ────────────────────────────────────────── <- `file-decoration-style`
        # ```

        file-style = colors.decorations;
        file-decoration-style = "ul ${colors.decorations}";

        # FIXME these are the ones that I didn't set. You can inspect them
        # in the future using `delta -h | grep SYNTAX`.
        #
        # blame-code-style = FIXME # Style string for the code section of a git blame line
        # blame-separator-style = FIXME # Style string for the blame-separator-format
        # commit-decoration-style = FIXME # Style string for the commit hash decoration [default: ]
        # commit-style = FIXME # Style string for the commit hash line [default: raw]
        # grep-file-style = FIXME # Style string for file paths in grep output [default: magenta]
        # grep-context-line-style = FIXME # Style string for non-matching lines of grep output
        # grep-header-decoration-style = FIXME # Style string for the header decoration in grep output
        # grep-header-file-style = FIXME # Style string for the file path part of the header in grep output
        grep-line-number-style = "ul"; # Style string for line numbers in grep output [default: green]
        # grep-match-line-style = FIXME # Style string for matching lines of grep output
        # grep-match-word-style = FIXME # Style string for the matching substrings within a matching line of grep output
        # hunk-header-decoration-style = FIXME # Style string for the hunk-header decoration [default: "blue box"]
        # hunk-header-file-style = FIXME # Style string for the file path part of the hunk-header [default: blue]
        # hunk-header-line-number-style = FIXME # Style string for the line number part of the hunk-header [default: blue]
        # hunk-header-style = FIXME # Style string for the hunk-header [default: "line-number syntax"]
        # inline-hint-style = FIXME # Style string for short inline hint text [default: blue]
        # merge-conflict-ours-diff-header-decoration-style = FIXME # Style string for the decoration of the header above the 'ours' merge conflict diff [default: box]
        # merge-conflict-ours-diff-header-style = FIXME # Style string for the header above the 'ours' branch merge conflict diff [default: normal]
        # merge-conflict-theirs-diff-header-decoration-style = FIXME # Style string for the decoration of the header above the 'theirs' merge conflict diff [default: box]
        # merge-conflict-theirs-diff-header-style = FIXME # Style string for the header above the 'theirs' branch merge conflict diff [default: normal]
        # minus-empty-line-marker-style = FIXME # Style string for removed empty line marker [default: "normal auto"]
        # minus-non-emph-style = FIXME # Style string for non-emphasized sections of removed lines that have an emphasized section [default: minus-style]
        # plus-empty-line-marker-style = FIXME # Style string for added empty line marker [default: "normal auto"]
        # plus-non-emph-style = FIXME # Style string for non-emphasized sections of added lines that have an emphasized section [default: plus-style]
        # whitespace-error-style = FIXME # Style string for whitespace errors [default: "auto auto"]
        # zero-style = FIXME # Style string for unchanged lines [default: "syntax normal"]

      };
    };
  };
}
