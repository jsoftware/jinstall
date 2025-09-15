#!/bin/bash

# get release in form j9.7:
S=`pwd`
echo $S

read -r V < release.txt
V=j$V
echo $V

D=https://www.jsoftware.com/download/$V

T=/tmp/aio
mkdir -p $T
rm -rf $T/*

W=/tmp/web
mkdir -p $W
rm -rf $W/*

buildlist=""

# mac ------------------------------------------------------------------
f() {
 if [[ "slim" = "$1" ]]; then
   s="-slim";
   t="_slim";
 fi
 rm -rf $T/*
 cd $T
 F=${V}_mac64.zip
 I=jqt-mac${s}.zip
 L=qt68-mac${s}.zip
 wget -q $D/install/$F
 wget -q $D/qtide/$I
 wget -q $D/qtlib/$L
 unzip -q $F
 unzip -q $L
 cd $V
 mv ../Qt .
 cd bin
 unzip -q  ../../$I
 cd ../..
 id="$W/mac64_AIO${t}.zip"
 buildlist+="${id},"
 zip -9ry $id $V
}

f ""
f "slim"

echo "after mac builds: $buildlist"

# linux ----------------------------------------------------------------
f() {
 if [[ "slim" = "$1" ]]; then
   s="-slim";
   t="_slim";
 fi
 rm -rf $T/*
 cd $T
 F=${V}_linux64.tar.gz
 I=jqt-linux${s}.tar.gz
 L=qt68-linux${s}.tar.gz
 wget -q $D/install/$F
 wget -q $D/qtide/$I
 wget -q $D/qtlib/$L
 tar -xf $F
 tar -xf $L
 cd $V
 rm -rf Qt
 mv ../Qt .
 cd bin
 tar -xf ../../$I
 cd ../..
 id="$W/linux64_AIO${t}.tar.gz"
 buildlist+="${id},"
 tar -cf - $V | gzip -9 - > $id
}

f ""
f "slim"

# finish ---------------------------------------------------------------
cd $S
cp $W/* .
buildlist="${buildlist::-1}"
echo $buildlist > buildlist.txt
cat buildlist.txt
ls -l
