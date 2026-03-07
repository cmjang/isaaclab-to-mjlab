#!/usr/bin/env bash
###############################################################################
# mjlab-skillkit Installer
# Interactive TUI - Compatible with bash and zsh
###############################################################################

# Detect shell
if [[ -n "${ZSH_VERSION:-}" ]]; then
    _SCRIPT_SOURCE="${0}"
    emulate -L bash 2>/dev/null || true
else
    _SCRIPT_SOURCE="${BASH_SOURCE[0]:-}"
fi

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${_SCRIPT_SOURCE}")" && pwd)"
REPO_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
SKILL_SLUG="mjlab-skillkit"
SHARED_RULES_FILE="$REPO_DIR/shared/${SKILL_SLUG}-rules.md"
CURSOR_RULES_FILE="$REPO_DIR/adapters/cursor/${SKILL_SLUG}.mdc"

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
WHITE='\033[1;37m'
GRAY='\033[0;90m'
NC='\033[0m'
BOLD='\033[1m'

# State
TOOL_CODEX=false
TOOL_CLAUDE=false
TOOL_GEMINI=false
TOOL_CURSOR=false
TOOL_OPENCODE=false
INSTALL_METHOD="copy"
PROJECT_DIR="${PWD}"
PROJECT_DIR_SET=false
INSTALL_SUMMARY=()

# Usage
usage() {
    cat << 'USAGE'
Usage:
  ./scripts/install.sh [options]

Interactive Mode:
  Simply run without arguments to enter interactive menu.

Options:
  --tool <name>       Install to tool(s): codex, claude, gemini, cursor, opencode
  --method <method>  Installation method: copy|symlink (default: copy)
  --project <path>   Project path for Cursor/OpenCode
  -h, --help        Show this help

Examples:
  ./scripts/install.sh
  ./scripts/install.sh --tool opencode
  ./scripts/install.sh --tool all --method symlink
USAGE
}

has_any_selection() {
    [[ "$TOOL_CODEX" == "true" ]] || [[ "$TOOL_CLAUDE" == "true" ]] || \
    [[ "$TOOL_GEMINI" == "true" ]] || [[ "$TOOL_CURSOR" == "true" ]] || \
    [[ "$TOOL_OPENCODE" == "true" ]]
}

toggle_codex() { TOOL_CODEX=$([[ "$TOOL_CODEX" == "true" ]] && echo "false" || echo "true"); }
toggle_claude() { TOOL_CLAUDE=$([[ "$TOOL_CLAUDE" == "true" ]] && echo "false" || echo "true"); }
toggle_gemini() { TOOL_GEMINI=$([[ "$TOOL_GEMINI" == "true" ]] && echo "false" || echo "true"); }
toggle_cursor() { TOOL_CURSOR=$([[ "$TOOL_CURSOR" == "true" ]] && echo "false" || echo "true"); }
toggle_opencode() { TOOL_OPENCODE=$([[ "$TOOL_OPENCODE" == "true" ]] && echo "false" || echo "true"); }

get_selected_str() {
    local s=""
    [[ "$TOOL_CODEX" == "true" ]] && s+="Codex, "
    [[ "$TOOL_CLAUDE" == "true" ]] && s+="Claude, "
    [[ "$TOOL_GEMINI" == "true" ]] && s+="Gemini, "
    [[ "$TOOL_CURSOR" == "true" ]] && s+="Cursor, "
    [[ "$TOOL_OPENCODE" == "true" ]] && s+="OpenCode, "
    s="${s%, }"
    [[ -z "$s" ]] && s="(none)"
    echo "$s"
}

# Display menu item: text, is_selected, is_hovered
display_item() {
    local text=$1 is_selected=$2 is_hovered=$3

    if [[ "$is_selected" == "true" && "$is_hovered" == "true" ]]; then
        echo -en "${GREEN}${BOLD}▶ ${text}${NC}"
    elif [[ "$is_selected" == "true" ]]; then
        echo -en "${GREEN}▶ ${text}${NC}"
    elif [[ "$is_hovered" == "true" ]]; then
        echo -en "${WHITE}${BOLD}▸ ${text}${NC}"
    else
        echo -en "${GRAY}  ${text}${NC}"
    fi
}

