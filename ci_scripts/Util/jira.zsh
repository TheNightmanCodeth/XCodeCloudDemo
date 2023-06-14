#!/bin/zsh

#  jira.zsh
#  XCC-Demo
#
#  Created by Joe Diragi on 5/22/23.
#

echo "Jira..."

jira::update_builds() {
    STORY_ID=$1
    DEV_LINK=$2
    QA_LINK=$3
    PROD_LINK=$4
    
    ## JIRA_APP_URL is stored in secrets, config under 'Edit Workflow > Environment'
    curl -X POST "$JIRA_APP_URL" -d "{ \"key\": \"$STORY_ID\", \"dev\": \"$DEV_LINK\", \"qa\": \"$QA_LINK\", \"prod\": \"$PROD_LINK\" }"
}
