import os
import time
from collections import defaultdict, deque
from threading import Lock
from fastapi import FastAPI
from fastapi import Request
from fastapi.middleware.cors import CORSMiddleware
from fastapi.responses import JSONResponse
from dotenv import load_dotenv
from routes import translate, learn, tts

load_dotenv()

app = FastAPI(title="Igbolingo API", version="1.0.0")

# A small local guard against accidental bursts. Production still needs an
# edge/gateway limit because this counter is per process and per instance.
_request_times = defaultdict(deque)
_rate_lock = Lock()
_limit = max(1, int(os.getenv("IGBOLINGO_API_REQUESTS_PER_MINUTE", "20")))


@app.middleware("http")
async def limit_paid_api(request: Request, call_next):
    if request.method != "POST" or not request.url.path.startswith("/api/"):
        return await call_next(request)
    now = time.monotonic()
    address = request.client.host if request.client else "unknown"
    with _rate_lock:
        calls = _request_times[address]
        while calls and calls[0] <= now - 60:
            calls.popleft()
        if len(calls) >= _limit:
            return JSONResponse({"detail": "Too many requests. Please try again shortly."}, status_code=429)
        calls.append(now)
        if len(_request_times) > 10000:
            for key in list(_request_times):
                if not _request_times[key] or _request_times[key][-1] <= now - 60:
                    del _request_times[key]
    return await call_next(request)

# Comma-separated production web origins; mobile WebView origins stay explicit.
extra_origins = [origin.strip() for origin in os.getenv("IGBOLINGO_CORS_ORIGINS", "").split(",") if origin.strip()]

app.add_middleware(
    CORSMiddleware,
    allow_origins=[
        "http://localhost:5173",
        "http://localhost:3000",
        # Capacitor mobile shells (iOS / Android webview origins)
        "capacitor://localhost",
        "http://localhost",
        "https://localhost",
    ] + extra_origins,
    allow_methods=["*"],
    allow_headers=["*"],
)

app.include_router(translate.router, prefix="/api")
app.include_router(learn.router, prefix="/api")
app.include_router(tts.router, prefix="/api")

@app.get("/api/health")
def health():
    return {"status": "ok", "service": "Igbolingo API"}
