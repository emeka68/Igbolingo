import io
import subprocess
import tempfile
import os
from fastapi import APIRouter, HTTPException
from pydantic import BaseModel
from fastapi.responses import FileResponse

router = APIRouter(prefix="/tts", tags=["tts"])

class TextToSpeechRequest(BaseModel):
    text: str
    language: str = "en"  # "en" for English, "ig" for Igbo (future)

@router.post("/synthesize")
async def synthesize_speech(req: TextToSpeechRequest):
    """
    Generate speech audio from text using espeak-ng.
    Currently uses en voice with adjusted pitch/rate for Igbo-like pronunciation.
    Future: switch to native Igbo voice when available or via ElevenLabs.
    """
    if not req.text or not req.text.strip():
        raise HTTPException(400, "Text cannot be empty")

    # Create temporary file for audio output
    with tempfile.NamedTemporaryFile(suffix=".wav", delete=False) as tmp:
        tmp_path = tmp.name

    try:
        # Use espeak-ng with -w flag to write to file
        # English voice with adjusted pitch (higher) and rate (slower)
        # This approximates an Igbo-accented pronunciation
        subprocess.run(
            [
                "espeak-ng",
                "-v", "en",           # English voice
                "-s", "130",           # Slower speech (130 wpm)
                "-p", "40",            # Higher pitch (1-99, 40 = higher)
                "-w", tmp_path,        # Write to temp file
                req.text.strip()
            ],
            capture_output=True,
            timeout=10,
            check=True
        )

        if not os.path.exists(tmp_path) or os.path.getsize(tmp_path) == 0:
            raise HTTPException(500, "Failed to generate audio")

        return FileResponse(
            tmp_path,
            media_type="audio/wav",
            headers={"Content-Disposition": "attachment; filename=speech.wav"}
        )

    except subprocess.TimeoutExpired:
        if os.path.exists(tmp_path):
            os.unlink(tmp_path)
        raise HTTPException(504, "TTS generation timed out")
    except subprocess.CalledProcessError as e:
        if os.path.exists(tmp_path):
            os.unlink(tmp_path)
        raise HTTPException(500, f"TTS generation failed")
    except Exception as e:
        if os.path.exists(tmp_path):
            os.unlink(tmp_path)
        raise HTTPException(500, f"TTS error: {str(e)}")
