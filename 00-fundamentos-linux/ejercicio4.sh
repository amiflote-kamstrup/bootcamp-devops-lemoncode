#!/bin/bash

# 4. Crea un script de bash que descargue el contenido de una página web a un fichero y busque en dicho fichero una palabra dada como parámetro al invocar el script
# 
# La URL de dicha página web será una constante en el script.
# 
# Si tras buscar la palabra no aparece en el fichero, se mostrará el siguiente mensaje:
# 
# $ ejercicio4.sh patata
# > No se ha encontrado la palabra "patata"
# 
# Si por el contrario la palabra aparece en la búsqueda, se mostrará el siguiente mensaje:
# 
# $ ejercicio4.sh patata
# > La palabra "patata" aparece 3 veces
# > Aparece por primera vez en la línea 27

if [ $# -lt 1 ]; then
    echo "Error: Introduce como argumento la palabra a buscar"
    echo "Uso: $0 <palabra>"
    exit 1
fi

url="https://lemoncode.net/"
word=$1
file="file1.txt"

curl -s $url > $file
matches=$(grep -o $word $file | wc -l)

if [ $matches -gt 0 ]; then
	line=$(grep -n $word $file | head -n 1 | sed 's/\([0-9]*\).*/\1/')
    echo "La palabra $word aparece $matches veces"
    echo "Aparece por primera vez en la línea $line"
else
    echo "No se ha encontrado la palabra \"$word\""
fi