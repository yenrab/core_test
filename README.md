# CoreTest - Core Erlang Testing Framework

CoreTest is a comprehensive testing framework designed specifically for Core Erlang projects. It provides automatic test discovery, multiple assertion styles, test categorization, and flexible output modes to help developers write and run reliable tests for their Core Erlang code.

## Purpose

CoreTest addresses the unique challenges of testing Core Erlang code by providing:

- **Core Erlang Native Support**: Built specifically for Core Erlang syntax and semantics
- **Automatic Test Discovery**: Finds and runs tests without manual configuration
- **Multiple Assertion Styles**: Supports both tuple-based and exception-based testing patterns
- **Test Categorization**: Organizes tests by type (unit, integration, system)
- **Flexible Output**: Provides both concise and verbose output modes
- **Exception Safety**: Graceful handling of test failures and exceptions

## Building CoreTest

### Prerequisites

- **Erlang/OTP**: Version 20.0 or later
- **Core Erlang Compiler**: The `erlc` compiler must be available in your PATH
- **Bash Shell**: For the command-line interface
- **Make**: For the build system

### Build Process

1. **Clone or download** the CoreTest framework
2. **Navigate** to the `core_test` directory
3. **Compile** all framework modules:
   ```bash
   make compile
   ```

The build process will:
- Compile all Core Erlang modules (`.core` files) to bytecode (`.beam` files)
- Set up the framework for immediate use
- Prepare self-tests and examples

### Available Build Commands

```bash
make compile    # Compile all modules
make test       # Run comprehensive test suite
make clean      # Clean compiled files
make help       # Show available commands
```

## Development and Self-Testing

For information on developing CoreTest itself and running its comprehensive self-tests, see [dev/DEV_README.md](dev/DEV_README.md).

The development documentation covers:
- Framework development workflow
- Running CoreTest's own test suite
- Contributing to the framework
- Advanced testing scenarios

## Using CoreTest with Your Project

### Project Structure

Organize your Core Erlang project with the following structure:

```
your_project/
├── src/                          # Source code
│   ├── calculator.core
│   ├── database.core
│   └── api.core
├── tests/                        # Test directory
│   ├── unit/                     # Unit tests
│   │   ├── calculator_unit_test.core
│   │   └── database_unit_test.core
│   ├── integration/              # Integration tests
│   │   ├── api_integration_test.core
│   │   └── database_integration_test.core
│   └── system/                   # System tests
│       ├── full_system_test.core
│       └── performance_test.core
└── core_test/                    # CoreTest framework
    ├── run_coretest
    ├── test_framework.core
    └── test_assertions.core
```

### Test File Requirements

1. **File Naming**: Test files must end with `_test.core`
   - Examples: `calculator_test.core`, `database_unit_test.core`

2. **Test Function Naming**: Test functions must start with `test_`
   - Examples: `test_addition/0`, `test_error_handling/1`

3. **Module Structure**: Follow standard Core Erlang module syntax:
   ```erlang
   module 'calculator_test'
       ['test_addition'/0, 'test_subtraction'/0]
       attributes []
       
       'test_addition'/0 =
           fun () ->
               let <Result> = call 'calculator':'add'/2 (5, 3)
               in let <Assertion> = call 'test_assertions':'assert_equal'/2 (Result, 8)
               in Assertion
   end
   ```

### Running Tests

```bash
# Run all tests (concise output)
./run_coretest

# Run all tests with verbose output
./run_coretest --verbose

# Run tests in specific directory
./run_coretest /path/to/your/tests

# Get help
./run_coretest --help
```

### Test Categorization

CoreTest automatically categorizes tests based on directory location:
- **Unit Tests**: Tests in `unit/` subdirectory
- **Integration Tests**: Tests in `integration/` subdirectory  
- **System Tests**: Tests in `system/` subdirectory

## Interpreting CoreTest Output

### Concise Output Format

```
{unit,4,1,0,integration,1,1,0,system,2,0,0,total,7,2,0}
```

**Format**: `{unit,passed,failed,errors,integration,passed,failed,errors,system,passed,failed,errors,total,passed,failed,errors}`

**Example Breakdown**:
- `unit,4,1,0` - Unit tests: 4 passed, 1 failed, 0 errors
- `integration,1,1,0` - Integration tests: 1 passed, 1 failed, 0 errors
- `system,2,0,0` - System tests: 2 passed, 0 failed, 0 errors
- `total,7,2,0` - Total: 7 passed, 2 failed, 0 errors

### Verbose Output Format

```
{verbose,unit,4,1,0,integration,1,1,0,system,2,0,0,total,7,2,0}
```

Same format as concise output but with `verbose` prefix for detailed logging and test execution information.

### Understanding Results

- **Passed**: Tests that completed successfully with all assertions passing
- **Failed**: Tests where assertions failed (expected vs actual value mismatch)
- **Errors**: Tests that encountered exceptions or compilation errors

### Exit Codes

- **0**: All tests passed successfully
- **1**: One or more tests failed or encountered errors

## Available Assertions

CoreTest provides two assertion styles:

### Tuple-Based Assertions
- `assert_equal/2` - Compare two values for equality
- `assert_true/1` - Verify a value is `true`
- `assert_false/1` - Verify a value is `false`
- `assert_not_equal/2` - Verify two values are not equal
- `assert_match/2` - Verify a value matches a pattern

### Exception-Based Assertions
- `assert_equal!/2` - Throwing version of `assert_equal/2`
- `assert_true!/1` - Throwing version of `assert_true/1`
- `assert_false!/1` - Throwing version of `assert_false/1`
- `assert_not_equal!/2` - Throwing version of `assert_not_equal/2`
- `assert_match!/2` - Throwing version of `assert_match/2`

## Getting Help

- Run `./run_coretest --help` for command-line options
- See [Using CoreTest.md](Using%20CoreTest.md) for detailed usage instructions
- Check the `dev/self_tests/` directory for example test implementations
- Refer to [dev/DEV_README.md](dev/DEV_README.md) for development information

## License

CoreTest is provided as-is for educational and development purposes.
