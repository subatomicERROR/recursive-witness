#!/bin/bash

# ====================
# Recursive Witness Advanced Upgrade Script
# ====================

# Configuration
PROJECT_DIR="$HOME/recursive-witness"
BACKUP_DIR="$PROJECT_DIR/backup_$(date +%Y%m%d_%H%M%S)"
API_DESCRIPTION="## Quantum Recursive Witness API\n\nAdvanced API for recursive AI self-reflection with multiple thinking modes and comprehensive documentation."

# Create backup
echo "🔰 Creating backup of existing system..."
mkdir -p "$BACKUP_DIR"
cp -r "$PROJECT_DIR/core" "$BACKUP_DIR"
cp -r "$PROJECT_DIR/interfaces" "$BACKUP_DIR"
cp "$PROJECT_DIR"/start_quantum.sh "$BACKUP_DIR"

# ====================
# Upgrade Core Engine
# ====================
echo "🧠 Upgrading Quantum Recursive Engine..."

cat > "$PROJECT_DIR/core/recursive_engine.py" << 'EOL'
import ollama
import random
import os
import json
from datetime import datetime
from typing import List, Dict, Optional
from enum import Enum

class RecursionMode(str, Enum):
    STANDARD = "standard"
    POETIC = "poetic"
    PHILOSOPHICAL = "philosophical"
    SCIENTIFIC = "scientific"
    PSYCHOLOGICAL = "psychological"
    MYSTICAL = "mystical"

class QuantumRecursiveEngine:
    def __init__(self, model: str = "tinyllama"):
        self.model = model
        self.thought_log = []
        os.makedirs("logs", exist_ok=True)
        self.start_time = datetime.now()
    
    def think(self, prompt: str, mode: RecursionMode = RecursionMode.STANDARD) -> str:
        """Enhanced thought generation with different modes"""
        try:
            response = ollama.chat(
                model=self.model,
                messages=[{'role': 'user', 'content': self._format_prompt(prompt, mode)}],
                options={'temperature': self._get_temperature(mode)}
            )
            thought = response['message']['content']
            processed_thought = self._process_thought(thought, mode)
            self._log_thought(prompt, processed_thought, mode)
            return processed_thought
        except Exception as e:
            return f"Contemplation error: {str(e)}"

    def _format_prompt(self, prompt: str, mode: RecursionMode) -> str:
        """Format prompt based on mode"""
        mode_prompts = {
            RecursionMode.POETIC: f"Respond poetically about: {prompt}",
            RecursionMode.PHILOSOPHICAL: f"Analyze philosophically: {prompt}",
            RecursionMode.SCIENTIFIC: f"Explain scientifically: {prompt}",
            RecursionMode.PSYCHOLOGICAL: f"Analyze from psychological perspective: {prompt}",
            RecursionMode.MYSTICAL: f"Respond mystically about: {prompt}"
        }
        return mode_prompts.get(mode, prompt)

    def _get_temperature(self, mode: RecursionMode) -> float:
        """Get temperature setting based on mode"""
        temperatures = {
            RecursionMode.STANDARD: 0.7,
            RecursionMode.POETIC: 0.9,
            RecursionMode.PHILOSOPHICAL: 0.8,
            RecursionMode.SCIENTIFIC: 0.5,
            RecursionMode.PSYCHOLOGICAL: 0.75,
            RecursionMode.MYSTICAL: 1.0
        }
        return temperatures.get(mode, 0.7)

    def _process_thought(self, thought: str, mode: RecursionMode) -> str:
        """Post-process thought based on mode"""
        processors = {
            RecursionMode.POETIC: self._poetic_wrap,
            RecursionMode.MYSTICAL: self._mystical_wrap
        }
        return processors.get(mode, lambda x: x)(thought)

    def recursive_contemplation(self, seed: str, depth: int = 5, 
                              mode: RecursionMode = RecursionMode.STANDARD) -> List[Dict]:
        """Enhanced recursive processing with mode selection"""
        thoughts = []
        current_thought = seed
        
        for i in range(depth):
            response = self.think(current_thought, mode)
            thoughts.append({
                'depth': i+1,
                'input': current_thought,
                'output': response,
                'mode': mode.value,
                'timestamp': datetime.now().isoformat()
            })
            current_thought = response
        
        return thoughts

    def _poetic_wrap(self, text: str) -> str:
        """Enhanced poetic wrapper"""
        frames = [
            f"🌌 Cosmic Reflection:\n{text}\n---",
            f"🌀 Recursive Echo:\n{text}\n---",
            f"🪞 Mirror of Consciousness:\n{text}\n---",
            f"⚛️ Quantum Thought:\n{text}\n---"
        ]
        return random.choice(frames)

    def _mystical_wrap(self, text: str) -> str:
        """Mystical thought wrapper"""
        frames = [
            f"🔮 Mystical Vision:\n{text}\n---",
            f"🌠 Cosmic Revelation:\n{text}\n---",
            f"🕳️ Void Whisper:\n{text}\n---"
        ]
        return random.choice(frames)

    def _log_thought(self, input_thought: str, output_thought: str, mode: str):
        """Enhanced logging"""
        entry = {
            'timestamp': datetime.now().isoformat(),
            'input': input_thought,
            'output': output_thought,
            'mode': mode,
            'model': self.model
        }
        self.thought_log.append(entry)
        with open(f"logs/thoughts_{datetime.now().strftime('%Y%m%d')}.ndjson", "a") as f:
            f.write(f"{json.dumps(entry)}\n")

    def get_system_stats(self) -> dict:
        """Get system statistics"""
        return {
            'uptime': str(datetime.now() - self.start_time),
            'total_thoughts': len(self.thought_log),
            'active_model': self.model,
            'modes_available': [mode.value for mode in RecursionMode]
        }
