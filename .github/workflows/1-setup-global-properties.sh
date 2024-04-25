#!/bin/bash
if [[ ${debug:-false} == true ]]; then
    set -o xtrace   # activate bash debug
fi

build_dir=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)

#
# MIND configuration in GH workflow yml file
#    environment: pekirsc
#    env:
#      REPOSILITE_ID: ${{ vars.REPOSILITE_ID }}
#      REPOSILITE_URL: ${{ vars.REPOSILITE_URL }}
#      REPOSILITE_USERNAME: ${{ secrets.REPOSILITE_USERNAME }}
#      REPOSILITE_TOKEN: ${{ secrets.REPOSILITE_TOKEN }}
#

global_properties=~/.global.properties
if [ -f $global_properties ]; then
  echo existing "using $global_properties" 
else
  echo "creating $global_properties" 
  echo       "REPOSILITE_ID=$REPOSILITE_ID"         >> $global_properties
  echo      "REPOSILITE_URL=$REPOSILITE_URL"        >> $global_properties
  echo "REPOSILITE_USERNAME=$REPOSILITE_USERNAME"   >> $global_properties
  echo    "REPOSILITE_TOKEN=$REPOSILITE_TOKEN"      >> $global_properties
fi
