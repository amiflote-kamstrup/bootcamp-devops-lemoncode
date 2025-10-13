#!/bin/bash
# (continuación del ejercicio 1)
# 2. Mediante comandos de bash, vuelca el contenido de file1.txt a file2.txt y mueve file2.txt a la carpeta empty
# El resultado de los comandos ejecutados sobre la jerarquía anterior deben dar el siguiente resultado.
# 
# foo/
# ├─ dummy/
# │  ├─ file1.txt
# ├─ empty/
#   ├─ file2.txt
# 
# Donde file1.txt y file2.txt deben contener el siguiente texto:
# 
# Me encanta la bash!!

cat foo/dummy/file1.txt > foo/dummy/file2.txt
mv foo/dummy/file2.txt foo/empty/file2.txt