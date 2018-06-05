#!/bin/bash

#
# Program configuration
#

CMD_FMT="\e[1;94m"
WARN_FMT="\e[91m"
INFO_FMT="\e[1;93m"
APP_NAME='pingpong'

#
# Function descriptions
#

SYNOPSIS="""$INFO_FMT
SYNOPSIS

    usage: setup [up] [down]

DESCRIPTION

    up
        Build the docker images

    run
        Once images are built, spin them on

    status
        Get the current swarm state

    down
        Removes ALL images and containers

"""
# get only the ones that matches the 123-something-node pattern
NODE_NAME_PATTERN='^([0-9]{3}-).+(-node)$'
fn_UP_HEADLINE="""$WARN_FMT
>>> Building containers
"""
fn_UP_BODY="""$CMD_FMT
    docker build -t \"$node\" -f \"$node_dir/Dockerfile\" .

    -- TODO --
    Cleanup and exit after build failure
    -- ODOT --
"""
fn_DOWN_HEADLINE="""$WARN_FMT
>>> Cleanup in progress

Before:
"""
fn_DOWN_FOOTER="""$WARN_FMT
After:
"""
fn_RUN_HEADLINE="""$INFO_FMT
>>> Start nodes for app $appname

Before:
"""
fn_RUN_FOOTER="""$INFO_FMT
After:
"""
