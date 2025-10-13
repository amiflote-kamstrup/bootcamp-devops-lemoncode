#!/bin/bash

# 3. Crear un script de bash que agrupe los pasos de los ejercicios anteriores y además permita establecer el texto de file1.txt alimentándose como parámetro al invocarlo
# 
# Si se le pasa un texto vacío al invocar el script, el texto de los ficheros, el texto por defecto será:
# 
# Que me gusta la bash!!!!

message="Me encanta la bash!!!!"

if [ $# -ge 1 ]
then
    message=$1
fi                                                                                                                                   
mkdir foo/{dummy,empty} -p
touch foo/dummy/file{1,2}.txt
echo $message > foo/dummy/file1.txt
cat foo/dummy/file1.txt > foo/dummy/file2.txt
mv foo/dummy/file2.txt foo/empty/file2.txt