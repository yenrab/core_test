# CoreTest Framework - Main Makefile
# This Makefile delegates all commands to the dev/ directory

# Default target
all: test

# Delegate all targets to the dev/ directory
%:
	@cd dev && $(MAKE) $@

# Explicit targets for clarity
compile:
	@cd dev && $(MAKE) compile

test:
	@cd dev && $(MAKE) test

clean:
	@cd dev && $(MAKE) clean

help:
	@cd dev && $(MAKE) help

# Show help by default
.DEFAULT_GOAL := help

# Phony targets
.PHONY: all compile test clean help
