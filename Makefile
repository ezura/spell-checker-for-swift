INSTALL_PATH = /usr/local/bin/typokana

install:
	swift package update
	swift build -c release
	cp -f .build/release/typokana $(INSTALL_PATH)

uninstall:
	rm -f $(INSTALL_PATH)
