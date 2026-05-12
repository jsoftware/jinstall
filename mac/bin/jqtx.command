#!/bin/sh
cd "`dirname "$0"`/.."
export QT_PLUGIN_PATH="$(pwd)"/Qt/plugins

arch -x86_64 bin/jqt "$@"
