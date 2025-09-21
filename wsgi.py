# Minimal WSGI wrapper:
#  - imports Znail's Flask app (defined in znail/ui/__init__.py)
#  - adds /healthz without editing upstream code
from znail.ui import app as _app

if not any(r.rule == "/healthz" for r in _app.url_map.iter_rules()):
    @_app.route("/healthz")
    def _healthz():
        return "ok", 200

app = _app  # gunicorn entrypoint "wsgi:app"
