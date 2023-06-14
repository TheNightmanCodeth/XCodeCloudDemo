#!/bin/zsh

#  util.zsh
#
#  Created by Joe Diragi on 5/22/23.
#
#  Various utility functions

echo "Util..."

## True if a command is installed and available in path
util::installed() {
    command -v $1 > /dev/null 2>&1
}

## True if variable is defined/not empty
util::defined() {
    typeset -f + "$1" &> /dev/null
}

## The output of an archive run
util::path_to_archive() {
    return $CI_APP_STORE_SIGNED_APP_PATH
}
