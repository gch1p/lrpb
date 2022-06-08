PREFIX = /usr/local
INSTALL = /usr/bin/env install

all:
	@echo "run \"make install\" to install to $(PREFIX)"

install:
	$(INSTALL) lrpb $(PREFIX)/bin

.PHONY: all install

