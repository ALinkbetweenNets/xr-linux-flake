#!/usr/bin/env bash
set -euo pipefail

# Test script for breezy-desktop-gnome package
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

echo -e "${YELLOW}Testing breezy-desktop-gnome package at ${PACKAGE_PATH}...${NC}"

# Test 1: Check if the GNOME extension exists
if [ -d "${PACKAGE_PATH}/share/gnome-shell/extensions/breezydesktop@xronlinux.com" ]; then
    echo -e "${GREEN}✓ GNOME extension directory exists${NC}"
else
    echo -e "${RED}✗ GNOME extension directory not found${NC}"
    exit 1
fi

# Test 2: Check if extension has required files
if [ -f "${PACKAGE_PATH}/share/gnome-shell/extensions/breezydesktop@xronlinux.com/extension.js" ]; then
    echo -e "${GREEN}✓ Extension.js exists${NC}"
else
    echo -e "${RED}✗ Extension.js not found${NC}"
    exit 1
fi

if [ -f "${PACKAGE_PATH}/share/gnome-shell/extensions/breezydesktop@xronlinux.com/metadata.json" ]; then
    echo -e "${GREEN}✓ Metadata.json exists${NC}"
else
    echo -e "${RED}✗ Metadata.json not found${NC}"
    exit 1
fi

# Test 3: Check if setup/uninstall scripts exist
if [ -f "${PACKAGE_PATH}/bin/breezy-desktop-gnome-setup" ]; then
    echo -e "${GREEN}✓ Setup script exists${NC}"
else
    echo -e "${RED}✗ Setup script not found${NC}"
    exit 1
fi

if [ -f "${PACKAGE_PATH}/bin/breezy-desktop-gnome-uninstall" ]; then
    echo -e "${GREEN}✓ Uninstall script exists${NC}"
else
    echo -e "${RED}✗ Uninstall script not found${NC}"
    exit 1
fi

# Test 4: Check if setup script is executable
if [ -x "${PACKAGE_PATH}/bin/breezy-desktop-gnome-setup" ]; then
    echo -e "${GREEN}✓ Setup script is executable${NC}"
else
    echo -e "${RED}✗ Setup script is not executable${NC}"
    exit 1
fi

# Test 5: Check if application files exist
if [ -f "${PACKAGE_PATH}/share/applications/com.xronlinux.BreezyDesktop.desktop" ]; then
    echo -e "${GREEN}✓ Desktop file exists${NC}"
else
    echo -e "${YELLOW}! Desktop file not found (may be packaged differently)${NC}"
fi

echo -e "${GREEN}All tests passed for breezy-desktop-gnome package!${NC}"
exit 0