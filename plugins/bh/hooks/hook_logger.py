#!/usr/bin/env python3
"""Hook logger — appends every hook payload to .claude/hook_logs/{event}.jsonl"""

import json
import os
import sys
from datetime import datetime, timezone


def main():
    event_name = sys.argv[1] if len(sys.argv) > 1 else "unknown"

    # Read payload from stdin
    try:
        payload = json.load(sys.stdin)
    except (json.JSONDecodeError, EOFError):
        payload = {}

    # Add metadata
    entry = {
        "timestamp": datetime.now(timezone.utc).isoformat(),
        "event": event_name,
        "payload": payload,
    }

    # Log to project's .claude/hook_logs/ (CWD-based)
    log_dir = os.path.join(os.getcwd(), ".claude", "hook_logs")
    os.makedirs(log_dir, exist_ok=True)

    # Append to event-specific JSONL file
    log_file = os.path.join(log_dir, f"{event_name}.jsonl")
    with open(log_file, "a") as f:
        f.write(json.dumps(entry) + "\n")


if __name__ == "__main__":
    main()