interactive_menu() {
    # Save and setup terminal
    OLD_TTY_SETTINGS=""
    OLD_TTY_SETTINGS=$(stty -g 2>/dev/null || echo "")
    
    cleanup() {
        if [[ -n "$OLD_TTY_SETTINGS" ]]; then
            stty "$OLD_TTY_SETTINGS" 2>/dev/null
        fi
        tput cnorm 2>/dev/null
    }
    trap cleanup EXIT
    
    stty -echo -icanon min 1 time 0 2>/dev/null || true
    tput civis 2>/dev/null
    tput clear 2>/dev/null
    
    local cursor_pos=0
    local needs_redraw=true
    
    while true; do
        if [[ "$needs_redraw" == "true" ]]; then
            tput clear
            
            # Header
            tput cup 0 0
            echo -en "${BOLD}${BLUE}╔════════════════════════════════════════════════════════════╗${NC}"
            tput cup 1 0
            echo -en "${BOLD}${BLUE}║              mjlab-skillkit - Installer                    ║${NC}"
            tput cup 2 0
            echo -en "${BOLD}${BLUE}╚════════════════════════════════════════════════════════════╝${NC}"
            
            tput cup 4 0
            echo -en "${YELLOW}Use arrow keys to navigate, SPACE to toggle, ENTER to confirm${NC}"
            
            tput cup 6 0
            echo -en "${BOLD}Select target agent tools:${NC}"
            tput cup 7 0
            
            # Tools with hover effect
            display_item "Codex" "$TOOL_CODEX" "$([[ $cursor_pos -eq 0 ]] && echo true || echo false)"
            tput cup 8 0
            display_item "Claude Code" "$TOOL_CLAUDE" "$([[ $cursor_pos -eq 1 ]] && echo true || echo false)"
            tput cup 9 0
            display_item "Gemini CLI" "$TOOL_GEMINI" "$([[ $cursor_pos -eq 2 ]] && echo true || echo false)"
            tput cup 10 0
            display_item "Cursor" "$TOOL_CURSOR" "$([[ $cursor_pos -eq 3 ]] && echo true || echo false)"
            tput cup 11 0
            display_item "OpenCode" "$TOOL_OPENCODE" "$([[ $cursor_pos -eq 4 ]] && echo true || echo false)"
            
            tput cup 13 0
            echo -en "${BOLD}Installation method:${NC}"
            tput cup 14 0
            
            # Method options with hover
            if [[ "$INSTALL_METHOD" == "copy" ]]; then
                [[ $cursor_pos -eq 5 ]] && echo -en "${WHITE}${BOLD}▸ Copy (recommended for production)${NC}" || echo -en "${GREEN}▶ Copy (recommended for production)${NC}"
            else
                [[ $cursor_pos -eq 5 ]] && echo -en "${WHITE}${BOLD}  Copy (recommended for production)${NC}" || echo -en "${GRAY}  Copy (recommended for production)${NC}"
            fi
            tput cup 15 0
            
            if [[ "$INSTALL_METHOD" == "symlink" ]]; then
                [[ $cursor_pos -eq 6 ]] && echo -en "${WHITE}${BOLD}▸ Symlink (recommended for development)${NC}" || echo -en "${GREEN}▶ Symlink (recommended for development)${NC}"
            else
                [[ $cursor_pos -eq 6 ]] && echo -en "${WHITE}${BOLD}  Symlink (recommended for development)${NC}" || echo -en "${GRAY}  Symlink (recommended for development)${NC}"
            fi
            
            tput cup 17 0
            echo -en "${BOLD}Project directory: ${WHITE}${PROJECT_DIR}${NC}"
            
            # Footer
            local fl=$(( $(tput lines) - 4 ))
            tput cup $fl 0
            echo -en "${CYAN}────────────────────────────────────────────────────────────${NC}"
            ((fl++))
            tput cup $fl 0
            echo -en "Will install to: ${GREEN}$(get_selected_str)${NC}"
            ((fl++))
            tput cup $fl 0
            echo -en "${CYAN}────────────────────────────────────────────────────────────${NC}"
            ((fl++))
            tput cup $fl 0
            echo -en "${GRAY}[↑/↓] Navigate  [SPACE] Toggle  [Enter] Install  [Q] Quit ${NC}"
            
            # Position cursor
            local cursory=$((7 + cursor_pos))
            [[ $cursor_pos -gt 4 ]] && cursory=$((cursor_pos + 9))
            tput cup $cursory 0
            
            needs_redraw=false
        fi
        
        # Read key
        local key
        key=$(dd bs=1 count=1 2>/dev/null | od -An -tx1 | tr -d ' ')
        [[ -z "$key" ]] && continue
        
        case "$key" in
            1b)  # Escape
                local k2
                k2=$(dd bs=1 count=1 2>/dev/null | od -An -tx1 | tr -d ' ')
                if [[ "$k2" == "5b" ]]; then
                    k2=$(dd bs=1 count=1 2>/dev/null | od -An -tx1 | tr -d ' ')
                    case "$k2" in
                        41) [[ $cursor_pos -gt 0 ]] && ((cursor_pos--)) && needs_redraw=true ;;
                        42) [[ $cursor_pos -lt 6 ]] && ((cursor_pos++)) && needs_redraw=true ;;
                    esac
                fi
                ;;
            20)  # Space
                case $cursor_pos in
                    0) toggle_codex ;;
                    1) toggle_claude ;;
                    2) toggle_gemini ;;
                    3) toggle_cursor ;;
                    4) toggle_opencode ;;
                    5|6) [[ "$INSTALL_METHOD" == "copy" ]] && INSTALL_METHOD="symlink" || INSTALL_METHOD="copy" ;;
                esac
                needs_redraw=true
                ;;
            0a|0d)  # Enter
                if has_any_selection; then
                    tput cnorm; tput clear
                    return 0
                fi
                ;;
            71|51)  # q/Q
                tput cnorm; tput clear
                echo "Installation cancelled."
                exit 0
                ;;
        esac
    done
}

