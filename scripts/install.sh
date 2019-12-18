#!/bin/sh

repo_url="https://github.com/craicoverflow/sailr"
release_tag=v0.1
script_file="https://raw.githubusercontent.com/craicoverflow/sailr/$release_tag/sailr.sh"

function init {
    if [ ! -z $1 ]; then
        echo "Unsupported argument '$1'"
    fi

    destination="${PWD}/.git/hooks"

    download_status=$(curl $script_file -o "${destination}/commit-msg")
    chmod u+x "${destination}/commit-msg"

    echo -e "\nInstalled Sailr as \e[33mcommit-msg\033[0m hook in \e[32m$destination\033[0m."
    echo "For usage see https://github.com/craicoverflow/sailr#usage"
}

init $1
