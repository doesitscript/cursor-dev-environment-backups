#!/bin/bash
# =============================================================================
# Setup Copy Last Command Output Shortcut
# =============================================================================
# This script sets up a keyboard shortcut to copy the last command and its output

set -euo pipefail

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Logging functions
log() {
    echo -e "${BLUE}[COPY-SHORTCUT]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[COPY-SHORTCUT]${NC} ✅ $1"
}

log_warning() {
    echo -e "${YELLOW}[COPY-SHORTCUT]${NC} ⚠️  $1"
}

log_error() {
    echo -e "${RED}[COPY-SHORTCUT]${NC} ❌ $1"
}

# Setup the copy shortcut
setup_copy_shortcut() {
    log "Setting up copy last command output shortcut..."

    local cursor_user_dir="$HOME/Library/Application Support/Cursor/User"
    local keybindings_file="$cursor_user_dir/keybindings.json"
    local script_dir="$(dirname "$0")"
    local shortcut_file="$script_dir/copy_last_command_output.json"

    # Create Cursor User directory
    mkdir -p "$cursor_user_dir"

    # Backup existing keybindings
    if [[ -f "$keybindings_file" ]]; then
        cp "$keybindings_file" "${keybindings_file}.backup.$(date +%Y%m%d_%H%M%S)"
        log "Backed up existing keybindings: ${keybindings_file}.backup.$(date +%Y%m%d_%H%M%S)"
    fi

    # Install the shortcut
    if [[ -f "$shortcut_file" ]]; then
        cp "$shortcut_file" "$keybindings_file"
        log_success "Copy shortcut installed: $keybindings_file"
    else
        log_error "Shortcut template not found: $shortcut_file"
        return 1
    fi
}

# Show current shortcuts
show_current_shortcuts() {
    log "Current keyboard shortcuts:"

    local keybindings_file="$HOME/Library/Application Support/Cursor/User/keybindings.json"

    if [[ -f "$keybindings_file" ]]; then
        echo ""
        cat "$keybindings_file" | python3 -m json.tool 2>/dev/null || cat "$keybindings_file"
        echo ""
    else
        log_warning "No keybindings file found"
    fi
}

# Test the shortcut
test_shortcut() {
    log "Testing copy shortcut setup..."

    local keybindings_file="$HOME/Library/Application Support/Cursor/User/keybindings.json"

    if [[ -f "$keybindings_file" ]]; then
        if python3 -m json.tool "$keybindings_file" >/dev/null 2>&1; then
            log_success "Keybindings JSON is valid"
        else
            log_error "Keybindings JSON is invalid"
            return 1
        fi
    else
        log_error "Keybindings file not found"
        return 1
    fi
}

# Show usage instructions
show_usage() {
    echo ""
    echo "🎯 Copy Last Command Output Shortcut"
    echo "===================================="
    echo ""
    echo "⌨️  Keyboard Shortcut: Cmd+Shift+C"
    echo ""
    echo "📋 What it does:"
    echo "  1. Selects all content in the terminal"
    echo "  2. Copies the selection (command + output)"
    echo "  3. Switches focus back to the editor"
    echo "  4. Pastes the content at your cursor position"
    echo ""
    echo "🚀 How to use:"
    echo "  1. Run a command in the integrated terminal"
    echo "  2. Press Cmd+Shift+C"
    echo "  3. The command and output will be copied and pasted in the editor"
    echo ""
    echo "🔄 Next steps:"
    echo "  1. Restart Cursor IDE to apply the shortcut"
    echo "  2. Test it by running a command in the terminal"
    echo "  3. Press Cmd+Shift+C to copy command and output"
    echo ""
}

# Main function
main() {
    case "${1:-setup}" in
        "setup")
            setup_copy_shortcut
            test_shortcut
            show_usage
            ;;
        "show")
            show_current_shortcuts
            ;;
        "test")
            test_shortcut
            ;;
        "help"|"-h"|"--help")
            echo "Setup Copy Last Command Output Shortcut"
            echo "======================================"
            echo ""
            echo "Usage: $0 [OPTIONS]"
            echo ""
            echo "Options:"
            echo "  setup              Set up the copy shortcut"
            echo "  show               Show current shortcuts"
            echo "  test               Test shortcut configuration"
            echo "  help               Show this help message"
            ;;
        *)
            log_error "Unknown option: $1"
            echo "Use '$0 help' for usage information"
            exit 1
            ;;
    esac
}

# Run main function
main "$@"
