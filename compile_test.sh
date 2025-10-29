#!/bin/bash
cd /home/dev/core_test
echo "Attempting to compile test_framework.core..."
erlc test_framework.core 2>&1
echo "Compilation exit code: $?"
echo "Checking if beam file exists..."
ls -la test_framework.beam 2>&1
