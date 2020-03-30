#!/bin/bash

SRVS="personal gf itl"
for srv in $SRVS ; do
  echo ----------------------------------------------
  echo Service: $srv
  echo ----------------------------------------------
  docker-compose exec tresorit-${srv} ./tresorit-cli tresors
  echo --------
  docker-compose exec tresorit-${srv} ./tresorit-cli transfers
done
