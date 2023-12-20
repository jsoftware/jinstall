# build J installers

release.txt has the J release number as major.minor e.g. 9.5.

build.txt has a dummy build number.
Any change to it triggers copy build to the jsoftware server.
The number itself is unimportant, e.g. just increment it for a new build.

Other files need not be changed.

## Method

In the following REL is the J release number with a 'j' prefix, e.g. j9.5.

* qtide repo builds REL/qtidedev - then manual copy to REL/qtide (this is the only manual step).

* base9 repo builds the base library in download/library/base9.tar.gz.

* jsource repo builds the JE binaries in github.com/jsoftware/jsource/releases/tag/build. Update the version number in version.txt to copy to download/jengine/REL and then run jinstall.

* jinstall repo builds the installers. Make any update to the build.txt file, then commit.
