#!/bin/bash
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
