import json, re
from fastapi import APIRouter, HTTPException
from pydantic import BaseModel
from typing import List
from anthropic import Anthropic

router = APIRouter(prefix="/learn", tags=["learn"])
client = Anthropic()
MODEL = "claude-sonnet-4-6"

def strip_fences(text: str) -> str:
    return re.sub(r"```(?:json)?\s*|\s*```", "", text).strip()

class LessonRequest(BaseModel):
    topic: str
    level: str = "beginner"

class WordPair(BaseModel):
    english: str
    igbo: str
    pronunciation: str
    emoji: str = ""

class QuizRequest(BaseModel):
    words: List[WordPair]

@router.post("/cultural-note")
async def cultural_note(req: LessonRequest):
    prompt = f"""Give a short (2-3 sentence) cultural note about "{req.topic}" in Igbo culture.
Be specific and interesting. Plain text only, no markdown."""
    msg = client.messages.create(model=MODEL, max_tokens=200,
        messages=[{"role": "user", "content": prompt}])
    return {"note": msg.content[0].text.strip()}

@router.post("/quiz")
async def generate_quiz(req: QuizRequest):
    words_json = json.dumps([w.model_dump() for w in req.words[:10]])
    prompt = f"""Create 5 multiple-choice quiz questions from these Igbo words: {words_json}

Return ONLY a JSON array (no markdown):
[{{
  "question": "What is the Igbo word for X?",
  "correctAnswer": "...",
  "wrongAnswers": ["...", "...", "..."]
}}]"""
    msg = client.messages.create(model=MODEL, max_tokens=1024,
        messages=[{"role": "user", "content": prompt}])
    try:
        return json.loads(strip_fences(msg.content[0].text))
    except Exception:
        raise HTTPException(500, "Failed to generate quiz")
