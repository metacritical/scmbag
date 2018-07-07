#!/bin/bash

build(){
  echo "Compiling SCMBAG ..."
  chicken-install -prefix $PWD/scmbag -deploy regex loops args scsh-process
}

install(){
  echo "Installing scmbag"
  cp scmbag /usr/local/bin/
}

if [ -z "${1+x}" ]; then
  build
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
