#!/bin/bash
# MCP Components Backup Script
# Purpose: Backup all MCP-related configuration and rules
# Usage: ./backup_mcp_components.sh

set -e

# Configuration
BACKUP_DIR="/Users/a805120/develop/cursor-dev-environment-backups"
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
MCP_BACKUP_DIR="$BACKUP_DIR/mcp_servers"

echo "🔄 Starting MCP Components Backup - $TIMESTAMP"

# Create backup directories
mkdir -p "$MCP_BACKUP_DIR/rules"
mkdir -p "$MCP_BACKUP_DIR/state"
mkdir -p "$BACKUP_DIR/instructions"

# Backup core MCP configuration
echo "📋 Backing up MCP configuration..."
if [ -f ~/.cursor/mcp.json ]; then
    cp ~/.cursor/mcp.json "$MCP_BACKUP_DIR/mcp.json"
    echo "✅ MCP config backed up"
else
    echo "⚠️  MCP config not found at ~/.cursor/mcp.json"
fi

# Backup guardrail rules
echo "🛡️  Backing up guardrail rules..."
if [ -d ~/.mcp/rules ]; then
    cp -r ~/.mcp/rules/* "$MCP_BACKUP_DIR/rules/" 2>/dev/null || true
    echo "✅ Guardrail rules backed up"
else
    echo "⚠️  Guardrail rules directory not found"
fi

# Backup command-line tooling instructions
echo "📚 Backing up command-line tooling instructions..."
if [ -d "/Users/a805120/develop/workflows/.cursor/instructions/command-line-tooling" ]; then
    cp -r "/Users/a805120/develop/workflows/.cursor/instructions/command-line-tooling"/* "$BACKUP_DIR/instructions/" 2>/dev/null || true
    echo "✅ Command-line tooling instructions backed up"
else
    echo "⚠️  Command-line tooling instructions not found"
fi

# Backup MCP state directories (optional)
echo "💾 Backing up MCP state directories..."
if [ -d ~/.mcp ]; then
    tar -czf "$MCP_BACKUP_DIR/state/mcp_state_$TIMESTAMP.tar.gz" -C ~ .mcp 2>/dev/null || true
    echo "✅ MCP state directories backed up"
else
    echo "⚠️  MCP state directory not found"
fi

# Backup MCP source code (if exists)
echo "🔧 Backing up MCP source code..."
if [ -d ~/.mcp-src ]; then
    tar -czf "$MCP_BACKUP_DIR/mcp_sources_$TIMESTAMP.tar.gz" -C ~ .mcp-src 2>/dev/null || true
    echo "✅ MCP source code backed up"
else
    echo "ℹ️  MCP source code directory not found (using npm packages)"
fi

# Create backup manifest
echo "📝 Creating backup manifest..."
cat > "$MCP_BACKUP_DIR/backup_manifest_$TIMESTAMP.yaml" << EOF
backup_timestamp: $TIMESTAMP
backup_location: $MCP_BACKUP_DIR
components_backed_up:
  - mcp_config: $(test -f "$MCP_BACKUP_DIR/mcp.json" && echo "✅" || echo "❌")
  - guardrail_rules: $(test -d "$MCP_BACKUP_DIR/rules" && echo "✅" || echo "❌")
  - cli_instructions: $(test -d "$BACKUP_DIR/instructions" && echo "✅" || echo "❌")
  - mcp_state: $(test -f "$MCP_BACKUP_DIR/state/mcp_state_$TIMESTAMP.tar.gz" && echo "✅" || echo "❌")
  - mcp_sources: $(test -f "$MCP_BACKUP_DIR/mcp_sources_$TIMESTAMP.tar.gz" && echo "✅" || echo "❌")

active_mcp_servers:
  - chrome-devtools
  - macos-automator
  - custom-macos-automator
  - fastmcp
  - vscode-mcp-server
  - make-mcp-server
  - youtube-transcript
  - mermaid
  - augments
  - serena
  - awslabs.ccapi-mcp-server
  - terraform-mcp-server
  - mcp-pandoc
  - MCP Memory Keeper
  - MCP Chat History Recorder
  - MCP Guardrail
  - Exa Search
  - github-grep
  - grep-mcp

guardrail_rules:
  - cli-knowledge-leverage.json

restoration_notes:
  - Copy mcp.json to ~/.cursor/
  - Copy rules to ~/.mcp/rules/
  - Copy instructions to workflows/.cursor/instructions/
  - Restart Cursor to reload configuration
EOF

echo "✅ Backup manifest created"

# Summary
echo ""
echo "🎉 MCP Components Backup Complete!"
echo "📁 Backup location: $MCP_BACKUP_DIR"
echo "📋 Manifest: backup_manifest_$TIMESTAMP.yaml"
echo ""
echo "To restore:"
echo "1. Copy mcp.json to ~/.cursor/"
echo "2. Copy rules to ~/.mcp/rules/"
echo "3. Copy instructions to workflows project"
echo "4. Restart Cursor"






