export BR2_EXTERNAL := $(CURDIR)/infix:$(CURDIR)

ARCH   ?= $(shell uname -m)
O      ?= $(CURDIR)/output

config := $(O)/.config
bmake   = $(MAKE) -C infix/buildroot O=$(O) $1
imake   = $(MAKE) -C infix O=$(O) $1


all: $(config) infix/buildroot/Makefile
	@+$(call bmake,$@)

$(config):
	@+$(call bmake,list-defconfigs)
	@echo "ERROR: No configuration selected."
	@echo "Please choose a configuration from the list above by running"
	@echo "'make <board>_defconfig' before building an image."
	@exit 1

%_defconfig: configs/%_defconfig
	@+$(call bmake,$@)

%: | infix/buildroot/Makefile
	@+$(call bmake,$@)

infix/buildroot/Makefile:
	@git submodule update --init --recursive

.PHONY: all

.PHONY: test

test:
	$(call imake,test)

test-spec:
	$(call imake,test-spec)

defconfigs-generate:
	 ./infix/utils/generate-defconfig.sh -b infix/configs/aarch64_defconfig -c config-snippets/vendor.conf -o configs/aarch64_defconfig
	 ./infix/utils/generate-defconfig.sh -b infix/configs/x86_64_defconfig -c config-snippets/vendor.conf -o configs/x86_64_defconfig
	 ./infix/utils/generate-defconfig.sh -b infix/configs/aarch64_minimal_defconfig -c config-snippets/vendor.conf -o configs/aarch64_minimal_defconfig
	 ./infix/utils/generate-defconfig.sh -b infix/configs/x86_64_minimal_defconfig -c config-snippets/vendor.conf -o configs/x86_64_minimal_defconfig
