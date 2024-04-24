#!/bin/bash

script_dir=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)

echo -e "#\n# sourcing environment from build\n#\n"
. ~/.ecdev/set-env.sh # must not use pipe `2>&1 | tee -a $log_file`, cause export env vars will not work

SOURCE_FOLDER=${1:-$script_dir/repo.binary/target/repository}  # local generated p2 repository folder
TARGET_REPO=${2:-smaragd-internet-mirror-generic-local}
TARGET_FOLDER=${3:-example.pde.rcp/repo.binary/$(date +'%Y%m%d-%H%M%S')}  # target root folder default timestamp folder 
TARGET_URI=${artifactory_url}/$TARGET_REPO/$TARGET_FOLDER

[[ -z "${artifactory_url}" ]] && { echo "missing env variabale artifactory_url" ; exit 1; }
[[ -z "${artifactory_username}" ]] && { echo "missing env variabale artifactory_username" ; exit 1; }
[[ -z "${artifactory_token}" ]] && { echo "missing env variabale artifactory_token" ; exit 1; }

echo -e "#\n# uploading p2 repo from directory\n#    $SOURCE_FOLDER\n# to artifactory\n#    $TARGET_URI\n#\n"
# find all files recursively with relative path
if [ -d "$SOURCE_FOLDER" ]; then
  pushd "$SOURCE_FOLDER"
  for file in $(find . -type f)
  do
    read -r -d '' command << EOM
curl -v --user ${artifactory_username}:${artifactory_token} -X PUT $TARGET_URI/${file:2} -T ${file}
EOM
# MIND activation of this will expose credentials
#    echo -e "# executing following command\n$command\n"
    $command
  done
  popd
else
  echo "# source folder $SOURCE_FOLDER not found"
  exit 1
fi  

echo "# finished"

