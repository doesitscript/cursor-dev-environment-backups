#!/bin/bash
# =============================================================================
# Remove Keyboard Shortcuts Script
# =============================================================================
# This script removes existing keyboard shortcuts from Cursor IDE

set -euo pipefail

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Logging functions
log() {
    echo -e "${BLUE}[REMOVE-SHORTCUTS]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[REMOVE-SHORTCUTS]${NC} ✅ $1"
}

log_warning() {
    echo -e "${YELLOW}[REMOVE-SHORTCUTS]${NC} ⚠️  $1"
}

log_error() {
    echo -e "${RED}[REMOVE-SHORTCUTS]${NC} ❌ $1"
}

# Remove keyboard shortcuts
remove_keyboard_shortcuts() {
    log "Removing existing keyboard shortcuts..."

    local keybindings_file="$HOME/Library/Application Support/Cursor/User/keybindings.json"

    # Check if keybindings file exists
    if [[ ! -f "$keybindings_file" ]]; then
        log_warning "No keybindings file found: $keybindings_file"
        return 0
    fi

    # Create backup
    cp "$keybindings_file" "${keybindings_file}.backup.$(date +%Y%m%d_%H%M%S)"
    log "Created backup: ${keybindings_file}.backup.$(date +%Y%m%d_%H%M%S)"

    # Remove the keybindings file (this resets to default)
    rm "$keybindings_file"
    log_success "Keyboard shortcuts removed: $keybindings_file"

    # Alternative: Create empty keybindings file
    echo "[]" > "$keybindings_file"
    log_success "Empty keybindings file created: $keybindings_file"
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

# Restore from backup
restore_from_backup() {
    log "Available backups:"

    local keybindings_file="$HOME/Library/Application Support/Cursor/User/keybindings.json"
    local backup_dir="$(dirname "$keybindings_file")"

    ls -la "$backup_dir"/keybindings.json.backup.* 2>/dev/null || log_warning "No backups found"
}

# Main function
main() {
    case "${1:-remove}" in
        "remove")
            show_current_shortcuts
            remove_keyboard_shortcuts
            log_success "Keyboard shortcuts removal completed!"
            echo ""
            echo "🔄 Next steps:"
            echo "  1. Restart Cursor IDE to apply changes"
            echo "  2. Keyboard shortcuts will be reset to defaults"
            ;;
        "show")
            show_current_shortcuts
            ;;
        "restore")
            restore_from_backup
            ;;
        "help"|"-h"|"--help")
            echo "Remove Keyboard Shortcuts Script"
            echo "================================="
            echo ""
            echo "Usage: $0 [OPTIONS]"
            echo ""
            echo "Options:"
            echo "  remove              Remove existing keyboard shortcuts"
            echo "  show                Show current keyboard shortcuts"
            echo "  restore             Show available backups"
            echo "  help                Show this help message"
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
