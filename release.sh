#!/bin/bash
if [[ ${debug:-false} == true ]]; then
  set -o xtrace   # activate bash debug
fi

# MIND the DOT at beginning of line
echo "# configure local bash environment (environment variables and proxy)"
. ~/.klibio/set-env.sh
env | sort | grep -E 'artifactory_|git_|engine|HOME' | sed -r 's/artifactory_token=(.*)/artifactory_token=<set-but-hidden>/'

mkdir _log >/dev/null 2>&1
log_file=_log/$(date +"%Y-%m-%d_%H-%M-%S")_release.log
echo "execute release and write a log file $log_file"
./mvnw --batch-mode -Dorg.slf4j.simpleLogger.defaultLogLevel=debug clean release:prepare 2>&1 | tee $log_file

echo execution completed at $(date +"%Y-%m-%d_%H-%M-%S") - log file create $log_file
