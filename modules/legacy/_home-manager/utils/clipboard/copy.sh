#! /bin/sh
set -eu

has_cmd() {
    command -v "$1" > /dev/null
}


if [ -S "$XDG_RUNTIME_DIR/$WAYLAND_DISPLAY" ] && has_cmd 'wl-copy'; then
    wl-copy
elif has_cmd 'pbcopy'; then
    pbcopy # macOS.
else
    cat > "$XDG_RUNTIME_DIR/clipboard"
fi
