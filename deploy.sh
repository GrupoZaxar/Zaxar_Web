#!/bin/bash

# ==============================================================================
# Script para actualizar el sitio web servido con Nginx
# Versión 3.0 - Profesional y segura.
#
# Uso:
# 1. Asegúrate de que este script está en tu repo.
# 2. Desde la terminal del servidor, ejecuta: sudo bash /var/www/grupozaxar.com/deploy.sh
# ==============================================================================

# --- Configuración ---
# El directorio donde vive la web y el repositorio.
# Hacemos el pull para descargar los últimos cambios.
git pull
echo "-> Repositorio actualizado."
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
