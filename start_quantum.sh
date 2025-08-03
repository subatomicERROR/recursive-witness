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
