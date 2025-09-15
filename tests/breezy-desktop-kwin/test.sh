#!/usr/bin/env bash
set -euo pipefail

# Test script for breezy-desktop-kwin package
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

echo -e "${YELLOW}Testing breezy-desktop-kwin package at ${PACKAGE_PATH}...${NC}"

# Test 1: Check if the KWin plugin exists
if [ -f "${PACKAGE_PATH}/lib/qt6/plugins/kwin/effects/plugins/breezyfollow.so" ]; then
    echo -e "${GREEN}✓ KWin plugin exists${NC}"
else
    echo -e "${RED}✗ KWin plugin not found${NC}"
    exit 1
fi

# Test 2: Check if KCM module exists
if [ -f "${PACKAGE_PATH}/lib/qt6/plugins/plasma/kcms/kcm_breezy_kwin_follow.so" ]; then
    echo -e "${GREEN}✓ KCM module exists${NC}"
else
    echo -e "${RED}✗ KCM module not found${NC}"
    exit 1
fi

# Test 3: Check if desktop files exist
if [ -f "${PACKAGE_PATH}/share/applications/kcm_breezy_kwin_follow.desktop" ]; then
    echo -e "${GREEN}✓ KCM desktop file exists${NC}"
else
    echo -e "${RED}✗ KCM desktop file not found${NC}"
    exit 1
fi

if [ -f "${PACKAGE_PATH}/share/applications/com.xronlinux.BreezyDesktop.desktop" ]; then
    echo -e "${GREEN}✓ Application desktop file exists${NC}"
else
    echo -e "${RED}✗ Application desktop file not found${NC}"
    exit 1
fi

# Test 4: Check if setup/uninstall scripts exist
if [ -f "${PACKAGE_PATH}/bin/breezy-desktop-kwin-setup" ]; then
    echo -e "${GREEN}✓ Setup script exists${NC}"
else
    echo -e "${RED}✗ Setup script not found${NC}"
    exit 1
fi

if [ -f "${PACKAGE_PATH}/bin/breezy-desktop-kwin-uninstall" ]; then
    echo -e "${GREEN}✓ Uninstall script exists${NC}"
else
    echo -e "${RED}✗ Uninstall script not found${NC}"
    exit 1
fi

# Test 5: Check if setup script is executable
if [ -x "${PACKAGE_PATH}/bin/breezy-desktop-kwin-setup" ]; then
    echo -e "${GREEN}✓ Setup script is executable${NC}"
else
    echo -e "${RED}✗ Setup script is not executable${NC}"
    exit 1
fi

# Test 6: Check if icon exists
if [ -f "${PACKAGE_PATH}/share/icons/hicolor/scalable/apps/com.xronlinux.BreezyDesktop.svg" ]; then
    echo -e "${GREEN}✓ Application icon exists${NC}"
else
    echo -e "${RED}✗ Application icon not found${NC}"
    exit 1
fi

echo -e "${GREEN}All tests passed for breezy-desktop-kwin package!${NC}"
exit 0