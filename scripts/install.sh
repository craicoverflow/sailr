#!/bin/sh

repo_url="https://github.com/craicoverflow/sailr"
release_tag=master
script_file="https://raw.githubusercontent.com/craicoverflow/sailr/$release_tag/sailr.sh"

function init {
    global=false
    if [ -z "$1" ] || [ $1 = "." ] ; then
        destination="$PWD/.git/hooks"
    elif [ $1 = "--global" ] || [ $1 = "-g" ]; then
        destination="$HOME/.git-templates/hooks"
        global=true
    elif [ ! -z $1 ]; then
        echo "Unsupported argument '$1'"
    fi

    curl $script_file -o "$destination/commit-msg"
    chmod u+x "$destination/commit-msg"

    if [ $global = false ]; then
        echo -e "\nInstalled Sailr \e[33mcommit-msg\033[0m hook to \e[32m$PWD\033[0m."
    else
        echo -e "\nInstalled Sailr as global \e[33mcommit-msg\033[0m Git hook."
    fi
    echo "For usage see https://github.com/craicoverflow/sailr#usage"
}

init $1