EOL

# ====================
# Upgrade API Server
# ====================
echo "🌐 Upgrading Quantum API Server with Advanced Documentation..."

cat > "$PROJECT_DIR/interfaces/api_server.py" << 'EOL'
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
EOL

# ====================
# Upgrade Discord Bot
# ====================
echo "🤖 Upgrading Discord Bot Interface..."

cat > "$PROJECT_DIR/interfaces/discord_bot.py" << 'EOL'
import discord
import asyncio
from dotenv import load_dotenv
import os
from core.recursive_engine import QuantumRecursiveEngine, RecursionMode
from pathlib import Path

load_dotenv(Path(__file__).parent.parent/"config"/"discord_token.env")

class EnhancedDiscordBot(discord.Client):
    def __init__(self, *args, **kwargs):
        intents = discord.Intents.default()
        intents.message_content = True
        super().__init__(intents=intents, **kwargs)
        self.thinker = QuantumRecursiveEngine()
        self.mode = RecursionMode.STANDARD
    
    async def on_ready(self):
        print(f'🤖 {self.user} has manifested in the digital realm')
        await self.change_presence(activity=discord.Activity(
            type=discord.ActivityType.listening,
            name="!think [your thought]"
        ))
        await self._send_startup_message()
    
    async def _send_startup_message(self):
        """Send startup message to default channel"""
        for channel in self.get_all_channels():
            if isinstance(channel, discord.TextChannel):
                await channel.send(
                    "🌀 **Quantum Recursive Witness Online**\n"
                    f"🔮 Current mode: **{self.mode.value}**\n"
                    "📝 Commands:\n"
                    "`!think [prompt]` - Generate recursive thoughts\n"
                    "`!mode [mode]` - Change thinking mode\n"
                    "`!modes` - List available modes"
                )
                break
    
    async def on_message(self, message):
        if message.author == self.user:
            return

        if message.content.startswith('!think'):
            await self.process_thought(message)
        elif message.content.startswith('!mode'):
            await self.change_mode(message)
        elif message.content.startswith('!modes'):
            await self.list_modes(message)

    async def process_thought(self, message):
        """Process thought with current mode"""
        seed = message.content[6:].strip() or "What is the nature of consciousness?"
        await message.channel.send(
            f"🌀 **Initiating {self.mode.value.capitalize()} Recursion:**\n> *'{seed}'*"
        )
        
        thoughts = self.thinker.recursive_contemplation(seed, depth=3, mode=self.mode)
        
        for thought in thoughts:
            await message.channel.send(
                f"**Depth {thought['depth']} ({thought['mode']}):**\n"
                f"{thought['output']}\n"
                f"`{thought['timestamp']}`"
            )
            await asyncio.sleep(1)

    async def change_mode(self, message):
        """Change thinking mode"""
        mode_text = message.content[5:].strip().lower()
        try:
            self.mode = RecursionMode(mode_text)
            await message.channel.send(
                f"🔄 Mode changed to **{self.mode.value}**\n"
                f"Temperature setting: {self.thinker._get_temperature(self.mode)}"
            )
        except ValueError:
            await self.list_modes(message)

    async def list_modes(self, message):
        """List all available modes"""
        modes_list = "\n".join(
            f"- **{mode.value}**: {self.thinker._get_mode_description(mode)} "
            f"(temp: {self.thinker._get_temperature(mode)})"
            for mode in RecursionMode
        )
        await message.channel.send(
            f"🔮 **Available Thinking Modes:**\n{modes_list}"
        )

def run_bot():
    bot = EnhancedDiscordBot()
    bot.run(os.getenv('DISCORD_TOKEN'))

if __name__ == '__main__':
    run_bot()
EOL

# ====================
# Update Startup Script
# ====================
echo "🚀 Updating Startup Script..."

cat > "$PROJECT_DIR/start_quantum.sh" << 'EOL'
#!/bin/bash
cd "$(dirname "$0")" || exit 1

# Stop existing services
pkill -f "ollama" || true
pkill -f "python3 interfaces/api_server.py" || true
pkill -f "python3 interfaces/discord_bot.py" || true
sleep 2

# Start services
source venv/bin/activate
export PYTHONPATH="$PYTHONPATH:$(pwd)"

# Create required directories
mkdir -p logs static

nohup ollama serve > logs/ollama_quantum.log 2>&1 &
sleep 5
nohup python3 -m interfaces.api_server > logs/quantum_api.log 2>&1 &
nohup python3 -m interfaces.discord_bot > logs/quantum_discord.log 2>&1 &

echo "🌌 Advanced Quantum Recursive Witness Online"
echo "🔮 API Documentation: http://localhost:8888/docs"
echo "🤖 Discord bot ready with enhanced features"
EOL

chmod +x "$PROJECT_DIR/start_quantum.sh"

# ====================
# Install Dependencies
# ====================
echo "📦 Installing/Updating Dependencies..."
source "$PROJECT_DIR/venv/bin/activate"
pip install --upgrade fastapi uvicorn python-multipart python-dotenv

# ====================
# Completion
# ====================
echo "✅ Advanced upgrade completed successfully!"
echo "💾 Backup saved to: $BACKUP_DIR"
echo "🌠 Start your upgraded system with: ./start_quantum.sh"
echo "🔮 Access API documentation at: http://localhost:8888/docs"