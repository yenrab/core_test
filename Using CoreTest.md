# Using CoreTest - Comprehensive Guide

## Overview

CoreTest is a comprehensive testing framework designed specifically for Core Erlang projects. It provides a robust infrastructure for writing, discovering, and running tests with support for multiple test types, assertion styles, and output formats.

## Purpose and Philosophy

CoreTest addresses the unique challenges of testing Core Erlang code by providing:

- **Core Erlang Native Support**: Built specifically for Core Erlang syntax and semantics
- **Automatic Test Discovery**: Finds and runs tests without manual configuration
- **Multiple Assertion Styles**: Supports both tuple-based and exception-based testing patterns
- **Test Categorization**: Organizes tests by type (unit, integration, system)
- **Flexible Output**: Provides both concise and verbose output modes
- **Exception Safety**: Graceful handling of test failures and exceptions

## Requirements for Using CoreTest

### System Requirements

1. **Erlang/OTP Installation**
   - Erlang/OTP version 20.0 or later
   - Core Erlang compiler (`erlc`) available in PATH
   - Sufficient system resources for concurrent test execution

2. **Development Environment**
   - Bash-compatible shell for command-line interface
   - Text editor supporting Core Erlang syntax
   - File system with read/write permissions

3. **Project Structure**
   - Core Erlang source files (`.core` extension)
   - Test files following naming convention (`*_test.core`)
   - Proper module organization

### Code Requirements

1. **Module Structure**
   ```erlang
   module 'your_module'
       ['function1'/1, 'function2'/2]
       attributes []
       'function1'/1 = fun (Arg) -> ... end
       'function2'/2 = fun (Arg1, Arg2) -> ... end
   end
   ```

2. **Test File Naming**
   - Test files must end with `_test.core`
   - Examples: `calculator_test.core`, `database_unit_test.core`

3. **Test Function Naming**
   - Test functions must start with `test_`
   - Examples: `test_addition/0`, `test_error_handling/1`

## Available Assertions

CoreTest provides a comprehensive assertion library with two distinct styles:

### Tuple-Based Assertions

These assertions return result tuples that can be processed by the test framework:

#### `assert_equal/2`
Compares two values for equality.
```erlang
'assert_equal'/2 = fun (Actual, Expected) ->
    case call 'erlang':'==' (Actual, Expected) of
        <'true'> when 'true' -> {'pass'}
        <'false'> when 'true' -> {'fail', Actual, Expected}
    end
end
```

#### `assert_true/1`
Verifies that a value is `'true'`.
```erlang
'assert_true'/1 = fun (Value) ->
    case Value of
        <'true'> when 'true' -> {'pass'}
        <'false'> when 'true' -> {'fail', Value, 'true'}
    end
end
```

#### `assert_false/1`
Verifies that a value is `'false'`.
```erlang
'assert_false'/1 = fun (Value) ->
    case Value of
        <'false'> when 'true' -> {'pass'}
        <'true'> when 'true' -> {'fail', Value, 'false'}
    end
end
```

#### `assert_not_equal/2`
Verifies that two values are not equal.
```erlang
'assert_not_equal'/2 = fun (Actual, Expected) ->
    case call 'erlang':'==' (Actual, Expected) of
        <'false'> when 'true' -> {'pass'}
        <'true'> when 'true' -> {'fail', Actual, Expected}
    end
end
```

#### `assert_match/2`
Verifies that a value matches a pattern.
```erlang
'assert_match'/2 = fun (Value, Pattern) ->
    case call 'erlang':'==' (Value, Pattern) of
        <'true'> when 'true' -> {'pass'}
        <'false'> when 'true' -> {'fail', Value, Pattern}
    end
end
```

### Exception-Based Assertions

These assertions throw exceptions on failure, suitable for exception-driven testing:

#### `assert_equal!/2`
Throwing version of `assert_equal/2`.
```erlang
'assert_equal!'/2 = fun (Actual, Expected) ->
    case call 'erlang':'==' (Actual, Expected) of
        <'true'> when 'true' -> 'ok'
        <'false'> when 'true' -> call 'erlang':'throw' ({'assertion_failed', 'assert_equal', Actual, Expected})
    end
end
```

#### `assert_true!/1`
Throwing version of `assert_true/1`.
```erlang
'assert_true!'/1 = fun (Value) ->
    case Value of
        <'true'> when 'true' -> 'ok'
        <'false'> when 'true' -> call 'erlang':'throw' ({'assertion_failed', 'assert_true', Value, 'true'})
    end
end
```

#### `assert_false!/1`
Throwing version of `assert_false/1`.
```erlang
'assert_false!'/1 = fun (Value) ->
    case Value of
        <'false'> when 'true' -> 'ok'
        <'true'> when 'true' -> call 'erlang':'throw' ({'assertion_failed', 'assert_false', Value, 'false'})
    end
end
```

#### `assert_not_equal!/2`
Throwing version of `assert_not_equal/2`.
```erlang
'assert_not_equal!'/2 = fun (Actual, Expected) ->
    case call 'erlang':'==' (Actual, Expected) of
        <'false'> when 'true' -> 'ok'
        <'true'> when 'true' -> call 'erlang':'throw' ({'assertion_failed', 'assert_not_equal', Actual, Expected})
    end
end
```

#### `assert_match!/2`
Throwing version of `assert_match/2`.
```erlang
'assert_match!'/2 = fun (Value, Pattern) ->
    case call 'erlang':'==' (Value, Pattern) of
        <'true'> when 'true' -> 'ok'
        <'false'> when 'true' -> call 'erlang':'throw' ({'assertion_failed', 'assert_match', Value, Pattern})
    end
end
```

## Writing Test Functions

### Basic Test Function Structure

