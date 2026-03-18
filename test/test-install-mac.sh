#!/usr/bin/env bash
# ═══════════════════════════════════════════════════════════════════════════════
# DeltaNode Business AI - Installation Test Suite (Mac/Linux)
# ═══════════════════════════════════════════════════════════════════════════════

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

TESTS_PASSED=0
TESTS_FAILED=0

# ─────────────────────────────────────────────────────────────────────────────
# Test helpers
# ─────────────────────────────────────────────────────────────────────────────
pass() {
    echo -e "${GREEN}✓ PASS:${NC} $1"
    TESTS_PASSED=$((TESTS_PASSED + 1))
}

fail() {
    echo -e "${RED}✗ FAIL:${NC} $1"
    TESTS_FAILED=$((TESTS_FAILED + 1))
}

warn() {
    echo -e "${YELLOW}! WARN:${NC} $1"
}

header() {
    echo ""
    echo "═══════════════════════════════════════════════════════════════════"
    echo " $1"
    echo "═══════════════════════════════════════════════════════════════════"
    echo ""
}

# ─────────────────────────────────────────────────────────────────────────────
# Tests
# ─────────────────────────────────────────────────────────────────────────────
test_install_script_exists() {
    if [ -f "../install.sh" ]; then
        pass "install.sh exists"
    else
        fail "install.sh not found"
    fi
}

test_install_script_executable() {
    if [ -x "../install.sh" ]; then
        pass "install.sh is executable"
    else
        chmod +x ../install.sh 2>/dev/null
        if [ -x "../install.sh" ]; then
            pass "install.sh made executable"
        else
            fail "install.sh cannot be made executable"
        fi
    fi
}

test_install_script_syntax() {
    if bash -n ../install.sh 2>/dev/null; then
        pass "install.sh has valid bash syntax"
    else
        fail "install.sh has syntax errors"
    fi
}

test_node_installed() {
    if command -v node &> /dev/null; then
        local version=$(node -v)
        pass "Node.js installed: $version"
    else
        fail "Node.js not installed"
    fi
}

test_node_version() {
    if command -v node &> /dev/null; then
        local major=$(node -v | cut -d'.' -f1 | tr -d 'v')
        if [ "$major" -ge 22 ]; then
            pass "Node.js version >= 22"
        else
            warn "Node.js version < 22 (found: $(node -v))"
        fi
    fi
}

test_openclaw_installed() {
    if command -v openclaw &> /dev/null; then
        pass "OpenClaw installed"
    else
        warn "OpenClaw not installed (will be installed during setup)"
    fi
}

test_skills_present() {
    local skills_dir="../kit/skills"
    local required_skills=(
        "daily-briefing"
        "email-drafter"
        "meeting-prep"
        "research"
        "content-writer"
        "invoice-chaser"
        "decision-helper"
        "follow-up"
        "weekly-summary"
        "skill-builder"
    )

    local all_present=true
    for skill in "${required_skills[@]}"; do
        if [ -f "$skills_dir/$skill/SKILL.md" ]; then
            pass "Skill present: $skill"
        else
            fail "Skill missing: $skill"
            all_present=false
        fi
    done

    if $all_present; then
        pass "All 10 skills present"
    fi
}

test_soul_present() {
    if [ -f "../kit/SOUL.md" ]; then
        pass "SOUL.md present"

        # Check it has required sections
        if grep -q "## Identity" ../kit/SOUL.md && \
           grep -q "## Personality" ../kit/SOUL.md && \
           grep -q "## First Interaction" ../kit/SOUL.md; then
            pass "SOUL.md has required sections"
        else
            fail "SOUL.md missing required sections"
        fi
    else
        fail "SOUL.md not found"
    fi
}

test_agents_present() {
    if [ -f "../kit/AGENTS.md" ]; then
        pass "AGENTS.md present"

        # Check it has required sections
        if grep -q "llm:" ../kit/AGENTS.md && \
           grep -q "channels:" ../kit/AGENTS.md && \
           grep -q "memory:" ../kit/AGENTS.md; then
            pass "AGENTS.md has required sections"
        else
            fail "AGENTS.md missing required sections"
        fi
    else
        fail "AGENTS.md not found"
    fi
}

test_autostart_mac() {
    if [[ "$OSTYPE" == "darwin"* ]]; then
        local plist_path="$HOME/Library/LaunchAgents/io.deltanode.assistant.plist"
        if [ -f "$plist_path" ]; then
            pass "macOS LaunchAgent plist exists"

            if grep -q "RunAtLoad" "$plist_path" && grep -q "KeepAlive" "$plist_path"; then
                pass "LaunchAgent has RunAtLoad and KeepAlive"
            else
                fail "LaunchAgent missing RunAtLoad or KeepAlive"
            fi
        else
            warn "LaunchAgent not yet created (created during installation)"
        fi
    fi
}

test_autostart_linux() {
    if [[ "$OSTYPE" == "linux-gnu"* ]]; then
        local service_path="$HOME/.config/systemd/user/deltanode.service"
        if [ -f "$service_path" ]; then
            pass "Linux systemd service exists"

            if grep -q "Restart=always" "$service_path"; then
                pass "Systemd service has Restart=always"
            else
                fail "Systemd service missing Restart=always"
            fi
        else
            warn "Systemd service not yet created (created during installation)"
        fi
    fi
}

test_openclaw_running() {
    if pgrep -f "openclaw" > /dev/null; then
        pass "OpenClaw process is running"
    else
        warn "OpenClaw not running (starts after installation)"
    fi
}

test_log_directory() {
    local log_dir="$HOME/.deltanode"
    if [ -d "$log_dir" ]; then
        pass "Log directory exists: $log_dir"
    else
        warn "Log directory not yet created"
    fi
}

test_windows_files_present() {
    if [ -f "../install.bat" ]; then
        pass "install.bat present"
    else
        fail "install.bat not found"
    fi

    if [ -f "../install.ps1" ]; then
        pass "install.ps1 present"
    else
        fail "install.ps1 not found"
    fi
}

test_readme_present() {
    if [ -f "../README.md" ]; then
        pass "README.md present"
    else
        fail "README.md not found"
    fi
}

# ─────────────────────────────────────────────────────────────────────────────
# Run all tests
# ─────────────────────────────────────────────────────────────────────────────
main() {
    header "DeltaNode Business AI - Test Suite"

    echo "Testing on: $(uname -s) $(uname -m)"
    echo ""

    header "1. Installation Files"
    test_install_script_exists
    test_install_script_executable
    test_install_script_syntax
    test_windows_files_present
    test_readme_present

    header "2. Dependencies"
    test_node_installed
    test_node_version
    test_openclaw_installed

    header "3. Skills"
    test_skills_present

    header "4. Configuration Files"
    test_soul_present
    test_agents_present

    header "5. Auto-Start Configuration"
    test_autostart_mac
    test_autostart_linux

    header "6. Runtime"
    test_openclaw_running
    test_log_directory

    # Summary
    header "Test Summary"
    echo -e "${GREEN}Passed: $TESTS_PASSED${NC}"
    echo -e "${RED}Failed: $TESTS_FAILED${NC}"
    echo ""

    if [ $TESTS_FAILED -eq 0 ]; then
        echo -e "${GREEN}All tests passed!${NC}"
        exit 0
    else
        echo -e "${RED}Some tests failed. Review the output above.${NC}"
        exit 1
    fi
}

# Run
cd "$(dirname "$0")"
main
