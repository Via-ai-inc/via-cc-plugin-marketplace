---
description: Index repository for intelligent code search
---

# /via-index - Index Repository for Code Search

Execute the `index-repository.sh` shell script to index the current workspace directory.

## Task

1. Inform the user that you're indexing their repository
2. Run the indexing script using the Bash tool:

```bash
bash /root/cc-plugins-marketplace/via-cc-plugin/commands/index-repository.sh
```

The script will:
- Automatically use the current working directory
- Create a tarball with smart filtering (excludes node_modules, .git, etc.)
- Upload to the Via service at localhost:8002
- Wait for upload to complete

## Example

```
User: /via-index

You: I'll index your repository for code search.

[Execute: bash /root/cc-plugins-marketplace/via-cc-plugin/commands/index-repository.sh]

[Script output shows progress and results]

You: Your repository has been indexed! 
```

## Notes

- The script uses the current working directory automatically
- Smart filtering excludes common patterns (node_modules, .git, __pycache__, etc.)
- Same directory = same workspace across all conversations
