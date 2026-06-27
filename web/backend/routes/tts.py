import subprocess
import tempfile
import os
from fastapi import APIRouter, HTTPException
from pydantic import BaseModel
from fastapi.responses import FileResponse

router = APIRouter(prefix="/tts", tags=["tts"])

# Future: Load custom VITS/Piper models trained on Igbo speaker data
_custom_model = None

def load_custom_model():
    """
    Placeholder for loading custom Igbo TTS model.
    User can provide trained VITS or Piper model for hybrid approach.
    """
    global _custom_model
    # TODO: Load custom model from /models/igbo-tts.pt if it exists
    return None

class TextToSpeechRequest(BaseModel):
    text: str
    language: str = "ig"

@router.post("/synthesize")
async def synthesize_speech(req: TextToSpeechRequest):
    """
    Generate speech audio from text.
    Primary: Custom Igbo TTS model (if user provides trained model)
    Fallback: espeak-ng (Nigerian English approximation)

    Hybrid approach: Uses espeak-ng now, upgrades to custom models
    when user provides trained VITS/Piper weights.
    """
    if not req.text or not req.text.strip():
        raise HTTPException(400, "Text cannot be empty")

    text = req.text.strip()

    # Try custom model if available (user-trained VITS or Piper)
    custom_model = load_custom_model()
    if custom_model is not None and req.language == "ig":
        try:
            # TODO: Use custom model to generate speech
            pass
        except Exception as e:
            print(f"Custom model error: {e}")
            # Fall through to espeak-ng

    # Use espeak-ng as current fallback
    with tempfile.NamedTemporaryFile(suffix=".wav", delete=False) as tmp:
        tmp_path = tmp.name

    try:
        # Nigerian English approximation for Igbo
        # Better than plain English, acceptable until custom model is trained
        subprocess.run(
            [
                "espeak-ng",
                "-v", "en-029",      # Caribbean English (similar tonality to Igbo regions)
                "-s", "125",          # Moderate speech rate
                "-p", "45",           # Slightly higher pitch
                "-w", tmp_path,
                text
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
    except subprocess.CalledProcessError:
        if os.path.exists(tmp_path):
            os.unlink(tmp_path)
        raise HTTPException(500, "TTS generation failed")
    except Exception as e:
        if os.path.exists(tmp_path):
            os.unlink(tmp_path)
        raise HTTPException(500, f"TTS error: {str(e)}")
