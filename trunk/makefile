INSTDIR=/usr/local
PROGNAME=yolanda

build: frontend backend
	echo "building"

backend: database
	# TODO: copy apache configuration

database:
	# TODO: database setup - use dialog to answer the questions
	# which database ? (suggested: mysql)
	# root pasword ? (for setup)
	# yolanda username ? (suggested: yolanda)
	# yolanda password ? (will generate random username if none is chosen)
	dialog --yesno "database stuff" 10 40

frontend: svg2png
	# TODO: figure out what should go in here

install: build
	-mkdir "${INSTDIR}/share/${PROGNAME}"
	-mkdir "${INSTDIR}/share/${PROGNAME}/www"
	# only stuff that is necessary should be copied - how to determine what is necessary ?
	cp * ${INSTDIR}/share/${PROGNAME}/www -R

remove:
	rm -rf "${INSTDIR}/share/yolanda"
	# TODO: kill off database

svg2png:
	# TODO: figure out how imagemagick works and convert every 
single SVG

