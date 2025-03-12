#!/bin/bash

P=`pwd`

# get release in form j9.7:
read -r V < release.txt
V=j$V

E=https://www.jsoftware.com/download/jengine/$V
RX=https://github.com/jsoftware/jsource/raw/master/pcre2
GREP=https://github.com/jsoftware/ide_jhs/raw/master/grep.exe

M=~/libtemp # temp files
S=~/libshared # common files
T=~/libdist # distribution builds
Z=~/libzips # zipped builds

for f in $M $S $T $Z; do
  mkdir -p $f
  rm -rf $f/*
done

$P/script/getrevision.sh $V
$P/script/getshared.sh $V $P $M $S

cat revision.txt

maketar() {
 tar -cf $Z/$1.tar *
 gzip -f $Z/$1.tar
}

makezip() {
 zip $Z/$1.zip -r .
}

# l64 ------------------------------------------------------------------
W=$T/l64/$V
mkdir -p $W/bin
cd $W
cp -R $S/install/* .
cp -R $P/unix/* .
cd bin
cp $P/misc/install-usr.sh .
wget $E/linux/j64/jconsole
wget $E/linux/j64/libj.so
wget $E/linux/j64/libgmp.so
chmod +x jconsole
cd ../tools/regex
wget $RX/linux/x86_64/libjpcre2.so
cd $W/..
maketar linux64

# fbsd64 ---------------------------------------------------------------
W=$T/fbsd64/$V
mkdir -p $W/bin
cd $W
cp -R $S/install/* .
cp -R $P/unix/* .
cd bin
cp $P/misc/install-usr.sh .
wget $E/freebsd/j64/jconsole
wget $E/freebsd/j64/libj.so
wget $E/freebsd/j64/libgmp.so
chmod +x jconsole
cd ../tools/regex
wget $RX/freebsd/x86_64/libjpcre2.so
cd $W/..
maketar fbsd64

# obsd64 ---------------------------------------------------------------
W=$T/obsd64/$V
mkdir -p $W/bin
cd $W
cp -R $S/install/* .
cp -R $P/unix/* .
cd bin
cp $P/misc/install-usr.sh .
wget $E/openbsd/j64/jconsole
wget $E/openbsd/j64/libj.so
wget $E/openbsd/j64/libgmp.so
chmod +x jconsole
cd ../tools/regex
wget $RX/openbsd/x86_64/libjpcre2.so
cd $W/..
maketar obsd64

# p32 ---------------------------------------------------------------
W=$T/p32/$V
mkdir -p $W/bin
cd $W
cp -R $S/install/* .
cp -R $P/unix/* .
cd bin
wget $E/raspberry/j32/jconsole
wget $E/raspberry/j32/libj.so
wget $E/raspberry/j32/libgmp.so
chmod +x jconsole
cd ../tools/regex
wget $RX/linux/arm/libjpcre2.so
cd $W/..
maketar raspi32

# p64 ---------------------------------------------------------------
W=$T/p64/$V
mkdir -p $W/bin
cd $W
cp -R $S/install/* .
cp -R $P/unix/* .
cd bin
wget $E/raspberry/j64/jconsole
wget $E/raspberry/j64/libj.so
wget $E/raspberry/j64/libgmp.so
chmod +x jconsole
cd ../tools/regex
wget $RX/linux/arm/libjpcre2.so
cd $W/..
maketar raspi64

# m64 ---------------------------------------------------------------
W=$T/m64/$V
mkdir -p $W/bin
cd $W
cp -R $S/install/* .
cp -R $P/mac/* .
cd bin
wget $E/darwin/j64/jconsole
wget $E/darwin/j64/libj.dylib
wget $E/darwin/j64/libgmp.dylib
chmod +x jconsole
cd ../tools/regex
wget $RX/apple/macos/libjpcre2.dylib
cd $W/..
makezip mac64

# w64 ---------------------------------------------------------------
W=$T/w64/$V
mkdir -p $W/bin
cd $W
cp -R $S/install/* .
cp -R $P/win/* .
find . -type f -print0 | xargs -0 unix2dos
cd $W/addons/ide/jhs
wget $GREP
cd $W/bin
wget $E/windows/j64/jconsole.exe
wget $E/windows/j64/j.dll
wget $E/windows/j64/mpir.dll
wget $E/windows/j64/pthreadVC3.dll
cd ../tools/regex
wget $RX/windows/x64/jpcre2.dll
cd $W/..
makezip win64

# warm64 ---------------------------------------------------------------
echo "build warm64"
W=$T/warm64/$V
mkdir -p $W/bin
cd $W
cp -R $S/install/* .
cp -R $P/win/* .
find . -type f -print0 | xargs -0 unix2dos
cd $W/addons/ide/jhs
wget $GREP
cd $W/bin
wget $E/windows/jarm64/j.dll
wget $E/windows/jarm64/jconsole.exe
wget $E/windows/jarm64/mpir.dll
wget $E/windows/jarm64/pthreadVC3.dll
cd ../tools/regex
wget $RX/windows/arm64/jpcre2.dll
cd $W/..
makezip winarm64

# cp to home -----------------------------------------------------------
cp $Z/* $P
