# MCP Components Backup Manifest
# Generated: 2025-01-27
# Purpose: Track all MCP-related components for backup and restoration

## Core MCP Configuration Files
- **Primary Config**: `~/.cursor/mcp.json` - Main MCP server configuration
- **Backup Location**: `cursor-dev-environment-backups/mcp_servers/mcp.json`

## Guardrail Rules Directory
- **Source**: `~/.mcp/rules/` - Guardrail rule files
- **Backup Location**: `cursor-dev-environment-backups/mcp_servers/rules/`
- **Current Rules**:
  - `cli-knowledge-leverage.json` - CLI tooling enforcement rule

## MCP State Directories
- **Memory Keeper State**: `~/.mcp/keeper/` - Session/workspace continuity data
- **Chat Logs**: `~/.mcp/chat-logs/` - Chat history recordings
- **Rule Logs**: `~/.mcp/rule-logs/` - Guardrail enforcement logs
- **Memory**: `~/.mcp/memory/` - General memory storage

## MCP Server Source Code
- **Memory Keeper**: `~/.mcp-src/mcp-memory-keeper/` - Local clone
- **Guardrail**: `~/.mcp-src/mcp-guard/` - Local clone  
- **Chat Recorder**: `~/.mcp-src/chat-history-recorder-mcp/` - Local clone
- **Python Environment**: `~/.mcp-venv/chatrec/` - Virtual environment

## Workflow Integration Files
- **Command Line Tooling**: `workflows/.cursor/instructions/command-line-tooling/`
  - `process-management.md` - Process management patterns
  - `find-grep-patterns.md` - Search patterns
  - `troubleshooting-log.md` - Common issues and solutions
  - `README.md` - Master reference

## Backup Script Requirements

### Files to Copy
```bash
# Core MCP config
cp ~/.cursor/mcp.json cursor-dev-environment-backups/mcp_servers/

# Guardrail rules
cp -r ~/.mcp/rules/* cursor-dev-environment-backups/mcp_servers/rules/

# Command line tooling instructions
cp -r workflows/.cursor/instructions/command-line-tooling/* cursor-dev-environment-backups/instructions/
```

### Directories to Archive
```bash
# MCP state directories (optional - contains runtime data)
tar -czf mcp_state_backup.tar.gz ~/.mcp/

# MCP source code (if custom modifications exist)
tar -czf mcp_sources_backup.tar.gz ~/.mcp-src/
```

## Restoration Process
1. **Restore MCP Config**: Copy `mcp.json` to `~/.cursor/`
2. **Restore Guardrail Rules**: Copy rules to `~/.mcp/rules/`
3. **Restore Instructions**: Copy command-line-tooling to workflows project
4. **Restart Cursor**: Reload MCP configuration

## Current Active Components
- ✅ **MCP Guardrail**: Enabled - Enforces CLI knowledge leverage
- ✅ **MCP Memory Keeper**: Enabled - Session continuity
- ❌ **MCP Chat History Recorder**: Disabled - Chat logging
- ✅ **Chrome DevTools**: Enabled - Browser automation
- ✅ **VS Code MCP**: Enabled - Editor integration
- ✅ **AWS Labs CCAPI**: Enabled - AWS operations
- ✅ **Terraform MCP**: Enabled - Infrastructure management

## Dependencies
- **Node.js**: Required for most MCP servers
- **Python**: Required for some servers (augments, chat recorder)
- **Chrome**: Required for Chrome DevTools MCP
- **AWS CLI**: Required for AWS operations

## Last Updated
2025-01-27 - Added guardrail configuration and CLI knowledge leverage rule






