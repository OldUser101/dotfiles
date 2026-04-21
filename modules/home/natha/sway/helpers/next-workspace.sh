#!/bin/sh

next=$(swaymsg -t get_dynamic_workspaces | jq -r '.next')

swaymsg workspace "$next"
