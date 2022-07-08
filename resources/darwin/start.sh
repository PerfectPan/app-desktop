#!/usr/bin/env bash

function app_realpath() {
  SOURCE=$1
  while [ -h "$SOURCE" ]; do
    DIR=$(dirname "$SOURCE")
    SOURCE=$(readlink "$SOURCE")
    [[ $SOURCE != /* ]] && SOURCE=$DIR/$SOURCE
  done
  SOURCE_DIR="$( cd -P "$( dirname "$SOURCE" )" >/dev/null 2>&1 && pwd )"
  echo "${SOURCE_DIR%%${SOURCE_DIR#*.app}}"
}

APP_PATH="$(app_realpath "${BASH_SOURCE[0]}")"
if [ -z "$APP_PATH" ]; then
  echo "Unable to determine app path from symlink : ${BASH_SOURCE[0]}"
  exit 1
fi
CONTENTS="$APP_PATH/Contents"
ELECTRON="$CONTENTS/MacOS/Electron"
CLI="$CONTENTS/Resources/app.asar/bootstrap/node/cli.js"
ELECTRON_RUN_AS_NODE=1 "$ELECTRON" --no-deprecation "$CLI" "$@"
exit $?
