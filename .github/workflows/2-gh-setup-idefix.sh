#!/bin/bash
if [[ ${debug:-false} == true ]]; then
    set -o xtrace   # activate bash debug
fi

build_dir=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)

if [ -d ~/.ecdev ]; then
  echo "using existing idefix tooling from ~/.ecdev - skipping provisioning" 
else
  echo "provisioning idefix tooling inside ~/.ecdev - please be patient"
  /bin/bash -c "$(curl -fsSLk https://cec-dev1.es.corpintra.net/updates/idefix/install-cec.sh)" bash -j
  # archive_link="${artifactory_url}/smaragd-generic-devtools-local/origin/idefix/2023.09.19.ecdev.tar.bz2"
  # curl -u${artifactory_username}:${artifactory_token} -skSL ${archive_link} | tar -xj -C ~
fi

echo execution completed at $(date +"%Y-%m-%d_%H-%M-%S")
