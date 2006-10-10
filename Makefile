# spsel - simple print selection
#   (C)opyright MMVI Anselm R. Garbe

include config.mk

SRC = spsel.c
OBJ = ${SRC:.c=.o}

all: options spsel

options:
	@echo spsel build options:
	@echo "CFLAGS   = ${CFLAGS}"
	@echo "LDFLAGS  = ${LDFLAGS}"
	@echo "CC       = ${CC}"
	@echo "LD       = ${LD}"

.c.o:
	@echo CC $<
	@${CC} -c ${CFLAGS} $<

${OBJ}: config.mk

spsel: ${OBJ}
	@echo LD $@
	@${LD} -o $@ ${OBJ} ${LDFLAGS}
	@strip $@

clean:
	@echo cleaning
	@rm -f spsel ${OBJ} spsel-${VERSION}.tar.gz

dist: clean
	@echo creating dist tarball
	@mkdir -p spsel-${VERSION}
	@cp -R LICENSE Makefile README config.mk ${SRC} spsel-${VERSION}
	@tar -cf spsel-${VERSION}.tar spsel-${VERSION}
	@gzip spsel-${VERSION}.tar
	@rm -rf spsel-${VERSION}

install: all
	@echo installing executable file to ${DESTDIR}${PREFIX}/bin
	@mkdir -p ${DESTDIR}${PREFIX}/bin
	@cp -f spsel ${DESTDIR}${PREFIX}/bin
	@chmod 755 ${DESTDIR}${PREFIX}/bin/spsel

uninstall:
	@echo removing executable file from ${DESTDIR}${PREFIX}/bin
	@rm -f ${DESTDIR}${PREFIX}/bin/spsel

.PHONY: all options clean dist install uninstall
