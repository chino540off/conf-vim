MOD_VERSION		= 1.0
MOD_PATH		= $(shell dirname `pwd -P`)
LINUX_PATH 		= # FIXME

INCLUDES		+= -I$(MOD_PATH)/include
WFLAGS			+= -Werror

EXTRA_CFLAGS 		+= $(WFLAGS)							\
			   $(INCLUDES)							\
			   -DMOD_VERSION='\"'$(MOD_VERSION)'\"'

KBUILD_EXTRA_SYMBOLS    += -I $(MOD_PATH)/Module.symvers

ifdef DEBUG
EXTRA_CFLAGS 		+= -g -ggdb -O0

ifdef GCOV
EXTRA_CFLAGS		+= -fprofile-arcs -ftest-coverage
endif #! GCOV #

else #! DEBUG #
EXTRA_CFLAGS 		+= -O2

endif #! DEBUG #

# FIXME: add your targets and source files here
TARGETS			= my_mod
my_mod-objs		= src/my_mod_file1.o						\
			  src/my_mod_file2.o


make_obj		= $(1).o
make_mod_objs		= $(1)-objs="$($(1)-objs)"

modules:
	+make -C $(LINUX_PATH)/ M=$(PWD) modules					\
		EXTRA_CFLAGS="$(EXTRA_CFLAGS)"						\
		KBUILD_EXTRA_SYMBOLS="$(KBUILD_EXTRA_SYMBOLS)"				\
		V=$(V)									\
		obj-m="$(foreach target,$(TARGETS),$(call make_obj,$(target)))"		\
		$(foreach target,$(TARGETS),$(call make_mod_objs,$(target)))

clean:
	+make -C $(LINUX_PATH)/ M=$(PWD) clean

modules_install:
	+make -C $(LINUX_PATH)/ M=$(PWD) modules_install				\
		INSTALL_MOD_PATH=$(DESTDIR)						\
		INSTALL_MOD_DIR=$(subst $(BASEDIR)/dev/,,$(MOD_PATH))

.DEFAULT: modules

# vim:filetype=make
