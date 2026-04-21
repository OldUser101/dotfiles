#!/bin/sh

prev=$(swaymsg -t get_dynamic_workspaces | jq -r '.prev')

swaymsg move container to workspace "$prev"
swaymsg workspace "$prev"
