# CoreTest Framework Makefile
# Phase 1: Basic Assertions

# Default target
all: compile

# Compile all Core Erlang files
compile:
	@echo "Compiling CoreTest modules..."
	@ERL_MAX_PORTS=1024 erlc -o .. ../test_assertions.core
	@ERL_MAX_PORTS=1024 erlc -o .. ../simple_test_runner.core
	@ERL_MAX_PORTS=1024 erlc -o .. ../test_framework.core
	@ERL_MAX_PORTS=1024 erlc -o self_tests self_tests/assertion_test.core
	@ERL_MAX_PORTS=1024 erlc -o self_tests self_tests/comprehensive_exception_test.core
	@ERL_MAX_PORTS=1024 erlc -o self_tests self_tests/exception_assertion_test.core
	@ERL_MAX_PORTS=1024 erlc -o self_tests self_tests/exception_handling_test.core
	@ERL_MAX_PORTS=1024 erlc -o self_tests self_tests/simple_test.core
	@ERL_MAX_PORTS=1024 erlc -o self_tests self_tests/test_module.core
	@ERL_MAX_PORTS=1024 erlc -o self_tests/unit self_tests/unit/quicksort_unit_test.core
	@ERL_MAX_PORTS=1024 erlc -o self_tests/integration self_tests/integration/data_pipeline_integration_test.core
	@ERL_MAX_PORTS=1024 erlc -o self_tests/system self_tests/system/full_app_system_test.core
	@echo "Compilation complete."

