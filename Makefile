#--------------------------
# MultiMail Makefile (top)
#--------------------------

include version

# General options (passed to mmail/Makefile and interfac/Makefile):

# With debug:
#OPTS = -g -Wall -pedantic

# Optimized, no debug:
#OPTS = -O2 -Wall -pedantic

# Optimized for egcs -- since MultiMail does not (yet) use exceptions, we
# can save a little space in the executable:
OPTS = -O2 -Wall -pedantic -fno-exceptions -fno-rtti -fconserve-space

# PREFIX is the base directory under which to install the binary and man 
# page; generally either /usr/local or /usr (or perhaps /opt...):

PREFIX = /usr/local

# Delete command ("rm" or "del", as appropriate):

RM = rm -f

# The separator for multi-statement lines... some systems require ";",
# while others need "&&":

SEP = ;

# Any post-processing that needs doing:

POST =

#--------------------------------------------------------------
# Defaults are for the standard curses setup:

# CURS_INC specifies the location of your curses header file. Broken
# brackets (<, >) should be preceded by backslashes. Quotes (") should
# be preceded by *three* backslashes:

CURS_INC = \<curses.h\>

# CURS_DIR may also be necessary in some cases:

CURS_DIR = .

# CURS_LIB specifies the directory where the curses libraries can be found,
# if they're not in the standard search path:

CURS_LIB = .

# LIBS lists any "extra" libraries that need to be linked in:

LIBS = -lcurses

#--------------------------------------------------------------
# With ncurses installed beside the original curses, rather than
# replacing it -- for older Linux distros, etc.:

#CURS_INC = \<ncurses/curses.h\>
#CURS_DIR = /usr/include/ncurses
#CURS_LIB = /usr/local/lib
#LIBS = -lncurses

# For static linking (examples):

#LIBS = /usr/lib/libncurses.a
#LIBS = /opt/sfw/lib/libncurses.a

#--------------------------------------------------------------
# With ncurses installed in the user's home directory:

# Example with quotes (relative pathnames start from ./interfac):
#CURS_INC = \\\"../../ncurses-5.2/include/curses.h\\\"
#CURS_DIR = ../../ncurses-5.2/include
#CURS_LIB = ../ncurses-5.2/lib
#LIBS = -lncurses

#--------------------------------------------------------------
# With XCurses (PDCurses 2.5) in my home directory:

#CURS_INC = \\\"/home/wmcbrine/PDCurses-2.5/curses.h\\\"
# Sneak some extra defines in through the back door:
#CURS_DIR = /home/wmcbrine/PDCurses-2.5 -DXCURSES -DHAVE_PROTO
#CURS_LIB = /home/wmcbrine/PDCurses-2.5/pdcurses
#LIBS = -L/usr/X11R6/lib -lXCurses -lXaw -lXmu -lXt -lX11 -lSM -lICE -lXext

#--------------------------------------------------------------
#--------------------------------------------------------------

HELPDIR = $(PREFIX)/man/man1

all:	mm

mm-main:
	cd mmail $(SEP) $(MAKE) MM_MAJOR="$(MM_MAJOR)" \
		MM_MINOR="$(MM_MINOR)" OPTS="$(OPTS)" mm-main $(SEP) cd ..

intrfc:
	cd interfac $(SEP) $(MAKE) MM_MAJOR="$(MM_MAJOR)" \
		MM_MINOR="$(MM_MINOR)" OPTS="$(OPTS) -I$(CURS_DIR)" \
		CURS_INC="$(CURS_INC)" intrfc $(SEP) cd ..

mm:	mm-main intrfc
	$(CXX) -o mm mmail/*.o interfac/*.o -L$(CURS_LIB) $(LIBS)
	$(POST)

dep:
	cd interfac $(SEP) $(MAKE) CURS_INC="$(CURS_INC)" dep $(SEP) cd ..
	cd mmail $(SEP) $(MAKE) dep $(SEP) cd ..

clean:
	cd interfac $(SEP) $(MAKE) RM="$(RM)" clean $(SEP) cd ..
	cd mmail $(SEP) $(MAKE) RM="$(RM)" clean $(SEP) cd ..
	$(RM) mm

modclean:
	cd mmail $(SEP) $(MAKE) RM="$(RM)" modclean $(SEP) cd ..

install:
	install -c -s mm $(PREFIX)/bin
	install -c -m 644 mm.1 $(HELPDIR)
	$(RM) $(HELPDIR)/mmail.1
	ln $(HELPDIR)/mm.1 $(HELPDIR)/mmail.1