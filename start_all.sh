#!/bin/bash
source venv/bin/activate
# Ensure Ollama is running
if ! pgrep -x "ollama" > /dev/null; then
    echo "🚀 Starting Ollama service..."
    ollama serve > logs/ollama.log 2>&1 &
    sleep 5
fi
nohup python interfaces/api_server.py > logs/api.log 2>&1 &
nohup python interfaces/discord_bot.py > logs/bot.log 2>&1 &
echo "Recursive Witness systems online"
echo "API: http://localhost:8888"
echo "Discord bot ready for !think commands"
