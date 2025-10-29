#!/bin/bash
cd /home/dev/core_test
echo "Testing the new main Makefile..."

echo "1. Testing 'make help'"
make help
echo "Exit code: $?"

echo ""
echo "2. Testing 'make clean'"
make clean
echo "Exit code: $?"

echo ""
echo "3. Testing 'make compile'"
make compile
echo "Exit code: $?"
