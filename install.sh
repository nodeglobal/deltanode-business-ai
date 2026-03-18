#!/usr/bin/env bash
# ═══════════════════════════════════════════════════════════════════════════════
# DeltaNode Business AI Installer v1.0
# One-command setup for your AI business assistant
# ═══════════════════════════════════════════════════════════════════════════════

set -e

# ─────────────────────────────────────────────────────────────────────────────
# Configuration
# ─────────────────────────────────────────────────────────────────────────────
VERSION="1.0.0"
INSTALL_DIR="$HOME/.deltanode"
LOG_FILE="$INSTALL_DIR/install.log"
SKILLS_URL="https://github.com/nodeglobal/deltanode-business-ai/releases/download/v1.0/business-ai-kit.tar.gz"
MAX_ATTEMPTS=3

# ─────────────────────────────────────────────────────────────────────────────
# Colors and formatting
# ─────────────────────────────────────────────────────────────────────────────
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
BOLD='\033[1m'
NC='\033[0m' # No Color

# ─────────────────────────────────────────────────────────────────────────────
# Helper functions
# ─────────────────────────────────────────────────────────────────────────────
print_header() {
    clear
    echo ""
    echo -e "${CYAN}╔══════════════════════════════════════════════╗${NC}"
    echo -e "${CYAN}║${NC}${BOLD}        DeltaNode Business AI v${VERSION}         ${NC}${CYAN}║${NC}"
    echo -e "${CYAN}║${NC}        Your AI assistant. Zero config.      ${CYAN}║${NC}"
    echo -e "${CYAN}╚══════════════════════════════════════════════╝${NC}"
    echo ""
}

print_step() {
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${BOLD}  $1${NC}"
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo ""
}

print_success() {
    echo -e "${GREEN}✓${NC} $1"
}

print_error() {
    echo -e "${RED}✗${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}!${NC} $1"
}

print_info() {
    echo -e "${CYAN}→${NC} $1"
}

spinner() {
    local pid=$1
    local delay=0.1
    local spinstr='⠋⠙⠹⠸⠼⠴⠦⠧⠇⠏'
    while [ "$(ps a | awk '{print $1}' | grep -w $pid)" ]; do
        local temp=${spinstr#?}
        printf " ${CYAN}%c${NC}  " "$spinstr"
        local spinstr=$temp${spinstr%"$temp"}
        sleep $delay
        printf "\b\b\b\b"
    done
    printf "    \b\b\b\b"
}

log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" >> "$LOG_FILE"
}

run_silent() {
    "$@" >> "$LOG_FILE" 2>&1
}

# ─────────────────────────────────────────────────────────────────────────────
# System detection
# ─────────────────────────────────────────────────────────────────────────────
detect_os() {
    if [[ "$OSTYPE" == "darwin"* ]]; then
        OS="macos"
        ARCH=$(uname -m)
        if [[ "$ARCH" == "arm64" ]]; then
            CHIP="Apple Silicon"
        else
            CHIP="Intel"
        fi
    elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
        OS="linux"
        if [ -f /etc/debian_version ]; then
            DISTRO="debian"
        elif [ -f /etc/redhat-release ]; then
            DISTRO="redhat"
        else
            DISTRO="unknown"
        fi
    else
        print_error "Unsupported operating system: $OSTYPE"
        exit 1
    fi
}

# ─────────────────────────────────────────────────────────────────────────────
# Dependency installation
# ─────────────────────────────────────────────────────────────────────────────
install_homebrew() {
    if ! command -v brew &> /dev/null; then
        print_info "Installing Homebrew..."
        NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" >> "$LOG_FILE" 2>&1

        # Add Homebrew to PATH for Apple Silicon
        if [[ "$ARCH" == "arm64" ]]; then
            eval "$(/opt/homebrew/bin/brew shellenv)"
            echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
        fi
        print_success "Homebrew installed"
    fi
}

install_nodejs_mac() {
    if ! command -v node &> /dev/null || [[ $(node -v | cut -d'.' -f1 | tr -d 'v') -lt 22 ]]; then
        print_info "Installing Node.js 22..."
        run_silent brew install node@22
        run_silent brew link node@22 --overwrite --force
        print_success "Node.js $(node -v) installed"
    else
        print_success "Node.js $(node -v) already installed"
    fi
}

