#!/bin/bash

# 1. Crea mediante comandos de bash la siguiente jerarquía de ficheros y directorios
#
# foo/
# ├─ dummy/
# │  ├─ file1.txt
# │  ├─ file2.txt
# ├─ empty/

mkdir foo/{dummy,empty} -p
touch foo/dummy/file{1,2}.txt
echo "Me encanta la bash!!" > foo/dummy/file1.txt