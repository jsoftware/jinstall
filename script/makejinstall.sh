
P=`pwd`

ls -alrt

# get release in form j9.7:
read -r V < release.txt
V=j$V

cd script
chmod +x jinstall.sh
tar -czf ../${V}_linux64_install.tar.gz jinstall.sh

cp jinstall.sh jinstall.command
zip ../${V}_mac64_install.zip jinstall.command

cd ..
ls -alrt
