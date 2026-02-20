#!/usr/bin/env sh
#
# parameters
# install directory
# Jqt: none/slim/full (default full)
# Addons: none/all (default all)

set -eu

V=j9.7

OS=$(uname -s)
ARCH=$(uname -m)
if [ "$OS" != "Darwin" ] && [ "$OS" != "Linux" ] && [ "$OS" != "FreeBSD" ] && [ "$OS" != "OpenBSD" ]; then
 printf "This script only works for Linux macOS FreeBSD or OpenBSD, not for $OS\n"
 exit 1
fi

# ----------------------------------------------------------------------
# Show usage
usage() {
 cat <<EOF
Usage: $(basename "$0") [OPTIONS] [Dir] [Jqt] [Addons]

Options:
    -h, --help          Show this help and exit
    -d, --default       install with default parameters (home/full/all)
    -f, --force         Force operation (no prompts)

Give other parameters in order, use "" or empty for the default

[Dir] - installation top level directory, default $HOME.
        The installation is to a $V subdirectory of this.
        In Linux, a directory of /usr makes a standard system install
[Jqt] - Jqt installed, one of none|slim|full (default full)
[Addons] - Addons installed, one of none|all (default all)

Examples:
$(basename "$0") --default       # install full Jqt system under home with all addons
$(basename "$0") "" slim none    # install slim Jqt system under home with no addons
$(basename "$0") -f mydir none none  # install base system only in mydir, no prompts
$(basename "$0") mydir none      # install base system in mydir with all addons
$(basename "$0") /usr none none  # system install on Linux, with base system only
EOF
}

# ----------------------------------------------------------------------
if [ $# -eq 0 ]; then
  usage;
  printf "\nPress enter to finish "
  read wait
  printf "\n"
  exit 0
fi

# ----------------------------------------------------------------------
FORCE=0;
DEFAULT=0;

# ----------------------------------------------------------------------
# Parse options
while [ $# -gt 0 ]; do
 case "$1" in
  -h|--help)    usage; exit 0 ;;
  -f|--force)   FORCE=1; shift ;;
  -d|--default) DEFAULT=1; break ;;
  --)           shift; break ;;
  -*)           printf "Unknown option: $1" >&2; usage ;;
  *)            break ;;   # first non-option argument → stop parsing
 esac
done

# ----------------------------------------------------------------------
# directory, Jqt, Addons parameters

if [ $DEFAULT = "1" ]; then
 D=home
 P=full
 A=all
else
 D=${1:-"home"}
 P=${2:-"full"}
 A=${3:-"all"}
fi

# check likely incorrect directory
case "$D" in
 none|slim|full|all)
 printf "The installation directory may not be one of the keywords: none|slim|full|all\n";
 exit 1 ;;
esac

if [ "$D" = "home" ]; then D="$HOME"; fi

# check Jqt selection
case "$P" in
 none|slim|full) ;;
 *) printf "Invalid Jqt selection: $P\n"; exit 1 ;;
esac

# check Addons selection
case "$A" in
 none|all) ;;
 *) printf "Invalid Addons selection: $A\n"; exit 1 ;;
esac

# ----------------------------------------------------------------------
# check user/path/OS combo
UID1=`id -u`
if [ "$D" = "/usr" ]; then
 if [ "$OS" = "Darwin" ]; then
  printf "This script does not support install to /usr in macOS\n"
  exit 1
 fi
 if [ ! $UID1 = 0 ]; then
  printf "Run this script as root to install under /usr\n"
  exit 1
 fi
else
 if [ $UID1 = 0 ]; then
  printf "You are running this script as root. OK to continue? (y/N) "
  read response
  case "${response:-N}" in
   [Yy]*) ;;
   *) exit 1 ;;
  esac
 fi
fi

# ----------------------------------------------------------------------
# resolve directory path
if [ ! "$D" = "/usr" ]; then
 mkdir -p $D
 cd $D
 D=`pwd`
fi

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

printf "$m in $D/$V\n"

if [ "$FORCE" = 0 ]; then
 printf 'OK to continue? (y/N) '
 read response
 case "${response:-N}" in   # defaults to N on Enter
  [Yy]*) ;;                 # do nothing
  *) printf "Not done.\n"; exit 1 ;;
 esac
fi

M=$(mktemp -d -t 'jtemp.XXXXXX')
trap 'rm -rf "$M"' EXIT
cd $M

S="https://www.jsoftware.com/download/$V/install"

if [ "$OS" = "Darwin" ]; then
 W=${V}_mac64.zip
 curl -OL $S/$W
 unzip $W
else
 if [ "$OS" = "Linux" ]; then
  if [ "$ARCH" = "aarch64" ] || [ "$ARCH" = "arm64" ] ; then
   W=${V}_raspi64.tar.gz
  elif [ "$ARCH" = "armv6l" ]; then
   W=${V}_raspi32.tar.gz
  else
   W=${V}_linux64.tar.gz
  fi
 elif [ "$OS" = "FreeBSD" ]; then
  if [ "$ARCH" = "aarch64" ] || [ "$ARCH" = "arm64" ] ; then
   printf "This script only works for x86_64\n" ; exit 1
  else
   W=${V}_fbsd64.tar.gz
  fi
 elif [ "$OS" = "OpenBSD" ]; then
  if [ "$ARCH" = "aarch64" ] || [ "$ARCH" = "arm64" ] ; then
   printf "This script only works for x86_64\n" ; exit 1
  else
   W=${V}_obsd64.tar.gz
  fi
 fi
 wget $S/$W
 tar -xf $W
fi

# ----------------------------------------------------------------------
if [ "$OS" = "Linux" ] && [ "$D" = "/usr" ]; then
 cd $V
 bin/jconsole -js "install 'system $P $A'"
 if [ -f "/etc/alternatives/ijconsole" ]; then
  update-alternatives --remove-all ijconsole
 fi
 bin/install-usr.sh
else
 mkdir -p $D/$V
 cp -r $M/$V/* $D/$V
 cd $D/$V
 bin/jconsole -js "install 'system $P $A'"
fi

