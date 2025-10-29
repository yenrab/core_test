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
