002-setup-idefix.sh#!/bin/bash
if [[ ${debug:-false} == true ]]; then
    set -o xtrace   # activate bash debug
fi

build_dir=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)
bootstrap=.klibio

if [ -d ~/${bootstrap} ]; then
  echo "using existing idefix tooling from ~/${bootstrap} - skipping provisioning" 
else
  echo "provisioning idefix tooling inside ~/${bootstrap} - please be patient"
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/klibio/bootstrap/main/install-klibio.sh)" bash -j
fi

echo execution completed at $(date +"%Y-%m-%d_%H-%M-%S")