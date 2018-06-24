#!/bin/bash

build(){
  echo "Compiling SCMBAG ..."
  csc  -O5 -u -local -disable-interrupts -w -d0 -lfa2 scmbag.scm 
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
    *)
      echo "Give some flag .."
      ;;
  esac
fi
