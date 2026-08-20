#!/bin/bash
# Estado del agente Aura (servidor API + modelo local en Ollama)

AURA_DIR="$HOME/agents/aura"
ENV_FILE="$AURA_DIR/.env"

PORT=$(grep -oP '(?<=^AURA_PORT=).*' "$ENV_FILE" 2>/dev/null)
PORT=${PORT:-8000}
MODEL=$(grep -oP '(?<=^OLLAMA_MODEL=).*' "$ENV_FILE" 2>/dev/null)
MODEL=${MODEL:-gemma4:e2b}

if curl -s -m 1 "http://localhost:${PORT}/health" >/dev/null 2>&1; then
  if ollama ps 2>/dev/null | grep -q "^${MODEL}[[:space:]]"; then
    echo "{\"text\":\"󰚩\", \"tooltip\":\"Aura activo — modelo $MODEL cargado\\nClic para detener\", \"class\":\"active\"}"
  else
    echo "{\"text\":\"󰚩\", \"tooltip\":\"Aura activo — modelo $MODEL no está en VRAM todavía\\nClic para detener\", \"class\":\"active\"}"
  fi
else
  echo "{\"text\":\"󰚩\", \"tooltip\":\"Aura detenido\\nClic para iniciar\", \"class\":\"empty\"}"
fi
