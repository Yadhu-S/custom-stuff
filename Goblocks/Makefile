##
#
# @file
# @version 1.0
build:
	go build goblocks.go

install: build
	sudo cp -f goblocks /usr/local/bin/goblocks; \
	sudo chmod 755 /usr/local/bin/goblocks

uninstall:
	sudo rm -f /usr/local/bin/goblocks

run: build
	./goblocks