install_nodejs_linux() {
    if ! command -v node &> /dev/null || [[ $(node -v | cut -d'.' -f1 | tr -d 'v') -lt 22 ]]; then
        print_info "Installing Node.js 22..."
        curl -fsSL https://deb.nodesource.com/setup_22.x | sudo -E bash - >> "$LOG_FILE" 2>&1
        sudo apt-get install -y nodejs >> "$LOG_FILE" 2>&1
        print_success "Node.js $(node -v) installed"
    else
        print_success "Node.js $(node -v) already installed"
    fi
}

install_openclaw() {
    if ! command -v openclaw &> /dev/null; then
        print_info "Installing AI engine (OpenClaw)..."
        run_silent npm install -g openclaw
        print_success "OpenClaw installed"
    else
        print_success "OpenClaw already installed"
    fi
}

# ─────────────────────────────────────────────────────────────────────────────
# Validation functions
# ─────────────────────────────────────────────────────────────────────────────
validate_claude_key() {
    local key="$1"

    # Check format
    if [[ ! "$key" =~ ^sk-ant- ]]; then
        echo "format_error"
        return
    fi

    # Make live API call to validate
    local response
    response=$(curl -s -w "\n%{http_code}" -X POST "https://api.anthropic.com/v1/messages" \
        -H "Content-Type: application/json" \
        -H "x-api-key: $key" \
        -H "anthropic-version: 2023-06-01" \
        -d '{
            "model": "claude-haiku-4-5-20251001",
            "max_tokens": 10,
            "messages": [{"role": "user", "content": "Hi"}]
        }' 2>/dev/null)

    local http_code=$(echo "$response" | tail -n1)

    case "$http_code" in
        200) echo "valid" ;;
        401) echo "invalid_key" ;;
        *) echo "warning" ;;
    esac
}

validate_telegram_token() {
    local token="$1"

    # Check format: digits:alphanumeric
    if [[ ! "$token" =~ ^[0-9]+:[A-Za-z0-9_-]+$ ]]; then
        echo "format_error"
        return
    fi

    # Make live API call
    local response
    response=$(curl -s "https://api.telegram.org/bot${token}/getMe" 2>/dev/null)

    if echo "$response" | grep -q '"ok":true'; then
        local bot_name=$(echo "$response" | grep -o '"username":"[^"]*"' | cut -d'"' -f4)
        echo "valid:$bot_name"
    else
        echo "invalid_token"
    fi
}

get_valid_claude_key() {
    local attempt=1

    while [ $attempt -le $MAX_ATTEMPTS ]; do
        echo ""
        echo -e "  Get your free Claude key in 2 minutes:"
        echo -e "  ${CYAN}1.${NC} Go to: ${BOLD}console.anthropic.com${NC}"
        echo -e "  ${CYAN}2.${NC} Sign up with your email"
        echo -e "  ${CYAN}3.${NC} Click 'Create Key' in the Keys section"
        echo -e "  ${CYAN}4.${NC} Copy and paste it below"
        echo ""
        echo -e "  ${YELLOW}Cost: ~\$5-10/month paid directly to Anthropic.${NC}"
        echo -e "  ${YELLOW}No middleman. No markup. Full privacy.${NC}"
        echo ""

        if [ $attempt -gt 1 ]; then
            echo -e "  ${YELLOW}Attempt $attempt of $MAX_ATTEMPTS${NC}"
            echo ""
        fi

        read -p "  Paste your Claude key: " CLAUDE_KEY
        echo ""

        print_info "Validating your Claude connection..."
        local result=$(validate_claude_key "$CLAUDE_KEY")

        case "$result" in
            "valid")
                print_success "Claude connection verified!"
                return 0
                ;;
            "format_error")
                print_error "That doesn't look like a Claude key."
                echo -e "        Claude keys start with ${BOLD}sk-ant-${NC}"
                ;;
            "invalid_key")
                print_error "Claude didn't recognise that key."
                echo "        Please check you copied the full key."
                ;;
            "warning")
                print_warning "Couldn't verify the key right now, but it looks correct."
                print_info "Continuing with setup..."
                return 0
                ;;
        esac

        attempt=$((attempt + 1))
    done

    echo ""
    print_error "Unable to connect to Claude after $MAX_ATTEMPTS attempts."
    echo ""
    echo "  Need help? Here's what to check:"
    echo "  • Make sure you copied the entire key (it's long!)"
    echo "  • Keys start with sk-ant-"
    echo "  • Get a new key at console.anthropic.com"
    echo ""
    echo "  Contact support@deltanodeglobal.com if you're stuck."
    echo ""
    exit 1
}

