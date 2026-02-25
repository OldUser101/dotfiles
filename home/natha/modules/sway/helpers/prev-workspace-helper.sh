#!/bin/sh

workspaces_json=$(swaymsg -t get_workspaces)
current_workspace=$(echo "$workspaces_json" | jq -r '.[] | select(.focused==true).name')
current_num=$(echo "$current_workspace" | grep -Eo '^[0-9]+' || echo 0)
current_output=$(echo "$workspaces_json" | jq -r '.[] | select(.focused==true).output')

output_ws_nums=($(echo "$workspaces_json" | jq -r --arg output "$current_output" '[.[] | select(.output == $output) | select(.name | tonumber?)] | map(.name | tonumber) | sort| .[]'))

prev=0
for (( i=${#output_ws_nums[@]}-1; i>=0; i-- )); do
  if (( output_ws_nums[i] < current_num )); then
    prev=${output_ws_nums[i]}
    break
  fi
done

if (( prev == 0 )); then
  prev=${output_ws_nums[-1]}
fi

echo "$prev"
