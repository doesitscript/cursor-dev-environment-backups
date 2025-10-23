#!/bin/bash
# =============================================================================
# Cursor Settings Backup Script
# =============================================================================
# This script backs up current Cursor settings to the workflows project
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
    echo -e "${BLUE}[CURSOR-BACKUP]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[CURSOR-BACKUP]${NC} ✅ $1"
}

log_warning() {
    echo -e "${YELLOW}[CURSOR-BACKUP]${NC} ⚠️  $1"
}

log_error() {
    echo -e "${RED}[CURSOR-BACKUP]${NC} ❌ $1"
}

# Get script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../../.." && pwd)"

# Cursor settings locations
CURSOR_USER_DIR="$HOME/Library/Application Support/Cursor/User"
CURSOR_CONFIG_DIR="$SCRIPT_DIR/config"

# Create config directory if it doesn't exist
mkdir -p "$CURSOR_CONFIG_DIR"

# Generate timestamp for backup
TIMESTAMP=$(date +%Y%m%d_%H%M%S)

# Backup main settings files
backup_main_settings() {
    log "Backing up main Cursor settings..."

    # Backup settings.json
    if [[ -f "$CURSOR_USER_DIR/settings.json" ]]; then
        cp "$CURSOR_USER_DIR/settings.json" "$CURSOR_CONFIG_DIR/settings.json"
        log_success "Backed up settings.json"
    else
        log_warning "settings.json not found at $CURSOR_USER_DIR/settings.json"
    fi

    # Backup keybindings.json
    if [[ -f "$CURSOR_USER_DIR/keybindings.json" ]]; then
        cp "$CURSOR_USER_DIR/keybindings.json" "$CURSOR_CONFIG_DIR/keybindings.json"
        log_success "Backed up keybindings.json"
    else
        log_warning "keybindings.json not found at $CURSOR_USER_DIR/keybindings.json"
    fi
}

# Backup workspace settings
backup_workspace_settings() {
    log "Backing up workspace settings..."

    local workspace_storage_dir="$CURSOR_USER_DIR/workspaceStorage"
    local workspace_backup_dir="$CURSOR_CONFIG_DIR/workspace_backups"

    if [[ -d "$workspace_storage_dir" ]]; then
        mkdir -p "$workspace_backup_dir"

        # Find and backup workspace.json files
        local workspace_count=0
        while IFS= read -r -d '' workspace_file; do
            local workspace_id=$(basename "$(dirname "$workspace_file")")
            local backup_file="$workspace_backup_dir/workspace_${workspace_id}_${TIMESTAMP}.json"
            cp "$workspace_file" "$backup_file"
            ((workspace_count++))
        done < <(find "$workspace_storage_dir" -name "workspace.json" -print0)

        if [[ $workspace_count -gt 0 ]]; then
            log_success "Backed up $workspace_count workspace settings"
        else
            log_warning "No workspace settings found"
        fi
    else
        log_warning "Workspace storage directory not found: $workspace_storage_dir"
    fi
}

# Create backup manifest
create_backup_manifest() {
    log "Creating backup manifest..."

    local manifest_file="$CURSOR_CONFIG_DIR/backup_manifest_${TIMESTAMP}.yaml"

    cat > "$manifest_file" << EOF
# Cursor Settings Backup Manifest
# Generated: $(date -u +"%Y-%m-%dT%H:%M:%SZ")

backup_info:
  timestamp: "$TIMESTAMP"
  backup_date: "$(date)"
  cursor_version: "$(cursor --version 2>/dev/null || echo 'Unknown')"
  system: "$(uname -s)"
  architecture: "$(uname -m)"

backed_up_files:
  main_settings:
    - "settings.json"
    - "keybindings.json"
  workspace_settings:
    count: $(find "$CURSOR_CONFIG_DIR/workspace_backups" -name "workspace_*_${TIMESTAMP}.json" 2>/dev/null | wc -l | tr -d ' ')
    location: "workspace_backups/"

source_locations:
  cursor_user_dir: "$CURSOR_USER_DIR"
  settings_file: "$CURSOR_USER_DIR/settings.json"
  keybindings_file: "$CURSOR_USER_DIR/keybindings.json"
  workspace_storage: "$CURSOR_USER_DIR/workspaceStorage"

backup_locations:
  config_dir: "$CURSOR_CONFIG_DIR"
  main_settings: "$CURSOR_CONFIG_DIR/"
  workspace_backups: "$CURSOR_CONFIG_DIR/workspace_backups/"

restore_instructions:
  main_settings:
    - "Copy settings.json to ~/Library/Application Support/Cursor/User/"
    - "Copy keybindings.json to ~/Library/Application Support/Cursor/User/"
    - "Restart Cursor IDE"
  workspace_settings:
    - "Copy workspace_*.json files to appropriate workspaceStorage subdirectories"
    - "Restart Cursor IDE"

notes:
  - "This backup follows the workflows project app setup pattern"
  - "Files are organized in scripts/setup/cursor/config/"
  - "Workspace settings are backed up with timestamps for version control"
EOF

    log_success "Created backup manifest: $manifest_file"
}

# Show backup summary
show_backup_summary() {
    echo ""
    echo "🎯 Cursor Settings Backup Summary"
    echo "================================="
    echo ""
    echo "📁 Backup Location: $CURSOR_CONFIG_DIR"
    echo "⏰ Backup Timestamp: $TIMESTAMP"
    echo ""
    echo "📋 Backed Up Files:"
    echo "  ✅ settings.json"
    echo "  ✅ keybindings.json"
    echo "  ✅ Workspace settings (if found)"
    echo "  ✅ Backup manifest"
    echo ""
    echo "🔄 Next Steps:"
    echo "  1. Review backed up files in: $CURSOR_CONFIG_DIR"
    echo "  2. Commit changes to git for version control"
    echo "  3. Use restore script if needed to restore settings"
    echo ""
}

# Main backup function
backup_cursor_settings() {
    log "Starting Cursor settings backup..."

    # Check if Cursor user directory exists
    if [[ ! -d "$CURSOR_USER_DIR" ]]; then
        log_error "Cursor user directory not found: $CURSOR_USER_DIR"
        log "Please ensure Cursor IDE is installed and has been run at least once"
        return 1
    fi

    # Create config directory
    mkdir -p "$CURSOR_CONFIG_DIR"

    # Backup main settings
    backup_main_settings

    # Backup workspace settings
    backup_workspace_settings

    # Create backup manifest
    create_backup_manifest

    # Show summary
    show_backup_summary

    log_success "Cursor settings backup completed successfully!"
}

# Show help
show_help() {
    echo "Cursor Settings Backup Script"
    echo "============================="
    echo ""
    echo "Usage: $0 [OPTIONS]"
    echo ""
    echo "Options:"
    echo "  backup                 Backup current Cursor settings (default)"
    echo "  help                   Show this help message"
    echo ""
    echo "This script backs up Cursor IDE settings to the workflows project"
    echo "following the established app setup pattern in scripts/setup/cursor/"
    echo ""
    echo "Backup includes:"
    echo "  - Main settings (settings.json, keybindings.json)"
    echo "  - Workspace-specific settings"
    echo "  - Backup manifest with metadata"
    echo ""
}

# Main script logic
main() {
    case "${1:-backup}" in
        "backup")
            backup_cursor_settings
            ;;
        "help"|"-h"|"--help")
            show_help
            ;;
        *)
            log_error "Unknown option: $1"
            show_help
            exit 1
            ;;
    esac
}

# Run main function with all arguments
main "$@"

