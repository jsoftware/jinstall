#!/usr/bin/env sh
#
# parameters
# install directory
# Jqt: none/slim/full (default full)
# Addons: none/all (default none)

set -eu

V=j9.7

OS=$(uname -s)
if [ "$OS" != "Darwin" ] && [ "$OS" != "Linux" ]; then
 echo "This script only works for Linux or macOS, not for $OS"
 exit 1
fi

# ----------------------------------------------------------------------
# Show usage
usage() {
 cat <<EOF
Usage: $(basename "$0") [OPTIONS] [Dir] [Jqt] [Addons]

Options:
    -h, --help          Show this help and exit
    -f, --force         Force operation (no prompts)

Give other parameters in order, use "" or empty for the default

[Dir] - installation directory, default $HOME/$V
[Jqt] - Jqt installed, one of none|slim|full (default full)
[Addons] - Addons installed, one of none|all (default none)

Examples:
$(basename "$0")                 # install full Jqt system under home with no addons
$(basename "$0") "" slim         # install slim Jqt system under home with no addons
$(basename "$0") -f mydir none   # install base system only in mydir, no prompts
$(basename "$0") mydir none all  # install base system in mydir plus all addons
EOF
 exit 0
}

FORCE=0;

# ----------------------------------------------------------------------
# Parse options
while [ $# -gt 0 ]; do
 case "$1" in
  -h|--help)    usage ;;
  -f|--force)   FORCE=1; shift ;;
  --)           shift; break ;;
  -*)           echo "Unknown option: $1" >&2; usage ;;
  *)            break ;;   # first non-option argument → stop parsing
 esac
done

# ----------------------------------------------------------------------
# directory, Jqt, Addons parameters
D=${1:-$HOME}
P=${2:-"full"}
A=${3:-"none"}

# check likely incorrect directory
case "$D" in
 none|slim|full|all)
 echo "The installation directory may not be one of the keywords: none|slim|full|all";
 exit 1 ;;
esac

if [ "$D" = "home" ]; then D=$HOME; fi

# check Jqt selection
case "$P" in
 none|slim|full) ;;
 *) echo "Invalid Jqt selection: $P"; exit 1 ;;
esac

# check Addons selection
case "$A" in
 none|all) ;;
 *) echo "Invalid Addons selection: $A"; exit 1 ;;
esac

# resolve directory path and add J version
mkdir -p $D
D="$(cd -P "$D" && pwd -P)/$V"

# ----------------------------------------------------------------------
# install message + prompt to continue
m="Installing"

case "$P" in
  "slim") m="$m slim Jqt system" ;;
  "full") m="$m full Jqt system" ;;
  *) m="$m base system with no Jqt" ;;
esac

if [ "$A" = "all" ]; then
 m="$m and all Addons"
else
 m="$m and no Addons"
fi

echo "$m in $D"

if [ "$FORCE" = 0 ]; then
 printf 'OK to continue? (y/N) '
 read response
 case "${response:-N}" in   # defaults to N on Enter
  [Yy]*) ;;                 # do nothing
  *) echo "Not done."; exit 1 ;;
 esac
fi

exit 0

M=$(mktemp -d -t 'jtemp.XXXXXX')
cd $M

S="https://www.jsoftware.com/download/$V/install"

if [ "$OS" = "Darwin" ]; then
 W=${V}_mac64.zip
 curl -O $S/$W
 unzip $W
else
 W=${V}_linux64.tar.gz
 wget $S/$W
 tar -xf $W
fi

cd -
cp -r $M/$V/* $D
cd $D
rm -rf $M

bin/jconsole -js "install 'system $P $A'"
