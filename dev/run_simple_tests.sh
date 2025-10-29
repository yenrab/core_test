#!/bin/bash

# Simple CoreTest runner
# Runs tests in the experiment directory

cd /home/dev/actly_experiment/experiment

echo "Running CoreTest in experiment directory..."

# Compile all test files
echo "Compiling test files..."
for file in *_test.core tests/*/*.core; do
    if [ -f "$file" ]; then
        echo "Compiling $file"
        ERL_MAX_PORTS=1024 erlc "$file" 2>/dev/null || echo "Failed to compile $file"
    fi
done

# Compile supporting modules
echo "Compiling supporting modules..."
ERL_MAX_PORTS=1024 erlc test.core 2>/dev/null || echo "Failed to compile test.core"
ERL_MAX_PORTS=1024 erlc advanced_example.core 2>/dev/null || echo "Failed to compile advanced_example.core"
ERL_MAX_PORTS=1024 erlc voting_process.core 2>/dev/null || echo "Failed to compile voting_process.core"

# Copy test assertions
cp /home/dev/actly_experiment/core_test/simple_test_assertions.core . 2>/dev/null
ERL_MAX_PORTS=1024 erlc simple_test_assertions.core 2>/dev/null || echo "Failed to compile simple_test_assertions.core"

echo ""
echo "Running individual tests..."

# Run basic test
echo "Running basic_test..."
ERL_MAX_PORTS=1024 erl -noshell -pa . -eval "code:load_file(basic_test), Result = basic_test:test_simple(), io:format('basic_test:test_simple() = ~p~n', [Result]), init:stop()." 2>/dev/null

echo ""
echo "CoreTest completed."
