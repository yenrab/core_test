# CoreTest Development Files

This directory contains development and testing files for the CoreTest framework.

## Contents

- **`Makefile`** - Build system for compiling framework and self-tests
- **`README.md`** - Development documentation
- **`run_simple_tests.sh`** - Simple test runner script for development
- **`self_tests/`** - Framework self-tests and examples
- **`erl_crash.dump`** - Erlang crash dump (if any)

## Usage

These files are for framework development and testing. End users should use the files in the parent directory:

- `run_coretest` - Main CLI interface
- `test_framework.core` - Main framework
- `test_assertions.core` - Assertion library
- `Using CoreTest.md` - User documentation

## Development

To work on the framework, use the main Makefile in the parent directory:

1. `cd ..` (to core_test directory)
2. `make compile` - Compile all modules
3. `make test` - Run comprehensive test suite
4. `make clean` - Clean compiled files
5. `make help` - Show available commands
