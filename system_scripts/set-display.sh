#!/usr/bin/env bash
CONFIG_DIR="$HOME/.config/hypr/monitors"
STATE_FILE="$CONFIG_DIR/current_mode"

mode="$1"

case "$mode" in
  laptop)
    hyprctl keyword monitor eDP-1,1920x1080@60.05,1985x1439,1.5
    hyprctl keyword monitor desc:Samsung Electric Company SAMSUNG 0x01000E00,disable
    echo "laptop" > "$STATE_FILE"
    ;;
  external)
    hyprctl keyword monitor eDP-1,disable
    hyprctl keyword monitor desc:Samsung Electric Company SAMSUNG 0x01000E00,3840x2160@30.0,1360x0,1.5000000000000004
    echo "external" > "$STATE_FILE"
    ;;
  both)
    hyprctl keyword monitor eDP-1,1920x1080@60.05,1985x1439,1.5
    hyprctl keyword monitor desc:Samsung Electric Company SAMSUNG 0x01000E00,3840x2160@30.0,1360x0,1.5000000000000004
    echo "both" > "$STATE_FILE"
    ;;
  toggle)
    current=$(cat "$STATE_FILE" 2>/dev/null || echo "laptop")
    case "$current" in
      laptop)
        move_workspaces_from "desc:Samsung Electric Company SAMSUNG 0x01000E00" "eDP-1"
        hyprctl keyword monitor eDP-1,disable
        hyprctl keyword monitor desc:Samsung Electric Company SAMSUNG 0x01000E00,3840x2160@30.0,1360x0,1.5000000000000004
        pkill waybar && hyprctl dispatch exec waybar
        echo "external" > "$STATE_FILE"
        ;;
      external)
        move_workspaces_from "desc:Samsung Electric Company SAMSUNG 0x01000E00" "eDP-1"
        hyprctl keyword monitor eDP-1,1920x1080@60.05,1985x1439,1.5
        hyprctl keyword monitor desc:Samsung Electric Company SAMSUNG 0x01000E00,3840x2160@30.0,1360x0,1.5000000000000004
        pkill waybar && hyprctl dispatch exec waybar
        echo "both" > "$STATE_FILE"
        ;;
      *)
        hyprctl keyword monitor eDP-1,1920x1080@60.05,1985x1439,1.5
        hyprctl keyword monitor desc:Samsung Electric Company SAMSUNG 0x01000E00,disable
        pkill waybar && hyprctl dispatch exec waybar
        echo "laptop" > "$STATE_FILE"
        ;;
    esac
    ;;
  *)
    echo "Usage: $0 [laptop|external|both|toggle]"
    exit 1
    ;;
esac


move_workspaces_from() {
  local src_monitor="$1"
  local dst_monitor="$2"

  # Get workspaces on the source monitor
  workspaces=$(hyprctl workspaces -j | jq -r ".[] | select(.monitor == \"$src_monitor\") | .id")

  for ws in $workspaces; do
    echo "Moving workspace $ws from $src_monitor to $dst_monitor"
    hyprctl dispatch moveworkspacetomonitor "$ws" "$dst_monitor"
  done
}
