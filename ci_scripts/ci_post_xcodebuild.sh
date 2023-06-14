#!/bin/zsh

## Fail build if a command returns a nonzero exit code
#set -e
echo "Starting post build..."

source ./Util/util.zsh
source ./Util/jira.zsh
source ./Util/appcenter.zsh

if "$CI_XCODEBUILD_ACTION" == "archive"
then
    ## Use the PR source branch to retrieve the issue key
    # Get string between angle brackets and save in `ISSUE_KEY`
    echo "$CI_PULL_REQUEST_SOURCE_BRANCH" | cut -d "[" -f2 | cut -d "]" -f1 | read ISSUE_KEY
    # Fail out if source branch does not contain issue key
    [[ -z "$ISSUE_KEY" ]] && \
    { echo "Branch name does not contain issue key. Exiting"; exit 1; }
    
    ## Upload build artifact to appcenter
    #[[ $CI_XCODE_SCHEME =~ "dev" ]] && appcenter::publish "dev"
    #[[ $CI_XCODE_SCHEME =~ "qa" ]] && appcenter::publish "qa"
    #[[ $CI_XCODE_SCHEME =~ "prod" ]] && appcenter::publish "prod"
    PUBLISH_OUTPUT=$(appcenter::publish)
    
    ## Get build URLs from appcenter cli
    # Successfull build output: "Release 1.0 (4) was successfully released to 1 testers in Collaborators"
    
    # Use build "Version" from output (inside parens) to find download link
    appcenter::get_build_id $PUBLISH_OUTPUT
    
    ## Use $RELEASE_ID to pull the install url
    appcenter::get_download_url $RELEASE_ID
    
    ## Update Jira
    jira::update_builds "$ISSUE_KEY" "$REL_URL" "$REL_URL" "$REL_URL"
    
    echo "Release URL: $REL_URL"
    
    exit 0
fi



appcenter_upload() {
    ## Authenticate
    ## APPCENTER_ACCESS_TOKEN="a6113ed1920565a60e9b47a730606c7cb979e9cb"
    APPCENTER_ACCESS_TOKEN="a8eef496052f76a276a6006725cfeb77f9c2df19"
    
    ## Push update
    appcenter apps update
}
