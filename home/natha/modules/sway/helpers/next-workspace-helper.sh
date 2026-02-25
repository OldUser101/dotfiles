#!/bin/sh

workspaces_json=$(swaymsg -t get_workspaces)

current_name=$(echo "$workspaces_json" | jq -r '.[] | select(.focused==true).name')
current_num=$(echo "$current_name" | grep -Eo '^[0-9]+' || echo 0)
current_output=$(echo "$workspaces_json" | jq -r '.[] | select(.focused==true).output')

output_ws_nums=($(echo "$workspaces_json" | jq -r --arg output "$current_output" '[.[] | select(.output == $output) | select(.name | tonumber?)] | map(.name | tonumber) | sort | .[]'))

global_ws_max=$(echo "$workspaces_json" | jq -r '[.[] | select(.name | tonumber?)] | map(.name | tonumber) | max')

next=0
for ws in "${output_ws_nums[@]}"; do
  if (( ws > current_num )); then
    next=$ws
    break
  fi
done

if (( next == 0 )); then
  next=$((global_ws_max + 1))
fi

echo "$next"
