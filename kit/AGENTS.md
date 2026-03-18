# DeltaNode Business AI — Agent Configuration

## Model Configuration

```yaml
llm:
  provider: anthropic
  model: claude-sonnet-4-6
  temperature: 0.7
  max_tokens: 4096
  timeout: 60000
```

## Context Management

```yaml
context:
  # Keep last 50 messages in conversation history
  max_messages: 50

  # Summarise older context when approaching limit
  auto_summarise: true
  summarise_threshold: 40

  # Include relevant memory in each request
  include_memory: true
  memory_items_limit: 10
```

## Skills Configuration

```yaml
skills:
  # Load skills from default directory
  directory: ~/.openclaw/skills/

  # Also load custom user-created skills
  custom_directory: ~/.openclaw/skills/custom/

  # Auto-reload skills when files change
  watch: true

  # Skills are loaded at startup
  preload: true
```

## Channel Configuration

```yaml
channels:
  telegram:
    enabled: true
    # Bot token set during installation
    botToken: ${TELEGRAM_BOT_TOKEN}

    # Webhook or polling
    mode: polling

    # Only respond to these user IDs (empty = respond to all)
    allowedUsers: []

    # Rate limiting
    maxMessagesPerMinute: 30
```

## Scheduled Tasks

```yaml
schedule:
  daily_briefing:
    cron: "0 8 * * *"
    timezone: user_local
    skill: daily-briefing

  weekly_summary:
    cron: "0 18 * * 5"
    timezone: user_local
    skill: weekly-summary

  # Check for due reminders every 5 minutes
  reminder_check:
    cron: "*/5 * * * *"
    action: check_reminders
```

## Memory Configuration

```yaml
memory:
  # Storage location
  directory: ~/.openclaw/memory/

  # Storage format
  format: json

  # Persist across sessions
  persistent: true

  # Memory types
  types:
    - user_profile      # Name, business, preferences
    - projects          # Active projects and context
    - follow_ups        # Scheduled reminders
    - decisions         # Past decisions for reference
    - patterns          # Learned user patterns
    - weekly_summaries  # Archive of weekly summaries

  # Auto-cleanup old memory
  retention:
    follow_ups: 90d     # Keep completed follow-ups for 90 days
    decisions: 365d     # Keep decisions for a year
    patterns: forever   # Never delete learned patterns
```

## Security Configuration

```yaml
security:
  # Never execute shell commands without explicit confirmation
  require_confirmation:
    - shell_commands
    - file_deletion
    - external_api_calls
    - sending_messages

  # Restrict file access to user's workspace
  allowed_paths:
    - ~/.openclaw/
    - ~/Documents/
    - ~/Desktop/

  # Block access to sensitive paths
  blocked_paths:
    - ~/.ssh/
    - ~/.aws/
    - ~/.config/
    - /etc/
    - /var/

  # Log all actions
  logging:
    enabled: true
    path: ~/.openclaw/logs/
    level: info
    retain_days: 30
```

## Behaviour Rules

```yaml
behaviour:
  # Always confirm before taking actions with side effects
  confirm_before_action: true

  # Show thinking/reasoning for complex decisions
  show_reasoning: true

  # Proactively suggest follow-ups
  suggest_followups: true

  # Learn from user corrections
  learn_from_feedback: true

  # Maximum retries for failed operations
  max_retries: 3
```

## Error Handling

```yaml
errors:
  # User-friendly error messages
  friendly_messages: true

  # Never show raw technical errors
  hide_technical_details: true

  # Suggest next steps on error
  suggest_recovery: true

  # Log errors for debugging
  log_errors: true
```

## Performance

```yaml
performance:
  # Request timeout
  timeout: 60000

  # Retry on transient failures
  retry:
    enabled: true
    max_attempts: 3
    backoff: exponential

  # Cache frequently used data
  cache:
    enabled: true
    ttl: 3600
```

## Startup Checklist

On startup, verify:
1. ✅ Claude connection is valid
2. ✅ Telegram bot is responsive
3. ✅ All skills are loaded
4. ✅ Memory directory exists and is writable
5. ✅ Scheduled tasks are registered
6. ✅ Logging is configured

If any check fails, log the error and notify user on first message.
