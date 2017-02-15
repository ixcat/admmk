#! /bin/sh
# bmake.sh: simple 'driver' script to install bmake into /usr/local/bin

# currently only tested against openbsd 5.5
# will probably have path issues on some other platforms - e.g. '-g bin'
# not setup on some linuces

cd bmake \
	&& make -f Makefile.boot \
	&& install -m 555 -o root -g bin bmake /usr/local/bin/bmake \
	&& install -m 444 -o root -g bin make.1 /usr/local/man/man1/bmake.1 \
	&& make -f Makefile.boot clean

