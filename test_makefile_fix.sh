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

echo "Testing the Makefile Phase 12 fix..."

echo "1. Testing from dev directory with cd .. && ./run_coretest --help"
cd /home/dev/core_test/dev
cd .. && ./run_coretest --help | head -5
echo "Exit code: $?"

echo ""
echo "2. Testing from dev directory with ../run_coretest --help (old way)"
cd /home/dev/core_test/dev
../run_coretest --help | head -5
echo "Exit code: $?"

echo ""
echo "3. Testing basic run from dev directory"
cd /home/dev/core_test/dev
cd .. && ./run_coretest
echo "Exit code: $?"
