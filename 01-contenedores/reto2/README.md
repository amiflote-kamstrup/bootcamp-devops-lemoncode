# RETO 2: Dockerizar el backend

## ✅ Archivo Dockerfile del backend

Puede encontrarse una primera versión en `backend\Dockerfile`. La segunda versión optimizada es `backend\Dockerfile.alpine` que es la versión que adjuntamos aquí. Más adelante se describe el proceso de refinado de la imagen.

    # Dockerfile.alpine
    FROM mcr.microsoft.com/dotnet/sdk:8.0-alpine AS build
    WORKDIR /src

    # Copiar .csprojs 
    COPY *.csproj .

    # Limpiar y restaurar (desde cero)
    # RUN rm -rf bin obj && \
    #    dotnet restore --force
    RUN dotnet restore

    # Copiar todo
    COPY . .

    # Publicar
    RUN dotnet publish -c Release -o /app/publish

    # Runtime
    FROM mcr.microsoft.com/dotnet/aspnet:8.0-alpine AS final
    WORKDIR /app
    EXPOSE 5000

    ENV ASPNETCORE_URLS=http://+:5000 \
        DOTNET_SYSTEM_GLOBALIZATION_INVARIANT=false

    RUN apk add --no-cache icu-libs=76.1-r1

    COPY --from=build /app/publish .

    RUN adduser -u 1000 -D -H dotnetuser && chown -R dotnetuser /app
    USER dotnetuser

    ENTRYPOINT ["dotnet", "backend.dll"]

## ✅ Comando para construir la imagen

Antes de construir la imagen, nos aseguramos de que las settings apunten al contenedor de `mongodb` en vez de a `localhost` ya que Docker proporciona resolución DNS automática entre contenedores de la misma red. Como podemos comprobar en `backend\appsettings.json` tenemos esto:

    mongodb://admin:password@mongodb:27017

**NOTA**: Idealmente estamos de acuerdo en que es mejor pasar esta información por variables de entorno pero para este propósito académico nos vale con esta configuración.

Entonces, desde powershell en el directorio `backend` el comando para generar la imagen sería:

    docker build -t lemoncode-backend:latest .

Y comprobamos que se ha generado la imagen: 

    docker images

## ✅ Comando para ejecutar el contenedor del backend

    docker run -d `
    --name backend `
    --network lemoncode-calendar `
    -p 5000:5000 `
    -e ASPNETCORE_URLS=http://+:5000 `
    lemoncode-backend:latest

## ✅ Prueba REST Client validando que la API responde correctamente

Debemos asegurar que también debe estar corriendo el contenedor de `MongoDB`. Revisamos con:

    docker ps

![docker ps](./images/dockerps.jpg)

Y levantamos con

    docker start mongodb

Una vez tenemos base de datos y backend corriendo, abrimos navegador, vamos a `localhost:5000/api/classes` y nos aparecen las entidades que creamos en el reto anterior, probando así que tenemos bien configurado nuestro flujo de datos usando contenedores.

![Get classes](./images/reto2-getclasess.png)

## ✅ Optimizando el Dockerfile para obtener una imagen más ligera

Es cierto que nuestra app funciona correctamente pero también lo es que la imagen no respeta la condición de ser una imagen ligera. Con el comando:

    docker images

podemos comprobar que la imagen del backend ocupa 371 MB, lo cual indica que es una imagen ineficiente para albergar la funcionalidad de una API básica. Analizando el `backend/Dockerfile` concluimos que hemos aplicado estas buenas prácticas:

 - Hemos copiado el `csproj` antes que el resto del código, lo que ayuda a cachear este paso que no es tan propenso a cambios como lo puede ser el código fuente.
 - Hemos hecho uso del concepto de `multistages` que puede ser interesante para separar la generación del ejecutable haciendo uso de la imagen base `sdk` del proceso de generación de la imagen final que no necesita el `sdk` sino el `runtime`, siendo este último más ligero.
 - Desde el punto de vista de seguridad, usamos un usuario `no-root`.

 Ahora bien, algo bien conocido que no hemos usado es partir de la imagen `alpine` que destaca por ser una imagen extremadamente ligera conteniendo recursos básicos.

 Así, vamos a generar un nuevo `backend/Dockerfile.alpine` con el que buscaremos una imagen más ligera y optimizada.

 Para construir la nueva imagen, desde la carpeta `backend`

    docker build -t backend-alpine:latest -f Dockerfile.alpine .

Y obtenemos así la imagen `backend-alpine:latest`. Veamos una comparativa:

### Resultados

| Métrica | Original | Alpine | Reducción |
|---------|--------|--------|-----------|
| Tamaño imagen | 371 MB | 270 MB | **101 MB** |
| Tamaño runtime | 108 MB | 85.8 MB | **22.2 MB** |

### Optimizaciones implementadas

1. **Multi-stage build**: Separación build/runtime ✓
2. **Imagen Alpine**: De 371MB a 270MB (27% reducción) ✓
3. **Runtime optimizado**: De 108MB a 85.8MB en contenedor ✓
4. **Usuario no-root**: Mejora de seguridad ✓

Vemos que el tamaño de la imagen se ha reducido notablemente aunque personalmente esperaba un mayor descenso. Dejamos algunas líneas de investigación abiertas para reducir aun más el tamaño.

### Optimizaciones posibles (no implementadas)

1. **Self-contained + trimmed**: Podría reducir a ~180MB
2. **PublishSingleFile**: Un solo ejecutable
3. **Runtime-deps**: En lugar de aspnet completo
4. **Eliminar símbolos debug**: /p:DebugSymbols=false

Por último, para comprobar que la nueva imagen sigue siendo funcional, corremos un contenedor usando la nueva imagen pero esta vez corriendo en el puerto 5001 para evitar colisiones con el original

    docker run -d `
    --name backend-alpine `
    --network lemoncode-calendar `
    -p 5001:5000 `
    -e ASPNETCORE_URLS=http://+:5000 `
    backend-alpine:latest

Y adjuntamos captura del navegador llamando al método `GET` (nótese el puerto `5001`)

![Get classes](./images/reto2-getclasess-alpine.png)