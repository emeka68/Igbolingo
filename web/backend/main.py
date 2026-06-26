from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from dotenv import load_dotenv
from routes import translate, learn, tts

load_dotenv()

app = FastAPI(title="Igbolingo API", version="1.0.0")

app.add_middleware(
    CORSMiddleware,
    allow_origins=["http://localhost:5173", "http://localhost:3000"],
    allow_methods=["*"],
    allow_headers=["*"],
)

app.include_router(translate.router, prefix="/api")
app.include_router(learn.router, prefix="/api")
app.include_router(tts.router, prefix="/api")

@app.get("/api/health")
def health():
    return {"status": "ok", "service": "Igbolingo API"}
