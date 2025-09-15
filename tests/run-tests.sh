#!/usr/bin/env bash
set -euo pipefail

# Main test runner script
# This script builds each package and runs the corresponding tests

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$REPO_ROOT"

echo -e "${BLUE}==== Running Tests for XRLinuxDriver Flake ====${NC}"
echo -e "${BLUE}Repository root: ${REPO_ROOT}${NC}"

# Set execute permissions for all test scripts
chmod +x tests/*/test.sh
chmod +x tests/run-tests.sh

# Verify all test scripts exist
for package in xrlinuxdriver breezy-desktop-common breezy-desktop-gnome breezy-desktop-kwin; do
    if [ ! -f "tests/${package}/test.sh" ]; then
        echo -e "${RED}Error: Test script for ${package} not found${NC}"
        exit 1
    fi
    
    if [ ! -x "tests/${package}/test.sh" ]; then
        echo -e "${RED}Error: Test script for ${package} is not executable${NC}"
        exit 1
    fi
done

echo -e "${GREEN}All test scripts found and executable${NC}"

# Test 1: Build and test xrlinuxdriver
echo -e "\n${YELLOW}Building xrlinuxdriver package...${NC}"
nix build .#xrlinuxdriver -L || { echo -e "${RED}Failed to build xrlinuxdriver${NC}"; exit 1; }
echo -e "${GREEN}Successfully built xrlinuxdriver package${NC}"

echo -e "\n${YELLOW}Running tests for xrlinuxdriver...${NC}"
tests/xrlinuxdriver/test.sh "$(realpath ./result)" || { echo -e "${RED}Tests failed for xrlinuxdriver${NC}"; exit 1; }

# Test 2: Build and test breezy-desktop-common
echo -e "\n${YELLOW}Building breezy-desktop-common package...${NC}"
nix build .#breezy-desktop-common -L || { echo -e "${RED}Failed to build breezy-desktop-common${NC}"; exit 1; }
echo -e "${GREEN}Successfully built breezy-desktop-common package${NC}"

echo -e "\n${YELLOW}Running tests for breezy-desktop-common...${NC}"
tests/breezy-desktop-common/test.sh "$(realpath ./result)" || { echo -e "${RED}Tests failed for breezy-desktop-common${NC}"; exit 1; }

# Test 3: Build and test breezy-desktop-gnome
echo -e "\n${YELLOW}Building breezy-desktop-gnome package...${NC}"
nix build .#breezy-desktop-gnome -L || { echo -e "${RED}Failed to build breezy-desktop-gnome${NC}"; exit 1; }
echo -e "${GREEN}Successfully built breezy-desktop-gnome package${NC}"

echo -e "\n${YELLOW}Running tests for breezy-desktop-gnome...${NC}"
tests/breezy-desktop-gnome/test.sh "$(realpath ./result)" || { echo -e "${RED}Tests failed for breezy-desktop-gnome${NC}"; exit 1; }

# Test 4: Build and test breezy-desktop-kwin
echo -e "\n${YELLOW}Building breezy-desktop-kwin package...${NC}"
nix build .#breezy-desktop-kwin -L || { echo -e "${RED}Failed to build breezy-desktop-kwin${NC}"; exit 1; }
echo -e "${GREEN}Successfully built breezy-desktop-kwin package${NC}"

echo -e "\n${YELLOW}Running tests for breezy-desktop-kwin...${NC}"
tests/breezy-desktop-kwin/test.sh "$(realpath ./result)" || { echo -e "${RED}Tests failed for breezy-desktop-kwin${NC}"; exit 1; }

# Test 5: Run flake check
echo -e "\n${YELLOW}Running flake check...${NC}"
nix flake check || { echo -e "${RED}Flake check failed${NC}"; exit 1; }
echo -e "${GREEN}Flake check passed${NC}"

echo -e "\n${GREEN}==== All tests passed! ====${NC}"
exit 0