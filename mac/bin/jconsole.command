#!/bin/bash
cd "`dirname "$0"`/.."

if [[ "$(uname -v)" = *ARM64* ]]; then
  arch -arm64 bin/jconsole "$@"
else
  arch -x86_64 bin/jconsole "$@"
fi
