#!/bin/bash

# ==============================================================================
# Script para actualizar y reiniciar el servidor web de Zaxar
#
# Uso:
# 1. Guarda este archivo como /root/update_server.sh
# 2. Dale permisos de ejecución con: chmod +x /root/update_server.sh
# 3. Ejecútalo con: sudo /root/update_server.sh
# ==============================================================================

# --- Configuración ---
# Asegúrate de que esta es la ruta correcta a la carpeta que contiene tu .git
REPO_DIR="/root/Zaxar_Web"

# --- Inicio del Script ---
echo "============================================="
echo "Iniciando script de actualización del servidor..."
echo "============================================="
echo

# --- 1. Actualizar el código desde el repositorio de Git ---
echo "[Paso 1/3] Navegando a $REPO_DIR y actualizando el código..."
cd "$REPO_DIR" || { echo "Error Crítico: El directorio $REPO_DIR no existe. Abortando."; exit 1; }
git pull
echo "-> Repositorio actualizado."
echo

# --- 2. Matar cualquier proceso antiguo del servidor Python ---
# Usamos 'pkill -f' para buscar y matar cualquier proceso que coincida con
# la cadena de comando completa. Es más seguro que 'ps | grep | kill'.
echo "[Paso 2/3] Buscando y deteniendo el servidor Python antiguo..."
if pgrep -f "python3 -m http.server 8000" > /dev/null; then
    pkill -f "python3 -m http.server 8000"
    sleep 1 # Damos un segundo para que el proceso termine limpiamente
    echo "-> Servidor antiguo detenido."
else
    echo "-> No se encontró ningún servidor antiguo en ejecución. Perfecto."
fi
echo

# --- 3. Lanzar el nuevo servidor en segundo plano ---
echo "[Paso 3/3] Lanzando el nuevo servidor actualizado en el puerto 8000..."
# 'nohup' asegura que el proceso siga corriendo aunque cierres la sesión.
# '&' lo ejecuta en segundo plano.
# '>/dev/null 2>&1' evita que se cree el archivo 'nohup.out' y redirige toda
# la salida (normal y de error) al vacío para no generar basura.
nohup python3 -m http.server 8000 > /dev/null 2>&1 &
sleep 2 # Esperamos un par de segundos para que el servidor arranque

# --- Verificación Final ---
if pgrep -f "python3 -m http.server 8000" > /dev/null; then
    echo "-> ¡Éxito! El nuevo servidor se está ejecutando en segundo plano."
else
    echo "-> ¡Error! No se pudo iniciar el nuevo servidor. Revisa si hay algún problema."
fi
echo
echo "============================================="
echo "Script de actualización finalizado."
echo "=============================================" 