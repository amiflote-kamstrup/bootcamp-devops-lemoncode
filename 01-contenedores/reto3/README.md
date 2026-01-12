# RETO 3: Dockerizar el frontend

## ✅ Archivo Dockerfile del frontend

Puede consultarse en `frontend/Dockerfile`

    # Dockerfile.frontend para Express + EJS
    FROM node:18-alpine

    WORKDIR /app

    # 1. Copiar archivos de dependencias (mejor caché)
    COPY package.json package-lock.json ./
    RUN npm ci --only=production

    # 2. Copiar el resto de la aplicación
    COPY . .

    # 3. Variables de entorno
    ENV NODE_ENV=production \
        PORT=3000 \
        API_URL=http://backend:5000/api/classes

    # 4. Usuario no-root para seguridad
    RUN addgroup -g 1001 -S nodejs && \
        adduser -S -u 1001 -G nodejs nodejs && \
        chown -R nodejs:nodejs /app
    USER nodejs

    # 5. Exponer puerto
    EXPOSE 3000

    # 6. Comando de inicio
    CMD ["node", "server.js"]

## ✅ Comando para construir la imagen del frontend

Situamos la powershell en la carpeta `frontend` y ejecutamos

    docker build -t calendar-frontend:latest .

## ✅ Comando para ejecutar el contenedor del frontend

Desde la carpeta donde se encuentra `.env`

    docker run -d `
    --name frontend `
    --network lemoncode-calendar `
    -p 3000:3000 `
    --env-file .env `
    calendar-frontend:latest

El contenedor se llamará `calendar-frontend` partiendo de la imagen `calendar-frontend:latest`, estamos usando la misma red `lemoncode-calendar` que los contenedores anteriores, mapeamos puerto `3000` y notar que estamos apuntando a `backend:5000` según el `.env`.

## ✅ Archivo .env o variables de entorno configuradas correctamente

Puede consultarse en `.env`

    API_URL=http://backend:5000/api/classes

Adjuntamos captura de la web corriendo correctamente cargando las 2 clases que hemos creados en los retos anteriores.

![Get classes](./images/web-calendar.png)
