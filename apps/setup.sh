#!/bin/bash
set -e
source ./constants.sh
source ./utils.sh

if [ $# -eq 0 ]
  then
    echolor "$INFO_FMT" "$SYNOPSIS"
fi

function up {
    __DIRNAME__=$(pwd)
    __SWARM_NODES=$(ls -1 | grep -E $NODE_NAME_PATTERN)

    echolor "$CMD_FMT" "$fn_UP_HEADLINE"

    for node in $__SWARM_NODES; do
        node_dir="$__DIRNAME__/$node"

        cd "$node_dir" || exit

        echolor "$CMD_FMT" "$fn_UP_BODY"
        docker build -t "$node" -f "$node_dir/Dockerfile" .
    done

    reportAll
}


function down {
    echolor "$INFO_FMT" "$fn_DOWN_HEADLINE"
    reportAll

    echolor "$WARN_FMT" "\n>>> Tearing down swarm \n\n"
    echo_run "docker stack rm \"$APP_NAME\"" || true
    echo_run "docker swarm leave --force" || true

    echolor "$WARN_FMT" "\n>>> Removing images\n"
    for image in $(docker images -q); do
        docker rmi --force "$image"
    done

    echolor "$WARN_FMT" "\n>>> Removing containers\n"
    for container in $(docker ps -q); do
        docker rm --force "$container"
    done

    echolor "$INFO_FMT" "$fn_DOWN_FOOTER"
    reportAll

}

function run {
    echolor "$INFO_FMT" "$fn_RUN_HEADLINE"

    echo_run "docker images --all"
    echo_run "docker ps --all"
    echo_run "docker swarm init"
    echo_run "docker stack deploy -c docker-compose.yml $APP_NAME"

    echolor "$INFO_FMT" "$fn_RUN_FOOTER"
    reportAll
}

function reportAll {
    echo_run "docker images --all"
    echo_run "docker ps --all"
    echo_run "docker service ls || true"

    echolor "$CMD_FMT" "\n>>> docker service ps \$(docker service ls -q | paste -sd \" \" -)\n\n"
    docker service ps $(docker service ls -q | paste -sd " " -) || true

    echo_run "docker container ls -q"
}

while [[ $# -gt 0 ]]
do
key="$1"

case $key in
    "up")
      up
    shift
    ;;"run")
      run
    shift
    ;;"status")
      reportAll
    shift
    ;;"down")
      down
    shift
    ;;
    *)
      # unknown option
    ;;
esac
shift
done