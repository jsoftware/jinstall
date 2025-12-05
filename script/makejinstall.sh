
P=`pwd`

cd script
chmod +x jinstall.sh
tar -czf ../linux64_install.tar.gz jinstall.sh

cp jinstall.sh jinstall.command
zip ../mac64_install.zip jinstall.command

cd ..
ls -alrt
