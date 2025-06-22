#!/bin/bash

# ==============================================================================
# Script para actualizar y reiniciar el servidor web de Zaxar
# Versión 2.0 - Corregido para operar en el directorio web correcto.
#
# Uso:
# 1. Guarda este archivo como /root/update_server.sh
# 2. Dale permisos de ejecución con: chmod +x /root/update_server.sh
# 3. Ejecútalo con: sudo /root/update_server.sh
# ==============================================================================

# --- Configuración ---
# Esta es ahora la única fuente de verdad: el repositorio y la web viven aquí.
WEB_DIR="/root/Zaxar_Web"

# --- Inicio del Script ---
echo "============================================="
echo "Iniciando script de actualización (v2.0)..."
echo "============================================="
echo

# --- 1. Navegar al directorio correcto y actualizar desde Git ---
echo "[Paso 1/3] Navegando a $WEB_DIR y actualizando el código..."
cd "$WEB_DIR" || { echo "Error Crítico: El directorio $WEB_DIR no existe. Abortando."; exit 1; }
git pull
echo "-> Repositorio actualizado en el directorio web."
echo

# --- 2. Matar el proceso antiguo del servidor Python ---
echo "[Paso 2/3] Buscando y deteniendo el servidor Python antiguo..."
if pgrep -f "python3 -m http.server 8000" > /dev/null; then
    pkill -f "python3 -m http.server 8000"
    sleep 1
    echo "-> Servidor antiguo detenido."
else
    echo "-> No se encontró ningún servidor antiguo en ejecución."
fi
echo

# --- 3. Lanzar el nuevo servidor desde el directorio actualizado ---
echo "[Paso 3/3] Lanzando el nuevo servidor desde $WEB_DIR..."
# Nos aseguramos de lanzar el servidor desde dentro del directorio correcto
nohup python3 -m http.server 8000 > /dev/null 2>&1 &
sleep 2

# --- Verificación Final ---
if pgrep -f "python3 -m http.server 8000" > /dev/null; then
    echo "-> ¡Éxito! El nuevo servidor se está ejecutando."
else
    echo "-> ¡Error! No se pudo iniciar el nuevo servidor."
fi
echo
echo "============================================="
echo "Script de actualización finalizado."
echo "=============================================" 