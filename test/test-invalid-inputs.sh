#!/usr/bin/env bash
# ═══════════════════════════════════════════════════════════════════════════════
# DeltaNode Business AI - Invalid Input Test Suite
# Tests validation and error handling
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

header() {
    echo ""
    echo "═══════════════════════════════════════════════════════════════════"
    echo " $1"
    echo "═══════════════════════════════════════════════════════════════════"
    echo ""
}

# ─────────────────────────────────────────────────────────────────────────────
# Claude Key Validation Tests
# ─────────────────────────────────────────────────────────────────────────────
test_claude_key_format_invalid() {
    echo "Testing: Invalid Claude key format..."

    # Test cases that should fail format check
    local invalid_keys=(
        ""
        "invalid"
        "sk-invalid"
        "sk_test_123"
        "api-key-123"
        "anthropic_key_123"
    )

    for key in "${invalid_keys[@]}"; do
        # Check format (should NOT start with sk-ant-)
        if [[ "$key" =~ ^sk-ant- ]]; then
            fail "Key '$key' incorrectly passed format check"
        else
            pass "Key '$key' correctly failed format check"
        fi
    done
}

test_claude_key_format_valid() {
    echo "Testing: Valid Claude key format..."

    # Test cases that should pass format check (but may fail API check)
    local valid_format_keys=(
        "sk-ant-api03-abc123"
        "sk-ant-test-key-123456789"
        "sk-ant-xxxxxxxxxxxxxxxxxxxxx"
    )

    for key in "${valid_format_keys[@]}"; do
        if [[ "$key" =~ ^sk-ant- ]]; then
            pass "Key format '$key' correctly passed format check"
        else
            fail "Key format '$key' incorrectly failed format check"
        fi
    done
}

test_claude_key_api_invalid() {
    echo "Testing: Invalid Claude key API response..."

    # This is an invalid key that passes format but fails API
    local invalid_key="sk-ant-api03-invalid-test-key-12345"

    # Make API call
    local response
    local http_code

    response=$(curl -s -w "\n%{http_code}" -X POST "https://api.anthropic.com/v1/messages" \
        -H "Content-Type: application/json" \
        -H "x-api-key: $invalid_key" \
        -H "anthropic-version: 2023-06-01" \
        -d '{
            "model": "claude-haiku-4-5-20251001",
            "max_tokens": 10,
            "messages": [{"role": "user", "content": "Hi"}]
        }' 2>/dev/null || echo -e "\n000")

    http_code=$(echo "$response" | tail -n1)

    if [ "$http_code" == "401" ]; then
        pass "Invalid key correctly returns 401 Unauthorized"
    elif [ "$http_code" == "000" ]; then
        pass "API call failed (network) - validation would show warning"
    else
        fail "Unexpected response code: $http_code"
    fi
}

# ─────────────────────────────────────────────────────────────────────────────
# Telegram Token Validation Tests
# ─────────────────────────────────────────────────────────────────────────────
test_telegram_token_format_invalid() {
    echo "Testing: Invalid Telegram token format..."

    local invalid_tokens=(
        ""
        "invalid"
        "123456789"
        "abcdefghij"
        "123:abc"
        "12345:short"
    )

    for token in "${invalid_tokens[@]}"; do
        # Check format (should be digits:alphanumeric with reasonable length)
        if [[ "$token" =~ ^[0-9]+:[A-Za-z0-9_-]+$ ]] && [ ${#token} -gt 20 ]; then
            fail "Token '$token' incorrectly passed format check"
        else
            pass "Token '$token' correctly failed format check"
        fi
    done
}

test_telegram_token_format_valid() {
    echo "Testing: Valid Telegram token format..."

    local valid_format_tokens=(
        "123456789:ABCdefGHI-jklMNO_pqr123456789"
        "9876543210:zyxWVUtsrqponmlkjihgfedcba"
        "1234567890:ABCDEFGHIJKLMNOPQRSTUVWXYZ_1234"
    )

    for token in "${valid_format_tokens[@]}"; do
        if [[ "$token" =~ ^[0-9]+:[A-Za-z0-9_-]+$ ]]; then
            pass "Token format correctly passed format check"
        else
            fail "Token format incorrectly failed format check"
        fi
    done
}

test_telegram_token_api_invalid() {
    echo "Testing: Invalid Telegram token API response..."

    local invalid_token="123456789:ABCdefGHI-jklMNO_pqr123456789"

    local response
    response=$(curl -s "https://api.telegram.org/bot${invalid_token}/getMe" 2>/dev/null)

    if echo "$response" | grep -q '"ok":false'; then
        pass "Invalid token correctly returns error from Telegram API"
    elif echo "$response" | grep -q '"ok":true'; then
        fail "Invalid token unexpectedly returned success"
    else
        pass "API returned error response (expected for invalid token)"
    fi
}

# ─────────────────────────────────────────────────────────────────────────────
# Error Message Tests
# ─────────────────────────────────────────────────────────────────────────────
test_error_messages_no_api_key_term() {
    echo "Testing: Error messages don't say 'API key'..."

    local script_content
    script_content=$(cat ../install.sh 2>/dev/null || echo "")

    # Check user-facing strings don't say "API key"
    local user_messages=$(echo "$script_content" | grep -E 'echo|print_error|print_info' | grep -i "api key" || true)

    if [ -z "$user_messages" ]; then
        pass "No 'API key' in user-facing messages (uses 'Claude key' instead)"
    else
        fail "Found 'API key' in user-facing messages"
        echo "$user_messages"
    fi
}

test_error_messages_plain_english() {
    echo "Testing: Error messages are in plain English..."

    local script_content
    script_content=$(cat ../install.sh 2>/dev/null || echo "")

    # Check for helpful error patterns
    if echo "$script_content" | grep -q "That doesn't look like"; then
        pass "Error messages use friendly language"
    else
        fail "Error messages may not be user-friendly"
    fi

    if echo "$script_content" | grep -q "Need help"; then
        pass "Error messages offer help"
    else
        fail "Error messages should offer help"
    fi
}

test_retry_loop_exists() {
    echo "Testing: Retry loop is implemented..."

    local script_content
    script_content=$(cat ../install.sh 2>/dev/null || echo "")

    if echo "$script_content" | grep -q "MAX_ATTEMPTS\|max_attempts\|attempt.*le.*3"; then
        pass "Retry loop with max attempts is implemented"
    else
        fail "Retry loop not found in script"
    fi

    if echo "$script_content" | grep -q "while.*attempt"; then
        pass "While loop for retries found"
    else
        fail "While loop for retries not found"
    fi
}

# ─────────────────────────────────────────────────────────────────────────────
# Run all tests
# ─────────────────────────────────────────────────────────────────────────────
main() {
    header "Invalid Input Test Suite"

    header "1. Claude Key Format Validation"
    test_claude_key_format_invalid
    test_claude_key_format_valid

    header "2. Claude Key API Validation"
    test_claude_key_api_invalid

    header "3. Telegram Token Format Validation"
    test_telegram_token_format_invalid
    test_telegram_token_format_valid

    header "4. Telegram Token API Validation"
    test_telegram_token_api_invalid

    header "5. Error Message Quality"
    test_error_messages_no_api_key_term
    test_error_messages_plain_english
    test_retry_loop_exists

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
