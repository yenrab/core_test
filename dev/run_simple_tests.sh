#!/bin/bash
# MIT License
#
# Copyright (c) 2025 Lee Barney
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

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
