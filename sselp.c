/* See LICENSE file for license details. */
#include <stdio.h>
#include <string.h>
#include <X11/Xlib.h>
#include <X11/Xatom.h>

int
main(int argc, char *argv[]) {
	Atom utf8, type;
	Display *dpy;
	Window win;
	XEvent ev;
	int fmt;
	long off = 0;
	unsigned char *data;
	unsigned long len, more;

	if(argc > 1 && !strcmp(argv[1], "-v")) {
		fputs("sselp-"VERSION", © 2006-2010 Anselm R Garbe\n", stdout);
		return 0;
	}
	if(!(dpy = XOpenDisplay(NULL)))
		return 1;

	utf8 = XInternAtom(dpy, "UTF8_STRING", False);
	win = XCreateSimpleWindow(dpy, DefaultRootWindow(dpy), 0, 0, 1, 1, 0,
	                          CopyFromParent, CopyFromParent);
	XConvertSelection(dpy, XA_PRIMARY, utf8, None, win, CurrentTime);

	XNextEvent(dpy, &ev);
	if(ev.type == SelectionNotify && ev.xselection.property != None) {
		do {
			XGetWindowProperty(dpy, win, utf8, off, BUFSIZ, False,
			                   utf8, &type, &fmt, &len, &more, &data);
			fwrite(data, 1, len, stdout);
			XFree(data);
			off += len;
		}
		while(more > 0);
		putchar('\n');
	}
	XCloseDisplay(dpy);
	return 0;
}
