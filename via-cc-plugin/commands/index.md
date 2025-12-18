---
description: Index repository for intelligent code search
---

# /via-cc-plugin:index - Index Repository for Code Search

Execute the `index-repository.sh` shell script to index a workspace directory with the Via cloud service.

## Syntax

```
/via-cc-plugin:index <token> [directory]
```

**Arguments:**
- `token` - Via API authentication token (required)
- `directory` - Path to directory to index (optional, defaults to current directory)

## Task

1. Parse the token argument from the user's command
2. Validate that token is provided
3. If no directory specified, use current working directory
4. Find the plugin's script location and run the indexing script

**Script Location:**
The `index-repository.sh` script is located in the via-cc-plugin commands directory. Find it using:

```bash
# Locate the installed plugin script
PLUGIN_SCRIPT=$(find ~/.claude/plugins/cache/via-plugins-marketplace-for-claude-code/via-cc-plugin -type f -name "index-repository.sh" | head -1)

# Run with the provided arguments
bash "$PLUGIN_SCRIPT" <token> [directory]
```

Replace `<token>` and `[directory]` with the actual values from the user's command.

## Examples

**Index current directory:**
```
User: /via-cc-plugin:index sk-1234567890

You: I'll index your current directory using the Via service.
[Execute: Find and run index-repository.sh sk-1234567890]
```

**Index specific directory:**
```
User: /via-cc-plugin:index sk-1234567890 ~/testing

You: I'll index ~/testing using the Via service.
[Execute: Find and run index-repository.sh sk-1234567890 ~/testing]
```

## Error Handling

If the user doesn't provide a token:
```
User: /via-cc-plugin:index

You: The index command requires your Via API authentication token.

Example: /via-cc-plugin:index sk-your-token
Example with directory: /via-cc-plugin:index sk-your-token ~/testing
```

## Notes

- **Service URL**: `https://via-litellm-dev-647509527972.us-west1.run.app`
- The script creates a tarball excluding common patterns (node_modules, .git, __pycache__, etc.)
- Indexing happens asynchronously on the server (30-120 seconds)
- You'll receive a project UUID to check indexing status
