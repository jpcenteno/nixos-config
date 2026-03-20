#! /usr/bin/env bash
set -euo pipefail

printf '┌───────┬────────┬──────┬───────────────────────────────────────────────────────────────────┐\n'
printf '│ Color │ Base16 │ Ansi │ Description                                                       │\n'
printf '├───────┼────────┼──────┼───────────────────────────────────────────────────────────────────┤\n'
printf '│ %s     %s │ base00 │    0 │ Default Background                                                │\n' "$( tput setab 0 )" "$( tput sgr0 )"
printf '│ %s     %s │ base01 │   10 │ Lighter Background (Used for status bars)                         │\n' "$( tput setab 10 )" "$( tput sgr0 )"
printf '│ %s     %s │ base02 │   11 │ Selection Background                                              │\n' "$( tput setab 11 )" "$( tput sgr0 )"
printf '│ %s     %s │ base03 │    8 │ Comments, Invisibles, Line Highlighting                           │\n' "$( tput setab 8 )" "$( tput sgr0 )"
printf '│ %s     %s │ base04 │   12 │ Dark Foreground (Used for status bars)                            │\n' "$( tput setab 12 )" "$( tput sgr0 )"
printf '│ %s     %s │ base05 │    7 │ Default Foreground, Caret, Delimiters, Operators                  │\n' "$( tput setab 7 )" "$( tput sgr0 )"
printf '│ %s     %s │ base06 │   13 │ Light Foreground                                                  │\n' "$( tput setab 13 )" "$( tput sgr0 )"
printf '│ %s     %s │ base07 │   15 │ The Lightest Foreground                                           │\n' "$( tput setab 15 )" "$( tput sgr0 )"
printf '│ %s     %s │ base08 │    1 │ Variables, XML Tags, Markup Link Text, Markup Lists, Diff Deleted │\n' "$( tput setab 1 )" "$( tput sgr0 )"
printf '│ %s     %s │ base09 │    9 │ Integers, Boolean, Constants, XML Attributes, Markup Link Url     │\n' "$( tput setab 9 )" "$( tput sgr0 )"
printf '│ %s     %s │ base0A │    3 │ Classes, Markup Bold, Search Text Background                      │\n' "$( tput setab 3 )" "$( tput sgr0 )"
printf '│ %s     %s │ base0B │    2 │ Strings, Inherited Class, Markup Code, Diff Inserted              │\n' "$( tput setab 2 )" "$( tput sgr0 )"
printf '│ %s     %s │ base0C │    6 │ Support, Regular Expressions, Escape Characters, Markup Quotes    │\n' "$( tput setab 6 )" "$( tput sgr0 )"
printf '│ %s     %s │ base0D │    4 │ Functions, Methods, Attribute IDs, Headings                       │\n' "$( tput setab 4 )" "$( tput sgr0 )"
printf '│ %s     %s │ base0E │    5 │ Keywords, Storage, Selector, Markup Italic, Diff Changed          │\n' "$( tput setab 5 )" "$( tput sgr0 )"
printf '│ %s     %s │ base0F │   14 │ Deprecated, Opening/Closing Embedded Language Tags, e.g. <?php ?> │\n' "$( tput setab 14 )" "$( tput sgr0 )"
printf '└───────┴────────┴──────┴───────────────────────────────────────────────────────────────────┘\n'
