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
 rm -rf $T/$V/*
 cd $T
 F=${V}_mac64.zip
 I=jqt-mac${s}.zip
 L=qt68-mac${s}.zip
 wget $D/install/$F
 wget $D/qtide/$I
 wget $D/qtlib/$L
 unzip $F
 unzip $L
 cd $V
 mv ../Qt .
 cd bin
 unzip  ../../$I
 cd ../..
 id="$W/mac64_AIO${t}.zip"
 buildlist+="${id},"
 zip -9ry $id $V
}

f ""
f "slim"

# linux ----------------------------------------------------------------
f () {
 if [[ "slim" = "$1" ]]; then
   s="-slim";
   t="_slim";
 fi
rm -rf $T/$V/*
I=jqt-linux${s}.tar.gz
L=qt68-linux${s}.tar.gz
wget $D/install/$F
wget $D/qtide/$I
wget $D/qtlib/$L
tar -xvf $F
tar -xvf $L
cd $V
rm -rf Qt
mv ../Qt .
cd bin
tar -xvf ../../$I
cd ../..
id="$W/linux64_AIO${t}.tar.gz"
buildlist+="${id},"
tar -cvf - $V | gzip -9 - > $id
}

f ""
f "slim"

# finish ---------------------------------------------------------------
cd $S
cp $W/* .
echo "${buildlist::-1}" > buildlist.txt
cat buildlist.txt
ls -l
