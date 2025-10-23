#!/bin/bash
# =============================================================================
# Cursor IDE Setup Script
# =============================================================================
# This script configures Cursor IDE settings, keybindings, and tasks
# It follows the established app setup pattern for consistency

set -euo pipefail

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Logging functions
log() {
    echo -e "${BLUE}[CURSOR-SETUP]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[CURSOR-SETUP]${NC} ✅ $1"
}

log_warning() {
    echo -e "${YELLOW}[CURSOR-SETUP]${NC} ⚠️  $1"
}

log_error() {
    echo -e "${RED}[CURSOR-SETUP]${NC} ❌ $1"
}

# Check if Cursor is installed
check_cursor_installation() {
    log "Checking Cursor IDE installation..."

    local cursor_paths=(
        "/Applications/Cursor.app"
        "/usr/local/bin/cursor"
        "$(which cursor 2>/dev/null)"
    )

    local cursor_found=false
    for path in "${cursor_paths[@]}"; do
        if [[ -n "$path" && -e "$path" ]]; then
            log_success "Cursor IDE found at: $path"
            cursor_found=true
            break
        fi
    done

    if [[ "$cursor_found" == "false" ]]; then
        log_warning "Cursor IDE not found. Please install Cursor IDE first."
        log "Download from: https://cursor.sh/"
        return 1
    fi

    return 0
}

# Setup Cursor settings
setup_cursor_settings() {
    log "Setting up Cursor IDE settings..."

    local cursor_user_dir="$HOME/Library/Application Support/Cursor/User"
    local settings_file="$cursor_user_dir/settings.json"
    local keybindings_file="$cursor_user_dir/keybindings.json"

    # Create Cursor User directory
    mkdir -p "$cursor_user_dir"

    # Backup existing files
    if [[ -f "$settings_file" ]]; then
        cp "$settings_file" "${settings_file}.backup.$(date +%Y%m%d_%H%M%S)"
        log "Backed up existing settings: ${settings_file}.backup.$(date +%Y%m%d_%H%M%S)"
    fi

    if [[ -f "$keybindings_file" ]]; then
        cp "$keybindings_file" "${keybindings_file}.backup.$(date +%Y%m%d_%H%M%S)"
        log "Backed up existing keybindings: ${keybindings_file}.backup.$(date +%Y%m%d_%H%M%S)"
    fi

    # Install settings
    local script_dir="$(dirname "$0")"
    if [[ -f "$script_dir/settings.json" ]]; then
        cp "$script_dir/settings.json" "$settings_file"
        log_success "Cursor settings installed: $settings_file"
    else
        log_error "Settings template not found: $script_dir/settings.json"
        return 1
    fi

    if [[ -f "$script_dir/keybindings.json" ]]; then
        cp "$script_dir/keybindings.json" "$keybindings_file"
        log_success "Cursor keybindings installed: $keybindings_file"
    else
        log_error "Keybindings template not found: $script_dir/keybindings.json"
        return 1
    fi
}

# Setup Terraform-specific settings
setup_terraform_settings() {
    log "Setting up Terraform-specific settings..."

    local script_dir="$(dirname "$0")"
    local terraform_settings="$script_dir/terraform-settings.json"

    if [[ -f "$terraform_settings" ]]; then
        log_success "Terraform settings template available: $terraform_settings"
        log "Note: Terraform settings should be applied per-workspace or globally as needed"
    else
        log_warning "Terraform settings template not found: $terraform_settings"
    fi
}

# Setup tasks
setup_tasks() {
    log "Setting up Cursor tasks..."

    local script_dir="$(dirname "$0")"
    local tasks_file="$script_dir/terraform-tasks.json"

    if [[ -f "$tasks_file" ]]; then
        log_success "Terraform tasks template available: $tasks_file"
        log "Note: Tasks should be added to workspace .vscode/tasks.json or global tasks"
    else
        log_warning "Tasks template not found: $tasks_file"
    fi
}

