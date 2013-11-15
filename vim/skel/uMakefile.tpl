MOD_VERSION		= 1.0
MOD_PATH		= $(shell dirname `pwd -P`)
DISTFILES		= *.gcno

CC			= $(CROSS_COMPILE)gcc
CXX			= $(CROSS_COMPILE)g++
AR			= $(CROSS_COMPILE)ar
LD			= $(CROSS_COMPILE)ld
STRIP			= $(CROSS_COMPILE)strip

INCLUDES		+= -I$(MOD_PATH)/include
WFLAGS			?= -W							\
			  -Wall							\
			  -Werror						\
			  -Wundef						\
			  -fno-strict-aliasing					\
			  -fno-delete-null-pointer-checks			\
			  -Wuninitialized	#				\
			  -D_FORTIFY_SOURCE=2					\
			  -D_REENTRANT						\
			  -fPIE							\
			  -fstack-protector

CFLAGS			= $(WFLAGS)						\
			  -std=c99						\
			  $(EXTRA_CFLAGS)					\
			  -DMOD_VERSION='"$(MOD_VERSION)"'			\
			  $(INCLUDES)

CXXFLAGS		= $(WFLAGS)						\
			  -std=c++0x						\
			  $(EXTRA_CXXFLAGS)					\
			  -DMOD_VERSION='"$(MOD_VERSION)"'			\
			  $(INCLUDES)

LDFLAGS			= $(EXTRA_LDFLAGS)
LIB			+= $(EXTRA_LIB)

ifdef DEBUG
CFLAGS 			+= -g -ggdb -O -DPFA_DEBUG
CXXFLAGS 		+= -g -ggdb -O -DPFA_DEBUG

ifdef GCOV
CFLAGS			+= -fprofile-arcs -ftest-coverage
CXXFLAGS		+= -fprofile-arcs -ftest-coverage
LIB			+= -lgcov
endif #! GCOV #

else #! DEBUG #
CFLAGS 			+= -O2
CXXFLAGS 		+= -O2

endif

# FIXME: add your targets and source files here
TARGETS			= libmylib_static.a					\
			  mybinary

libmylib_static.i-objs	= src/mylib_file1.o					\
			  src/mylib_file2.o

my_binary-objs		= src/mybinary_file1.o					\
			  src/mybinary_file2.o

define TARGET_LIB_STATIC_compile
$(1): $$($(1)-objs)
	@echo "  AR		$(1)"
	@$(AR) rcs $(1) $$($(1)-objs)
endef

define TARGET_LIB_STATIC_install
$(1)_install:
endef
$(foreach target,$(filter %.a,$(TARGETS)),$(eval $(call TARGET_LIB_STATIC_compile,$(target))))
$(foreach target,$(filter %.a,$(TARGETS)),$(eval $(call TARGET_LIB_STATIC_install,$(target))))

define TARGET_BINARY_compile
$(1): $$($(1)-objs)
	@echo "  LD		$(1) (v$(MOD_VERSION))"
# FIXME: use LD instead of CXX
#	$(LD) -v -v -static -o $(1) -L$(shell $(CC) -print-file-name=) /usr/lib/crt1.o /usr/lib/crti.o $$($(1)-objs) $(LIB) /usr/lib/crtn.o $(LDFLAGS)
	@$(CXX) $(LDFLAGS) -o $(1) $$($(1)-objs) $(LIB)
endef

define TARGET_BINARY_install
$(1)_install:
	@echo "  INSTALL	$(1)"
	@install -d $(DESTDIR)/bin
	@install -m755 $(1) $(DESTDIR)/bin
endef
$(foreach target,$(filter-out %.a,$(TARGETS)),$(eval $(call TARGET_BINARY_compile,$(target))))
$(foreach target,$(filter-out %.a,$(TARGETS)),$(eval $(call TARGET_BINARY_install,$(target))))

define TARGET_clean
$(1)_clean:
	@echo "  CLEAN		$(1)"
	@rm -f $(1) $$($(1)-objs) $(DISTFILES)
endef
$(foreach target,$(TARGETS) $(TARGETS_GEN),$(eval $(call TARGET_clean,$(target))))

define TARGET_generate
$(1): $(1).in
	@echo "  GENERATE	$(1)"
	@cp $(1).in $(1)
endef
$(foreach target,$(TARGETS_GEN),$(eval $(call TARGET_generate,$(target))))
$(foreach target,$(TARGETS_GEN),$(eval $(call TARGET_BINARY_install,$(target))))

%.o: %.c
	@echo "  CC		$@"
	@$(CC) $(CFLAGS) -c $(MOD_PATH)/user/$< -o $@

%.o: %.cc
	@echo "  CXX		$@"
	@$(CXX) $(CXXFLAGS) -c $(MOD_PATH)/user/$< -o $@

all: $(TARGETS_GEN) $(TARGETS)

clean: $(addsuffix _clean,$(TARGETS_GEN)) $(addsuffix _clean,$(TARGETS))

install: all $(addsuffix _install,$(TARGETS_GEN)) $(addsuffix _install,$(TARGETS))

debian:
	dpkg-buildpackage -b -uc -a$(DEBIAN_ARCH) -t$(CROSS_COMPILE)

.DEFAULT: all

.PHONY: debian

# vim:filetype=make
