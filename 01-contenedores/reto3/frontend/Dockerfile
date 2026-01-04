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