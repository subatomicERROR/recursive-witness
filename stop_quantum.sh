#!/bin/bash
cd "$(dirname "$0")" || exit 1
pkill -f "ollama" || true
pkill -f "python3 interfaces/api_server.py" || true
pkill -f "python3 interfaces/discord_bot.py" || true
echo "🌑 All quantum processes terminated"