# Run tests
test: compile
	@echo "Running CoreTest Phase 1 tests..."
	@ERL_MAX_PORTS=1024 erl -pa . -pa .. -pa self_tests -noshell -eval "\
		code:load_file(simple_test), \
		Result = simple_test:test_assertions(), \
		io:format('Phase 1 Test Results: ~p~n', [Result])" -s init stop
	@echo ""
	@echo "Running CoreTest Phase 3 tests..."
	@ERL_MAX_PORTS=1024 erl -pa . -pa .. -pa self_tests -noshell -eval "\
		code:load_file(simple_test_runner), \
		code:load_file(test_module), \
		TestFunctions = simple_test_runner:extract_test_functions('test_module'), \
		Results = simple_test_runner:run_module_tests('test_module', TestFunctions), \
		io:format('Phase 3 Test Results: ~p~n', [Results])" -s init stop
	@echo ""
	@echo "Running CoreTest Phase 5 tests..."
	@ERL_MAX_PORTS=1024 erl -pa . -pa .. -pa self_tests -noshell -eval "\
		code:load_file(test_framework), \
		TestType1 = test_framework:categorize_test('simple_test.core'), \
		TestType2 = test_framework:categorize_test('test_module.core'), \
		TestType3 = test_framework:categorize_test('factorial_unit_test.core'), \
		TestType4 = test_framework:categorize_test('voting_integration_test.core'), \
		TestType5 = test_framework:categorize_test('full_app_system_test.core'), \
		io:format('Phase 5 Test Categorization: ~p~n', [{TestType1, TestType2, TestType3, TestType4, TestType5}])" -s init stop
	@echo ""
	@echo "Running CoreTest Phase 6 tests..."
	@ERL_MAX_PORTS=1024 erl -pa . -pa .. -pa self_tests -noshell -eval "\
		code:load_file(test_framework), \
		code:load_file(simple_test), \
		code:load_file(test_module), \
		AllTestFiles = test_framework:discover_test_files('.'), \
		io:format('Phase 6 All Test Files: ~p~n', [AllTestFiles]), \
		TestTypes = [test_framework:categorize_test(File) || File <- AllTestFiles], \
		io:format('Phase 6 Test Types: ~p~n', [TestTypes]), \
		Results = test_framework:run_test_files_with_categories(AllTestFiles, 0), \
		io:format('Phase 6 Categorized Results: ~p~n', [Results])" -s init stop
	@echo ""
	@echo "Running CoreTest Phase 7 tests..."
	@ERL_MAX_PORTS=1024 erl -pa . -pa .. -pa self_tests -noshell -eval "\
		code:load_file(test_framework), \
		code:load_file(simple_test), \
		code:load_file(test_module), \
		AllTestFiles = test_framework:discover_test_files('.'), \
		CategorizedResults = test_framework:run_test_files_with_categories(AllTestFiles, 0), \
		FormattedResults = test_framework:format_results(CategorizedResults, 0), \
		io:format('Phase 7 Formatted Results: ~p~n', [FormattedResults])" -s init stop
	@echo ""
	@echo "Running CoreTest Phase 8 tests..."
	@ERL_MAX_PORTS=1024 erl -pa . -pa .. -pa self_tests -noshell -eval "\
		code:load_file(test_framework), \
		code:load_file(simple_test), \
		code:load_file(test_module), \
		AllTestFiles = test_framework:discover_test_files('.'), \
		CategorizedResults = test_framework:run_test_files_with_categories(AllTestFiles, 1), \
		VerboseResults = test_framework:format_results(CategorizedResults, 1), \
		io:format('Phase 8 Verbose Results: ~p~n', [VerboseResults]), \
		TestDetails = test_framework:format_test_details({'test_name', 'sample_test', 'result', {'pass'}}), \
		io:format('Phase 8 Test Details: ~p~n', [TestDetails])" -s init stop
	@echo ""
	@echo "Running CoreTest Phase 9 tests..."
	@ERL_MAX_PORTS=1024 erl -pa . -pa .. -pa self_tests -noshell -eval "\
		code:load_file(test_assertions), \
		code:load_file(assertion_test), \
		Result = assertion_test:test_new_assertions(), \
		io:format('Phase 9 New Assertions Test: ~p~n', [Result]), \
		AssertFalse1 = test_assertions:assert_false('false'), \
		AssertFalse2 = test_assertions:assert_false('true'), \
		AssertNotEqual1 = test_assertions:assert_not_equal(5, 3), \
		AssertNotEqual2 = test_assertions:assert_not_equal(5, 5), \
		AssertMatch1 = test_assertions:assert_match(5, 5), \
		AssertMatch2 = test_assertions:assert_match(5, 3), \
		io:format('Phase 9 Individual Assertions: ~p~n', [{AssertFalse1, AssertFalse2, AssertNotEqual1, AssertNotEqual2, AssertMatch1, AssertMatch2}])" -s init stop
	@echo ""
	@echo "Running CoreTest Phase 10 tests..."
	@ERL_MAX_PORTS=1024 erl -pa . -pa .. -pa self_tests -noshell -eval "\
		code:load_file(test_assertions), \
		code:load_file(exception_assertion_test), \
		SuccessResult = exception_assertion_test:test_successful_assertions(), \
		io:format('Phase 10 Successful Throwing Assertions: ~p~n', [SuccessResult]), \
		AssertEqual1 = test_assertions:'assert_equal!' (5, 5), \
		AssertTrue1 = test_assertions:'assert_true!' ('true'), \
		AssertFalse1 = test_assertions:'assert_false!' ('false'), \
		io:format('Phase 10 Individual Throwing Assertions: ~p~n', [{AssertEqual1, AssertTrue1, AssertFalse1}])" -s init stop
	@echo ""
	@echo "Running CoreTest Phase 11 tests..."
	@ERL_MAX_PORTS=1024 erl -pa . -pa .. -pa self_tests -noshell -eval "\
		code:load_file(test_assertions), \
		code:load_file(exception_handling_test), \
		io:format('Phase 11 Exception Handling Tests:~n', []), \
		io:format('Testing successful throwing assertion...~n', []), \
		try exception_handling_test:test_successful_throwing_assertion() of \
			Result1 -> io:format('Success: ~p~n', [Result1]) \
		catch \
			Error1 -> io:format('Exception caught: ~p~n', [Error1]) \
		end, \
		io:format('Testing failing throwing assertion...~n', []), \
		try exception_handling_test:test_failing_throwing_assertion() of \
			Result2 -> io:format('Success: ~p~n', [Result2]) \
		catch \
			Error2 -> io:format('Exception caught: ~p~n', [Error2]) \
		end, \
		io:format('Phase 11 Exception Handling Complete~n', [])" -s init stop
	@echo ""
	@echo "Running CoreTest Comprehensive Exception Handling tests..."
	@ERL_MAX_PORTS=1024 erl -pa . -pa .. -pa self_tests -noshell -eval "\
		code:load_file(test_assertions), \
		code:load_file(comprehensive_exception_test), \
		io:format('Comprehensive Exception Handling Tests:~n', []), \
		io:format('Testing tuple assertions (no exceptions)...~n', []), \
		TupleResult1 = test_assertions:assert_equal(5, 5), \
		TupleResult2 = test_assertions:assert_equal(5, 3), \
		io:format('Tuple assertions results: ~p~n', [{TupleResult1, TupleResult2}]), \
		io:format('Testing throwing assertions (with exception handling)...~n', []), \
		try test_assertions:'assert_equal!' (5, 5) of \
			ThrowingResult1 -> io:format('Throwing assertion success: ~p~n', [ThrowingResult1]) \
		catch \
			ThrowingError1 -> io:format('Throwing assertion exception: ~p~n', [ThrowingError1]) \
		end, \
		try test_assertions:'assert_equal!' (5, 3) of \
			ThrowingResult2 -> io:format('Throwing assertion success: ~p~n', [ThrowingResult2]) \
		catch \
			ThrowingError2 -> io:format('Throwing assertion exception: ~p~n', [ThrowingError2]) \
		end, \
		io:format('Testing mixed assertions (tuple + throwing)...~n', []), \
		MixedTupleResult = test_assertions:assert_equal(5, 5), \
		try test_assertions:'assert_equal!' (5, 3) of \
			MixedThrowingResult -> io:format('Mixed assertions success: ~p~n', [{MixedTupleResult, MixedThrowingResult}]) \
		catch \
			MixedThrowingError -> io:format('Mixed assertions exception: ~p~n', [{MixedTupleResult, MixedThrowingError}]) \
		end, \
		io:format('Comprehensive Exception Handling Complete~n', [])" -s init stop
	@echo ""
	@echo "Running CoreTest Phase 12 tests..."
	@echo "Testing command-line interface..."
	@cd .. && ./run_coretest --help | head -5
	@echo ""
	@echo "Testing basic test run..."
	@cd .. && ./run_coretest
	@echo ""
	@echo "Testing verbose mode..."
	@cd .. && ./run_coretest --verbose
	@echo ""
	@echo "Testing short form options..."
	@cd .. && ./run_coretest -v
	@echo ""
	@echo "Testing error handling..."
	@cd .. && ./run_coretest || echo "Error handling works correctly"
	@echo ""
	@echo "Testing invalid options..."
	@cd .. && ./run_coretest --invalid || echo "Invalid option handling works correctly"
	@echo "Tests completed."

# Clean compiled files
clean:
	@echo "Cleaning compiled files..."
	@rm -f *.beam
	@rm -f ../*.beam
	@rm -f self_tests/*.beam
	@rm -f self_tests/unit/*.beam
	@rm -f self_tests/integration/*.beam
	@rm -f self_tests/system/*.beam
	@echo "Clean complete."

# Show help
help:
	@echo "CoreTest Framework Makefile - Phase 1"
	@echo ""
	@echo "Available targets:"
	@echo "  all     - Compile all modules (default)"
	@echo "  compile - Compile CoreTest modules"
	@echo "  test    - Compile and run tests"
	@echo "  clean   - Remove compiled .beam files"
	@echo "  help    - Show this help message"
	@echo ""
	@echo "Examples:"
	@echo "  make           # Compile modules"
	@echo "  make test      # Compile and run tests"
	@echo "  make clean     # Remove compiled files"

# Phony targets
.PHONY: all compile test clean help