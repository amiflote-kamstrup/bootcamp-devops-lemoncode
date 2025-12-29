# RETO 2: Dockerizar el backend

## ✅ Archivo Dockerfile del backend

Puede encontrarse en `backend\Dockerfile`

## ✅ Comando para construir la imagen

Antes de construir la imagen (DEBE HABER UNA FORMA MÁS LIMPIA!!), nos aseguramos de que las settings apunten al contenedor de `mongodb` en vez de a `localhost`. Como podemos comprobar en `backend\appsettings.json` tenemos esto:

    mongodb://admin:password@mongodb:27017

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
    calendar-backend:latest

## ✅ Prueba REST Client validando que la API responde correctamente

Debemos asegurar que también debe estar corriendo el contenedor de `MongoDB`. Revisamos con:

    docker ps

Y levantamos con

    docker start mongodb

Una vez tenemos base de datos y backend corriendo, abrimos navegador, vamos a `localhost:5000/api/classes` y nos aparecen las entidades que creamos en el reto anterior, probando así que tenemos bien configurado nuestro flujo de datos usando contenedores.

![Get classes](./images/reto2-getclasess.png)