#!/usr/bin/env python3
import http.server
import os
import sys

PORT = int(sys.argv[1]) if len(sys.argv) > 1 else 18080
ROOT = os.path.join(os.path.dirname(os.path.abspath(__file__)), "site")

class Handler(http.server.SimpleHTTPRequestHandler):
    def __init__(self, *args, **kwargs):
        super().__init__(*args, directory=ROOT, **kwargs)
    def log_message(self, format, *args):
        pass

if __name__ == "__main__":
    with http.server.ThreadingHTTPServer(("127.0.0.1", PORT), Handler) as httpd:
        httpd.serve_forever()
