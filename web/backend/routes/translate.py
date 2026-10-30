import base64, json, re
from fastapi import APIRouter, HTTPException, UploadFile, File
from starlette.concurrency import run_in_threadpool
from pydantic import BaseModel, Field
from anthropic import Anthropic

router = APIRouter(prefix="/translate", tags=["translate"])
client = Anthropic()
MODEL = "claude-sonnet-4-6"

# Supported Igbo dialects. "izugbe" = Standard Literary Igbo (the default,
# taught in schools and used in most reference material). The others are
# major regional varieties; output for them is best-effort and flagged in
# the UI as experimental.
DIALECTS = {
    "izugbe":  "Standard Igbo (Igbo Izugbe), the central literary standard",
    "onitsha": "the Onitsha dialect of Igbo (Anambra riverine)",
    "owerri":  "the Owerri dialect of Igbo (Imo/central)",
    "nsukka":  "the Nsukka/Enugu (Waawa) dialect of Igbo",
    "enuani":  "the Enuani/Delta (West Niger) dialect of Igbo",
}


def strip_fences(text: str) -> str:
    return re.sub(r"```(?:json)?\s*|\s*```", "", text).strip()


def dialect_clause(dialect: str) -> str:
    desc = DIALECTS.get(dialect, DIALECTS["izugbe"])
    return desc


class TextRequest(BaseModel):
    text: str = Field(min_length=1, max_length=2000)
    dialect: str = "izugbe"


class SpeechRequest(BaseModel):
    text: str = Field(min_length=1, max_length=2000)
    dialect: str = "izugbe"


@router.post("/text")
def translate_text(req: TextRequest):
    prompt = f"""You are an expert Igbo linguist and translator. Translate the following English text into {dialect_clause(req.dialect)}.

English: "{req.text}"

Rules:
- Use correct Igbo orthography with ALL diacritics and tone/dot marks (ị, ọ, ụ, ṅ, and sub-dot vowels) exactly as standard written Igbo requires.
- Prefer natural, idiomatic Igbo over word-for-word calques.
- If the phrase has a well-known Igbo equivalent, use it.
- Keep the register appropriate (respectful/plural forms where English implies politeness).

Respond ONLY with valid JSON (no markdown, no commentary):
{{
  "igbo": "the translation with full diacritics",
  "pronunciation": "syllable-by-syllable guide, e.g. nah-MAH",
  "tones": "brief note on tone (high/low/down-step) where it matters for meaning",
  "example": "a natural Igbo example sentence using the word/phrase (optional)",
  "exampleTranslation": "English translation of the example (optional)"
}}"""
    msg = client.messages.create(model=MODEL, max_tokens=600,
        messages=[{"role": "user", "content": prompt}])
    try:
        return json.loads(strip_fences(msg.content[0].text))
    except Exception:
        raise HTTPException(500, "Failed to parse translation")


@router.post("/image")
async def translate_image(file: UploadFile = File(...)):
    if file.content_type not in {"image/jpeg", "image/png", "image/webp", "image/gif"}:
        raise HTTPException(415, "Upload a JPEG, PNG, WebP, or GIF image")
    data = await file.read(5 * 1024 * 1024 + 1)
    if len(data) > 5 * 1024 * 1024:
        raise HTTPException(413, "Image must be 5 MB or smaller")
    if not data:
        raise HTTPException(400, "Image is empty")
    b64 = base64.standard_b64encode(data).decode()
    media_type = file.content_type or "image/jpeg"

    prompt = """Identify the main objects in this image and give their names in Standard Igbo (Igbo Izugbe).
Use correct Igbo orthography with all diacritics and sub-dot marks.
Return ONLY a JSON array (no markdown), max 8 items:
[{"english":"...", "igbo":"...", "pronunciation":"...", "emoji":"..."}]"""

    msg = await run_in_threadpool(
        client.messages.create, model=MODEL, max_tokens=1024,
        messages=[{"role": "user", "content": [
            {"type": "image", "source": {"type": "base64", "media_type": media_type, "data": b64}},
            {"type": "text", "text": prompt}
        ]}])
    try:
        return json.loads(strip_fences(msg.content[0].text))
    except Exception:
        raise HTTPException(500, "Failed to parse image translation")


@router.post("/speech")
def translate_speech(req: SpeechRequest):
    prompt = f"""Translate this spoken English into {dialect_clause(req.dialect)}.
Use correct Igbo orthography with all diacritics.
English: "{req.text}"
Respond ONLY with valid JSON: {{"igbo": "...", "pronunciation": "..."}}"""
    msg = client.messages.create(model=MODEL, max_tokens=300,
        messages=[{"role": "user", "content": prompt}])
    try:
        return json.loads(strip_fences(msg.content[0].text))
    except Exception:
        raise HTTPException(500, "Failed to parse speech translation")
