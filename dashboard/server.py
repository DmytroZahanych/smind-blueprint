#!/usr/bin/env python3
"""Tiny server: serves dashboard static files + saves correction JSON files."""
import http.server
import json
import os
import time

CORRECTIONS_DIR = "/root/.openclaw/workspace/corrections"
DASHBOARD_DIR = os.path.dirname(os.path.abspath(__file__))

class Handler(http.server.SimpleHTTPRequestHandler):
    def __init__(self, *args, **kwargs):
        super().__init__(*args, directory=DASHBOARD_DIR, **kwargs)

    def do_POST(self):
        if self.path == "/api/correction":
            length = int(self.headers.get("Content-Length", 0))
            body = self.rfile.read(length)
            try:
                data = json.loads(body)
                # Save as atomic file: <timestamp>_<node_id>.json
                node_id = data.get("nodeId", "unknown").replace("/", "_")
                ts = int(time.time() * 1000)
                filename = f"{ts}_{node_id}.json"
                filepath = os.path.join(CORRECTIONS_DIR, filename)
                with open(filepath, "w") as f:
                    json.dump(data, f, indent=2)
                self.send_response(200)
                self.send_header("Content-Type", "application/json")
                self.end_headers()
                self.wfile.write(json.dumps({"ok": True, "file": filename}).encode())
            except Exception as e:
                self.send_response(500)
                self.send_header("Content-Type", "application/json")
                self.end_headers()
                self.wfile.write(json.dumps({"ok": False, "error": str(e)}).encode())
        else:
            self.send_response(404)
            self.end_headers()

if __name__ == "__main__":
    os.makedirs(CORRECTIONS_DIR, exist_ok=True)
    server = http.server.HTTPServer(("0.0.0.0", 8099), Handler)
    print(f"Serving dashboard on :8099, corrections → {CORRECTIONS_DIR}")
    server.serve_forever()
