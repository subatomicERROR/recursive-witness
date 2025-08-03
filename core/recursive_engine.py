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
