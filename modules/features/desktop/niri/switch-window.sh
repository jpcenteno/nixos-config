#! /usr/bin/env bash
set -euo pipefail

FS="$(printf '\t')"

windows="$( niri msg --json windows | jq -r '.[] | "\(.id)\t\(.title) (\(.app_id))"' )"
i="$( echo "$windows" | cut -d "$FS" -f 2- | wofi --show dmenu --define=dmenu-print_line_num=true )"
id="$( echo "$windows" | sed -n "$(( i + 1 ))p" | cut -d "$FS" -f 1 )"

niri msg action focus-window --id "$id"
