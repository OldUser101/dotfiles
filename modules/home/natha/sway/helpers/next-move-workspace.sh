#!/bin/sh

SRC=$(cd -- "$(dirname -- "$0")" && pwd)

next=$($SRC/next-workspace-helper.sh)

swaymsg move container to workspace "$next"
swaymsg workspace "$next"
