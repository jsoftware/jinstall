#!/bin/bash
cd "`dirname "$0"`/.."
export QT_PLUGIN_PATH="$(pwd)"/Qt/plugins

if [[ "$(uname -v)" = *ARM64* ]]; then
  arch -arm64 bin/jqt "$@"
else
  arch -x86_64 bin/jqt "$@"
fi
