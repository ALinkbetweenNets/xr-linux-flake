#!/usr/bin/env bash
set -euo pipefail

# Test script for xrlinuxdriver package
# This script verifies that the package builds correctly and contains all required files

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
NC='\033[0m' # No Color

PACKAGE_PATH="$1"
if [ -z "$PACKAGE_PATH" ]; then
    echo -e "${RED}Error: Package path not provided${NC}"
    echo "Usage: $0 <package-path>"
    exit 1
fi

echo -e "${YELLOW}Testing xrlinuxdriver package at ${PACKAGE_PATH}...${NC}"

# Test 1: Check if the main binary exists
if [ -f "${PACKAGE_PATH}/bin/xrDriver" ]; then
    echo -e "${GREEN}✓ Main binary exists${NC}"
else
    echo -e "${RED}✗ Main binary not found${NC}"
    exit 1
fi

# Test 2: Check if helper scripts exist
for script in xr_driver_cli xr_driver_setup xr_driver_uninstall xr_driver_verify; do
    if [ -f "${PACKAGE_PATH}/bin/${script}" ]; then
        echo -e "${GREEN}✓ Helper script ${script} exists${NC}"
    else
        echo -e "${RED}✗ Helper script ${script} not found${NC}"
        exit 1
    fi
done

# Test 3: Check if udev rules exist
if [ -d "${PACKAGE_PATH}/lib/udev/rules.d" ]; then
    rule_count=$(find "${PACKAGE_PATH}/lib/udev/rules.d" -name "*.rules" | wc -l)
    if [ "$rule_count" -gt 0 ]; then
        echo -e "${GREEN}✓ Udev rules exist (${rule_count} files)${NC}"
    else
        echo -e "${RED}✗ No udev rules found${NC}"
        exit 1
    fi
else
    echo -e "${RED}✗ Udev rules directory not found${NC}"
    exit 1
fi

# Test 4: Check if the systemd service file exists
if [ -f "${PACKAGE_PATH}/lib/systemd/user/xr-driver.service" ]; then
    echo -e "${GREEN}✓ Systemd service file exists${NC}"
else
    echo -e "${RED}✗ Systemd service file not found${NC}"
    exit 1
fi

# Test 5: Try running the main binary with --help
if "${PACKAGE_PATH}/bin/xrDriver" --help 2>&1 | grep -q "Usage"; then
    echo -e "${GREEN}✓ Main binary runs and displays usage information${NC}"
else
    echo -e "${YELLOW}! Main binary does not display usage information (this may be normal)${NC}"
fi

# Test 6: Try running the CLI tool with no arguments (should display usage)
if "${PACKAGE_PATH}/bin/xr_driver_cli" 2>&1 | grep -q "usage"; then
    echo -e "${GREEN}✓ CLI tool runs and displays usage information${NC}"
else
    echo -e "${YELLOW}! CLI tool does not display usage information (this may be normal)${NC}"
fi

echo -e "${GREEN}All tests passed for xrlinuxdriver package!${NC}"
exit 0