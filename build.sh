#!/bin/bash
if [[ ${debug:-false} == true ]]; then
  set -o xtrace   # activate bash debug
fi

# MIND the DOT at beginning of line
echo "# configure local bash environment (environment variables and proxy)"
. ~/.ecdev/set-env.sh
env | sort | grep -E 'arti|engine|HOME' | sed -r 's/artifactory_token=(.*)/artifactory_token=<set-but-hidden>/'

mkdir _log >/dev/null 2>&1
log_file=_log/$(date +"%Y-%m-%d_%H-%M-%S")_build.log
echo "execute build and write a log file $log_file"
#./mvnw clean package 2>&1 | tee $log_file
./mvnw clean deploy 2>&1 | tee $log_file

echo execution completed at $(date +"%Y-%m-%d_%H-%M-%S") - log file create $log_file
