# build J installers

release.txt has the J release number as major.minor e.g. 9.5.

build.txt has a dummy build number.
Any change to it triggers copy build to the jsoftware server.
The number itself is unimportant, e.g. just increment it for a new build.

Other files need not be changed.

## Method

For now, this requires two manual steps. In the following REL is the J release number with a 'j' prefix, e.g. j9.5.

* jsource repo builds the JE binaries. Any change to the version.txt file triggers copy to the download/jengine/staged area of the webserver. If OK, then manually push this to the download/jengine/REL folder. 
* base9 repo builds the base library + required addons. Any commit updates the download/library folder.
* jinstall repo builds the installers. Make any update to the build.txt file, then commit. This builds the installers which are written to the download/REL/staged area. If OK, then manually push this to the download/REL/install area and run installer.sh REL (as sudo).