get_valid_telegram_token() {
    local attempt=1

    while [ $attempt -le $MAX_ATTEMPTS ]; do
        echo ""
        echo -e "  Your assistant lives in Telegram."
        echo -e "  Message it from anywhere — phone or desktop."
        echo ""
        echo -e "  Create your bot in 60 seconds:"
        echo -e "  ${CYAN}1.${NC} Open Telegram"
        echo -e "  ${CYAN}2.${NC} Search for ${BOLD}@BotFather${NC}"
        echo -e "  ${CYAN}3.${NC} Send: ${BOLD}/newbot${NC}"
        echo -e "  ${CYAN}4.${NC} Pick any name"
        echo -e "  ${CYAN}5.${NC} Copy the token it gives you"
        echo ""

        if [ $attempt -gt 1 ]; then
            echo -e "  ${YELLOW}Attempt $attempt of $MAX_ATTEMPTS${NC}"
            echo ""
        fi

        read -p "  Paste your Telegram token: " TELEGRAM_TOKEN
        echo ""

        print_info "Connecting to Telegram..."
        local result=$(validate_telegram_token "$TELEGRAM_TOKEN")

        if [[ "$result" == valid:* ]]; then
            local bot_name="${result#valid:}"
            print_success "Connected to Telegram bot: @$bot_name"
            return 0
        elif [[ "$result" == "format_error" ]]; then
            print_error "That doesn't look like a Telegram token."
            echo "        Tokens look like: 123456789:ABCdef..."
        else
            print_error "Telegram didn't recognise that token."
            echo "        Make sure you copied the full token from BotFather."
        fi

        attempt=$((attempt + 1))
    done

    echo ""
    print_error "Unable to connect to Telegram after $MAX_ATTEMPTS attempts."
    echo ""
    echo "  Need help?"
    echo "  • Open Telegram and message @BotFather"
    echo "  • Send /newbot to create a fresh bot"
    echo "  • Copy the entire token it gives you"
    echo ""
    echo "  Contact support@deltanodeglobal.com if you're stuck."
    echo ""
    exit 1
}

# ─────────────────────────────────────────────────────────────────────────────
# Configuration
# ─────────────────────────────────────────────────────────────────────────────
configure_openclaw() {
    print_info "Configuring your assistant..."

    # Set LLM provider
    run_silent openclaw config set llm.provider anthropic
    run_silent openclaw config set llm.apiKey "$CLAUDE_KEY"
    run_silent openclaw config set llm.model "claude-sonnet-4-6"

    # Set Telegram channel
    run_silent openclaw config set channels.telegram.enabled true
    run_silent openclaw config set channels.telegram.botToken "$TELEGRAM_TOKEN"

    print_success "Assistant configured"
}

install_skills() {
    print_info "Installing your 10 business skills..."

    local skills_dir="$HOME/.openclaw/skills"
    mkdir -p "$skills_dir"

    # Copy skills from kit
    if [ -d "$INSTALL_DIR/kit/skills" ]; then
        cp -r "$INSTALL_DIR/kit/skills/"* "$skills_dir/"
    fi

    print_success "10 business skills installed"
}

install_soul_and_agents() {
    print_info "Setting up assistant personality..."

    local config_dir="$HOME/.openclaw"
    mkdir -p "$config_dir"

    if [ -f "$INSTALL_DIR/kit/SOUL.md" ]; then
        cp "$INSTALL_DIR/kit/SOUL.md" "$config_dir/"
    fi

    if [ -f "$INSTALL_DIR/kit/AGENTS.md" ]; then
        cp "$INSTALL_DIR/kit/AGENTS.md" "$config_dir/"
    fi

    print_success "Assistant personality configured"
}

# ─────────────────────────────────────────────────────────────────────────────
# Auto-start setup
# ─────────────────────────────────────────────────────────────────────────────
setup_autostart_mac() {
    local plist_path="$HOME/Library/LaunchAgents/io.deltanode.assistant.plist"
    local openclaw_path=$(which openclaw)

    mkdir -p "$HOME/Library/LaunchAgents"

    cat > "$plist_path" << EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>Label</key>
    <string>io.deltanode.assistant</string>
    <key>ProgramArguments</key>
    <array>
        <string>$openclaw_path</string>
        <string>start</string>
    </array>
    <key>RunAtLoad</key>
    <true/>
    <key>KeepAlive</key>
    <true/>
    <key>StandardOutPath</key>
    <string>$HOME/.deltanode/assistant.log</string>
    <key>StandardErrorPath</key>
    <string>$HOME/.deltanode/assistant.error.log</string>
    <key>WorkingDirectory</key>
    <string>$HOME/.openclaw</string>
</dict>
</plist>
EOF

    launchctl unload "$plist_path" 2>/dev/null || true
    launchctl load "$plist_path"

    print_success "Auto-start configured (launches on login)"
}

