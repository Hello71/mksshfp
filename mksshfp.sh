#!/bin/sh

reallydohash() {
  base64 -d | ${1}sum | cut -d ' ' -f 1
}

dohash() {
  IN="$(cat | cut -d ' ' -f 2)"
  printf >&2 "%d %d " $1 1
  echo "$IN" | reallydohash sha1
  printf >&2 "%d %d " $1 2
  echo "$IN" | reallydohash sha256
}

usage() {
  echo >&2 "Usage: $0 -"
  echo >&2 "       $0 etc"
  echo >&2 "Use - to read public keys from stdin"
  echo >&2 "Use etc to read public keys from /etc/ssh/*.pub"
}

if [ $# == 0 ]; then
  echo >&2 "Not enough arguments."
  usage
  exit 1

elif [ $# -gt 1 ]; then
  echo >&2 "Too many arguments."
  usage
  exit 1

elif [ $1 == etc ]; then
  echo >&2 "Using keys from /etc/ssh..."

  dohash 1 < /etc/ssh/ssh_host_rsa_key.pub
  dohash 2 < /etc/ssh/ssh_host_dsa_key.pub
  dohash 3 < /etc/ssh/ssh_host_ecdsa_key.pub

  exit 0

elif [ $1 == - ]; then
  echo >&2 "/etc/ssh/ssh_host_rsa_key.pub:"
  dohash 1

  echo >&2 "/etc/ssh/ssh_host_dsa_key.pub:"
  dohash 2

  echo >&2 "/etc/ssh/ssh_host_ecdsa_key.pub:"
  dohash 3

  exit 0

else
  echo >&2 "Incorrect argument $1"
  usage
  exit 1
fi
