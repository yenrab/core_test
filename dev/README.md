# CoreTest - Core Erlang Testing Framework

A comprehensive testing framework for Core Erlang that provides automatic test discovery, unit/integration/system test support, and configurable output.

## Purpose

CoreTest is designed to provide a robust testing infrastructure for Core Erlang projects. It offers automatic test discovery, multiple assertion styles, configurable output modes, and comprehensive test categorization to help developers write and run reliable tests for their Core Erlang code.

## Quick Start

### Prerequisites

- **Erlang/OTP**: CoreTest requires Erlang/OTP to be installed on your system
- **Core Erlang Compiler**: The `erlc` compiler must be available in your PATH
- **Bash Shell**: The command-line interface requires a bash-compatible shell

### Installation

1. Clone or download the CoreTest framework
2. Navigate to the `core_test` directory
3. Run `make compile` to compile all framework modules

### Running Tests

```bash
# Run all self-tests in current directory (concise output)
./run_coretest

# Run all self-tests with verbose output
./run_coretest --verbose

# Run only unit tests (future feature)
./run_coretest --unit

# Run tests in specific directory
./run_coretest /path/to/tests

# Get help
./run_coretest --help
```

## Makefile Usage

Use the main Makefile in the `core_test` directory for all build and test operations:

```bash
# Compile all modules
make compile

# Run comprehensive test suite
make test

# Clean compiled files
make clean

# Show available commands
make help
```

**What to expect:**
- `make compile`: Compiles all framework modules and self-tests
- `make test`: Runs 12 phases of tests demonstrating all framework features
- `make clean`: Removes all compiled `.beam` files
- `make help`: Shows detailed help information

## Directory Structure

```
core_test/
├── Makefile                      # Main build system (delegates to dev/)
├── run_coretest                  # Command-line interface
├── test_assertions.core          # Core assertion library
├── test_framework.core           # Main test framework
├── simple_test_runner.core       # Basic test runner
├── dev/                          # Development files
│   ├── Makefile                  # Development build system
│   ├── self_tests/               # Self-contained test directory
│   │   ├── assertion_test.core   # Framework self-tests
│   │   ├── exception_assertion_test.core
│   │   ├── simple_test.core
│   │   ├── test_module.core
│   │   ├── unit/                 # Unit tests
│   │   ├── integration/          # Integration tests
│   │   └── system/               # System tests
│   └── README.md                 # Development documentation
└── Using CoreTest.md             # User documentation
```

## Features

- **Automatic Test Discovery**: Finds `*_test.core` files and tests in subdirectories
- **Multiple Test Types**: Supports unit, integration, and system tests
- **Dual Assertion Styles**: Both tuple-based and exception-based assertions
- **Configurable Output**: Concise (default) and verbose modes
- **Exception Handling**: Graceful error handling with test continuation
- **Command-Line Interface**: Professional CLI with multiple options
- **Self-Contained**: All tests and examples included in framework

## Getting Help

- Run `./run_coretest --help` for command-line options
- See `Using CoreTest.md` for detailed usage instructions
- Check the `self_tests/` directory for example test implementations

## License

CoreTest is provided as-is for educational and development purposes.