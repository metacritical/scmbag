#!/bin/bash

build(){
  echo "Compiling SCMBAG ..."
  csc -O1 -u -local -disable-interrupts -w -d0 -lfa2 scmbag.scm 
}

install(){
  echo "Installing scmbag"
  cp scmbag /usr/local/bin/
}

if [ -z "${1+x}" ]; then
  build
  install
else
  case "$1" in
    "scmbag")
      build
      ;;
    "install")
      install
      ;;
    "-h")
      printf "Usage: ./build.sh [COMMAND]\n\n"
      cat <<EOF
Commands :
  build    Build scmbag
install    Install scmbag
EOF
      ;;
  esac
fi
