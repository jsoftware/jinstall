#!/bin/bash

cd `dirname "$(realpath $0)"`

f() {
 echo "parse.sh $@"
 if [ "$#" -eq 0 ]; then
  ./parse.sh
 else
  ./parse.sh "$@"
 fi
 echo "-----------------------------------"
}

f
f -h
f -p moot
f -q slim
f --no-addons
f --no-shortcuts
f -p moot -q slim --no-addons --no-shortcuts
f --no-shortcuts --no-addons --qt slim --path moot
f abc def
f --abc def
