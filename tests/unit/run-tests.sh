#!/usr/bin/env bash
set -euo pipefail

# Define colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
cd "$REPO_ROOT"

echo -e "${BLUE}==== Running Nix Unit Tests ====${NC}"

# Make tests executable
chmod +x tests/unit/run-tests.sh

# Run lib tests
echo -e "\n${YELLOW}Running lib unit tests...${NC}"
LIB_TEST_OUTPUT=$(nix-build --no-out-link tests/unit/default.nix)

if [ -f "$LIB_TEST_OUTPUT" ]; then
  # Print test results
  echo -e "${GREEN}$(cat "$LIB_TEST_OUTPUT")${NC}"
else
  echo -e "${RED}Lib tests failed${NC}"
  exit 1
fi

# In the future, add more test modules here

echo -e "\n${GREEN}==== All Nix unit tests passed! ====${NC}"
exit 0