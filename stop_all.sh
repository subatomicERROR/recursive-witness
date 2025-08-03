#!/bin/bash
source venv/bin/activate
pkill -f "python interfaces/api_server.py"
pkill -f "python interfaces/discord_bot.py"
echo "Recursive Witness systems offline"
