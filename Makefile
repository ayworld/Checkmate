# Checkmate (c) 2014-2015 Kaleb Klein

# Prerequisites
# Make (build)
# Qt5 Base and Qt5 Webkit

# all: updater app

all: app

install:
	mkdir /opt/checkmate
	cp src/Checkmate /opt/checkmate/Checkmate
	# cp updater_src/CheckmateUpdater /opt/checkmate/CheckmateUpdater
	ln -s /opt/checkmate/Checkmate /usr/bin/checkmate
	cp checkmate.desktop /usr/share/applications/checkmate.desktop
	cp src/gear.png /usr/share/icons/checkmate_icon.png

uninstall:
	rm -rf /opt/checkmate
	rm /usr/share/applications/checkmate.desktop
	rm /usr/share/icons/checkmate_icon.png
	rm /usr/bin/checkmate

updater:
	qmake updater_src/CheckmateUpdater.pro -o updater_src/Makefile
	make -C updater_src

app:
	qmake src/Checkmate.pro -o src/Makefile
	make -C src

clean:
	# make -C updater_src clean
	make -C src clean
	rm src/Makefile
	rm src/Checkmate
	# rm updater_src/Makefile
	# rm updater_src/CheckmateUpdater
