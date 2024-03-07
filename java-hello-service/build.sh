#!/bin/sh
set -eux


MODE_TRACE="TRACE"
MODE_ERROR="ERROR"

set +u
BUILD_MODE="${1}"
set -u

printHelp(){
  echo "usage: $0 ['all', 'clean', 'prepare', 'build', 'run' 'test', 'package', 'docker']"  
}

logBase()
{
  MESSAGE_MODE="${1}"
  MESSAGE_TEXT="${2}"
  [ -z "$MESSAGE" ] && MESSAGE=" "
  printf '%s - %s - %s\n' "$(date)" "${MESSAGE_MODE}" "${MESSAGE_TEXT}" 
}

logTrace()
{
  set +x
  set +u
  MESSAGE="${1}"
  logBase "${MODE_TRACE}" "${MESSAGE}"
  set -u
  set -x
}

logError()
{
  set +x
  set +u
  MESSAGE="${1}"
  logBase "${MODE_ERROR}" "${MESSAGE}" 1>&2
  set -u
  set -x
}

set +eu
[ -z "${BUILD_MODE}" ] && logError "no build mode provided" && printHelp 1>&2 && exit 1
set -eu

stage_clean(){
  logTrace "Not implemented - clean"
}

stage_prepare(){
  logTrace "Not implemented - Prepare"
}

stage_build(){
  logTrace "Not implemented - build"
}

stage_run(){
  logTrace "Not implemented - run"
}

stage_test(){
  logTrace "Not implemented - test"
}

stage_package(){
  logTrace "Not implemented package"
}

stage_packageDocker(){
  logTrace "Not implemented - docker"
}

case "$BUILD_MODE" in
  "help")
    printHelp && exit 0
    ;;

  "all")
    stage_prepare
    stage_build
    stage_test
    stage_package
    stage_packageDocker
    ;;

  "prepare")
    stage_prepare
    ;;

  "build")
    stage_build
    ;;

  "test")
    stage_test
    ;;

  "package")
    stage_package
    ;;

  "docker")
    stage_packageDocker
    ;;

  "*")
    logError "Unknown mode exiting" && printHelp && exit 1
    ;;
    
esac



