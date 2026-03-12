#!/bin/bash
CHROME=$(find /home/browser/.cache -name "chrome" -type f | head -1)
exec "$CHROME" \
    --no-sandbox --disable-gpu --disable-dev-shm-usage \
    --remote-debugging-port=9220 --remote-debugging-address=0.0.0.0 \
    --user-data-dir=/home/browser/chrome-data \
    --no-first-run --no-default-browser-check --window-size=1920,1080
