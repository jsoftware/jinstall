#!/bin/bash
#
# copies the script into the current directory and makes a zip

cp script/jinstall.sh .

zip jinstall.zip jinstall.sh

ls -alrt
