#!/usr/bin/env python3
"""Regression: standard terminal bracketed paste must not corrupt a Nebius key."""
import os
import pathlib
import subprocess
import tempfile
import time

root = pathlib.Path(__file__).resolve().parent.parent
script = root / "scripts" / "onboard-hermes-nebius"
with tempfile.TemporaryDirectory() as tmp:
    fake = pathlib.Path(tmp) / "hermes-workshop"
    fake.write_text("#!/usr/bin/env bash\nprintf 'fake_hermes_hello=passed\\n'\n")
    fake.chmod(0o755)
    master, slave = os.openpty()
    env = os.environ | {"PATH": f"{tmp}:{os.environ['PATH']}"}
    process = subprocess.Popen([str(script)], stdin=slave, stdout=slave, stderr=slave, env=env, close_fds=True)
    os.close(slave)
    os.write(master, b"\x1b[200~fake-nebius-key\x1b[201~\n")
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
assert process.returncode == 0, (process.returncode, text)
assert "fake_hermes_hello=passed" in text, text
print("bracketed-paste guard passed")
