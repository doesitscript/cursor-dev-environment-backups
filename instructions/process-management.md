# Process Management Commands

## PS Command - Process Listing

### macOS Syntax (RECOMMENDED for this system)
```bash
# List all processes
ps -A

# List processes with full details
ps -A -o pid,ppid,user,command

# Filter processes
ps -A | grep "pattern"

# Find specific processes
ps -A | grep -v grep | grep "chrome"
```

### Linux Syntax (DOES NOT WORK on macOS)
```bash
# These commands FAIL on macOS:
ps aux          # ❌ "illegal argument: aux"
ps -ef          # ❌ "illegal option -- f"
```

### Cross-Platform Considerations
- **macOS**: Use `ps -A` for all processes
- **Linux**: Use `ps aux` or `ps -ef`
- **BSD**: Different syntax entirely

## Process Control Commands

### Kill Processes
```bash
# Kill by PID
kill 1234

# Force kill
kill -9 1234

# Kill by name
pkill -f "process_name"

# Kill all processes matching pattern
pkill -f "chrome"
```

### Process Monitoring
```bash
# Monitor processes in real-time
top

# Monitor specific process
top -pid 1234

# Process tree
pstree
```

## Common Patterns

### Find Running Services
```bash
# Find Chrome processes
ps -A | grep -v grep | grep "chrome"

# Find Node.js processes
ps -A | grep -v grep | grep "node"

# Find processes by user
ps -A -u username
```

### Process Information
```bash
# Get process details
ps -A -o pid,ppid,user,%cpu,%mem,command

# Find process by port
lsof -i :3000

# Find process by file
lsof /path/to/file
```

## Best Practices

1. **Always use `ps -A` on macOS** instead of `ps aux`
2. **Test command syntax** before using in scripts
3. **Use `grep -v grep`** to exclude grep process from results
4. **Document OS-specific variations** for cross-platform scripts

## Last Updated
2025-01-27 - Added macOS-specific ps command syntax and troubleshooting
