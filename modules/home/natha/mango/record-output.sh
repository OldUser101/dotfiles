#!/bin/sh
set -eu

PID_FILE_PATH="$XDG_RUNTIME_DIR/record_output.pid"

if [ ! -n "$XDG_RUNTIME_DIR" ]; then
    echo "XDG_RUNTIME_DIR empty not set!"
    exit 1
fi

if [ -f "$PID_FILE_PATH" ]; then
    TARGET_PID=$(cat "$PID_FILE_PATH")

    kill -n 2 "$TARGET_PID" || true
    waitpid "$TARGET_PID" || true

    rm -f "$PID_FILE_PATH"
    exit 0
fi

REC="$OUT_DIR/Recording_$(date +%F_%T).mkv"

nohup wf-recorder --file="$REC" > "$HOME/.wf-recorder.log" 2>&1 &
echo $! > "$PID_FILE_PATH"

exit 0
