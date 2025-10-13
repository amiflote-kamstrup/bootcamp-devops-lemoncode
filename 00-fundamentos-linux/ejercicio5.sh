#!/bin/bash

# 5. OPCIONAL - Modifica el ejercicio anterior de forma que la URL de la página web se pase por parámetro y también verifique que la llamada al script sea correcta
# 
# Si al invocar el script este no recibe dos parámetros (URL y palabra a buscar), se deberá de mostrar el siguiente mensaje:
# 
# $ ejercicio5.sh https://lemoncode.net/ patata 27
# > Se necesitan únicamente dos parámetros para ejecutar este script
# 
# Además, si la palabra sólo se encuentra una vez en el fichero, se mostrará el siguiente mensaje:
# 
# $ ejercicio5.sh https://lemoncode.net/ patata
# > La palabra "patata" aparece 1 vez
# > Aparece únicamente en la línea 27


if [ $# -ne 2 ]; then
    echo "Error: Se necesitan únicamente dos parámetros para ejecutar este script"
    echo "Uso: $0 <url> <palabra>"
    exit 1
fi

url=$1
word=$2
file="file1.txt"

curl -s $url > $file
matches=$(grep -o $word $file | wc -l)

if [ $matches -eq 0 ]; then
    echo "No se ha encontrado la palabra \"$word\""
else
    line=$(grep -n $word $file | head -n 1 | sed 's/\([0-9]*\).*/\1/')

    if [ $matches -eq 1 ]; then
        echo "La palabra $word aparece $matches vez"
        echo "Aparece únicamente en la línea $line"
    else
        echo "La palabra $word aparece $matches veces"
        echo "Aparece por primera vez en la línea $line"
    fi
fi
