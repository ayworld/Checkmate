# Fedora RPM Packaging for Checkmate

## Required Packages
* @development-tools
* fedora-packager
* rpmdevtools
* git
* gcc-c++
* qt5-qtbase
* qt5-qtbase-devel

## Setup
1. Clone the GitHub repo: `/> git clone https://github.com/pazuzu156/checkmate.git`

2. Create a new directory on the desktop. Use the version number given in `src/refs.h` on line 22: `#define VERSION_NAME "<VERSION_HERE>"`

3. It should look like this: checkmate-<VERSION_NAME>

4. Copy `src/` `checkmate.desktop` and `Makefile` and paste them into the new directory you created

5. Edit `Makefile` Replace `QMAKE=qmake` with `QMAKE=qmake-qt5`

6. Compress the folder in .tar.gz format: `/> tar -czvf checkmate-<VERSION_NAME>.tar.gz checkmate-<VERSION_NAME>`

7. Create RPM tree: `/> rpmdev-setuptree`

8. Paste the .tar.gz archive into `~/rpmbuild/SOURCES`

9. Change to RPM_BUILD_SCRIPTS branch: `/> git checkout rpm_build_scripts`

10. Copy `checkmate.spec` to `~/rpmbuild/SPECS` and CD into this directory: `/> cd ~/rpmbuild/SPECS`

12. Build the RPM! `/> rpmbuild -ba checkmate.spec`

Your new rpm package will be under `~/rpmbuild/RPMS/<ARCHITECTURE>`