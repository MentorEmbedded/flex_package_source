# NMake Makefile portion for enabling features for Windows builds

# Please do not change anything beneath this line unless maintaining the NMake Makefiles
OUTDIR = vs$(VSVER)\$(CFG)\$(PLAT)
RSVG_VER = 2
RSVG_API_VER = $(RSVG_VER).0
CHECK_GIR_PACKAGE = gdk-pixbuf-2.0
RSVG_PKG_VERSION = 2.52.10

# Make bin, include and library directories of configurable
!ifndef BINDIR
BINDIR=$(PREFIX)\bin
!endif

!ifndef LIBDIR
LIBDIR=$(PREFIX)\lib
!endif

!ifndef INCLUDEDIR
INCLUDEDIR=$(PREFIX)\include
!endif

# Make import libs of gettext-runtime, FreeType
# HarfBuzz and libxml2 configurable
!ifndef LIBINTL_LIB
LIBINTL_LIB = intl.lib
!endif

!ifndef FREETYPE_LIB
FREETYPE_LIB = freetype.lib
!endif

!ifndef HARFBUZZ_LIB
HARFBUZZ_LIB = harfbuzz.lib
!endif

!ifndef LIBXML2_LIB
LIBXML2_LIB = libxml2.lib
!endif

LDFLAGS = $(LDFLAGS) /libpath:$(LIBDIR)

# These are the base minimum libraries required for building librsvg.

# Visual Studio 2015 and later supports the /utf-8 compiler flag
# that prevents C4819 warnings/errors on non-Western locales
!if $(VSVER) > 12
EXTRA_BASE_CFLAGS = /utf-8
!else
EXTRA_BASE_CFLAGS =
!endif

BASE_CFLAGS =				\
	$(CFLAGS_ADD)			\
	/DHAVE_CONFIG_H			\
	/FImsvc_recommended_pragmas.h	\
	$(EXTRA_BASE_CFLAGS)

BASE_DEP_INCLUDES =			\
	/I$(INCLUDEDIR)\gdk-pixbuf-2.0	\
	/I$(INCLUDEDIR)\pango-1.0	\
	/I$(INCLUDEDIR)\gio-win32-2.0	\
	/I$(INCLUDEDIR)\glib-2.0	\
	/I$(LIBDIR)\glib-2.0\include	\
	/I$(INCLUDEDIR)\harfbuzz	\
	/I$(INCLUDEDIR)

BASE_DEP_LIBS =			\
	gdk_pixbuf-2.0.lib	\
	gio-2.0.lib		\
	gobject-2.0.lib		\
	glib-2.0.lib		\
	cairo.lib		\
	$(HARFBUZZ_LIB)	\
	$(FREETYPE_LIB)	\
	$(LIBXML2_LIB)	\
	$(LIBINTL_LIB)

LIBRSVG_LOG_DOMAIN = /DG_LOG_DOMAIN=\"librsvg\"

LIBRSVG_CFLAGS =				\
	$(BASE_CFLAGS)				\
	$(LIBRSVG_LOG_DOMAIN)			\
	/DRSVG_DISABLE_DEPRECATION_WARNINGS	\
	/DRSVG_COMPILATION			\
	/DRSVG_API=__declspec(dllexport)

LIBRSVG_INCLUDES =			\
	/I..\include			\
	/I.\$(OUTDIR)\librsvg		\
	$(BASE_DEP_INCLUDES)		\
	/I$(INCLUDEDIR)\libxml2

TEST_CFLAGS = $(BASE_CFLAGS)
TEST_DEP_LIBS = pango-1.0.lib harfbuzz.lib freetype.lib $(TOOLS_DEP_LIBS)

# Use PangoFT2 (for tests only)
!ifdef USE_PANGOFT2
TEST_CFLAGS =		\
	$(TEST_CFLAGS)	\
	/DHAVE_PANGOFT2

TEST_DEP_LIBS =	\
	$(TEST_DEP_LIBS)	\
	pangoft2-1.0.lib	\
	fontconfig.lib
!endif

RSVG_INTERNAL_LIB = $(OUTDIR)\obj\rsvg_c_api\$(RUST_TARGET)-pc-windows-msvc\$(CFG)\librsvg.lib

LIBRSVG_DEP_LIBS =			\
	$(RSVG_INTERNAL_LIB)		\
	pangocairo-1.0.lib		\
	$(LIBRSVG_EXTRA_DEP_LIBS)	\
	pango-1.0.lib			\
	cairo-gobject.lib		\
	$(BASE_DEP_LIBS)		\
	libxml2.lib			\
	advapi32.lib			\
	userenv.lib			\
	ws2_32.lib

RSVG_PIXBUF_LOADER_CFLAGS =			\
	$(BASE_CFLAGS)				\
	/DGDK_PIXBUF_ENABLE_BACKEND		\
	/DG_LOG_DOMAIN=\"libpixbufloader-svg\"

!if "$(LIBTOOL_DLL_NAME)" == "1"
LIBRSVG_DLL_FILENAME = $(OUTDIR)\librsvg-$(RSVG_API_VER)-0
!else
LIBRSVG_DLL_FILENAME = $(OUTDIR)\rsvg-$(RSVG_API_VER)-vs$(VSVER)
!endif

LIBRSVG_DLL = $(LIBRSVG_DLL_FILENAME).dll
LIBRSVG_LIB = $(OUTDIR)\rsvg-$(RSVG_API_VER).lib
LIBRSVG_DEF = $(OUTDIR)\librsvg\librsvg.def

GDK_PIXBUF_SVG_LOADER = $(OUTDIR)\libpixbufloader-svg.dll

TOOLS_DEP_INCLUDES =		\
	/I..\include		\
	/I.\$(OUTDIR)\librsvg	\
	$(BASE_DEP_INCLUDES)

TOOLS_DEP_LIBS = $(BASE_DEP_LIBS)

RSVG_TOOLS = $(OUTDIR)\rsvg-convert.exe

# Build Introspection if requested
EXTRA_TARGETS = $(GDK_PIXBUF_SVG_LOADER)
!ifdef INTROSPECTION
EXTRA_TARGETS =				\
	$(EXTRA_TARGETS)		\
	$(OUTDIR)\Rsvg-2.0.typelib
!endif
