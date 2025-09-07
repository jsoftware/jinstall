#!/bin/bash

# get release in form j9.7:
S=`pwd`
echo $S

read -r V < release.txt
V=j$V
echo $V

script/getrevision.sh $V
read -r R < revision.txt
R=j$R

D=https://www.jsoftware.com/download/$V

T=/tmp/aio
mkdir -p $T
rm -rf $T/*

W=/tmp/web
mkdir -p $W
rm -rf $W/*

buildlist=""

# mac full -------------------------------------------------------------
cd $T
F=${V}_mac64.zip
I=jqt-mac.zip
L=qt68-mac.zip
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
id="$W/${R}_mac64_AIO.zip"
buildlist+="${id},"
echo $id >> buildlist.txt
zip -9ry $id $V

# mac slim -------------------------------------------------------------
I=jqt-mac-slim.zip
L=qt68-mac-slim.zip
wget $D/qtide/$I
wget $D/qtlib/$L
unzip $L
cd $V
rm -rf Qt
mv ../Qt .
cd bin
unzip -xvf ../../$I
cd ../..
id="$W/${R}_mac64_AIO_slim.tar.gz"
buildlist+="${id},"
zip -9ry $id $V

# linux full -----------------------------------------------------------
rm -rf $T/$V/*
cd $T
F=${V}_linux64.tar.gz
I=jqt-linux.tar.gz
L=qt68-linux.tar.gz
wget $D/install/$F
wget $D/qtide/$I
wget $D/qtlib/$L
tar -xvf $F
tar -xvf $L
cd $V
mv ../Qt .
cd bin
tar -xvf ../../$I
cd ../..
id="$W/${R}_linux64_AIO.tar.gz"
buildlist+="${id},"
tar -cvf - $V | gzip -9 - > $id

# linux slim -----------------------------------------------------------
I=jqt-linux-slim.tar.gz
L=qt68-linux-slim.tar.gz
wget $D/qtide/$I
wget $D/qtlib/$L
tar -xvf $L
cd $V
rm -rf Qt
mv ../Qt .
cd bin
tar -xvf ../../$I
cd ../..
id="$W/${R}_linux64_AIO_slim.tar.gz"
buildlist+="${id}"
tar -cvf - $V | gzip -9 - > $id

# finish ---------------------------------------------------------------
cd $S
cp $W/* .
echo $buildlist > buildlist.txt
cat buildlist.txt
ls -l
