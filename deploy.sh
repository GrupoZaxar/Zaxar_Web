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
WEB_DIR="/var/www/grupozaxar.com"

# --- Inicio del Script ---
echo "======================================================"
echo "Iniciando script de despliegue para Nginx (v3.0)..."
echo "======================================================"
echo

# --- 1. Navegar al directorio correcto y actualizar desde Git ---
echo "[Paso 1/3] Navegando a $WEB_DIR y actualizando el código..."
cd "$WEB_DIR" || { echo "Error Crítico: El directorio $WEB_DIR no existe. Abortando."; exit 1; }

# Hacemos el pull para descargar los últimos cambios.
git pull
echo "-> Repositorio actualizado."
echo

# --- 2. Ajustar los permisos para Nginx ---
# Después de un 'git pull', algunos archivos pueden haber sido creados por el
# usuario root. Este comando asegura que el usuario de Nginx ('www-data')
# sea el dueño de todos los archivos y pueda leerlos.
echo "[Paso 2/3] Corrigiendo permisos para el usuario www-data..."
chown -R www-data:www-data "$WEB_DIR"
echo "-> Permisos de archivo asignados a Nginx."
echo

# --- 3. Reiniciar Nginx ---
# Esto no siempre es necesario para cambios en archivos estáticos (HTML/CSS/JS),
# pero es una buena práctica para asegurar que todo se recarga correctamente.
echo "[Paso 3/3] Reiniciando Nginx para aplicar los cambios..."
systemctl restart nginx
echo "-> Nginx reiniciado."
echo

# --- Verificación Final ---
echo "Comprobando el estado de Nginx..."
# 'systemctl is-active' es una forma rápida de ver si el servicio está corriendo.
if systemctl is-active --quiet nginx; then
    echo "-> ¡Éxito! Nginx está activo y los cambios deberían estar online."
else
    echo "-> ¡ERROR! Nginx no se pudo iniciar. Revisa los logs con 'sudo journalctl -u nginx -e'."
fi
echo
echo "======================================================"
echo "Script de despliegue finalizado."
echo "======================================================" 