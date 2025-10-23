#!/bin/bash
# =============================================================================
# Cursor IDE Configuration Install Script
# =============================================================================
# This script installs backed-up Cursor IDE configurations to their correct locations
# It follows the same pattern as the fzf and copilot setup for consistency

set -euo pipefail

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Logging functions
log() {
    echo -e "${BLUE}[CURSOR-INSTALL]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[CURSOR-INSTALL]${NC} ✅ $1"
}

log_warning() {
    echo -e "${YELLOW}[CURSOR-INSTALL]${NC} ⚠️  $1"
}

log_error() {
    echo -e "${RED}[CURSOR-INSTALL]${NC} ❌ $1"
}

# Show installation manifest
show_manifest() {
    echo "Cursor IDE Configuration Installation Manifest"
    echo "============================================="
    echo ""
    echo "Configuration Files:"
    echo "  📁 Source Directory: $SCRIPT_DIR"
    echo ""
    echo "  📄 settings.json"
    echo "     → $HOME/Library/Application Support/Cursor/User/settings.json"
    echo "     → Cursor IDE main settings and preferences"
    echo ""
    echo "  📄 keybindings.json"
    echo "     → $HOME/Library/Application Support/Cursor/User/keybindings.json"
    echo "     → Custom keyboard shortcuts and keybindings"
    echo ""
    echo "  📄 terraform-settings.json"
    echo "     → Project-specific Terraform settings (per-workspace)"
    echo "     → Terraform language server and validation settings"
    echo ""
    echo "  📄 terraform-tasks.json"
    echo "     → Project-specific Terraform tasks (per-workspace)"
    echo "     → Terraform init, plan, apply, validate tasks"
    echo ""
    echo "Workspace Integration:"
    echo "  🔧 Global settings: Applied to all Cursor workspaces"
    echo "  🔧 Global keybindings: Available in all Cursor workspaces"
    echo "  🔧 Terraform settings: Should be applied per-workspace"
    echo "  🔧 Terraform tasks: Should be added to .vscode/tasks.json"
    echo ""
}

# Install Cursor settings
install_cursor_settings() {
    log "Installing Cursor IDE settings..."

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
    if [[ -f "$SCRIPT_DIR/settings.json" ]]; then
        cp "$SCRIPT_DIR/settings.json" "$settings_file"
        log_success "Cursor settings installed: $settings_file"
    else
        log_error "Settings template not found: $SCRIPT_DIR/settings.json"
        return 1
    fi

    # Install keybindings
    if [[ -f "$SCRIPT_DIR/keybindings.json" ]]; then
        cp "$SCRIPT_DIR/keybindings.json" "$keybindings_file"
        log_success "Cursor keybindings installed: $keybindings_file"
    else
        log_error "Keybindings template not found: $SCRIPT_DIR/keybindings.json"
        return 1
    fi
}

# Install workspace configuration
install_workspace_config() {
    local workspace_path="${1:-.}"

    log "Installing workspace configuration to: $workspace_path"

    local workspace_dir="$workspace_path/.vscode"
    local tasks_file="$workspace_dir/tasks.json"
    local settings_file="$workspace_dir/settings.json"

    # Create .vscode directory
    mkdir -p "$workspace_dir"

    # Install tasks
    if [[ -f "$SCRIPT_DIR/terraform-tasks.json" ]]; then
        cp "$SCRIPT_DIR/terraform-tasks.json" "$tasks_file"
        log_success "Workspace tasks installed: $tasks_file"
    else
        log_error "Tasks template not found: $SCRIPT_DIR/terraform-tasks.json"
        return 1
    fi

    # Install terraform settings
    if [[ -f "$SCRIPT_DIR/terraform-settings.json" ]]; then
        cp "$SCRIPT_DIR/terraform-settings.json" "$settings_file"
        log_success "Workspace settings installed: $settings_file"
    else
        log_error "Terraform settings template not found: $SCRIPT_DIR/terraform-settings.json"
        return 1
    fi
}

