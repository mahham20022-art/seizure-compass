"""Static server with SPA fallback, for CI screenshots: python tool/serve.py build/web 8080"""
import http.server, os, sys
root, port = sys.argv[1], int(sys.argv[2])
os.chdir(root)
class H(http.server.SimpleHTTPRequestHandler):
    def send_head(self):
        path = self.translate_path(self.path.split('?')[0])
        if not os.path.exists(path):
            self.path = '/index.html'
        return super().send_head()
    def log_message(self, *a):
        pass
http.server.ThreadingHTTPServer(('127.0.0.1', port), H).serve_forever()
