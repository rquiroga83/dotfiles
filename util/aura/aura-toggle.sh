#!/bin/bash
# Inicia/detiene el agente Aura y carga/descarga el modelo local en Ollama.
# Click 1 (detenido): precarga el modelo en VRAM y arranca el servidor API.
# Click 2 (activo): mata el servidor API y descarga el modelo de VRAM.

AURA_DIR="$HOME/agents/aura"
ENV_FILE="$AURA_DIR/.env"
LOG_FILE="/tmp/aura-agent.log"

PORT=$(grep -oP '(?<=^AURA_PORT=).*' "$ENV_FILE" 2>/dev/null)
PORT=${PORT:-8000}
MODEL=$(grep -oP '(?<=^OLLAMA_MODEL=).*' "$ENV_FILE" 2>/dev/null)
MODEL=${MODEL:-gemma4:e2b}

if curl -s -m 1 "http://localhost:${PORT}/health" >/dev/null 2>&1; then
  # --- Detener: ya está corriendo ---
  pkill -f "${AURA_DIR}/main.py" 2>/dev/null
  ollama stop "$MODEL" 2>/dev/null
  notify-send "Aura" "󰚩 Agente detenido, modelo descargado de VRAM" --icon=dialog-information
  exit 0
fi

# --- Iniciar: no está corriendo ---
# Todo en background para que el click no bloquee a waybar.
(
  notify-send "Aura" "󰚩 Iniciando agente y cargando modelo..." --icon=dialog-information

  # Precarga el modelo sin generar texto: prompt vacío + keep_alive.
  curl -s -m 30 http://localhost:11434/api/generate \
    -d "{\"model\":\"${MODEL}\",\"prompt\":\"\",\"keep_alive\":\"30m\"}" >/dev/null 2>&1

  cd "$AURA_DIR" && nohup .venv/bin/python main.py > "$LOG_FILE" 2>&1 &
  disown

  for i in $(seq 1 15); do
    sleep 1
    if curl -s -m 1 "http://localhost:${PORT}/health" >/dev/null 2>&1; then
      notify-send "Aura" "󰚩 Agente iniciado" --icon=dialog-information
      exit 0
    fi
  done
  notify-send "Aura" "⚠ El agente tardó en iniciar, revisá $LOG_FILE" --icon=dialog-warning
) &
disown
