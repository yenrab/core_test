#!/bin/bash
cd /home/dev/core_test
echo "Testing run_coretest script..."
./run_coretest
echo "Exit code: $?"
echo ""
echo "Testing verbose mode..."
./run_coretest --verbose
echo "Exit code: $?"
