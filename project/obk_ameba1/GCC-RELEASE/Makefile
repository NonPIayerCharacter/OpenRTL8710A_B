all: ram_all

OS := $(shell uname)

.PHONY: toolchain
toolchain:
	
	
.PHONY: ram_all
ram_all: toolchain
	@$(MAKE) -f application.mk

.PHONY: mp
mp: toolchain
	@$(MAKE) -f application.mk mp

.PHONY: clean
clean:
	@$(MAKE) -f application.mk clean
	
.PHONY: flash debug ramdebug setup
setup:
	@$(MAKE) -f application.mk $(MAKECMDGOALS)

flash: toolchain
	@$(MAKE) -f application.mk flashburn
	
debug: toolchain
	@$(MAKE) -f application.mk debug	

ramdebug: toolchain
	@$(MAKE) -f application.mk ramdebug	