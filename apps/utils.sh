#!/bin/bash
set -e
source ./constants.sh

function echo_run {
    echolor "$CMD_FMT" "\n>>> $1\n\n"
    eval "$1"
}

function echolor {
    printf "$1$2\e[0m"
}
