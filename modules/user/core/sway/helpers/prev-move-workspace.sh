#!/bin/sh

SRC=$(cd -- "$(dirname -- "$0")" && pwd)

prev=$($SRC/prev-workspace-helper.sh)

swaymsg move container to workspace "$prev"
swaymsg workspace "$prev"
