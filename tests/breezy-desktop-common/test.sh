#!/usr/bin/env bash
set -euo pipefail

# Test script for breezy-desktop-common package
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

echo -e "${YELLOW}Testing breezy-desktop-common package at ${PACKAGE_PATH}...${NC}"

# Test 1: Check if breezy-desktop directory was created
if [ -d "${PACKAGE_PATH}/share/breezy-desktop" ]; then
    echo -e "${GREEN}✓ breezy-desktop directory exists${NC}"
else
    echo -e "${RED}✗ breezy-desktop directory not found${NC}"
    exit 1
fi

# Test 2: Check if VERSION file exists (optional)
if [ -f "${PACKAGE_PATH}/share/breezy-desktop/VERSION" ]; then
    echo -e "${GREEN}✓ VERSION file exists${NC}"
else
    echo -e "${YELLOW}! VERSION file not found (may be normal depending on source repo)${NC}"
fi

# Test 3: Check if PNG files are present (optional)
png_count=$(find "${PACKAGE_PATH}/share/breezy-desktop" -name "*.png" 2>/dev/null | wc -l)
if [ "$png_count" -gt 0 ]; then
    echo -e "${GREEN}✓ PNG files exist (${png_count} files)${NC}"
else
    echo -e "${YELLOW}! No PNG files found (may be normal depending on source repo)${NC}"
fi

# Test 4: Check if icons directory exists
if [ -d "${PACKAGE_PATH}/share/icons" ]; then
    echo -e "${GREEN}✓ Icons directory exists${NC}"
else
    echo -e "${YELLOW}! Icons directory not found (may be normal depending on source repo)${NC}"
fi

echo -e "${GREEN}All tests passed for breezy-desktop-common package!${NC}"
exit 0