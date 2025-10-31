# Cursor Development Environment Backup Management
# Orchestrates backup and restore operations for Cursor configs and MCP components

.PHONY: help backup-cursor restore-cursor backup-mcp list-backups verify-backups clean status

# Default target
.DEFAULT_GOAL := help

# Color definitions
CYAN := \033[0;36m
GREEN := \033[0;32m
YELLOW := \033[1;33m
RESET := \033[0m

#===============================================================================
# MAIN TARGETS
#===============================================================================

## help: Display this help message
help:
	@echo "$(CYAN)Cursor Dev Environment Backup Management$(RESET)"
	@echo ""
	@echo "$(GREEN)Available targets:$(RESET)"
	@sed -n 's/^## //p' $(MAKEFILE_LIST) | column -t -s ':' | sed -e 's/^/  /'
	@echo ""

## backup-cursor: Backup Cursor settings and configurations
backup-cursor:
	@echo "$(CYAN)=== Backing up Cursor configurations ===$(RESET)"
	@bash cursor_config/backup_cursor_settings.sh
	@echo "$(GREEN)✓ Cursor backup complete$(RESET)"

## restore-cursor: Restore Cursor settings from backup
restore-cursor:
	@echo "$(CYAN)=== Restoring Cursor configurations ===$(RESET)"
	@bash cursor_config/restore_cursor_settings.sh
	@echo "$(GREEN)✓ Cursor restore complete$(RESET)"

## backup-mcp: Backup MCP components and configurations
backup-mcp:
	@echo "$(CYAN)=== Backing up MCP components ===$(RESET)"
	@bash scripts/backup_mcp_components.sh
	@echo "$(GREEN)✓ MCP backup complete$(RESET)"

## backup-all: Run all backup operations
backup-all: backup-cursor backup-mcp
	@echo "$(GREEN)✓ All backups complete$(RESET)"

#===============================================================================
# INFORMATION & VERIFICATION
#===============================================================================

## list-backups: List all available backups
list-backups:
	@echo "$(CYAN)=== Available Backups ===$(RESET)"
	@echo ""
	@echo "$(YELLOW)[Cursor Config Backups]$(RESET)"
	@if [ -d "cursor_config/config/workspace_backups" ]; then \
		ls -lt cursor_config/config/workspace_backups/*.json 2>/dev/null | head -n 5 | awk '{print "  " $$9 " - " $$6 " " $$7 " " $$8}' || echo "  No workspace backups found"; \
	else \
		echo "  No workspace backups directory"; \
	fi
	@echo ""
	@echo "$(YELLOW)[MCP Component Backups]$(RESET)"
	@if [ -d "enterprise_mcp_backups" ]; then \
		ls -ldt enterprise_mcp_backups/mcp_backup_* 2>/dev/null | awk '{print "  " $$9 " - " $$6 " " $$7 " " $$8}' || echo "  No MCP backups found"; \
	else \
		echo "  No MCP backups directory"; \
	fi
	@echo ""

## verify-backups: Verify integrity of backup files
verify-backups:
	@echo "$(CYAN)=== Verifying Backup Integrity ===$(RESET)"
	@echo ""
	@echo "$(YELLOW)[Cursor Config Files]$(RESET)"
	@test -f "cursor_config/backup_cursor_settings.sh" && echo "  ✓ backup_cursor_settings.sh" || echo "  ✗ MISSING: backup_cursor_settings.sh"
	@test -f "cursor_config/restore_cursor_settings.sh" && echo "  ✓ restore_cursor_settings.sh" || echo "  ✗ MISSING: restore_cursor_settings.sh"
	@test -d "cursor_config/config" && echo "  ✓ config directory" || echo "  ✗ MISSING: config directory"
	@echo ""
	@echo "$(YELLOW)[MCP Components]$(RESET)"
	@test -f "scripts/backup_mcp_components.sh" && echo "  ✓ backup_mcp_components.sh" || echo "  ✗ MISSING: backup_mcp_components.sh"
	@test -d "enterprise_mcp_backups" && echo "  ✓ enterprise_mcp_backups directory" || echo "  ✗ MISSING: enterprise_mcp_backups directory"
	@test -d "mcp_servers" && echo "  ✓ mcp_servers directory" || echo "  ✗ MISSING: mcp_servers directory"
	@echo ""

## status: Show current backup status and statistics
status:
	@echo "$(CYAN)=== Backup System Status ===$(RESET)"
	@echo ""
	@echo "$(YELLOW)[Statistics]$(RESET)"
	@echo "  Cursor workspace backups: $$(ls -1 cursor_config/config/workspace_backups/*.json 2>/dev/null | wc -l | xargs)"
	@echo "  MCP backups: $$(ls -1d enterprise_mcp_backups/mcp_backup_* 2>/dev/null | wc -l | xargs)"
	@echo ""
	@echo "$(YELLOW)[Latest Backups]$(RESET)"
	@echo "  Latest Cursor: $$(ls -1t cursor_config/config/workspace_backups/*.json 2>/dev/null | head -n1 | xargs basename 2>/dev/null || echo 'None')"
	@echo "  Latest MCP: $$(ls -1dt enterprise_mcp_backups/mcp_backup_* 2>/dev/null | head -n1 | xargs basename 2>/dev/null || echo 'None')"
	@echo ""
	@echo "$(YELLOW)[Disk Usage]$(RESET)"
	@echo "  Cursor backups: $$(du -sh cursor_config 2>/dev/null | cut -f1 || echo 'N/A')"
	@echo "  MCP backups: $$(du -sh enterprise_mcp_backups 2>/dev/null | cut -f1 || echo 'N/A')"
	@echo "  Total: $$(du -sh . 2>/dev/null | cut -f1 || echo 'N/A')"
	@echo ""

#===============================================================================
# MAINTENANCE
#===============================================================================

## clean-old: Remove backups older than 30 days
clean-old:
	@echo "$(CYAN)=== Cleaning old backups ===$(RESET)"
	@echo "$(YELLOW)Removing backups older than 30 days...$(RESET)"
	@find enterprise_mcp_backups -name "mcp_backup_*" -type d -mtime +30 -exec rm -rf {} \; 2>/dev/null || true
	@find cursor_config/config/workspace_backups -name "*.json" -type f -mtime +30 -delete 2>/dev/null || true
	@echo "$(GREEN)✓ Cleanup complete$(RESET)"

## clean: Remove all backup files (WARNING: Destructive)
clean:
	@echo "$(YELLOW)⚠️  WARNING: This will delete ALL backups$(RESET)"
	@echo "Press Ctrl+C to cancel, or Enter to continue..."
	@read dummy
	@rm -rf enterprise_mcp_backups/mcp_backup_*
	@rm -rf cursor_config/config/workspace_backups/*
	@echo "$(GREEN)✓ All backups removed$(RESET)"

#===============================================================================
# ADVANCED OPERATIONS
#===============================================================================

## compare: Compare current config with latest backup
compare:
	@echo "$(CYAN)=== Comparing configurations ===$(RESET)"
	@echo ""
	@echo "$(YELLOW)[Cursor Settings]$(RESET)"
	@if [ -f "$$HOME/.cursor/User/settings.json" ] && [ -f "cursor_config/config/settings.json" ]; then \
		diff -u cursor_config/config/settings.json "$$HOME/.cursor/User/settings.json" | head -n 20 || echo "  Files are identical"; \
	else \
		echo "  Cannot compare: files missing"; \
	fi
	@echo ""

## install-mcp-verify: Install MCP verification Makefile to system
install-mcp-verify:
	@echo "$(CYAN)=== Installing MCP Verification Makefile ===$(RESET)"
	@if [ -f "enterprise_mcp_backups/mcp_backup_20251027_235229/Makefile.mcp-verify" ]; then \
		mkdir -p "$$HOME/.config/workflows"; \
		cp enterprise_mcp_backups/mcp_backup_20251027_235229/Makefile.mcp-verify "$$HOME/.config/workflows/"; \
		echo "$(GREEN)✓ Installed to $$HOME/.config/workflows/Makefile.mcp-verify$(RESET)"; \
		echo "  Run with: make -f ~/.config/workflows/Makefile.mcp-verify verify-claude-turn"; \
	else \
		echo "$(YELLOW)✗ MCP verification Makefile not found in backups$(RESET)"; \
	fi
	@echo ""

#===============================================================================
# DOCUMENTATION
#===============================================================================

## docs: Show documentation and usage examples
docs:
	@echo "$(CYAN)=== Backup System Documentation ===$(RESET)"
	@echo ""
	@echo "$(GREEN)Quick Start:$(RESET)"
	@echo "  1. Backup everything: make backup-all"
	@echo "  2. List backups: make list-backups"
	@echo "  3. Restore Cursor: make restore-cursor"
	@echo ""
	@echo "$(GREEN)Regular Maintenance:$(RESET)"
	@echo "  - Weekly: make backup-all"
	@echo "  - Monthly: make clean-old"
	@echo "  - Before updates: make backup-all"
	@echo ""
	@echo "$(GREEN)Scripts Location:$(RESET)"
	@echo "  - Cursor: cursor_config/backup_cursor_settings.sh"
	@echo "  - MCP: scripts/backup_mcp_components.sh"
	@echo ""
	@echo "$(GREEN)Backup Locations:$(RESET)"
	@echo "  - Cursor configs: cursor_config/config/"
	@echo "  - MCP components: enterprise_mcp_backups/"
	@echo "  - MCP servers: mcp_servers/"
	@echo ""
	@cat README.md 2>/dev/null || echo "$(YELLOW)ℹ️  Create README.md for detailed documentation$(RESET)"
	@echo ""

