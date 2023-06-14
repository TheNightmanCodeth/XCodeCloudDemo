#!/bin/zsh

#  dependencies.zsh
#
#  Created by Joe Diragi on 5/22/23.
#

echo "deps..."

source ./Util/util.zsh

authenticate() {
    ## Appcenter
    # Set APPCENTER_ACCESS_TOKEN to secret value
    export APPCENTER_ACCESS_TOKEN="$APPCENTER_TOKEN"
}

install_appcenter() {
    util::installed npm || brew install node
    npm install --location=global appcenter-cli
    util::installed appcenter || \
        { echo "Appcenter CLI installation failed"; exit 1; }
}

install_curl() {
    brew install curl
}

deps::verify() {
    # Restore cache if exists
    cd /Users/local/Homebrew && git stash pop

    util::installed appcenter || install_appcenter
    util::installed curl || brew install curl
    util::installed jq || brew install jq
    
    ## Apply environment variables for authenticating with various tools
    authenticate
}