```erlang
module 'calculator_test'
    ['test_addition'/0, 'test_subtraction'/0, 'test_error_handling'/0]
    attributes []
    
    'test_addition'/0 =
        fun () ->
            let <Result> = call 'calculator':'add'/2 (5, 3)
            in let <Assertion> = call 'test_assertions':'assert_equal'/2 (Result, 8)
            in Assertion
    
    'test_subtraction'/0 =
        fun () ->
            let <Result> = call 'calculator':'subtract'/2 (10, 4)
            in let <Assertion> = call 'test_assertions':'assert_equal'/2 (Result, 6)
            in Assertion
    
    'test_error_handling'/0 =
        fun () ->
            let <Result> = call 'calculator':'divide'/2 (10, 0)
            in let <Assertion> = call 'test_assertions':'assert_equal'/2 (Result, {'error', 'division_by_zero'})
            in Assertion
end
```

### Using Tuple-Based Assertions

```erlang
'test_tuple_assertions'/0 =
    fun () ->
        let <EqualResult> = call 'test_assertions':'assert_equal'/2 (5, 5)
        in let <TrueResult> = call 'test_assertions':'assert_true'/1 ('true')
        in let <FalseResult> = call 'test_assertions':'assert_false'/1 ('false')
        in let <NotEqualResult> = call 'test_assertions':'assert_not_equal'/2 (5, 3)
        in let <MatchResult> = call 'test_assertions':'assert_match'/2 ({'ok', 42}, {'ok', 42})
        in {EqualResult, TrueResult, FalseResult, NotEqualResult, MatchResult}
```

### Using Exception-Based Assertions

```erlang
'test_exception_assertions'/0 =
    fun () ->
        let <SuccessResult> = call 'test_assertions':'assert_equal!'/2 (5, 5)
        in let <FailResult> = call 'test_assertions':'assert_equal!'/2 (5, 3)
        in {SuccessResult, FailResult}
```

### Mixed Assertion Styles

```erlang
'test_mixed_assertions'/0 =
    fun () ->
        let <TupleResult> = call 'test_assertions':'assert_equal'/2 (5, 5)
        in let <ExceptionResult> = call 'test_assertions':'assert_equal!'/2 (5, 5)
        in {TupleResult, ExceptionResult}
```

## Test Organization

### Directory Structure

Organize your tests using the following structure:

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

### Test Categorization

CoreTest automatically categorizes tests based on their directory location:

- **Unit Tests**: Tests in `unit/` subdirectory
- **Integration Tests**: Tests in `integration/` subdirectory  
- **System Tests**: Tests in `system/` subdirectory

## Running Tests

### Command-Line Interface

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

### Output Formats

#### Concise Output
```
{unit,4,1,0,integration,1,1,0,system,2,0,0,total,7,2,0}
```
Format: `{unit,passed,failed,errors,integration,passed,failed,errors,system,passed,failed,errors,total,passed,failed,errors}`

#### Verbose Output
```
{verbose,unit,4,1,0,integration,1,1,0,system,2,0,0,total,7,2,0}
```
Same format as concise but with `verbose` prefix for detailed logging.

## Best Practices

### Test Function Design

1. **Single Responsibility**: Each test function should test one specific behavior
2. **Descriptive Names**: Use clear, descriptive names for test functions
3. **Arrange-Act-Assert**: Structure tests with clear setup, execution, and verification phases
4. **Independent Tests**: Tests should not depend on each other

### Assertion Selection

1. **Use Tuple-Based Assertions** for:
   - Simple value comparisons
   - When you need to process assertion results
   - When building custom test frameworks

2. **Use Exception-Based Assertions** for:
   - Exception-driven testing patterns
   - When you want tests to fail fast
   - When integrating with exception-handling frameworks

### Error Handling

1. **Test Both Success and Failure Cases**
2. **Use Appropriate Assertions** for different scenarios
3. **Handle Exceptions Gracefully** in your test code
4. **Provide Meaningful Error Messages**

## Troubleshooting

### Common Issues

1. **Compilation Errors**
   - Ensure all modules are properly structured
   - Check that function names match exports
   - Verify Core Erlang syntax

2. **Test Discovery Issues**
   - Ensure test files follow naming convention (`*_test.core`)
   - Check that test functions start with `test_`
   - Verify directory structure

3. **Assertion Failures**
   - Review assertion logic
   - Check data types and values
   - Verify function implementations

### Debugging Tips

1. **Use Verbose Output** to see detailed test execution
2. **Test Individual Functions** to isolate issues
3. **Check Module Loading** with `code:load_file/1`
4. **Verify Function Exports** and signatures

## Advanced Usage

### Custom Test Runners

You can create custom test runners by using the framework's internal functions:

```erlang
module 'custom_test_runner'
    ['run_custom_tests'/0]
    attributes []
    
    'run_custom_tests'/0 =
        fun () ->
            let <TestFiles> = call 'test_framework':'discover_tests_recursive'/1 ('.')
            in let <TestResults> = call 'test_framework':'run_test_files_with_categories'/2 (TestFiles, 1)
            in let <FormattedResults> = call 'test_framework':'format_results'/2 (TestResults, 1)
            in FormattedResults
end
```

### Integration with Build Systems

CoreTest can be integrated with various build systems:

```makefile
# Makefile integration
test: compile
	@./run_coretest

# CI/CD integration
test-ci:
	@./run_coretest --verbose
```

## Conclusion

CoreTest provides a comprehensive testing solution for Core Erlang projects. By following the guidelines in this document, you can create robust, maintainable test suites that help ensure the quality and reliability of your Core Erlang code.

For more examples and advanced usage patterns, refer to the test files in the `self_tests/` directory of the CoreTest framework.
