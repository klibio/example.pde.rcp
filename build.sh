#!/bin/bash
if [[ ${debug:-false} == true ]]; then
    set -o xtrace   # activate bash debug
    mvnDebug="-X"
fi

build_dir=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)
ts=$(date +"%Y%m%d-%H%M%S")

build_local=1
local_cache=
for i in "$@"; do
    case $i in
        --diag)
            build_local=0
            diag=1
        ;;
        --deploy)
            build_local=0
            build_deploy=1
        ;;
# optional configurable features        
        --jar-signing)
            jar_signing=-Dperform-jar-signing=true
        ;;
        --gpg-signing)
            gpg_signing=-Dperform-gpg-signing=true
        ;;
        --local-cache)
            read -p "delete local cache? (y/n) " -n 1 -r; echo; [[ $REPLY =~ ^[Yy]$ ]] && rm -rf ${build_dir}/.local_m2_cache
            local_cache=-Dmaven.repo.local=.local_m2_cache
        ;;
# break for unknown options
        -*|--*)
            echo "unknow option $i provided"
            exit 1
        ;;
        *)
        ;;
    esac
done

mkdir _log >/dev/null 2>&1
log_file=_log/${ts}_build.log
echo -e "#\n# build - log file $log_file\n#\n"      2>&1 | tee -a $log_file

echo -e "#\n# sourcing environment from build\n#\n" 2>&1 | tee -a $log_file
if [[ -f ~/.klibio/klibio.sh ]]; then
    . ~/.klibio/klibio.sh
else
    echo "warning: ~/.klibio/klibio.sh not found, continuing without it" 2>&1 | tee -a $log_file
fi
if [[ -f ~/.klibio/set-java.sh ]]; then
    . ~/.klibio/set-java.sh 21 # must not use pipe `2>&1 | tee -a $log_file`, cause export env vars will not work
else
    echo "warning: ~/.klibio/set-java.sh not found, using current JAVA_HOME=$JAVA_HOME" 2>&1 | tee -a $log_file
    if [[ "$JAVA_HOME" != *"JAVA21"* && -d "$HOME/.ecdev/java/ee/JAVA21" ]]; then
        export JAVA_HOME="$HOME/.ecdev/java/ee/JAVA21"
        export PATH="$JAVA_HOME/bin:$PATH"
        echo "info: fallback JAVA_HOME set to $JAVA_HOME" 2>&1 | tee -a $log_file
    fi
fi

# signing 
echo -e "#\n# sourcing sign properties\n#\n" 2>&1 | tee -a $log_file
if command -v readPropertyFile >/dev/null 2>&1; then
    readPropertyFile certificate/sign.properties # must not use pipe `2>&1 | tee -a $log_file`, cause export env vars will not work
elif [[ -f certificate/sign.properties ]]; then
    echo "warning: readPropertyFile function not available, skipping certificate/sign.properties import" 2>&1 | tee -a $log_file
fi
env | grep "sign_" 2>&1 | tee -a $log_file
if [[ "${sign_skip}" == "true" ]]; then
    keystore=-Dkeystore=${build_dir}/certificate/${sign_keystore}
    read -r -d '' signVM << EOM
-Dsign_skip=$sign_skip \
-Dsign_alias=$sign_alias \
-Dsign_keypass=$sign_keypass \
-Dsign_keystore=$sign_keystore \
-Dsign_storepass=$sign_storepass
EOM
fi
echo -e "# end of signing properties\n" 2>&1 | tee -a $log_file

if [[ ${diag} -eq 1 ]]; then
    echo -e "#\n# execute diagnose\n#\n" 2>&1 | tee -a $log_file
    ./mvnw \
        ${MAVEN_OPTS} \
        ${mvnDebug} \
        ${gpg_signing} \
        ${local_cache} \
        help:effective-settings 2>&1 | tee -a $log_file
fi

if [[ ${build_local} -eq 1 ]]; then
    echo -e "#\n# execute local build - log file $log_file\n#\n"  2>&1 | tee -a $log_file
read -r -d '' command << EOM
./mvnw clean verify \
  ${MAVEN_OPTS} \
  ${mvnDebug} \
  ${local_cache} \
  ${gpg_signing} \
  ${keystore} \
  ${signVM}
EOM
    echo -e "#\n$command\n#\n"  2>&1 | tee -a $log_file
    set -e
    $command  2>&1 | tee -a $log_file
fi

if [[ ${build_deploy} -eq 1 ]]; then
    echo -e "#\n#\n# execute SNAPSHOT/RELEASE build - log file $log_file\n#\n#\n"  2>&1 | tee -a $log_file
read -r -d '' command << EOM
./mvnw clean deploy -Ddeploy-maven-to-klibio=true \
  ${MAVEN_OPTS} \
  ${mvnDebug} \
  ${local_cache} \
  ${gpg_signing} \
  ${keystore} \
  ${signVM}
EOM
    echo -e "#\n$command\n#\n"  2>&1 | tee -a $log_file
    set -e
    $command  2>&1 | tee -a $log_file
fi

echo -e "#\n# execute build $build_rev completed - log file created $log_file\n#\n" 2>&1 | tee -a $log_file
