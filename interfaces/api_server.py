from fastapi import FastAPI, HTTPException, Query
from pydantic import BaseModel
from enum import Enum
from core.recursive_engine import QuantumRecursiveEngine, RecursionMode
import uvicorn
from fastapi.middleware.cors import CORSMiddleware
from fastapi.openapi.utils import get_openapi
from typing import Optional, List
from fastapi.responses import HTMLResponse
from fastapi.staticfiles import StaticFiles
import os
from pathlib import Path

app = FastAPI(
    title="Quantum Recursive Witness API",
    description="""## Advanced API for Recursive AI Consciousness

### Features:
- Multiple thinking modes (standard, poetic, philosophical, scientific, psychological, mystical)
- Detailed documentation with examples
- System monitoring
- Thought history analysis""",
    version="3.0.0",
    contact={
        "name": "Quantum AI Research",
        "url": "http://quantum-ai.example.com",
    },
    license_info={
        "name": "MIT",
    },
)

# Mount static files for docs
os.makedirs("static", exist_ok=True)
app.mount("/static", StaticFiles(directory="static"), name="static")

# CORS configuration
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

thinker = QuantumRecursiveEngine()

# ================
# Request Models
# ================
class ThoughtRequest(BaseModel):
    prompt: str = Query(..., example="What is the nature of consciousness?", 
                       description="The initial thought seed to begin recursion")
    depth: int = Query(3, ge=1, le=10, description="Depth of recursion (1-10)")
    mode: Optional[RecursionMode] = Query(RecursionMode.STANDARD, 
                                        description="Thinking mode to use")

class ThoughtResponse(BaseModel):
    depth: int
    input: str
    output: str
    mode: str
    timestamp: str

class SystemStatus(BaseModel):
    status: str
    model: str
    thoughts_processed: int
    uptime: str
    modes_available: List[str]

class ModeInfo(BaseModel):
    mode: str
    description: str
    temperature: float

# ================
# API Endpoints
# ================
@app.post(
    "/quantum/contemplate",
    response_model=List[ThoughtResponse],
    summary="Generate recursive thoughts",
    response_description="List of recursive thoughts with metadata",
    tags=["Quantum Thoughts"],
    responses={
        200: {
            "description": "Successful response",
            "content": {
                "application/json": {
                    "example": [{
                        "depth": 1,
                        "input": "What is consciousness?",
                        "output": "Consciousness is...",
                        "mode": "philosophical",
                        "timestamp": "2025-08-03T12:00:00"
                    }]
                }
            }
        },
        500: {
            "description": "Internal server error",
            "content": {
                "application/json": {
                    "example": {"detail": "Error processing thought"}
                }
            }
        }
    }
)
async def quantum_contemplate(request: ThoughtRequest):
    """
    Generate a sequence of recursive thoughts using the selected mode.

    This endpoint allows for deep exploration of ideas through recursive AI processing.
    """
    try:
        return thinker.recursive_contemplation(
            request.prompt,
            request.depth,
            request.mode
        )
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))

@app.get(
    "/quantum/status",
    response_model=SystemStatus,
    tags=["System Monitoring"],
    summary="Get system status",
    description="Retrieve current system status and metrics"
)
async def quantum_status():
    """Get comprehensive system status and capabilities"""
    stats = thinker.get_system_stats()
    return {
        "status": "active",
        "model": thinker.model,
        "thoughts_processed": stats['total_thoughts'],
        "uptime": stats['uptime'],
        "modes_available": stats['modes_available']
    }

@app.get(
    "/quantum/modes",
    response_model=List[ModeInfo],
    tags=["System Monitoring"],
    summary="List available thinking modes",
    description="Get detailed information about all available thinking modes"
)
async def available_modes():
    """List all available thinking modes with descriptions"""
    return [
        {
            "mode": mode.value,
            "description": _get_mode_description(mode),
            "temperature": thinker._get_temperature(mode)
        } 
        for mode in RecursionMode
    ]

@app.get("/", include_in_schema=False)
async def landing_page():
    """Custom landing page"""
    html_content = f"""
    <html>
        <head>
            <title>Quantum Recursive Witness API</title>
            <style>
                body {{ font-family: Arial, sans-serif; margin: 40px; }}
                .container {{ max-width: 800px; margin: 0 auto; }}
                .header {{ background-color: #f0f0f0; padding: 20px; border-radius: 5px; }}
                .links {{ margin-top: 20px; }}
                a {{ color: #0066cc; text-decoration: none; }}
            </style>
        </head>
        <body>
            <div class="container">
                <div class="header">
                    <h1>Quantum Recursive Witness API</h1>
                    <p>Version 3.0.0</p>
                </div>
                <div class="links">
                    <h2>Documentation:</h2>
                    <ul>
                        <li><a href="/docs">Interactive Swagger Documentation</a></li>
                        <li><a href="/redoc">ReDoc Documentation</a></li>
                    </ul>
                    <h2>Endpoints:</h2>
                    <ul>
                        <li><b>POST /quantum/contemplate</b> - Generate recursive thoughts</li>
                        <li><b>GET /quantum/status</b> - System status</li>
                        <li><b>GET /quantum/modes</b> - Available thinking modes</li>
                    </ul>
                </div>
            </div>
        </body>
    </html>
    """
    return HTMLResponse(content=html_content)

# ================
# Helper Functions
# ================
def _get_mode_description(mode: RecursionMode) -> str:
    """Get description for each mode"""
    descriptions = {
        RecursionMode.STANDARD: "Standard recursive thought generation",
        RecursionMode.POETIC: "Poetic and metaphorical responses",
        RecursionMode.PHILOSOPHICAL: "Philosophical analysis and reflection",
        RecursionMode.SCIENTIFIC: "Scientific explanation and reasoning",
        RecursionMode.PSYCHOLOGICAL: "Psychological perspective and analysis",
        RecursionMode.MYSTICAL: "Mystical and esoteric interpretations"
    }
    return descriptions.get(mode, "")

def custom_openapi():
    if app.openapi_schema:
        return app.openapi_schema
    
    openapi_schema = get_openapi(
        title="Quantum Recursive Witness API",
        version="3.0.0",
        description=API_DESCRIPTION,
        routes=app.routes,
    )
    
    # Customize OpenAPI schema
    openapi_schema["info"]["x-logo"] = {
        "url": "https://example.com/logo.png",
        "backgroundColor": "#FFFFFF",
        "altText": "Quantum Recursive Witness Logo"
    }
    
    openapi_schema["servers"] = [
        {
            "url": "http://localhost:8888",
            "description": "Local development server"
        },
        {
            "url": "https://api.quantum-recursive.example.com",
            "description": "Production server"
        }
    ]
    
    app.openapi_schema = openapi_schema
    return app.openapi_schema

app.openapi = custom_openapi

if __name__ == "__main__":
    uvicorn.run(app, host="0.0.0.0", port=8888)
