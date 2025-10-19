#! /bin/sh
set -eu

# Reloads the Ghostty configuration on each running instance.
#
# ## Context
#
# As of 2025-10-16, Ghostty does have configuration auto-reload and
# [the development team has no plans of implementing this feature][2].
#
# All the proposed solutions involve iterating through every running Ghostty
# instance and triggering a reload. This can be done by either sending the
# reload hotkey `C-S-,` to each window or (since version 1.2.0) sending a
# `SIGUSR2` signal to each running process.
#
# ## Implementation
#
# Because the stable branch of the package manager I use is still pinned to
# version `1.1.3`, I decided to go with a hyprland-specific implementation that
# sends the `C-S-,` hotkey to every Ghostty window on each Hyprland instance.
#
# The drawback of this approach is that it accidentally depends on Hyprland to
# send keys to running windows (Wayland does not provide a standard API for
# doing this for security reasons. The Hyprland team decided to implement this
# anyways). This adds friction to my idea of moving to a simpler window manager.
#
# On the other hand, I don't think that I will have time to tinker with another
# window manager before Ghostty `1.2` hits a satble branch of `nixpkgs`. Also,
# I'm not worried about the default mapping changing any time soon. In that case
# I could remap that in the ghostty config.
#
# ## See also:
#
# - [How to automatically reload configuration? #3643][1].
#
# [1]: https://github.com/ghostty-org/ghostty/discussions/3643
# [2]: https://github.com/ghostty-org/ghostty/discussions/3643#discussioncomment-11682315

temp_dir="$( mktemp -d )"
trap 'retval=$?; rm -rf "$temp_dir"; exit $retval' EXIT INT TERM

# We need to do it this way because the script will not have access to
# `$HYPRLAND_INSTANCE_SIGNATURE` when running as a Home-Manager activation
# script. As a plus, this method works if there is more than one running
# Hyprland instance.
for hyprland_instance in $( hyprctl instances -j | jq -r '.[] | .instance' )
do
    if ! hyprctl --instance "$hyprland_instance" clients -j > "$temp_dir/hyprland_window_props"
    then
        echo "Failed to fetch Hyprland window properties. hyprland_instance=$hyprland_instance"
        cat "$temp_dir/hyprland_window_props"

        continue # Try our luck with the other instances...
    fi

    addresses="$( jq -r '.[] | select(.class == "com.mitchellh.ghostty") | .address' "$temp_dir/hyprland_window_props" )"

    for address in $addresses
    do
        if ! hyprctl --instance "$hyprland_instance" dispatch sendshortcut "CTRL SHIFT, comma, address:$address" > "$temp_dir/sendshortcut_out"
        then
            echo "Failed to reload Hyprland config. hyprland_instance=$hyprland_instance address=$address"
            continue # Try the next window
        fi

        if [ $( cat "$temp_dir/sendshortcut_out" ) != "ok" ]
        then
            echo "Failed to reload Hyprland config. hyprland_instance=$hyprland_instance address=$address"
            continue # Try the next window
        fi
    done
done
