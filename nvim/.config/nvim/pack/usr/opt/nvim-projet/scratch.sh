#!/bin/sh
set -ex &&
	apk add --no-cache --virtual .lua-builddeps \
		ca-certificates \
		curl \
		gcc \
		libc-dev \
		make \
		readline-dev \
		ncurses-dev &&
	curl -fsSL -o /tmp/lua.tar.gz "https://www.lua.org/ftp/lua-5.1.5.tar.gz" &&
	cd /tmp &&
	echo "b3882111ad02ecc6b972f8c1241647905cb2e3fc *lua.tar.gz" | sha1sum -c - &&
	mkdir /tmp/lua &&
	tar -xf /tmp/lua.tar.gz -C /tmp/lua --strip-components=1 &&
	cd /tmp/lua &&
	make linux &&
	make install &&
	cd / &&
	apk add --no-network --no-cache --virtual .lua-rundeps \
		readline \
		ncurses-libs &&
	apk del --no-network .lua-builddeps &&
	rm -rf /tmp/lua /tmp/lua.tar.gz &&
	lua -v
