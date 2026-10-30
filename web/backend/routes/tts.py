import hashlib
import os
import requests
from fastapi import APIRouter, HTTPException
from pydantic import BaseModel, Field
from fastapi.responses import FileResponse
from dotenv import load_dotenv

load_dotenv()

router = APIRouter(prefix="/tts", tags=["tts"])

# ElevenLabs configuration
ELEVENLABS_API_KEY = os.getenv("ELEVENLABS_API_KEY")
ELEVENLABS_API_URL = "https://api.elevenlabs.io/v1/text-to-speech"

# Voice ID - Ugochukwu: native Igbo speaker voice
IGBO_VOICE_ID = "nw6EIXCsQ89uJMjytYb8"

# CRITICAL: must use a MULTILINGUAL model or ElevenLabs renders Igbo text
# through its English engine (which produces the American accent). The
# default when model_id is omitted is eleven_monolingual_v1 (English only).
ELEVENLABS_MODEL_ID = "eleven_multilingual_v2"

# On-disk cache. Content (word bank, proverbs, stories) is fixed, so each
# unique phrase is synthesized by ElevenLabs exactly once, then served from
# disk forever — kills both latency and per-play API cost.
CACHE_DIR = os.path.join(os.path.dirname(__file__), "..", "tts_cache")
os.makedirs(CACHE_DIR, exist_ok=True)


class TextToSpeechRequest(BaseModel):
    text: str = Field(min_length=1, max_length=2500)
    language: str = "ig"


def _cache_path(text: str) -> str:
    """Stable cache filename keyed by voice + model + text."""
    key = f"{IGBO_VOICE_ID}:{ELEVENLABS_MODEL_ID}:{text}"
    digest = hashlib.sha256(key.encode("utf-8")).hexdigest()
    return os.path.join(CACHE_DIR, f"{digest}.mp3")


@router.post("/synthesize")
def synthesize_speech(req: TextToSpeechRequest):
    """
    Generate speech audio using ElevenLabs multilingual TTS for Igbo.
    Cached to disk so identical phrases are only ever synthesized once.
    """
    if not req.text or not req.text.strip():
        raise HTTPException(400, "Text cannot be empty")

    if not ELEVENLABS_API_KEY:
        raise HTTPException(500, "ElevenLabs API key not configured")

    text = req.text.strip()
    cache_path = _cache_path(text)

    # Serve from cache if we've synthesized this phrase before
    if os.path.exists(cache_path) and os.path.getsize(cache_path) > 0:
        return FileResponse(cache_path, media_type="audio/mpeg")

    try:
        headers = {
            "xi-api-key": ELEVENLABS_API_KEY,
            "Content-Type": "application/json",
        }
        payload = {
            "text": text,
            "model_id": ELEVENLABS_MODEL_ID,
            "voice_settings": {
                "stability": 0.5,
                "similarity_boost": 0.75,
            },
        }

        response = requests.post(
            f"{ELEVENLABS_API_URL}/{IGBO_VOICE_ID}",
            headers=headers,
            json=payload,
            timeout=30,
        )

        if response.status_code != 200:
            raise HTTPException(502, "Speech provider could not generate audio")

        # Write to cache atomically (temp then rename) so a failed/partial
        # write can never leave a corrupt file that we'd later serve.
        tmp_path = cache_path + ".tmp"
        with open(tmp_path, "wb") as f:
            f.write(response.content)
        os.replace(tmp_path, cache_path)

        if os.path.getsize(cache_path) == 0:
            os.unlink(cache_path)
            raise HTTPException(500, "Failed to generate audio")

        return FileResponse(cache_path, media_type="audio/mpeg")

    except requests.exceptions.Timeout:
        raise HTTPException(504, "TTS request timed out")
    except requests.exceptions.RequestException:
        raise HTTPException(502, "Speech provider unavailable")
    except HTTPException:
        raise
    except Exception:
        raise HTTPException(500, "Speech generation failed")
