#!/usr/bin/env bash
#
# Ralph for OpenCode - Installer
#
# Usage:
#   curl -fsSL https://raw.githubusercontent.com/lucasrueda/ralph-opencode/main/install.sh | bash
#
# Or clone and run:
#   git clone https://github.com/lucasrueda/ralph-opencode.git
#   cd ralph-opencode && ./install.sh
#

set -euo pipefail

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

REPO_URL="https://github.com/lucasrueda/ralph-opencode.git"
INSTALL_DIR="${HOME}/.opencode/ralph-opencode"
SKILLS_DIR="${HOME}/.config/opencode/skill"
BIN_DIR="${HOME}/.local/bin"

echo -e "${BLUE}"
echo "╔══════════════════════════════════════════════════════════════╗"
echo "║                                                              ║"
echo "║   Ralph for OpenCode - Installer                             ║"
echo "║                                                              ║"
echo "╚══════════════════════════════════════════════════════════════╝"
echo -e "${NC}"

# Check dependencies
echo -e "${BLUE}Checking dependencies...${NC}"
missing=()
command -v git &> /dev/null || missing+=("git")
command -v jq &> /dev/null || missing+=("jq")

if [[ ${#missing[@]} -gt 0 ]]; then
    echo -e "${RED}Missing dependencies: ${missing[*]}${NC}"
    echo "Please install them first:"
    echo "  brew install ${missing[*]}  # macOS"
    echo "  apt install ${missing[*]}   # Ubuntu/Debian"
    exit 1
fi

# Check for opencode
if ! command -v opencode &> /dev/null; then
    echo -e "${YELLOW}Warning: 'opencode' not found in PATH${NC}"
    echo "Make sure OpenCode is installed: https://opencode.ai"
    echo ""
fi

# Determine if running from curl or local
# Handle case where BASH_SOURCE is unbound (piped from curl)
SCRIPT_DIR=""
if [[ -n "${BASH_SOURCE[0]:-}" ]]; then
    SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" 2>/dev/null && pwd 2>/dev/null || echo "")"
fi

if [[ -z "$SCRIPT_DIR" ]] || [[ ! -f "$SCRIPT_DIR/bin/ralph" ]]; then
    # Running from curl - need to clone
    echo -e "${BLUE}Cloning ralph-opencode...${NC}"
    
    if [[ -d "$INSTALL_DIR" ]]; then
        echo -e "${YELLOW}Existing installation found. Updating...${NC}"
        cd "$INSTALL_DIR"
        git pull --quiet
    else
        git clone --quiet "$REPO_URL" "$INSTALL_DIR"
    fi
    
    SCRIPT_DIR="$INSTALL_DIR"
else
    # Running from local clone
    echo -e "${BLUE}Installing from local directory...${NC}"
    
    # Copy to install dir if not already there
    if [[ "$SCRIPT_DIR" != "$INSTALL_DIR" ]]; then
        mkdir -p "$(dirname "$INSTALL_DIR")"
        if [[ -d "$INSTALL_DIR" ]]; then
            rm -rf "$INSTALL_DIR"
        fi
        cp -r "$SCRIPT_DIR" "$INSTALL_DIR"
        SCRIPT_DIR="$INSTALL_DIR"
    fi
fi

# Install skills (OpenCode requires: skill/<name>/SKILL.md)
echo -e "${BLUE}Installing skills...${NC}"

for skill_dir in "$SCRIPT_DIR/skills/"*/; do
    skill_name=$(basename "$skill_dir")
    target_dir="$SKILLS_DIR/$skill_name"
    
    mkdir -p "$target_dir"
    ln -sf "$skill_dir/SKILL.md" "$target_dir/SKILL.md"
    echo -e "  ${GREEN}✓${NC} $skill_name"
done

# Create bin directory and symlink ralph
echo -e "${BLUE}Installing ralph command...${NC}"
mkdir -p "$BIN_DIR"
chmod +x "$SCRIPT_DIR/bin/ralph"
ln -sf "$SCRIPT_DIR/bin/ralph" "$BIN_DIR/ralph"
echo -e "  ${GREEN}✓${NC} ralph -> $BIN_DIR/ralph"

# Check if bin is in PATH
if [[ ":$PATH:" != *":$BIN_DIR:"* ]]; then
    echo ""
    echo -e "${YELLOW}Note: $BIN_DIR is not in your PATH${NC}"
    echo "Add this to your shell profile (.bashrc, .zshrc, etc.):"
    echo ""
    echo "  export PATH=\"\$HOME/.local/bin:\$PATH\""
    echo ""
fi

# Success
echo ""
echo -e "${GREEN}╔══════════════════════════════════════════════════════════════╗${NC}"
echo -e "${GREEN}║  Installation complete!                                      ║${NC}"
echo -e "${GREEN}╚══════════════════════════════════════════════════════════════╝${NC}"
echo ""
echo -e "Installed to: ${YELLOW}$INSTALL_DIR${NC}"
echo ""
echo -e "${BLUE}Quick Start:${NC}"
echo ""
echo "  1. Generate a PRD:"
echo "     opencode \"/generate-prd Build a CLI tool that converts CSV to JSON\""
echo ""
echo "  2. Convert to JSON format:"
echo "     opencode \"/convert-to-json\""
echo ""
echo "  3. Run Ralph:"
echo "     ralph"
echo ""
echo -e "Documentation: ${YELLOW}https://github.com/lucasrueda/ralph-opencode${NC}"
