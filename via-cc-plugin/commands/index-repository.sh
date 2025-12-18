#!/bin/bash
set -e  # Exit on error

# Show usage information
show_usage() {
    cat << EOF
Usage: $0 <token> [workspace_dir]

Arguments:
  token           Via API authentication token (required)
  workspace_dir   Directory to index (optional, defaults to current directory)

Examples:
  $0 sk-1234567890 ~/testing      # Index specific directory
  $0 sk-1234567890                # Index current directory

Service URL: https://via-litellm-dev-647509527972.us-west1.run.app

EOF
    exit 0
}

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Via service URL (cloud only)
VIA_LITELLM_SERVICE_URL="https://via-litellm-dev-647509527972.us-west1.run.app"

# Parse command-line arguments
if [ $# -eq 0 ] || [ "$1" = "-h" ] || [ "$1" = "--help" ]; then
    show_usage
fi

VIA_LITELLM_API_KEY="$1"
WORKSPACE_DIR="${2:-$(pwd)}"  # Second arg or current directory

# Validate token is provided
if [ -z "$VIA_LITELLM_API_KEY" ]; then
    echo -e "${RED}[ERROR]${NC} Token is required"
    echo ""
    show_usage
fi

# Check and install dependencies
check_dependencies() {
    local missing_deps=()

    # Check for bc (basic calculator)
    if ! command -v bc &> /dev/null; then
        missing_deps+=("bc")
    fi

    # Check for curl
    if ! command -v curl &> /dev/null; then
        missing_deps+=("curl")
    fi

    # If dependencies are missing, try to install them
    if [ ${#missing_deps[@]} -gt 0 ]; then
        echo -e "${YELLOW}[SETUP]${NC} Installing missing dependencies: ${missing_deps[*]}"

        # Detect package manager and install
        if command -v apt-get &> /dev/null; then
            apt-get update -qq > /dev/null 2>&1
            apt-get install -y -qq "${missing_deps[@]}" > /dev/null 2>&1
        elif command -v yum &> /dev/null; then
            yum install -y -q "${missing_deps[@]}" > /dev/null 2>&1
        elif command -v apk &> /dev/null; then
            apk add --quiet "${missing_deps[@]}" > /dev/null 2>&1
        elif command -v brew &> /dev/null; then
            brew install -q "${missing_deps[@]}" > /dev/null 2>&1
        else
            echo -e "${RED}[ERROR]${NC} Could not install dependencies. Please install manually: ${missing_deps[*]}"
            exit 1
        fi

        echo -e "${GREEN}[SETUP]${NC} Dependencies installed successfully"
    fi
}

# Run dependency check
check_dependencies

# Function to log messages
log_info() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

log_warn() {
    echo -e "${YELLOW}[WARN]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Get absolute path for workspace directory
WORKSPACE_DIR=$(cd "$WORKSPACE_DIR" && pwd)

# Display configuration
echo ""
echo "======================================"
echo "Configuration"
echo "======================================"
echo "Service URL:  $VIA_LITELLM_SERVICE_URL"
echo "Workspace:    $WORKSPACE_DIR"
echo "======================================"
echo ""

log_info "Indexing repository: $WORKSPACE_DIR"

# Check if this is a git repository
if [ -d "$WORKSPACE_DIR/.git" ]; then
    log_info "Repository type: Git"
else
    log_warn "Not a git repository - may include unwanted files"
    log_warn "Consider running from a git repository root for best results"
fi

# Create temporary tarball
TEMP_DIR=$(mktemp -d)

# Generate tarball name from repository identity
TARBALL_NAME=""

if [ -d "$WORKSPACE_DIR/.git" ]; then
    # Try to get git repo name from remote URL
    GIT_REMOTE=$(cd "$WORKSPACE_DIR" && git config --get remote.origin.url 2>/dev/null)
    if [ -n "$GIT_REMOTE" ]; then
        # Extract repo name from URL (handles both HTTPS and SSH)
        TARBALL_NAME=$(echo "$GIT_REMOTE" | sed -E 's#.*/([^/]+)(\.git)?$#\1#' | sed 's/\.git$//')
    fi
fi

# Fallback to directory name if git repo name not available
if [ -z "$TARBALL_NAME" ]; then
    TARBALL_NAME=$(basename "$WORKSPACE_DIR")
fi

TARBALL_PATH="${TEMP_DIR}/${TARBALL_NAME}.tar.gz"
trap "rm -rf $TEMP_DIR" EXIT

log_info "Creating tarball from $WORKSPACE_DIR"
log_info "Excluding: .git, node_modules, __pycache__, venv, ..."

# Create tarball with exclusions
tar -czf "$TARBALL_PATH" \
    -C "$WORKSPACE_DIR" \
    --exclude='.git' \
    --exclude='.gitignore' \
    --exclude='.gitattributes' \
    --exclude='.gitmodules' \
    --exclude='.svn' \
    --exclude='.hg' \
    --exclude='node_modules' \
    --exclude='package-lock.json' \
    --exclude='yarn.lock' \
    --exclude='__pycache__' \
    --exclude='*.pyc' \
    --exclude='*.pyo' \
    --exclude='*.pyd' \
    --exclude='.venv' \
    --exclude='venv' \
    --exclude='env' \
    --exclude='virtualenv' \
    --exclude='.tox' \
    --exclude='.nox' \
    --exclude='vendor' \
    --exclude='Pods' \
    --exclude='dist' \
    --exclude='build' \
    --exclude='target' \
    --exclude='out' \
    --exclude='*.egg-info' \
    --exclude='*.egg' \
    --exclude='.eggs' \
    --exclude='.pytest_cache' \
    --exclude='.mypy_cache' \
    --exclude='.gradle' \
    --exclude='.m2' \
    --exclude='.idea' \
    --exclude='.vscode' \
    --exclude='.vs' \
    --exclude='*.swp' \
    --exclude='*.swo' \
    --exclude='*.swn' \
    --exclude='.project' \
    --exclude='.classpath' \
    --exclude='.settings' \
    --exclude='.DS_Store' \
    --exclude='Thumbs.db' \
    --exclude='desktop.ini' \
    --exclude='*.log' \
    --exclude='*.tmp' \
    --exclude='*.temp' \
    --exclude='.coverage' \
    --exclude='htmlcov' \
    --exclude='coverage' \
    --exclude='.cache' \
    --exclude='.env' \
    --exclude='.env.local' \
    --exclude='.env.*.local' \
    --exclude='*.mp4' \
    --exclude='*.mov' \
    --exclude='*.avi' \
    --exclude='*.mkv' \
    --exclude='*.zip' \
    --exclude='*.tar' \
    --exclude='*.tar.gz' \
    --exclude='*.tgz' \
    --exclude='*.iso' \
    --exclude='*.dmg' \
    --exclude='via_litellm_service' \
    --exclude='workspaces' \
    --exclude='data' \
    --exclude='*.sock' \
    --exclude='*.socket' \
    --exclude='*.lock' \
    --exclude='.s.PGSQL.*' \
    . \
    2>&1 | grep -v -E "(pax format|extended attributes|socket)" >&2 || true

# Get tarball size
TARBALL_SIZE=$(stat -f%z "$TARBALL_PATH" 2>/dev/null || stat -c%s "$TARBALL_PATH" 2>/dev/null)
TARBALL_SIZE_MB=$(echo "scale=1; $TARBALL_SIZE / 1024 / 1024" | bc)

# Validate tarball is not suspiciously small
if [ "$TARBALL_SIZE" -lt 1024 ]; then
    log_error "Tarball too small: ${TARBALL_SIZE_MB} MB (${TARBALL_SIZE} bytes)"
    log_error "Directory may be empty or contain only excluded files"
    log_error "Check the directory contents: ls -lah \"$WORKSPACE_DIR\""
    exit 1
fi

log_info "Tarball created: ${TARBALL_SIZE_MB} MB"

# Upload tarball to via-litellm service
log_info "Uploading ${TARBALL_SIZE_MB} MB (${TARBALL_NAME}.tar.gz)..."

# Capture both response body and HTTP status code
HTTP_RESPONSE=$(curl -s -w "\n%{http_code}" -X POST \
    "${VIA_LITELLM_SERVICE_URL}/v1/via-external/projects/upload" \
    -H "Authorization: Bearer ${VIA_LITELLM_API_KEY}" \
    -H "X-Local-Path: ${WORKSPACE_DIR}" \
    -F "file=@${TARBALL_PATH};type=application/gzip;filename=${TARBALL_NAME}.tar.gz")

# Parse response
UPLOAD_BODY=$(echo "$HTTP_RESPONSE" | sed '$d')
HTTP_STATUS=$(echo "$HTTP_RESPONSE" | tail -n 1)

# Check HTTP status code
if [ "$HTTP_STATUS" -ge 200 ] && [ "$HTTP_STATUS" -lt 300 ]; then
    log_info "Upload complete (HTTP $HTTP_STATUS)"

    # Try to parse project UUID from response
    if command -v jq &> /dev/null; then
        PROJECT_UUID=$(echo "$UPLOAD_BODY" | jq -r '.project_id' 2>/dev/null)
        if [ -n "$PROJECT_UUID" ] && [ "$PROJECT_UUID" != "null" ]; then
            log_info "Project UUID: $PROJECT_UUID"
        fi
    fi

    echo ""
    echo "======================================"
    echo "✅ Upload successful! Indexing in progress..."
    echo "======================================"
    echo "- Workspace: $WORKSPACE_DIR"
    echo "- Archive size: ${TARBALL_SIZE_MB} MB"
    echo "- Project ID: ${PROJECT_UUID:-N/A}"

    # Show status polling instructions if project UUID available
    if [ -n "$PROJECT_UUID" ] && [ "$PROJECT_UUID" != "null" ]; then
        echo ""
        echo "📊 Check indexing status:"
        echo "   curl -H \"Authorization: Bearer ${VIA_LITELLM_API_KEY}\" \\"
        echo "        \"${VIA_LITELLM_SERVICE_URL}/v1/via-external/projects/${PROJECT_UUID}/status\""
        echo ""
        echo "💡 Indexing happens asynchronously on the server."
        echo "   Use the status endpoint above to check completion."
    fi
    echo "======================================"
else
    log_error "Upload failed with HTTP $HTTP_STATUS"

    # Try to parse error message from JSON response
    if command -v jq &> /dev/null; then
        ERROR_MSG=$(echo "$UPLOAD_BODY" | jq -r '.detail' 2>/dev/null)
        if [ -n "$ERROR_MSG" ] && [ "$ERROR_MSG" != "null" ]; then
            log_error "Error details: $ERROR_MSG"
        else
            echo "$UPLOAD_BODY" | head -5
        fi
    else
        echo "$UPLOAD_BODY" | head -5
    fi

    echo ""
    echo "======================================"
    echo "❌ Upload failed"
    echo "======================================"
    echo "- HTTP Status: $HTTP_STATUS"
    echo "- Workspace: $WORKSPACE_DIR"
    echo "- Archive size: ${TARBALL_SIZE_MB} MB"
    echo ""
    echo "💡 Troubleshooting:"
    echo "   - Check API key: $VIA_LITELLM_API_KEY"
    echo "   - Verify service URL: $VIA_LITELLM_SERVICE_URL"
    echo "   - Check server logs for details"
    echo "======================================"
    exit 1
fi

echo ""
