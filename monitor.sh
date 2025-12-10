#!/bin/bash

# КОНФИГ
PROCESS_NAME="test"
URL="https://test.com/monitoring/test/api"
LOG_FILE="/var/log/monitoring.log"
PID_FILE="/var/run/monitor_test_last.pid"


CURRENT_PID=$(pgrep -x "$PROCESS_NAME" | head -n 1)

if [[ -z "$CURRENT_PID" ]]; then
    exit 0
fi


if [[ -f "$PID_FILE" ]]; then
    LAST_PID=$(cat "$PID_FILE")
    
    if [[ "$LAST_PID" != "$CURRENT_PID" ]]; then
        TIMESTAMP=$(date "+%Y-%m-%d %H:%M:%S")
        echo "[$TIMESTAMP] Process '$PROCESS_NAME' was restarted. Old PID: $LAST_PID, New PID: $CURRENT_PID" >> "$LOG_FILE"
    fi
fi

echo "$CURRENT_PID" > "$PID_FILE"


if ! curl -s -f -o /dev/null --connect-timeout 5 "$URL"; then
    TIMESTAMP=$(date "+%Y-%m-%d %H:%M:%S")
    echo "[$TIMESTAMP] Monitoring server unavailable: $URL" >> "$LOG_FILE"
fi