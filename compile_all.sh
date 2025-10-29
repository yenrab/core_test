#!/bin/bash
cd /home/dev/core_test
echo "Compiling Core Erlang files..."

# Try to compile each file individually
echo "Compiling test_assertions.core..."
erlc test_assertions.core
if [ $? -eq 0 ]; then
    echo "✓ test_assertions.core compiled successfully"
else
    echo "✗ test_assertions.core compilation failed"
fi

echo "Compiling simple_test_runner.core..."
erlc simple_test_runner.core
if [ $? -eq 0 ]; then
    echo "✓ simple_test_runner.core compiled successfully"
else
    echo "✗ simple_test_runner.core compilation failed"
fi

echo "Compiling test_framework.core..."
erlc test_framework.core
if [ $? -eq 0 ]; then
    echo "✓ test_framework.core compiled successfully"
else
    echo "✗ test_framework.core compilation failed"
fi

echo "Checking for beam files..."
ls -la *.beam 2>/dev/null || echo "No beam files found"
