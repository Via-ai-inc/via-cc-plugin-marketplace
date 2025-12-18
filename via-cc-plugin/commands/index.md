---
description: Index repository for intelligent code search
---

# /via-cc-plugin:index - Index Repository for Code Search

Execute the `index-repository.sh` shell script to index a workspace directory with the Via cloud service.

## Syntax

```
/via-cc-plugin:index [directory]
```

**Arguments:**
- `directory` - Path to directory to index (optional, defaults to current directory)

**Environment Variables:**
- `ANTHROPIC_API_KEY` - Via API authentication token (must be set)

## Task

1. Parse the directory argument from the user's command (optional)
2. If no directory specified, use current working directory
3. Find the plugin's script location and run the indexing script

**Script Location:**
The `index-repository.sh` script is located in the via-cc-plugin commands directory. Find it using:

```bash
# Locate the installed plugin script
PLUGIN_SCRIPT=$(find ~/.claude/plugins/cache/via-plugins-marketplace-for-claude-code/via-cc-plugin -type f -name "index-repository.sh" | head -1)

# Run with the provided directory (or no args for current directory)
bash "$PLUGIN_SCRIPT" [directory]
```

The script uses the `ANTHROPIC_API_KEY` environment variable for authentication.

## Examples

**Index current directory:**
```
User: /via-cc-plugin:index

You: I'll index your current directory using the Via service.
[Execute: Find and run index-repository.sh]
```

**Index specific directory:**
```
User: /via-cc-plugin:index ~/testing

You: I'll index ~/testing using the Via service.
[Execute: Find and run index-repository.sh ~/testing]
```

## Error Handling

If the `ANTHROPIC_API_KEY` environment variable is not set:
```
The script will return an error message indicating the environment variable is required.
Make sure users have set: export ANTHROPIC_API_KEY="sk-your-via-key"
```

## Notes

- **Service URL**: `https://via-litellm-dev-647509527972.us-west1.run.app`
- The script creates a tarball excluding common patterns (node_modules, .git, __pycache__, etc.)
- Indexing happens asynchronously on the server (30-120 seconds)
- You'll receive a project UUID to check indexing status
