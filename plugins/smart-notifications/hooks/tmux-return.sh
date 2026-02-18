#!/bin/bash
# Invoked by terminal-notifier -execute when a notification is clicked.
# Activates the parent terminal and navigates to the originating tmux pane.
#
# Args: <bundle_id> <client_tty> <socket_path> <target_window> <target_pane_id> <tmux_bin>

bundle_id="$1"
client_tty="$2"
socket_path="$3"
target_window="$4"
target_pane_id="$5"
tmux_bin="$6"

# Activate the parent terminal application
osascript -e "tell application id \"$bundle_id\" to activate"

# Navigate to the correct tmux window and pane.
# switch-client handles the case where the client is viewing a different session.
# Retry loop handles the race between app activation and tmux accepting focus.
for _ in $(seq 1 10); do
  "$tmux_bin" -S "$socket_path" switch-client -t "$target_window" 2>/dev/null \
    && "$tmux_bin" -S "$socket_path" select-window -t "$target_window" 2>/dev/null \
    && "$tmux_bin" -S "$socket_path" select-pane -t "$target_pane_id" 2>/dev/null \
    && break
  sleep 0.1
done
