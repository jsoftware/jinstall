#!/bin/bash
#
# read in shared files

# e.g. j9.6 home temp shared
V=$1
H=$2
M=$3
S=$4

mkdir -p $M
rm -rf $M/*

J=https://www.jsoftware.com

cd $S

# base9 library
wget -nc -q $J/download/library/base9.tar.gz > /dev/null
tar -xvf base9.tar.gz
rm -f *.gz
cp -R $H/common/* install

# required addons
cd $M
W="${V:1}"
K=${W%.*}
L=${W#*.}
if [ 1 = ${#L} ] ; then L="0$L"; fi
D=$J/jal/j"$K$L"
wget $D/addons.txt

g() {
  B=`echo $1 | cut -d " " -f1 | tr / _`
  E=`echo $1 | cut -d " " -f2`
  F="${B}_${E}_linux.tar.gz"
  wget $D/addons/$F > /dev/null
  tar xvf $F
}

for f in eformat fold lu modular; do
  T=`sed -n -e "/^dev\/${f}/p" addons.txt`
  g "$T"
done

for f in jhs qt; do
  T=`sed -n -e "/^ide\/${f}/p" addons.txt`
  g "$T"
done

rm *.txt*
rm *.gz*

T=$S/install/addons
mkdir -p $T
mv * $T
