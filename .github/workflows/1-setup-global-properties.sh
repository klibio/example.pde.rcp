#!/bin/bash
if [[ ${debug:-false} == true ]]; then
    set -o xtrace   # activate bash debug
fi

build_dir=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)

#
# MIND configuration in GH workflow yml file
#    environment: pekirsc
#    env:
#      GIT_ID: ${{ vars.GIT_ID }}
#      GIT_URL: ${{ vars.GIT_URL }}
#      GIT_USERNAME: ${{ secrets.GIT_USERNAME }}
#      GIT_EMAIL: ${{ secrets.GIT_EMAIL }}
#      GIT_TOKEN: ${{ secrets.GIT_TOKEN }}
#      ARTIFACTORY_ID: ${{ vars.ARTIFACTORY_ID }}
#      ARTIFACTORY_URL: ${{ vars.ARTIFACTORY_URL }}
#      ARTIFACTORY_USERNAME: ${{ secrets.ARTIFACTORY_USERNAME }}
#      ARTIFACTORY_TOKEN: ${{ secrets.ARTIFACTORY_TOKEN }}
#

ec_global_properties=~/.ec_global.properties
if [ -f $ec_global_properties ]; then
  echo existing "using $ec_global_properties" 
else
  echo "creating $ec_global_properties" 
  echo       "artifactory_id=$ARTIFACTORY_ID"         >> $ec_global_properties
  echo      "artifactory_url=$ARTIFACTORY_URL"        >> $ec_global_properties
  echo "artifactory_username=$ARTIFACTORY_USERNAME"   >> $ec_global_properties
  echo    "artifactory_token=$ARTIFACTORY_TOKEN"      >> $ec_global_properties
  echo               "git_id=$GIT_ID"                 >> $ec_global_properties
  echo              "git_url=$GIT_EMAIL"              >> $ec_global_properties
  echo              "git_url=$GIT_URL"                >> $ec_global_properties
  echo         "git_username=$GIT_USERNAME"           >> $ec_global_properties
  echo            "git_token=$GIT_TOKEN"              >> $ec_global_properties
fi
