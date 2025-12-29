# Reto 1: MongoDB en Contenedor

## ✅ Comandos utilizados para crear la red Docker

La creamos de tipo bridge (tipo por defecto) con: 

    docker network create lemoncode-calendar

Y verificamos que se ha creado correctamente:

    docker network ls
    docker network inspect lemoncode-calendar

## ✅ Comando para ejecutar el contenedor de MongoDB

Primero creamos el volumen para persistir los datos

    docker volume create mongo-data

Verificamos que se ha creado correctamente
    
    docker volume ls
    docker volume inspect mongo-data

Luego corremos el contenedor de MongoDB enlazando con el volumen proviamente creado además de la red

    docker run -d `
    --name mongodb `
    --network lemoncode-calendar `
    -p 27017:27017 `
    -v mongo-data:/data/db `
    -e MONGO_INITDB_ROOT_USERNAME=admin `
    -e MONGO_INITDB_ROOT_PASSWORD=password `
    mongo:latest

Y verificamos que está corriendo correctamente

    docker ps

## ✅ Configuración de conexión del backend a MongoDB

Para esto tenemos que asegurar que nuestra cadena de conexión del backend se corresponde con esta

    "ConnectionString": "mongodb://admin:password@localhost:27017"

Si nos fijamos, las credenciales son las mismas que hemos especificado en el comando `docker run`. Además, estamos apuntando al puerto `27017` de nuestro localhost, justo el puerto que hemos expuesto para el contenedor de `MongoDB`.

## ✅ Prueba REST Client mostrando peticiones exitosas (backend/client.http)

Desde VS hemos corrido nuestro backend. Como el `launchSettings.json` especifica que la app escucha por el puerto `5000`, hemos de asegurar que el `client.http` apunta a este mismo puerto (variable `@host`). Una vez asegurada esta configuración, podemos ir lanzando peticiones para confirmar que la conexión entre nuestro backend local y el contenedor `MongoDB` es exitosa. Dejamos algunas capturas testimoniales.

![Client.http](./images/clienthttp.png)

![Get classes](./images/getclasses.png)

En este momento también es interesante apuntar que si reiniciamos el contenedor, gracias a trabajar con el volumen de persistencia, los datos seguirán existiendo:

    docker stop mongodb
    docker start mongodb

Y volviendo a ejecutar un `GET` podemos comprobar que los datos siguen ahí.