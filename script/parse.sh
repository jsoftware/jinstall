#!/usr/bin/env sh
#
# parse development

set -eu

V=j9.8

# ----------------------------------------------------------------------
# Show usage
usage() {
 cat <<EOF
Usage: $(basename "$0") [OPTIONS]

Options:
  -h --help       Show this help and exit
  -p --path       installation top level directory, default $HOME.
                  The installation is to a $V subdirectory of this.
                  In Linux, a directory of /usr makes a standard system install.
                  Some paths may require root access.
  -q --qt         type of Jqt installed, one of [full]|slim|none
 --no-addons      do not install the full set of addons
 --no-shortcuts   do not create desktop shortcuts
EOF
}

D=$HOME
P=full
A=all
S=true

while [ $# -gt 0 ]; do
 echo "parm = $1"
 case "$1" in
  -h|--help)      usage;exit 1;;
  -p|--path)      D="$2";shift 2;;
  -q|--qt)        P="$2";shift 2;;
  --no-addons)    A=none;shift;;
  --no-shortcuts) S=false;shift;;
  --) break;;
  *) echo "Unknown option: $1";exit 1;;
 esac
done

echo "path      = $D"
echo "addons    = $A"
echo "jqt       = $P"
echo "shortcuts = $S"
