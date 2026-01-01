BRANCH = v0.7-3

mkfile_path := $(abspath $(lastword $(MAKEFILE_LIST)))
current_dir := $(patsubst %/,%,$(dir $(mkfile_path)))

architecture = $(shell dpkg --print-architecture)
GITHUB_RUN_NUMBER ?= 0

package = foonathan-memory
version = 0.7.3
build_number = $(GITHUB_RUN_NUMBER)
source_dir = $(current_dir)/src
build_dir = $(current_dir)/build
install_dir = $(current_dir)/install
stage_dir = $(current_dir)/$(package)_$(version)-$(build_number)_$(architecture)
install_prefix = $(install_dir)/opt/foonathan
debian_dir = $(stage_dir)/DEBIAN
control_file = $(debian_dir)/control
maintainer = you@example.com
description = Foonathan memory allocator

all: clone build stage control package

clone:
	git clone --branch=$(BRANCH) --depth=1 https://github.com/foonathan/memory.git src

build:
	mkdir $(build_dir)
	(cd $(build_dir); cmake $(source_dir) -DCMAKE_INSTALL_PREFIX=$(install_prefix) -DFOONATHAN_MEMORY_BUILD_EXAMPLES=OFF -DFOONATHAN_MEMORY_BUILD_TESTS=OFF -DBUILD_SHARED_LIBS=ON)
	(cd $(build_dir); cmake --build . -- install)

stage:
	cp -r $(install_dir) $(stage_dir)
	find $(stage_dir) -type d -exec chmod 755 {} \;
	find $(stage_dir) -type f -exec chmod 644 {} \;

control:
	@mkdir $(stage_dir)/DEBIAN
	@chmod 755 $(stage_dir)/DEBIAN
	@echo "Package: $(package)"            > $(control_file)
	@echo "Version: $(version)"           >> $(control_file)
	@echo "Architecture: $(architecture)" >> $(control_file)
	@echo "Maintainer: $(maintainer)"     >> $(control_file)
	@echo "Description: $(description)"   >> $(control_file)
	@echo "Section: devel"                >> $(control_file)
	@echo "Priority: optional"            >> $(control_file)

package:
	@dpkg-deb --build $(stage_dir)
	@dpkg-deb -c $(notdir $(stage_dir)).deb