# Create workspace configuration
create_workspace_config() {
    log "Creating workspace configuration..."

    local workspace_dir=".vscode"
    local tasks_file="$workspace_dir/tasks.json"
    local settings_file="$workspace_dir/settings.json"

    # Create .vscode directory
    mkdir -p "$workspace_dir"

    # Copy tasks if they don't exist
    if [[ ! -f "$tasks_file" ]]; then
        local script_dir="$(dirname "$0")"
        if [[ -f "$script_dir/terraform-tasks.json" ]]; then
            cp "$script_dir/terraform-tasks.json" "$tasks_file"
            log_success "Workspace tasks created: $tasks_file"
        fi
    else
        log_warning "Workspace tasks already exist: $tasks_file"
    fi

    # Copy terraform settings if they don't exist
    if [[ ! -f "$settings_file" ]]; then
        local script_dir="$(dirname "$0")"
        if [[ -f "$script_dir/terraform-settings.json" ]]; then
            cp "$script_dir/terraform-settings.json" "$settings_file"
            log_success "Workspace settings created: $settings_file"
        fi
    else
        log_warning "Workspace settings already exist: $settings_file"
    fi
}

# Test Cursor functionality
test_cursor() {
    log "Testing Cursor IDE functionality..."

    # Check if Cursor can be launched
    if command -v cursor >/dev/null 2>&1; then
        log_success "Cursor CLI is available"
    else
        log_warning "Cursor CLI not found in PATH"
    fi

    # Check if settings files exist
    local cursor_user_dir="$HOME/Library/Application Support/Cursor/User"
    if [[ -f "$cursor_user_dir/settings.json" ]]; then
        log_success "Cursor settings file exists"
    else
        log_error "Cursor settings file missing"
        return 1
    fi

    if [[ -f "$cursor_user_dir/keybindings.json" ]]; then
        log_success "Cursor keybindings file exists"
    else
        log_error "Cursor keybindings file missing"
        return 1
    fi
}

# Show configuration summary
show_configuration_summary() {
    echo ""
    echo "🎯 Cursor IDE Configuration Summary"
    echo "=================================="
    echo ""
    echo "📁 Global Configuration:"
    echo "  Settings: ~/Library/Application Support/Cursor/User/settings.json"
    echo "  Keybindings: ~/Library/Application Support/Cursor/User/keybindings.json"
    echo ""
    echo "🔧 Key Features Enabled:"
    echo "  ✅ Terminal integration with bash"
    echo "  ✅ Code intelligence and suggestions"
    echo "  ✅ AI-powered inline suggestions"
    echo "  ✅ Git integration and auto-fetch"
    echo "  ✅ Custom keyboard shortcuts"
    echo "  ✅ Terraform support and tasks"
    echo ""
    echo "⌨️  Custom Keyboard Shortcuts:"
    echo "  Cmd+Enter: Send selected text to terminal"
    echo "  Cmd+Shift+Enter: Send selected text to terminal (new line)"
    echo "  Shift+Cmd+\\: Run selected text in terminal"
    echo ""
    echo "🔄 Next Steps:"
    echo "  1. Restart Cursor IDE to apply all settings"
    echo "  2. Open a Terraform project to test tasks"
    echo "  3. Test keyboard shortcuts in the editor"
    echo ""
}

# Main setup function
setup_cursor() {
    log "Starting Cursor IDE setup..."

    # Check if Cursor is installed
    if ! check_cursor_installation; then
        log_warning "Continuing with configuration setup despite Cursor not being found"
    fi

    # Setup Cursor settings
    setup_cursor_settings

    # Setup Terraform settings
    setup_terraform_settings

    # Setup tasks
    setup_tasks

    # Create workspace configuration
    create_workspace_config

    # Test functionality
    test_cursor

    # Show configuration summary
    show_configuration_summary

    log_success "Cursor IDE setup completed successfully!"
}

# Show help
show_help() {
    echo "Cursor IDE Setup Script"
    echo "======================="
    echo ""
    echo "Usage: $0 [OPTIONS]"
    echo ""
    echo "Options:"
    echo "  setup                 Set up Cursor IDE configuration"
    echo "  test                  Test Cursor functionality"
    echo "  help                  Show this help message"
    echo ""
    echo "Configuration Files:"
    echo "  settings.json         # Cursor IDE main settings"
    echo "  keybindings.json      # Custom keyboard shortcuts"
    echo "  terraform-settings.json  # Terraform-specific settings"
    echo "  terraform-tasks.json     # Terraform tasks and commands"
    echo ""
    echo "Examples:"
    echo "  $0 setup              # Set up Cursor IDE configuration"
    echo "  $0 test               # Test Cursor functionality"
}

# Main script logic
main() {
    case "${1:-setup}" in
        "setup")
            setup_cursor
            ;;
        "test")
            test_cursor
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
