#!/bin/sh
cd "`dirname "$0"`/.."
export QT_PLUGIN_PATH="$(pwd)"/Qt/plugins
arch_name="$(sysctl -n machdep.cpu.brand_string)"

if [[ "${arch_name}" = *Apple* ]]; then
  arch -arm64 bin/jqt "$@"
else
  bin/jqt "$@"
fi