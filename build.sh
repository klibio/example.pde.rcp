#!/bin/bash
if [[ ${debug:-false} == true ]]; then
    set -o xtrace   # activate bash debug
    mvnDebug="-X"
fi

build_dir=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)
ts=$(date +"%Y%m%d_%H%M%S")

build_local=1
local_cache=
for i in "$@"; do
    case $i in
        -d|--diag)
            build_local=0
            diag=1
        ;;
        --local-cache)
            read -p "delete local cache? (y/n) " -n 1 -r; echo; [[ $REPLY =~ ^[Yy]$ ]] && rm -rf ${build_dir}/.local_m2_cache
            local_cache=-Dmaven.repo.local=.local_m2_cache
        ;;
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
. ~/.klibio/set-env.sh # must not use pipe `2>&1 | tee -a $log_file`, cause export env vars will not work
. ~/.klibio/set-java.sh 17 2>&1 | tee -a $log_file

# create a build_rev for products and repo archives
read -r file_rev < version.txt
semver_regex="^([0-9]+)\.([0-9]+)\.([0-9]+)$"
if [[ $file_rev =~ $semver_regex ]]; then
    build_rev=${file_rev}.$(date +"%Y%m%d-%H%M%S")
    vm_build_rev=-Dbuild-rev=${file_rev}
    echo "using semantic version: $build_rev"
else
    echo "error: version.txt is not containing valid version [major.minor.bugfix]: $build_rev"
    exit 1
fi

# signing properties
echo -e "#\n# sourcing sign properties\n#\n" 2>&1 | tee -a $log_file
readPropertyFile ${build_dir}/certificate/sign.properties # must not use pipe `2>&1 | tee -a $log_file`, cause export env vars will not work
env | grep "sign_" 2>&1 | tee -a $log_file
if [[ $sign_skip -eq "true" ]]; then
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
    echo -e "#\n# execute diagnose\n#\n"       2>&1 | tee -a $log_file
    ./mvnw \
        ${MAVEN_OPTS} \
        ${mvnDebug} \
        ${local_cache} \
        help:effective-settings 2>&1 | tee -a $log_file
fi

if [[ ${build_local} -eq 1 ]]; then
    echo -e "#\n# execute local build - log file $log_file\n#\n"  2>&1 | tee -a $log_file
    set -e
    ./mvnw clean package \
        ${MAVEN_OPTS} \
        ${mvnDebug} \
        ${local_cache} \
        ${vm_build_rev} \
        ${keystore} \
        ${signVM}                                                 2>&1 | tee -a $log_file
fi

echo execute build $build_rev completed - log file created $log_file 2>&1 | tee -a $log_file
