# Cursor IDE Complete Backup Package

**Backup Date:** $(date)  
**Repository Location:** `/Users/a805120/develop/oneoffs/cursor-dev-environment-backups/`  
**GitHub Repository:** https://github.com/doesitscript/cursor-dev-environment-backups

This backup package contains all Cursor IDE configurations, MCP servers, tasks, instructions, and workspace settings that are not typically captured in repository backups.

## 📁 Package Contents

### 1. Cursor Configuration (`cursor_config/`)
- **Settings & Keybindings**: Complete Cursor IDE user settings and custom keybindings
- **Setup Scripts**: Automated installation and configuration scripts
- **Terraform Integration**: Terraform-specific Cursor settings and configurations
- **Backup Scripts**: Scripts for backing up and restoring Cursor settings

**Key Files:**
- `settings.json` - Main Cursor IDE settings
- `keybindings.json` - Custom keyboard shortcuts
- `terraform-settings.json` - Terraform-specific configurations
- `terraform-tasks.json` - Terraform task definitions
- `backup_cursor_settings.sh` - Backup automation script
- `setup_cursor.sh` - Installation script

### 2. MCP Servers (`mcp_servers/`)
- **MCP Configuration**: Complete Model Context Protocol server configuration
- **Server Definitions**: All configured MCP servers with their settings

**Key Files:**
- `mcp.json` - Main MCP server configuration with 15+ servers including:
  - AWS Labs CCAPI MCP Server
  - Terraform MCP Server
  - Chrome DevTools MCP
  - GitHub Grep MCP
  - YouTube Transcript MCP
  - Mermaid MCP
  - And many more...

### 3. Tasks (`tasks/`)
- **Terraform Tasks**: Pre-configured Terraform workflow tasks
- **Custom Tasks**: Project-specific task definitions

**Key Files:**
- `terraform-tasks.json` - Complete Terraform task suite including:
  - Init, Validate, Plan, Apply
  - Format, TFLint, Checkov security scans
  - MCP integration tasks

### 4. Instructions (`instructions/`)
- **MCP Guides**: Comprehensive guides for using MCP servers
- **AWS Instructions**: AWS-specific MCP server instructions
- **Terraform Instructions**: Terraform MCP server usage guides
- **SDLC Instructions**: Software development lifecycle instructions

**Key Files:**
- `MCP_GUIDE.md` - Master guide for MCP server techniques
- `mcp_aws_server_instructions.yaml` - AWS MCP server instructions
- `mcp_terraform_server_instructions.yaml` - Terraform MCP instructions
- `sdlc_base_instructions.md` - SDLC workflow instructions

### 5. Workspaces (`workspaces/`)
- **Multi-Project Workspaces**: VS Code/Cursor workspace configurations
- **Project Settings**: Project-specific settings and extensions

**Key Files:**
- `workflows.code-workspace` - Main workflows project workspace
- `awsdir.code-workspace` - AWS directory project workspace
- `cast-ec2.code-workspace` - Cast EC2 project workspace

### 6. Scripts (`scripts/`)
- **Setup Scripts**: Automated setup and configuration scripts
- **Utility Scripts**: Helper scripts for Cursor functionality

**Key Files:**
- `enable_cursor_features.sh` - Enable Cursor-specific features
- `setup_serena_mcp.sh` - Serena MCP server setup

## 🔧 Restoration Instructions

### Quick Restore
```bash
# Navigate to backup directory
cd /Users/a805120/develop/oneoffs/cursor_backup_20251023_051106/

# Restore Cursor settings
./cursor_config/backup_cursor_settings.sh

# Restore MCP configuration
cp mcp_servers/mcp.json ~/.cursor/mcp.json

# Restore workspace files
cp workspaces/*.code-workspace /path/to/your/projects/
```

### Detailed Restoration

1. **Cursor Settings**:
   ```bash
   cp cursor_config/config/settings.json ~/Library/Application\ Support/Cursor/User/
   cp cursor_config/config/keybindings.json ~/Library/Application\ Support/Cursor/User/
   ```

2. **MCP Servers**:
   ```bash
   cp mcp_servers/mcp.json ~/.cursor/
   ```

3. **Workspace Files**:
   ```bash
   cp workspaces/*.code-workspace /path/to/your/projects/
   ```

4. **Tasks**:
   ```bash
   cp tasks/terraform-tasks.json .vscode/tasks.json
   ```

## 🚀 Features Included

### Cursor IDE Enhancements
- ✅ Custom keybindings for terminal integration
- ✅ Terraform-specific settings and formatting
- ✅ Python development configuration
- ✅ Git integration settings
- ✅ Editor enhancements (minimap, breadcrumbs, etc.)

### MCP Server Ecosystem
- ✅ **15+ MCP Servers** configured and ready
- ✅ AWS Labs CCAPI integration
- ✅ Terraform MCP server
- ✅ Chrome DevTools automation
- ✅ GitHub code search
- ✅ YouTube transcript processing
- ✅ Mermaid diagram generation
- ✅ And many more...

### Task Automation
- ✅ Complete Terraform workflow tasks
- ✅ Security scanning with Checkov
- ✅ Code formatting and linting
- ✅ MCP integration tasks

### Instruction Library
- ✅ Comprehensive MCP usage guides
- ✅ AWS-specific techniques
- ✅ Terraform best practices
- ✅ SDLC workflow instructions

## 📋 System Requirements

- **macOS** (tested on macOS 14.6.0)
- **Cursor IDE** (latest version)
- **Node.js** (for MCP servers)
- **Python 3** (for some MCP servers)
- **Terraform** (for Terraform tasks)
- **Homebrew** (for package management)

## 🔄 Maintenance

This backup can be updated by running the backup scripts in the `cursor_config/` directory:

```bash
./cursor_config/backup_cursor_settings.sh
```

## 📝 Notes

- This backup follows the established workflows project app setup pattern
- All configurations are tested and working in the current environment
- MCP servers include both npm packages and custom implementations
- Workspace files are configured for multi-project development
- Instructions include both basic and advanced usage patterns

## 🆘 Support

For issues with restoration or configuration:
1. Check the individual README files in each subdirectory
2. Review the instruction files for usage guidance
3. Ensure all dependencies are installed
4. Verify file paths match your system configuration

---

**Backup completed successfully!** 🎉
