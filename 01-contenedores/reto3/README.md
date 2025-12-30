# RETO 3: Dockerizar el frontend

## ✅ Archivo Dockerfile del frontend

Puede consultarse en `frontend/Dockerfile`

## ✅ Comando para construir la imagen del frontend

Situamos la powershell en la carpeta `frontend` y ejecutamos

    docker build -t calendar-frontend:latest .

## ✅ Comando para ejecutar el contenedor del frontend

    docker run -d `
    --name frontend `
    --network lemoncode-calendar `
    -p 3000:3000 `
    --env-file .env `
    calendar-frontend:latest

El contenedor se llamará `frontend`, estamos usando la misma red `lemoncode-calendar` que los contenedores anteriores, mapeamos puerto `3000` y notar que estamos apuntando a `backend-alpine:5000` según el `.env` que es el contenedor que usaba la imagen más optimizada.

## ✅ Archivo .env o variables de entorno configuradas correctamente

Puede consultarse en `.env`

Adjuntamos captura de la web corriendo correctamente cargando las 2 clases que hemos creados en los retos anteriores.

![Get classes](./images/web-calendar.png)
