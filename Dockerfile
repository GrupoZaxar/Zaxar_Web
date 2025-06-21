# Usar una imagen oficial de Python como imagen base
FROM python:3.9-slim

# Establecer el directorio de trabajo en el contenedor
WORKDIR /app

# Copiar los archivos de la aplicación al directorio de trabajo del contenedor
COPY . /app/

# Exponer el puerto 80 para que sea accesible desde fuera del contenedor
EXPOSE 80

# Ejecutar el servidor HTTP de Python cuando se inicie el contenedor
CMD ["python", "-m", "http.server", "80"] 