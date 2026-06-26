import base64, json, re
from fastapi import APIRouter, HTTPException, UploadFile, File
from pydantic import BaseModel
from anthropic import Anthropic

router = APIRouter(prefix="/translate", tags=["translate"])
client = Anthropic()
MODEL = "claude-sonnet-4-6"

def strip_fences(text: str) -> str:
    return re.sub(r"```(?:json)?\s*|\s*```", "", text).strip()

class TextRequest(BaseModel):
    text: str

class SpeechRequest(BaseModel):
    text: str

@router.post("/text")
async def translate_text(req: TextRequest):
    prompt = f"""Translate this English text to Igbo: "{req.text}"

Respond ONLY with valid JSON (no markdown):
{{
  "igbo": "...",
  "pronunciation": "syllable-by-syllable guide e.g. nah-MAH",
  "tones": "brief tone description",
  "example": "an Igbo example sentence (optional)",
  "exampleTranslation": "English translation of example (optional)"
}}"""
    msg = client.messages.create(model=MODEL, max_tokens=512,
        messages=[{"role": "user", "content": prompt}])
    try:
        return json.loads(strip_fences(msg.content[0].text))
    except Exception:
        raise HTTPException(500, "Failed to parse translation")

@router.post("/image")
async def translate_image(file: UploadFile = File(...)):
    data = await file.read()
    b64 = base64.standard_b64encode(data).decode()
    media_type = file.content_type or "image/jpeg"

    prompt = """Identify objects in this image and translate them to Igbo.
Return ONLY a JSON array (no markdown), max 8 items:
[{"english":"...", "igbo":"...", "pronunciation":"...", "emoji":"..."}]"""

    msg = client.messages.create(model=MODEL, max_tokens=1024,
        messages=[{"role": "user", "content": [
            {"type": "image", "source": {"type": "base64", "media_type": media_type, "data": b64}},
            {"type": "text", "text": prompt}
        ]}])
    try:
        return json.loads(strip_fences(msg.content[0].text))
    except Exception:
        raise HTTPException(500, "Failed to parse image translation")

@router.post("/speech")
async def translate_speech(req: SpeechRequest):
    prompt = f"""Translate this spoken English to Igbo: "{req.text}"
Respond ONLY with valid JSON: {{"igbo": "...", "pronunciation": "..."}}"""
    msg = client.messages.create(model=MODEL, max_tokens=256,
        messages=[{"role": "user", "content": prompt}])
    try:
        return json.loads(strip_fences(msg.content[0].text))
    except Exception:
        raise HTTPException(500, "Failed to parse speech translation")
