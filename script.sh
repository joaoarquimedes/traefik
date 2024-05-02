#!/usr/bin/env bash

export STACK=traefik

function timeStamp() { date +"%Y/%m/%d - %H:%M:%S"; }
export PATH_FULL=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
cd $PATH_FULL

function start(){
  docker stack deploy --compose-file docker-compose.yml ${STACK} --detach=true
}

function stop(){
  docker stack rm ${STACK}
}

function reload() {
  docker service update --force ${STACK}_server
  docker service update --force ${STACK}_nginx
}

function restart(){
  stop
  echo -n "Restarting."
  while ps | grep "Running" > /dev/null 2> /dev/null
  do
   echo -n "."
   sleep 2
  done
  start
}

function ps(){
  docker stack ps ${STACK}
}

function clear(){
  docker container prune -f
}

function bash(){
  docker exec -it $(docker ps | grep ${STACK}_server | cut -d " " -f1) ash
}

function logrotate(){
  echo "Log rotation"
  docker compose --file docker-compose.logrotate.yml run --rm logrotate ash -c "logrotate -vf /etc/logrotate.d/traefik"
  docker compose --file docker-compose.logrotate.yml down
  reload && sleep 5 && clear
}

echo "$(timeStamp) - $1"
$1

exit 0
