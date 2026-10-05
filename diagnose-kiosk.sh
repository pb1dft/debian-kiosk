#!/bin/bash
set -u

echo "=== Kiosk processes ==="
pgrep -a Xorg || true
pgrep -a openbox || true
pgrep -a chromium || true

echo
echo "=== Kiosk files ==="
ls -la /home/kiosk/.xinitrc /home/kiosk/.bash_profile 2>&1 || true
ls -la /home/kiosk/bin/ 2>&1 || true
ls -la /home/kiosk/.config/openbox/ 2>&1 || true

echo
echo "=== Logs ==="
for f in /home/kiosk/kiosk-session.log /home/kiosk/kiosk-browser.log /home/kiosk/kiosk-rotator.log; do
  echo "--- $f ---"
  tail -100 "$f" 2>/dev/null || true
done

echo
echo "=== Chromium binary ==="
command -v chromium || true
ls -l /usr/bin/chromium 2>&1 || true

echo
echo "=== X display ==="
echo "DISPLAY=${DISPLAY:-not-set}"
echo "XAUTHORITY=${XAUTHORITY:-not-set}"
