#!/bin/sh

SRC=$(cd -- "$(dirname -- "$0")" && pwd)

swaymsg workspace $($SRC/next-workspace-helper.sh)
