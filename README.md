# Via Plugin Marketplace for Claude Code

Official plugin marketplace for Via - bringing intelligent codebase indexing and search to Claude Code.

## 🚀 Quick Start

### Installation

1. **Start Claude Code** in your project directory:
   ```bash
   cd your-project
   claude
   ```

2. **Add Via marketplace** using the `/plugin` command:
   ```bash
   /plugin
   ```

3. Select **"Add marketplace"** and enter:
   ```
   https://github.com/via-ai-inc/via-cc-plugin-marketplace
   ```

4. **Install the Via plugin** from the marketplace

5. **Test the installation**:
   ```bash
   /via-cc-plugin:hello
   ```

## 📦 Available Plugins

### Via CC Plugin

Intelligent codebase indexing and semantic search for Claude Code.

**Commands:**

- `/via-cc-plugin:hello` - Test plugin connectivity
- `/via-cc-plugin:index [path]` - Index your codebase

## 📖 Usage

### Index Your Codebase

**Index current directory:**
```bash
/via-cc-plugin:index
```

**Index specific directory:**
```bash
/via-cc-plugin:index ~/path/to/project
```

**Requirements:**
- `ANTHROPIC_API_KEY` environment variable set to your Via virtual key
- Internet connection

### What Gets Indexed?

The plugin creates a tarball of your current directory, excluding:
- `.git` and version control files
- `node_modules`, `vendor`, dependency folders
- Build artifacts (`dist`, `build`, `target`, `out`)
- Virtual environments (`venv`, `.venv`, `env`)
- IDE configurations (`.idea`, `.vscode`, `.vs`)
- Compiled files (`*.pyc`, `*.pyo`, `__pycache__`)
- Large media files (`*.mp4`, `*.mov`, `*.zip`, `*.tar.gz`)
- Environment files (`.env`, `.env.local`)

### Indexing Process

1. **Upload**: Creates tarball and uploads to Via-LiteLLM service
2. **Extract**: Server extracts files to temporary location
3. **Index**: Codemap2 generates searchable database (async, 30-120s)
4. **Search**: Use natural language queries to find code

### Example Queries

Once indexed, ask Claude Code:

```
"Search for the QuantityIterator class using codemap_search"
"Find all functions that handle HTTP requests"
"Show me where database models are defined"
"Use codemap_search to find authentication logic"
```

## 🔑 Getting API Keys

Contact your Via administrator for your Via virtual API key. This key should be set as the `ANTHROPIC_API_KEY` environment variable:

```bash
export ANTHROPIC_API_KEY="sk-your-via-virtual-key"
```

Add this to your `~/.zshrc` or `~/.bashrc` to persist across sessions.

## 🏗️ Architecture

```
Claude Code
    ↓
Via Plugin (this repo)
    ↓
Via-LiteLLM Service (proxy + orchestration)
    ↓
Codemap2 Service (indexing + search)
    ↓
Search Results → Claude Code conversation
```

## 🛠️ Development

### Repository Structure

```
.claude-plugin/
  marketplace.json          # Marketplace metadata
via-cc-plugin/
  .claude-plugin/
    plugin.json             # Plugin metadata
  commands/
    hello.md                # Hello command prompt
    index.md                # Index command prompt
    index-repository.sh     # Indexing script
```

### Local Testing

To test the plugin locally without publishing:

```bash
cd /path/to/via-cc-plugin-marketplace
claude

# Inside Claude Code session
/plugin
# Select "Add marketplace"
# Enter: /path/to/via-cc-plugin-marketplace
```

## 📋 Requirements

- **Claude Code CLI** (version with plugin support)
- **Bash shell** (for indexing script)
- **curl** (auto-installed if missing)
- **bc** (basic calculator, auto-installed if missing)

## 🔧 Troubleshooting

### Plugin not found
- Verify you entered the correct marketplace URL
- Check network connectivity
- Try removing and re-adding the marketplace

### Upload fails
```bash
# Test service endpoint
curl https://via-litellm-dev-647509527972.us-west1.run.app/health/liveliness

# Verify API key is set
echo $ANTHROPIC_API_KEY | grep "sk-"
```

### Tarball too small
- Check if directory contains code files
- Verify you're not in an empty directory
- Run: `ls -lah` to see directory contents

## 🤝 Contributing

We welcome contributions! To add new commands or improve existing ones:

1. Fork this repository
2. Create a feature branch
3. Add your command as a `.md` file in `via-cc-plugin/commands/`
4. Update `plugin.json` if needed
5. Submit a pull request

## 📄 License

[License TBD]

## 🔗 Links

- [Via Documentation](https://docs.via.dev) (TBD)
- [Claude Code Documentation](https://docs.anthropic.com/en/docs/claude-code)
- [Via-LiteLLM GitHub](https://github.com/via-ai-inc/via-litellm) (TBD)
- [Codemap2 GitHub](https://github.com/via-ai-inc/codemap2) (TBD)

## 💬 Support

For issues or questions:
- Open an issue in this repository
- Contact: support@via.dev (TBD)
- Join our Discord: [link TBD]

---

Made with ❤️ by [Via Inc](https://via.dev)
