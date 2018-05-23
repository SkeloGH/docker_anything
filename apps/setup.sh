#!/bin/bash
set -e
if [ $# -eq 0 ]
  then
    printf \
'''
SYNOPSIS

    usage: setup [build] [down]

DESCRIPTION

    up
        Build the docker images

    down
        Removes ALL images and containers

'''
fi

appname='pingpong'


function up {
    __DIRNAME__=$(pwd)
    # list files and dirs
    # get only the ones that matches the 123-something-node pattern
    __SWARM_NODES=$(ls -1 | grep -E '^([0-9]{3}-).+(-node)$')

echo \
'''
################## Building containers
'''
    for node in $__SWARM_NODES; do
        node_dir="$__DIRNAME__/$node"

        cd "$node_dir" || exit
echo \
"""
    docker build --rm -t \"$node\" -f \"$node_dir/Dockerfile\" .

    -- TODO --
    Cleanup and exit after build failure
    -- ODOT --
"""
        docker build -t "$node" -f "$node_dir/Dockerfile" .
    done

    printf "\n    docker images --all \n"
    docker images --all

    printf "\n    docker ps --all \n"
    docker ps --all
}


function down {
    reportAll \
'''
################## Cleanup

Before:
'''

    printf "\n    Taking down the app    \n"
    docker stack rm $appname
    printf "\n    Taking down the swarm    \n"
    docker swarm leave --force

    printf "\n    Removing images    \n"
    for image in $(docker images -q); do
        docker rmi --force "$image"
    done

    printf "\n    Removing containers    \n"
    for container in $(docker ps -q); do
        docker rm --force "$container"
    done

    reportAll \
'''
After:
'''

}

function run {
echo \
"""
################## Start nodes for app $appname

Before:
"""
    docker images --all
    printf "\n"
    docker ps --all

echo \
'''
docker swarm init
'''
    docker swarm init
echo \
"""
docker stack deploy -c docker-compose.yml $appname
"""
    docker stack deploy -c docker-compose.yml $appname

echo \
'''
After:
'''
    docker images --all --all
    printf "\n"
    docker ps --all
echo \
'''
docker service ls
'''
    docker service ls
echo \
"""
docker service ps \$(docker service ls -q | paste -sd \" \" -)
"""
docker service ps $(docker service ls -q | paste -sd " " -)
echo \
'''
docker container ls -q
'''
    docker container ls -q
}

function reportAll {
    echo "$1"
echo \
'''
docker images --all
'''
    docker images --all
echo \
'''
docker ps --all
'''
    docker ps --all
echo \
'''
docker service ls
'''
    docker service ls
echo \
"""
docker service ps \$(docker service ls -q | paste -sd \" \" -)
"""
    docker service ps $(docker service ls -q | paste -sd " " -)
echo \
'''
docker container ls -q
'''
    docker container ls -q
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