ensure_import_line() {
    local file="$1" line="$2"
    mkdir -p "$(dirname "$file")"
    touch "$file"
    grep -Fqx "$line" "$file" 2>/dev/null || printf "\n%s\n" "$line" >> "$file"
}

record_install() {
    INSTALL_SUMMARY+=("$1")
}

print_install_summary() {
    [[ ${#INSTALL_SUMMARY[@]} -eq 0 ]] && return

    echo
    echo -e "${BOLD}Install summary:${NC}"
    for line in "${INSTALL_SUMMARY[@]}"; do
        echo "  - $line"
    done
}

install_codex() {
    local dest="${CODEX_HOME:-$HOME/.codex}/skills/$SKILL_SLUG"
    mkdir -p "$(dirname "$dest")"
    if [[ "$INSTALL_METHOD" == "symlink" ]]; then
        ln -sf "$REPO_DIR" "$dest" 2>/dev/null || { rm -rf "$dest"; ln -sf "$REPO_DIR" "$dest"; }
        echo "[codex] symlinked: $dest"
    else
        rsync -a --delete --exclude '.git/' "$REPO_DIR/" "$dest/"
        echo "[codex] installed: $dest"
    fi
    record_install "Codex ($INSTALL_METHOD): $dest"
}

install_claude() {
    local dir="$HOME/.claude/rules"
    local file="$dir/$SKILL_SLUG.md"
    mkdir -p "$dir"
    if [[ "$INSTALL_METHOD" == "symlink" ]]; then
        ln -sf "$SHARED_RULES_FILE" "$file" 2>/dev/null || { rm -f "$file"; ln -sf "$SHARED_RULES_FILE" "$file"; }
    else
        cp "$SHARED_RULES_FILE" "$file"
    fi
    ensure_import_line "$HOME/.claude/CLAUDE.md" "@$file"
    echo "[claude] installed: $file"
    record_install "Claude Code ($INSTALL_METHOD): $file"
}

install_gemini() {
    local dir="$HOME/.gemini/rules"
    local file="$dir/$SKILL_SLUG.md"
    mkdir -p "$dir"
    if [[ "$INSTALL_METHOD" == "symlink" ]]; then
        ln -sf "$SHARED_RULES_FILE" "$file" 2>/dev/null || { rm -f "$file"; ln -sf "$SHARED_RULES_FILE" "$file"; }
    else
        cp "$SHARED_RULES_FILE" "$file"
    fi
    ensure_import_line "$HOME/.gemini/GEMINI.md" "@$file"
    echo "[gemini] installed: $file"
    record_install "Gemini CLI ($INSTALL_METHOD): $file"
}

install_cursor() {
    local dir="$PROJECT_DIR/.cursor/rules"
    local file="$dir/$SKILL_SLUG.mdc"
    mkdir -p "$dir"
    if [[ "$INSTALL_METHOD" == "symlink" ]]; then
        ln -sf "$CURSOR_RULES_FILE" "$file" 2>/dev/null || { rm -f "$file"; ln -sf "$CURSOR_RULES_FILE" "$file"; }
    else
        cp "$CURSOR_RULES_FILE" "$file"
    fi
    echo "[cursor] installed: $file"
    record_install "Cursor ($INSTALL_METHOD): $file"
}

install_opencode() {
    local install_root
    if [[ "$PROJECT_DIR_SET" == "true" ]]; then
        install_root="$PROJECT_DIR/.opencode/skills"
    else
        install_root="$HOME/.config/opencode/skills"
    fi

    local dest_dir="$install_root/$SKILL_SLUG"

    mkdir -p "$install_root"

    if [[ "$INSTALL_METHOD" == "symlink" ]]; then
        ln -sfn "$REPO_DIR" "$dest_dir"
    else
        rsync -a --delete --exclude '.git/' "$REPO_DIR/" "$dest_dir/"
    fi

    if [[ "$PROJECT_DIR_SET" == "true" ]]; then
        echo "[opencode] installed (project): $dest_dir"
    else
        echo "[opencode] installed (global): $dest_dir"
    fi
    record_install "OpenCode ($INSTALL_METHOD): $dest_dir"
}

resolve_project_dir() {
    # Use PROJECT_DIR if explicitly set
    if [[ "$PROJECT_DIR_SET" == "true" ]] && [[ -n "$PROJECT_DIR" ]]; then
        echo "$PROJECT_DIR"
        return
    fi
    
    # Try git to find project root
    if command -v git >/dev/null 2>&1; then
        local git_root
        git_root=$(git rev-parse --show-toplevel 2>/dev/null || echo "")
        if [[ -n "$git_root" ]]; then
            echo "$git_root"
            return
        fi
    fi
    
    # Fallback to current directory
    echo "$PWD"
}

parse_args() {
    while [[ $# -gt 0 ]]; do
        case "$1" in
            --tool)
                [[ $# -lt 2 ]] && { echo "--tool requires value"; exit 1; }
                case "$2" in
                    codex) TOOL_CODEX=true ;;
                    claude) TOOL_CLAUDE=true ;;
                    gemini) TOOL_GEMINI=true ;;
                    cursor) TOOL_CURSOR=true ;;
                    opencode) TOOL_OPENCODE=true ;;
                    all) TOOL_CODEX=true; TOOL_CLAUDE=true; TOOL_GEMINI=true; TOOL_CURSOR=true; TOOL_OPENCODE=true ;;
                    *) echo "Unknown: $2"; exit 1 ;;
                esac
                shift 2
                ;;
            --method)
                [[ $# -lt 2 ]] && { echo "--method requires value"; exit 1; }
                [[ "$2" != "copy" && "$2" != "symlink" ]] && { echo "copy or symlink"; exit 1; }
                INSTALL_METHOD="$2"; shift 2
                ;;
            --project)
                [[ $# -lt 2 ]] && { echo "--project requires value"; exit 1; }
                PROJECT_DIR="$2"; PROJECT_DIR_SET=true; shift 2
                ;;
            -h|--help) usage; exit 0 ;;
            *) echo "Unknown: $1"; usage; exit 1 ;;
        esac
    done
}

main() {
    [[ $# -eq 0 ]] && interactive_menu || parse_args "$@"

    [[ "$TOOL_CODEX" == "true" ]] && install_codex
    [[ "$TOOL_CLAUDE" == "true" ]] && install_claude
    [[ "$TOOL_GEMINI" == "true" ]] && install_gemini

    if [[ "$TOOL_CURSOR" == "true" || "$TOOL_OPENCODE" == "true" ]]; then
        PROJECT_DIR="$(resolve_project_dir)"
        [[ ! -d "$PROJECT_DIR" ]] && { echo "Not found: $PROJECT_DIR"; exit 1; }
        [[ "$TOOL_CURSOR" == "true" ]] && install_cursor
        [[ "$TOOL_OPENCODE" == "true" ]] && install_opencode
    fi

    print_install_summary
    echo -e "\n${GREEN}Done!${NC}"
}

main "$@"