# Verify installation
verify_installation() {
    log "Verifying Cursor IDE installation..."

    local all_good=true
    local cursor_user_dir="$HOME/Library/Application Support/Cursor/User"

    # Check global settings
    if [[ -f "$cursor_user_dir/settings.json" ]]; then
        log_success "Global settings: $cursor_user_dir/settings.json"
    else
        log_error "Global settings missing: $cursor_user_dir/settings.json"
        all_good=false
    fi

    # Check global keybindings
    if [[ -f "$cursor_user_dir/keybindings.json" ]]; then
        log_success "Global keybindings: $cursor_user_dir/keybindings.json"
    else
        log_error "Global keybindings missing: $cursor_user_dir/keybindings.json"
        all_good=false
    fi

    # Check workspace configuration
    if [[ -f ".vscode/tasks.json" ]]; then
        log_success "Workspace tasks: .vscode/tasks.json"
    else
        log_warning "Workspace tasks not found: .vscode/tasks.json"
    fi

    if [[ -f ".vscode/settings.json" ]]; then
        log_success "Workspace settings: .vscode/settings.json"
    else
        log_warning "Workspace settings not found: .vscode/settings.json"
    fi

    if [[ "$all_good" == "true" ]]; then
        log_success "All Cursor IDE configurations verified successfully!"
    else
        log_error "Some Cursor IDE configurations failed verification"
        return 1
    fi
}

# Test functionality
test_functionality() {
    log "Testing Cursor IDE functionality..."

    # Check if Cursor can be launched
    if command -v cursor >/dev/null 2>&1; then
        log_success "Cursor CLI is available"
    else
        log_warning "Cursor CLI not found - install Cursor IDE from https://cursor.sh/"
    fi

    # Check if settings files are valid JSON
    local cursor_user_dir="$HOME/Library/Application Support/Cursor/User"

    if [[ -f "$cursor_user_dir/settings.json" ]]; then
        if python3 -m json.tool "$cursor_user_dir/settings.json" >/dev/null 2>&1; then
            log_success "Settings JSON is valid"
        else
            log_error "Settings JSON is invalid"
            return 1
        fi
    fi

    if [[ -f "$cursor_user_dir/keybindings.json" ]]; then
        if python3 -m json.tool "$cursor_user_dir/keybindings.json" >/dev/null 2>&1; then
            log_success "Keybindings JSON is valid"
        else
            log_error "Keybindings JSON is invalid"
            return 1
        fi
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

# Main installation function
install_cursor_configs() {
    local workspace_path="${1:-.}"

    log "Starting Cursor IDE configuration installation..."

    # Show manifest
    show_manifest

    # Install global settings
    install_cursor_settings

    # Install workspace configuration
    install_workspace_config "$workspace_path"

    # Verify installation
    verify_installation

    # Test functionality
    test_functionality

    # Show configuration summary
    show_configuration_summary

    log_success "Cursor IDE configuration installation completed!"
}

# Show help
show_help() {
    echo "Cursor IDE Configuration Install Script"
    echo "======================================"
    echo ""
    echo "Usage: $0 [OPTIONS] [WORKSPACE_PATH]"
    echo ""
    echo "Options:"
    echo "  install [PATH]        Install Cursor configurations"
    echo "  verify                Verify installation"
    echo "  test                  Test functionality"
    echo "  manifest              Show installation manifest"
    echo "  help                  Show this help message"
    echo ""
    echo "Arguments:"
    echo "  WORKSPACE_PATH        Workspace directory (default: current directory)"
    echo ""
    echo "Examples:"
    echo "  $0 install                    # Install to current directory"
    echo "  $0 install /path/to/project  # Install to specific workspace"
    echo "  $0 verify                     # Verify installation"
    echo "  $0 test                       # Test functionality"
    echo "  $0 manifest                   # Show installation manifest"
}

# Main script logic
main() {
    case "${1:-install}" in
        "install")
            install_cursor_configs "${2:-.}"
            ;;
        "verify")
            verify_installation
            ;;
        "test")
            test_functionality
            ;;
        "manifest")
            show_manifest
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
