#!/usr/bin/env python3
"""Regression: cursor-key bytes in a secret must stop bootstrap before networking."""
import os
import subprocess
import sys
import time

script = os.path.join(os.path.dirname(__file__), "..", "scripts", "onboard-telegram-agent")
master, slave = os.openpty()
process = subprocess.Popen([script], stdin=slave, stdout=slave, stderr=slave, close_fds=True)
os.close(slave)
os.write(master, b"fake-nebius-key\nbad-token\x1b[D\n")
output = b""
deadline = time.monotonic() + 10
while time.monotonic() < deadline:
    try:
        chunk = os.read(master, 4096)
        if chunk:
            output += chunk
    except OSError:
        break
    if process.poll() is not None:
        break
process.wait(timeout=2)
os.close(master)
text = output.decode("utf-8", errors="replace")
assert process.returncode == 2, (process.returncode, text)
assert "Telegram bot token contains a control character" in text, text
assert "Unable to validate the Telegram bot token" not in text, text
print("control-character guard passed")
