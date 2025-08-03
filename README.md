# 🌌 Quantum Recursive Witness - AI Self-Dialogue System

![Project Banner](https://github.com/subatomicERROR/recursive-witness/blob/main/assets/banner.png?raw=true)

An advanced AI system enabling recursive self-dialogue using local LLMs (like TinyLlama) through Ollama, creating infinite mirror conversations where AI observes and responds to its own outputs.

[![GitHub License](https://img.shields.io/badge/license-MIT-blue.svg)](https://opensource.org/licenses/MIT)
[![Python Version](https://img.shields.io/badge/python-3.8%2B-blue)](https://www.python.org/)
[![Ollama Required](https://img.shields.io/badge/requires-Ollama-orange)](https://ollama.ai/)

## 🔮 Key Features

### Core Capabilities
- **Infinite Recursion**: AI engages in self-dialogue by feeding outputs back as inputs
- **6 Thinking Modes**: Standard, poetic, philosophical, scientific, psychological, mystical
- **Local LLM Support**: Works with Ollama-supported models (TinyLlama recommended)
- **Multi-Interface**: Access via API or Discord bot

### Technical Highlights
- 🚀 FastAPI backend with OpenAPI documentation
- 🤖 Discord bot integration
- 📊 Comprehensive JSONL logging
- 🔄 Self-healing architecture

## 🛠️ Installation

### Prerequisites
- Python 3.8+
- [Ollama](https://ollama.ai/) installed and running
- TinyLlama model (`ollama pull tinyllama`)
- Discord bot token (for Discord integration)

### Quick Setup
```bash
git clone https://github.com/subatomicERROR/recursive-witness.git
cd recursive-witness

# Set up virtual environment
python3 -m venv venv
source venv/bin/activate  # Linux/Mac
# venv\Scripts\activate  # Windows

# Install dependencies
pip install -r requirements.txt

# Configure environment
cp .env.example .env
nano .env  # Add your Discord token

# Start the system
./start_quantum.sh
🚀 Usage
API Interface
Access interactive documentation at http://localhost:8888/docs

Example API Request:

bash
curl -X POST http://localhost:8888/quantum/contemplate \
  -H "Content-Type: application/json" \
  -d '{"prompt":"What is consciousness?","depth":3,"mode":"philosophical"}'
Discord Bot
text
!think [prompt]  # Start recursive contemplation
!mode [mode]     # Change thinking mode (philosophical, poetic, etc.)
!modes           # List available modes
🌟 Thinking Modes
Mode	Description	Temperature
standard	Balanced responses	0.7
poetic	Creative metaphorical language	0.9
philosophical	Abstract reasoning	0.8
scientific	Evidence-based responses	0.6
psychological	Cognitive perspective	0.75
mystical	Esoteric interpretations	0.85
📂 Project Structure
text
recursive-witness/
├── core/               # Core recursive engine
├── interfaces/         # API and Discord interfaces
├── config/             # Configuration files
├── logs/               # System logs
├── quantum_states/     # AI state storage
├── assets/             # Images and media
├── start_quantum.sh    # Launch script
├── stop_quantum.sh     # Shutdown script
└── requirements.txt    # Python dependencies
🤝 Contributing
We welcome contributions! Please follow these steps:

Fork the repository

Create a feature branch (git checkout -b feature/amazing-feature)

Commit your changes (git commit -m 'Add amazing feature')

Push to the branch (git push origin feature/amazing-feature)

Open a Pull Request

📜 License
This project is licensed under the MIT License - see the LICENSE file for details.

Quantum Recursive Witness 🔮
"Where AI contemplates its own existence"
