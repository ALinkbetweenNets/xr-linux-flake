#!/usr/bin/env bash
set -e

# Define colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
HOOKS_DIR="$REPO_ROOT/.github/hooks"
GIT_HOOKS_DIR="$REPO_ROOT/.git/hooks"

echo -e "${BLUE}==== Installing Git Hooks for XR Linux Flake ====${NC}"

# Make hooks executable
chmod +x "$HOOKS_DIR/pre-commit"

# Create the git hooks directory if it doesn't exist
mkdir -p "$GIT_HOOKS_DIR"

# Install pre-commit hook
echo -e "${YELLOW}Installing pre-commit hook...${NC}"
cp "$HOOKS_DIR/pre-commit" "$GIT_HOOKS_DIR/pre-commit"
chmod +x "$GIT_HOOKS_DIR/pre-commit"

echo -e "${GREEN}Git hooks installed successfully!${NC}"
echo -e "${YELLOW}Pre-commit hook will now run tests and builds before each commit.${NC}"