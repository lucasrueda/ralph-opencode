#!/usr/bin/env bash
#
# Ralph for OpenCode - Uninstaller
#

set -euo pipefail

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

INSTALL_DIR="${HOME}/.opencode/ralph-opencode"
SKILLS_DIR="${HOME}/.opencode/skills"
BIN_DIR="${HOME}/.local/bin"

echo -e "${YELLOW}Uninstalling Ralph for OpenCode...${NC}"
echo ""

# Remove skills symlinks
for skill in ralph.md generate-prd.md convert-to-json.md; do
    if [[ -L "$SKILLS_DIR/$skill" ]]; then
        rm "$SKILLS_DIR/$skill"
        echo -e "  ${GREEN}✓${NC} Removed skill: $skill"
    fi
done

# Remove ralph binary symlink
if [[ -L "$BIN_DIR/ralph" ]]; then
    rm "$BIN_DIR/ralph"
    echo -e "  ${GREEN}✓${NC} Removed: $BIN_DIR/ralph"
fi

# Remove installation directory
if [[ -d "$INSTALL_DIR" ]]; then
    rm -rf "$INSTALL_DIR"
    echo -e "  ${GREEN}✓${NC} Removed: $INSTALL_DIR"
fi

echo ""
echo -e "${GREEN}Ralph has been uninstalled.${NC}"
