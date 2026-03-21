#! /bin/sh
set -eu

# I called this script `pasta` because `paste` was already taken.

has_cmd() {
    command -v "$1" > /dev/null
}

if [ -S "$XDG_RUNTIME_DIR/$WAYLAND_DISPLAY" ] && has_cmd 'wl-paste'; then
    wl-paste
elif has_cmd 'pbpaste'; then
    pbpaste # macOS.
elif [ -f "$XDG_RUNTIME_DIR/clipboard" ]; then
    cat "$XDG_RUNTIME_DIR/clipboard"
fi
