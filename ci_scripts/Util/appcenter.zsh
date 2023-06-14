#!/bin/zsh

#  appcenter.zsh
#  XCC-Demo
#
#  Created by Joe Diragi on 5/22/23.
#

echo "Appcenter..."

## APPCENTER_NAME="pfjneagle-6loa-01"
export APPCENTER_GROUP="Collaborators"
export MOBILE_CENTER_CURRENT_APP="jdiggity/XCC-Demo"

get_build_version() {
    BUILD_OUTPUT=$1
    echo "$BUILD_OUTPUT" | cut -d "(" -f2 | cut -d ")" -f1 | read BUILD_VERSION
    export VERSION=$BUILD_VERSION
}

appcenter::get_build_id() {
    RELEASES=$(appcenter distribute releases list)
    get_build_version # Sets $VERSION to the version we are looking for
    INDEX=1
    while IFS= read -r line; do
        [[ $line =~ "Version:" ]] || \
            { INDEX=$((INDEX+1)); continue; }
        ## Pull out the version number
        VERSION_NUMBER=${line//[^0-9]/}
        ## Verify it matches the version we got from build output
        [[ $VERSION_NUMBER == $VERSION ]] && break || \
            { INDEX=$((INDEX+1)); continue; }
        ## This is the correct version index
    done <<< "$RELEASES"
    ## Go up 2 lines to the ID entry
    INDEX=$((INDEX-2))
    ID_LINE=$(sed "${INDEX}q;d" <<< "$RELEASES")
    export RELEASE_ID=${ID_LINE//[^0-9]/}
}

appcenter::get_download_url() {
    RELEASE_INFO=$(appcenter distribute releases show -r $1 --output json)
    ## Get Install URL from output
    if [[ $RELEASE_INFO =~ '\"installUrl\":\"([^"]*)\"' ]]; then
        REL_URL=${match[1]}
    else
        echo "Couldn't pull release url"
        echo $RELEASE_INFO
        exit 1
    fi
}

appcenter::publish() {
    #[[ $1 == "dev" ]] && MOBILE_CENTER_CURRENT_APP="${APPCENTER_NAME}/iOS-Pilot-Flying-J-Dev"
    #[[ $1 == "qa" ]] && MOBILE_CENTER_CURRENT_APP="${APPCENTER_NAME}/iOS-Pilot-Flying-J-QA-1"
    #[[ $1 == "prod" ]] && MOBILE_CENTER_CURRENT_APP="${APPCENTER_NAME}/iOS-Pilot-Flying-J-Prod-1"
    #ARCHIVE_PATH=$(util::path_to_archive)
    MOBILE_CENTER_CURRENT_APP="jdiggity/XCC-Demo"
    appcenter distribute release --file "$CI_APP_STORE_SIGNED_APP_PATH" --group "$APPCENTER_GROUP"
}
