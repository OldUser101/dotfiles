#!/bin/sh

next=$(swaymsg -t get_dynamic_workspaces | jq -r '.next')

swaymsg move container to workspace "$next"
swaymsg workspace "$next"
