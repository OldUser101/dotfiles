#!/bin/sh

prev=$(swaymsg -t get_dynamic_workspaces | jq -r '.prev')

swaymsg workspace "$prev"