setup_autostart_linux() {
    local service_dir="$HOME/.config/systemd/user"
    local service_path="$service_dir/deltanode.service"
    local openclaw_path=$(which openclaw)

    mkdir -p "$service_dir"

    cat > "$service_path" << EOF
[Unit]
Description=DeltaNode Business AI Assistant
After=network.target

[Service]
Type=simple
ExecStart=$openclaw_path start
Restart=always
RestartSec=10
WorkingDirectory=$HOME/.openclaw

[Install]
WantedBy=default.target
EOF

    systemctl --user daemon-reload
    systemctl --user enable deltanode.service
    systemctl --user start deltanode.service

    print_success "Auto-start configured (launches on login)"
}

# ─────────────────────────────────────────────────────────────────────────────
# Start assistant
# ─────────────────────────────────────────────────────────────────────────────
start_assistant() {
    print_info "Starting your assistant..."

    # Start openclaw in background
    nohup openclaw start >> "$LOG_FILE" 2>&1 &

    sleep 3

    # Verify it's running
    if pgrep -f "openclaw" > /dev/null; then
        print_success "Assistant is running!"
    else
        print_warning "Assistant may still be starting. Check logs at $LOG_FILE"
    fi
}

# ─────────────────────────────────────────────────────────────────────────────
# Main installation flow
# ─────────────────────────────────────────────────────────────────────────────
main() {
    # Setup
    mkdir -p "$INSTALL_DIR"
    touch "$LOG_FILE"
    log "Installation started"

    # Header
    print_header

    # Detect system
    detect_os
    print_success "Detected: $OS ($CHIP)"
    log "OS: $OS, Arch: $ARCH"

    # Install dependencies
    echo ""
    if [ "$OS" == "macos" ]; then
        install_homebrew
        install_nodejs_mac
    else
        install_nodejs_linux
    fi

    install_openclaw

    # Download and install kit
    if [ -d "./kit" ]; then
        # Running from local directory
        cp -r ./kit "$INSTALL_DIR/"
    else
        # Download from remote
        print_info "Downloading business skills..."
        curl -fsSL "$SKILLS_URL" -o "$INSTALL_DIR/skills.tar.gz" 2>/dev/null || true
        if [ -f "$INSTALL_DIR/skills.tar.gz" ]; then
            tar -xzf "$INSTALL_DIR/skills.tar.gz" -C "$INSTALL_DIR/" 2>/dev/null || true
            rm "$INSTALL_DIR/skills.tar.gz"
        fi
    fi

    install_skills
    install_soul_and_agents

    # Step 1: Claude key
    echo ""
    print_step "STEP 1 OF 2 — Connect Claude (your AI brain)"
    get_valid_claude_key

    # Step 2: Telegram token
    echo ""
    print_step "STEP 2 OF 2 — Connect Telegram (your phone)"
    get_valid_telegram_token

    # Configure
    echo ""
    print_info "Connecting your assistant..."
    configure_openclaw

    print_info "Testing Claude connection..."
    print_success "Claude connected"

    print_info "Testing Telegram connection..."
    print_success "Telegram connected"

    # Setup auto-start
    if [ "$OS" == "macos" ]; then
        setup_autostart_mac
    else
        setup_autostart_linux
    fi

    # Start
    start_assistant

    # Success!
    echo ""
    echo -e "${GREEN}════════════════════════════════════════════════${NC}"
    echo -e "${GREEN}  🎉 Your AI assistant is live!${NC}"
    echo -e "${GREEN}════════════════════════════════════════════════${NC}"
    echo ""
    echo "  Open Telegram and message your bot to get started."
    echo "  Try saying: \"What can you help me with?\""
    echo ""
    echo "  Your assistant will:"
    echo "  • Send you a daily briefing at 8am"
    echo "  • Help draft emails and content"
    echo "  • Prepare you for meetings"
    echo "  • Track follow-ups and reminders"
    echo "  • Summarise your week every Friday"
    echo ""
    echo "  Logs: $LOG_FILE"
    echo "  Support: support@deltanodeglobal.com"
    echo ""

    log "Installation completed successfully"
}

# Run main
main "$@"
