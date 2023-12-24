#!/bin/bash
#
# write revision.txt as full revision name, e.g. 9.6.0-beta1

rm -f version*
wget https://www.jsoftware.com/download/jengine/$1/version.txt
R=`sed -n -e '/#define/p' version.txt | cut -d ' ' -f 3`
R=${R//'"'}
echo $R > revision.txt
