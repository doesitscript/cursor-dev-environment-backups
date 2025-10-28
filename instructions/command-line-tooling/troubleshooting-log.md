# Troubleshooting Log

## 2025-01-27: Find Command Issues

### Problem
- **Tool**: `find` command with `-exec grep`
- **Error**: Global options warnings and directory separator issues
- **Context**: Searching for Chrome MCP references in markdown files

### Root Cause
1. `find` global options (`-maxdepth`, `-type`) must come before other arguments
2. `find -exec grep` pattern is problematic and inefficient
3. `grep -r` is more reliable for text searching

### Solution Applied
```bash
# Instead of:
find /path -name "*.md" -exec grep -l "pattern" {} \;

# Use:
grep -r -l -i "pattern" . --include="*.md"
```

### Results
- Successfully found 5 markdown files with Chrome MCP references
- No more find command warnings
- More efficient execution

### Prevention
- Always use `grep -r` for text searching
- Test simple patterns before complex ones
- Document working patterns for reuse

## Future Troubleshooting Template

### Problem
- **Tool**: [tool name]
- **Error**: [error message]
- **Context**: [what we were trying to do]

### Root Cause
- [analysis of why it failed]

### Solution Applied
```bash
# Working command
```

### Results
- [what worked]

### Prevention
- [how to avoid this in future]

## 2025-01-27: PS Command Issues on macOS

### Problem
- **Tool**: `ps` command with Linux-style options
- **Error**: "illegal argument: aux" and "illegal option -- f"
- **Context**: Trying to list processes with Linux syntax on macOS

### Root Cause
macOS `ps` command has different syntax than Linux `ps` command:
- Linux supports `ps aux` and `ps -ef`
- macOS doesn't support these options
- Cross-platform compatibility issues

### Solution Applied
```bash
# Instead of Linux syntax (FAILS on macOS):
ps aux          # ❌ "illegal argument: aux"
ps -ef          # ❌ "illegal option -- f"

# Use macOS-compatible syntax:
ps              # ✅ Basic process list
ps -A           # ✅ All processes
ps -A | grep pattern  # ✅ Filter processes
```

### Results
- Successfully listed processes using `ps -A`
- Found Chrome processes using `ps -A | grep chrome`
- Avoided cross-platform syntax errors

### Prevention
- Always use `ps -A` on macOS instead of `ps aux`
- Test `ps` syntax before using in scripts
- Document OS-specific command variations
