#!/bin/bash
watch -n 1 "
echo '=== QUANTUM SYSTEM STATUS ===';
echo 'Ollama:    $(pgrep ollama | wc -l) processes';
echo 'API:       $(pgrep -f "python interfaces/api_server.py" | wc -l) processes';
echo 'Discord:   $(pgrep -f "python interfaces/discord_bot.py" | wc -l) processes';
echo 'CPU:       $(top -bn1 | grep "Cpu(s)" | sed "s/.*, *\([0-9.]*\)%* id.*/\1/" | awk '\"{print 100 - \$1}\"')%';
echo 'Memory:    $(free -m | awk '\"/Mem:/ {print \$3/\$2*100}\"')%';
curl -s http://localhost:8888/quantum/status | jq -r '\".quantum_stability + \"% stability\"' 2>/dev/null || echo 'API not responding';
"
