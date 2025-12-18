---
description: Index repository for intelligent code search with local or cloud deployment
---

# /via-cc-plugin:index - Index Repository for Code Search

Execute the `index-repository.sh` shell script to index a workspace directory with the Via service.

## Syntax

```
/via-cc-plugin:index <env_type> <token> [directory]
```

**Arguments:**
- `env_type` - "local" or "cloud" (required)
- `token` - API authentication token (required)
- `directory` - Path to directory to index (optional, defaults to current directory)

## Task

1. Parse the arguments from the user's command
2. Validate that env_type and token are provided
3. If no directory specified, use current working directory
4. Find the plugin's script location and run the indexing script with parsed arguments

**For Claude Code plugin installations**, the script is located in the plugin directory. Use this approach:

```bash
# Find the script in the installed plugin directory
SCRIPT_PATH=$(find ~/.claude -type f -name "index-repository.sh" 2>/dev/null | grep via-cc-plugin | head -1)

# Run the script with arguments
bash "$SCRIPT_PATH" <env_type> <token> [directory]
```

## Examples

**Local deployment with current directory:**
```
User: /via-cc-plugin:index local sk-via-np-d-rishi_dev_litellm

You: I'll index your current directory using the local Via service.
[Execute: Find and run index-repository.sh local sk-via-np-d-rishi_dev_litellm]
```

**Cloud deployment with specific directory:**
```
User: /via-cc-plugin:index cloud sk-1234567890 ~/testing

You: I'll index ~/testing using the cloud Via service.
[Execute: Find and run index-repository.sh cloud sk-1234567890 ~/testing]
```

**Cloud deployment with current directory:**
```
User: /via-cc-plugin:index cloud sk-1234567890

You: I'll index your current directory using the cloud Via service.
[Execute: Find and run index-repository.sh cloud sk-1234567890]
```

## Error Handling

If the user doesn't provide enough arguments:
```
User: /via-cc-plugin:index

You: The index command requires at least 2 arguments:
- env_type: "local" or "cloud"
- token: Your API authentication token
- directory: (optional) Path to index, defaults to current directory

Example: /via-cc-plugin:index local sk-your-token ~/testing
```

## Notes

- **Local** uses: `http://host.docker.internal:4000` (or `http://localhost:4000`)
- **Cloud** uses: `https://via-litellm-dev-647509527972.us-west1.run.app`
- The script will create a tarball excluding common patterns (node_modules, .git, __pycache__, etc.)
- Authentication token is passed directly to the script for API calls
