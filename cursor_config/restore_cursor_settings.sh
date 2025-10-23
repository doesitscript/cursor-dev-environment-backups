#!/bin/bash
# =============================================================================
# Cursor Settings Restore Script
# =============================================================================
# This script restores Cursor settings from the workflows project backup
# following the established app setup pattern

set -euo pipefail

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Logging functions
log() {
    echo -e "${BLUE}[CURSOR-RESTORE]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[CURSOR-RESTORE]${NC} ✅ $1"
}

log_warning() {
    echo -e "${YELLOW}[CURSOR-RESTORE]${NC} ⚠️  $1"
}

log_error() {
    echo -e "${RED}[CURSOR-RESTORE]${NC} ❌ $1"
}

# Get script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CURSOR_CONFIG_DIR="$SCRIPT_DIR/config"

# Cursor settings locations
CURSOR_USER_DIR="$HOME/Library/Application Support/Cursor/User"

# Create Cursor user directory if it doesn't exist
mkdir -p "$CURSOR_USER_DIR"

# Restore main settings
restore_main_settings() {
    log "Restoring main Cursor settings..."

    # Restore settings.json
    if [[ -f "$CURSOR_CONFIG_DIR/settings.json" ]]; then
        # Backup existing settings
        if [[ -f "$CURSOR_USER_DIR/settings.json" ]]; then
            cp "$CURSOR_USER_DIR/settings.json" "$CURSOR_USER_DIR/settings.json.backup.$(date +%Y%m%d_%H%M%S)"
            log "Backed up existing settings.json"
        fi

        cp "$CURSOR_CONFIG_DIR/settings.json" "$CURSOR_USER_DIR/settings.json"
        log_success "Restored settings.json"
    else
        log_error "settings.json not found in backup: $CURSOR_CONFIG_DIR/settings.json"
        return 1
    fi

    # Restore keybindings.json
    if [[ -f "$CURSOR_CONFIG_DIR/keybindings.json" ]]; then
        # Backup existing keybindings
        if [[ -f "$CURSOR_USER_DIR/keybindings.json" ]]; then
            cp "$CURSOR_USER_DIR/keybindings.json" "$CURSOR_USER_DIR/keybindings.json.backup.$(date +%Y%m%d_%H%M%S)"
            log "Backed up existing keybindings.json"
        fi

        cp "$CURSOR_CONFIG_DIR/keybindings.json" "$CURSOR_USER_DIR/keybindings.json"
        log_success "Restored keybindings.json"
    else
        log_error "keybindings.json not found in backup: $CURSOR_CONFIG_DIR/keybindings.json"
        return 1
    fi
}

# List available workspace backups
list_workspace_backups() {
    log "Available workspace backups:"

    local workspace_backup_dir="$CURSOR_CONFIG_DIR/workspace_backups"
    if [[ -d "$workspace_backup_dir" ]]; then
        local backup_count=0
        while IFS= read -r -d '' backup_file; do
            local filename=$(basename "$backup_file")
            local workspace_id=$(echo "$filename" | sed 's/workspace_\([^_]*\)_.*/\1/')
            local timestamp=$(echo "$filename" | sed 's/workspace_[^_]*_\(.*\)\.json/\1/')
            echo "  📁 Workspace ID: $workspace_id (Backup: $timestamp)"
            ((backup_count++))
        done < <(find "$workspace_backup_dir" -name "workspace_*.json" -print0)

        if [[ $backup_count -eq 0 ]]; then
            log_warning "No workspace backups found"
        else
            log_success "Found $backup_count workspace backups"
        fi
    else
        log_warning "Workspace backup directory not found: $workspace_backup_dir"
    fi
}

# Restore specific workspace settings
restore_workspace_settings() {
    local workspace_id="$1"
    local timestamp="$2"

    if [[ -z "$workspace_id" || -z "$timestamp" ]]; then
        log_error "Workspace ID and timestamp are required"
        log "Usage: restore_workspace_settings <workspace_id> <timestamp>"
        return 1
    fi

    local workspace_backup_dir="$CURSOR_CONFIG_DIR/workspace_backups"
    local backup_file="$workspace_backup_dir/workspace_${workspace_id}_${timestamp}.json"
    local target_dir="$CURSOR_USER_DIR/workspaceStorage/$workspace_id"

    if [[ -f "$backup_file" ]]; then
        # Create target directory
        mkdir -p "$target_dir"

        # Backup existing workspace settings
        if [[ -f "$target_dir/workspace.json" ]]; then
            cp "$target_dir/workspace.json" "$target_dir/workspace.json.backup.$(date +%Y%m%d_%H%M%S)"
            log "Backed up existing workspace settings"
        fi

        # Restore workspace settings
        cp "$backup_file" "$target_dir/workspace.json"
        log_success "Restored workspace settings for ID: $workspace_id"
    else
        log_error "Workspace backup not found: $backup_file"
        return 1
    fi
}

# Show restore summary
show_restore_summary() {
    echo ""
    echo "🎯 Cursor Settings Restore Summary"
    echo "=================================="
    echo ""
    echo "📁 Restored Files:"
    echo "  ✅ settings.json → $CURSOR_USER_DIR/settings.json"
    echo "  ✅ keybindings.json → $CURSOR_USER_DIR/keybindings.json"
    echo ""
    echo "🔄 Next Steps:"
    echo "  1. Restart Cursor IDE to apply restored settings"
    echo "  2. Verify that all settings are working correctly"
    echo "  3. Test keyboard shortcuts and customizations"
    echo ""
    echo "💡 To restore workspace settings:"
    echo "  $0 workspace <workspace_id> <timestamp>"
    echo "  $0 list-workspaces (to see available backups)"
    echo ""
}

# Main restore function
restore_cursor_settings() {
    log "Starting Cursor settings restore..."

    # Check if backup directory exists
    if [[ ! -d "$CURSOR_CONFIG_DIR" ]]; then
        log_error "Backup directory not found: $CURSOR_CONFIG_DIR"
        log "Please run backup_cursor_settings.sh first"
        return 1
    fi

    # Restore main settings
    restore_main_settings

    # Show summary
    show_restore_summary

    log_success "Cursor settings restore completed successfully!"
}

# Show help
show_help() {
    echo "Cursor Settings Restore Script"
    echo "=============================="
    echo ""
    echo "Usage: $0 [COMMAND] [OPTIONS]"
    echo ""
    echo "Commands:"
    echo "  restore                 Restore main Cursor settings (default)"
    echo "  list-workspaces         List available workspace backups"
    echo "  workspace <id> <time>   Restore specific workspace settings"
    echo "  help                    Show this help message"
    echo ""
    echo "Examples:"
    echo "  $0 restore              # Restore main settings"
    echo "  $0 list-workspaces      # List available workspace backups"
    echo "  $0 workspace abc123 20251017_102759  # Restore specific workspace"
    echo ""
    echo "This script restores Cursor IDE settings from the workflows project"
    echo "backup following the established app setup pattern."
    echo ""
}

# Main script logic
main() {
    case "${1:-restore}" in
        "restore")
            restore_cursor_settings
            ;;
        "list-workspaces")
            list_workspace_backups
            ;;
        "workspace")
            if [[ $# -lt 3 ]]; then
                log_error "Workspace ID and timestamp are required"
                log "Usage: $0 workspace <workspace_id> <timestamp>"
                exit 1
            fi
            restore_workspace_settings "$2" "$3"
            ;;
        "help"|"-h"|"--help")
            show_help
            ;;
        *)
            log_error "Unknown command: $1"
            show_help
            exit 1
            ;;
    esac
}

# Run main function with all arguments
main "$@"

