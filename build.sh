#!/bin/bash

build(){
  echo "Compiling SCMBAG ..."
  chicken-install -prefix $PWD/scmbag -deploy regex loops args scsh-process
}

install(){
  echo "Installing scmbag"
  rm -rf /usr/local/share/scmbag
  cp -r scmbag /usr/local/share/scmbag
  mkdir -p /usr/local/opt/chicken/lib/
  ln -sf /usr/local/share/scmbag/libchicken.dylib /usr/local/opt/chicken/lib/
  /usr/local/share/scmbag/scmbag -i
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
