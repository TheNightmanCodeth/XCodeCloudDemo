#!/bin/zsh

#  pre-xcodebuild.sh
#
#  Created by Joe Diragi on 5/22/23.
#  

source ./Util/dependencies.zsh

#############################################
## Runs before each build. Verify deps and ##
## ensure authenticated for post-build     ##
#############################################


#############################################
##           Verify Dependencies           ##
#############################################
deps::verify
