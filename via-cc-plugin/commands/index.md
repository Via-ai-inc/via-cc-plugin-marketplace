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
2. Execute the indexing script using the command below

**If user provides a directory path:**
```bash
bash "$(find ~/.claude/plugins/cache/via-plugins-marketplace-for-claude-code/via-cc-plugin -type f -name "index-repository.sh" | head -1)" <directory-path>
```

**If no directory specified (index current directory):**
```bash
bash "$(find ~/.claude/plugins/cache/via-plugins-marketplace-for-claude-code/via-cc-plugin -type f -name "index-repository.sh" | head -1)"
```

The script uses the `ANTHROPIC_API_KEY` environment variable for authentication.

## Examples

**Index current directory:**
```
User: /via-cc-plugin:index

You: I'll index your current directory using the Via service.
[Execute: bash "$(find ~/.claude/plugins/cache/via-plugins-marketplace-for-claude-code/via-cc-plugin -type f -name "index-repository.sh" | head -1)"]
```

**Index specific directory:**
```
User: /via-cc-plugin:index ~/testing

You: I'll index ~/testing using the Via service.
[Execute: bash "$(find ~/.claude/plugins/cache/via-plugins-marketplace-for-claude-code/via-cc-plugin -type f -name "index-repository.sh" | head -1)" ~/testing]
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
