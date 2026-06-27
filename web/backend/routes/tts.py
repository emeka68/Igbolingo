import tempfile
import os
import requests
from fastapi import APIRouter, HTTPException
from pydantic import BaseModel
from fastapi.responses import FileResponse
from dotenv import load_dotenv

load_dotenv()

router = APIRouter(prefix="/tts", tags=["tts"])

# ElevenLabs configuration
ELEVENLABS_API_KEY = os.getenv("ELEVENLABS_API_KEY")
ELEVENLABS_API_URL = "https://api.elevenlabs.io/v1/text-to-speech"

# Voice ID - Ugochukwu: Native Igbo speaker voice
# Authentic pronunciation for Igbo language
IGBO_VOICE_ID = "nw6EIXCsQ89uJMjytYb8"  # Ugochukwu - Igbo voice

class TextToSpeechRequest(BaseModel):
    text: str
    language: str = "ig"

@router.post("/synthesize")
async def synthesize_speech(req: TextToSpeechRequest):
    """
    Generate speech audio using ElevenLabs for high-quality Igbo TTS.
    Primary: ElevenLabs API with Igbo voice model

    User can train custom voices from native Igbo speaker recordings
    to replace/improve the base model over time.
    """
    if not req.text or not req.text.strip():
        raise HTTPException(400, "Text cannot be empty")

    if not ELEVENLABS_API_KEY:
        raise HTTPException(500, "ElevenLabs API key not configured")

    text = req.text.strip()

    try:
        # Call ElevenLabs API
        headers = {
            "xi-api-key": ELEVENLABS_API_KEY,
            "Content-Type": "application/json"
        }

        payload = {
            "text": text,
            "voice_settings": {
                "stability": 0.5,
                "similarity_boost": 0.75
            }
        }

        response = requests.post(
            f"{ELEVENLABS_API_URL}/{IGBO_VOICE_ID}",
            headers=headers,
            json=payload,
            timeout=30
        )

        if response.status_code != 200:
            error_msg = response.json().get("detail", {}).get("message", "Unknown error")
            raise HTTPException(response.status_code, f"ElevenLabs error: {error_msg}")

        # Save audio to temporary file
        with tempfile.NamedTemporaryFile(suffix=".mp3", delete=False) as tmp:
            tmp_path = tmp.name
            tmp.write(response.content)

        if not os.path.exists(tmp_path) or os.path.getsize(tmp_path) == 0:
            raise HTTPException(500, "Failed to generate audio")

        return FileResponse(
            tmp_path,
            media_type="audio/mpeg",
            headers={"Content-Disposition": "attachment; filename=speech.mp3"}
        )

    except requests.exceptions.Timeout:
        raise HTTPException(504, "TTS request timed out")
    except requests.exceptions.RequestException as e:
        raise HTTPException(500, f"TTS request failed: {str(e)}")
    except Exception as e:
        raise HTTPException(500, f"TTS error: {str(e)}")
