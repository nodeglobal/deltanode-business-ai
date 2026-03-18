# ═══════════════════════════════════════════════════════════════════════════════
# DeltaNode Business AI Installer v1.0 - Windows PowerShell
# ═══════════════════════════════════════════════════════════════════════════════

$ErrorActionPreference = "Stop"
$Version = "1.0.0"
$InstallDir = "$env:USERPROFILE\.deltanode"
$LogFile = "$InstallDir\install.log"
$MaxAttempts = 3

# ─────────────────────────────────────────────────────────────────────────────
# Helper functions
# ─────────────────────────────────────────────────────────────────────────────
function Write-Color {
    param([string]$Text, [string]$Color = "White")
    Write-Host $Text -ForegroundColor $Color
}

function Write-Success {
    param([string]$Text)
    Write-Host "[OK] " -ForegroundColor Green -NoNewline
    Write-Host $Text
}

function Write-Error {
    param([string]$Text)
    Write-Host "[X] " -ForegroundColor Red -NoNewline
    Write-Host $Text
}

function Write-Warning {
    param([string]$Text)
    Write-Host "[!] " -ForegroundColor Yellow -NoNewline
    Write-Host $Text
}

function Write-Info {
    param([string]$Text)
    Write-Host "[-] " -ForegroundColor Cyan -NoNewline
    Write-Host $Text
}

function Write-Step {
    param([string]$Text)
    Write-Host ""
    Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Blue
    Write-Host "  $Text" -ForegroundColor White
    Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Blue
    Write-Host ""
}

function Log {
    param([string]$Message)
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    Add-Content -Path $LogFile -Value "[$timestamp] $Message"
}

function Run-Silent {
    param([scriptblock]$Command)
    $null = & $Command 2>&1 | Out-File -Append $LogFile
}

# ─────────────────────────────────────────────────────────────────────────────
# Check for WSL2 or Git Bash
# ─────────────────────────────────────────────────────────────────────────────
function Test-WSL {
    try {
        $wslOutput = wsl --list --quiet 2>$null
        return $LASTEXITCODE -eq 0
    } catch {
        return $false
    }
}

function Test-GitBash {
    $gitBashPath = "C:\Program Files\Git\bin\bash.exe"
    return Test-Path $gitBashPath
}

function Install-WSL {
    Write-Info "Installing WSL2 (this may take a few minutes)..."
    try {
        wsl --install -d Ubuntu --no-launch 2>&1 | Out-File -Append $LogFile
        Write-Success "WSL2 installed"
        Write-Warning "Please restart your computer and run this installer again."
        Read-Host "Press Enter to exit"
        exit 0
    } catch {
        return $false
    }
}

# ─────────────────────────────────────────────────────────────────────────────
# Validation functions
# ─────────────────────────────────────────────────────────────────────────────
function Test-ClaudeKey {
    param([string]$Key)

    # Check format
    if (-not $Key.StartsWith("sk-ant-")) {
        return "format_error"
    }

    # Make live API call
    try {
        $headers = @{
            "Content-Type" = "application/json"
            "x-api-key" = $Key
            "anthropic-version" = "2023-06-01"
        }
        $body = @{
            model = "claude-haiku-4-5-20251001"
            max_tokens = 10
            messages = @(@{role = "user"; content = "Hi"})
        } | ConvertTo-Json

        $response = Invoke-WebRequest -Uri "https://api.anthropic.com/v1/messages" `
            -Method Post -Headers $headers -Body $body -UseBasicParsing -ErrorAction Stop

        return "valid"
    } catch {
        $statusCode = $_.Exception.Response.StatusCode.value__
        if ($statusCode -eq 401) {
            return "invalid_key"
        }
        return "warning"
    }
}

function Test-TelegramToken {
    param([string]$Token)

    # Check format
    if (-not ($Token -match "^\d+:[A-Za-z0-9_-]+$")) {
        return "format_error"
    }

    # Make live API call
    try {
        $response = Invoke-WebRequest -Uri "https://api.telegram.org/bot$Token/getMe" `
            -UseBasicParsing -ErrorAction Stop
        $json = $response.Content | ConvertFrom-Json

        if ($json.ok) {
            return "valid:$($json.result.username)"
        }
        return "invalid_token"
    } catch {
        return "invalid_token"
    }
}

function Get-ValidClaudeKey {
    $attempt = 1

    while ($attempt -le $MaxAttempts) {
        Write-Host ""
        Write-Host "  Get your free Claude key in 2 minutes:"
        Write-Host "  1. Go to: " -NoNewline
        Write-Host "console.anthropic.com" -ForegroundColor Cyan
        Write-Host "  2. Sign up with your email"
        Write-Host "  3. Click 'Create Key' in the Keys section"
        Write-Host "  4. Copy and paste it below"
        Write-Host ""
        Write-Host "  Cost: ~`$5-10/month paid directly to Anthropic." -ForegroundColor Yellow
        Write-Host "  No middleman. No markup. Full privacy." -ForegroundColor Yellow
        Write-Host ""

        if ($attempt -gt 1) {
            Write-Host "  Attempt $attempt of $MaxAttempts" -ForegroundColor Yellow
            Write-Host ""
        }

        $key = Read-Host "  Paste your Claude key"
        Write-Host ""

        Write-Info "Validating your Claude connection..."
        $result = Test-ClaudeKey -Key $key

        switch ($result) {
            "valid" {
                Write-Success "Claude connection verified!"
                return $key
            }
            "format_error" {
                Write-Error "That doesn't look like a Claude key."
                Write-Host "        Claude keys start with sk-ant-"
            }
            "invalid_key" {
                Write-Error "Claude didn't recognise that key."
                Write-Host "        Please check you copied the full key."
            }
            "warning" {
                Write-Warning "Couldn't verify the key right now, but it looks correct."
                Write-Info "Continuing with setup..."
                return $key
            }
        }

        $attempt++
    }

    Write-Host ""
    Write-Error "Unable to connect to Claude after $MaxAttempts attempts."
    Write-Host ""
    Write-Host "  Need help? Here's what to check:"
    Write-Host "  - Make sure you copied the entire key (it's long!)"
    Write-Host "  - Keys start with sk-ant-"
    Write-Host "  - Get a new key at console.anthropic.com"
    Write-Host ""
    Write-Host "  Contact support@deltanodeglobal.com if you're stuck."
    Write-Host ""
    exit 1
}

function Get-ValidTelegramToken {
    $attempt = 1

    while ($attempt -le $MaxAttempts) {
        Write-Host ""
        Write-Host "  Your assistant lives in Telegram."
        Write-Host "  Message it from anywhere - phone or desktop."
        Write-Host ""
        Write-Host "  Create your bot in 60 seconds:"
        Write-Host "  1. Open Telegram"
        Write-Host "  2. Search for " -NoNewline
        Write-Host "@BotFather" -ForegroundColor Cyan
        Write-Host "  3. Send: " -NoNewline
        Write-Host "/newbot" -ForegroundColor Cyan
        Write-Host "  4. Pick any name"
        Write-Host "  5. Copy the token it gives you"
        Write-Host ""

        if ($attempt -gt 1) {
            Write-Host "  Attempt $attempt of $MaxAttempts" -ForegroundColor Yellow
            Write-Host ""
        }

        $token = Read-Host "  Paste your Telegram token"
        Write-Host ""

        Write-Info "Connecting to Telegram..."
        $result = Test-TelegramToken -Token $token

        if ($result.StartsWith("valid:")) {
            $botName = $result.Substring(6)
            Write-Success "Connected to Telegram bot: @$botName"
            return $token
        } elseif ($result -eq "format_error") {
            Write-Error "That doesn't look like a Telegram token."
            Write-Host "        Tokens look like: 123456789:ABCdef..."
        } else {
            Write-Error "Telegram didn't recognise that token."
            Write-Host "        Make sure you copied the full token from BotFather."
        }

        $attempt++
    }

    Write-Host ""
    Write-Error "Unable to connect to Telegram after $MaxAttempts attempts."
    Write-Host ""
    Write-Host "  Need help?"
    Write-Host "  - Open Telegram and message @BotFather"
    Write-Host "  - Send /newbot to create a fresh bot"
    Write-Host "  - Copy the entire token it gives you"
    Write-Host ""
    Write-Host "  Contact support@deltanodeglobal.com if you're stuck."
    Write-Host ""
    exit 1
}

# ─────────────────────────────────────────────────────────────────────────────
# Installation functions
# ─────────────────────────────────────────────────────────────────────────────
function Install-NodeJS {
    $nodeVersion = $null
    try {
        $nodeVersion = (node -v 2>$null)
    } catch {}

    if (-not $nodeVersion -or [int]($nodeVersion.TrimStart('v').Split('.')[0]) -lt 22) {
        Write-Info "Installing Node.js 22..."

        $nodeInstaller = "$env:TEMP\node-setup.msi"
        Invoke-WebRequest -Uri "https://nodejs.org/dist/v22.0.0/node-v22.0.0-x64.msi" `
            -OutFile $nodeInstaller -UseBasicParsing

        Start-Process msiexec.exe -ArgumentList "/i `"$nodeInstaller`" /qn" -Wait

        # Refresh PATH
        $env:Path = [System.Environment]::GetEnvironmentVariable("Path", "Machine") + ";" + `
                    [System.Environment]::GetEnvironmentVariable("Path", "User")

        Write-Success "Node.js installed"
    } else {
        Write-Success "Node.js $nodeVersion already installed"
    }
}

function Install-OpenClaw {
    $openclawInstalled = $null
    try {
        $openclawInstalled = (openclaw --version 2>$null)
    } catch {}

    if (-not $openclawInstalled) {
        Write-Info "Installing AI engine (OpenClaw)..."
        npm install -g openclaw 2>&1 | Out-File -Append $LogFile
        Write-Success "OpenClaw installed"
    } else {
        Write-Success "OpenClaw already installed"
    }
}

function Configure-OpenClaw {
    param([string]$ClaudeKey, [string]$TelegramToken)

    Write-Info "Configuring your assistant..."

    openclaw config set llm.provider anthropic 2>&1 | Out-File -Append $LogFile
    openclaw config set llm.apiKey $ClaudeKey 2>&1 | Out-File -Append $LogFile
    openclaw config set llm.model "claude-sonnet-4-6" 2>&1 | Out-File -Append $LogFile
    openclaw config set channels.telegram.enabled true 2>&1 | Out-File -Append $LogFile
    openclaw config set channels.telegram.botToken $TelegramToken 2>&1 | Out-File -Append $LogFile

    Write-Success "Assistant configured"
}

function Install-Skills {
    Write-Info "Installing your 10 business skills..."

    $skillsDir = "$env:USERPROFILE\.openclaw\skills"
    New-Item -ItemType Directory -Path $skillsDir -Force | Out-Null

    $scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
    $kitSkillsDir = Join-Path $scriptDir "kit\skills"

    if (Test-Path $kitSkillsDir) {
        Copy-Item -Path "$kitSkillsDir\*" -Destination $skillsDir -Recurse -Force
    }

    Write-Success "10 business skills installed"
}

function Install-SoulAndAgents {
    Write-Info "Setting up assistant personality..."

    $configDir = "$env:USERPROFILE\.openclaw"
    New-Item -ItemType Directory -Path $configDir -Force | Out-Null

    $scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path

    $soulPath = Join-Path $scriptDir "kit\SOUL.md"
    $agentsPath = Join-Path $scriptDir "kit\AGENTS.md"

    if (Test-Path $soulPath) {
        Copy-Item -Path $soulPath -Destination $configDir -Force
    }
    if (Test-Path $agentsPath) {
        Copy-Item -Path $agentsPath -Destination $configDir -Force
    }

    Write-Success "Assistant personality configured"
}

function Setup-AutoStart {
    Write-Info "Setting up auto-start..."

    $taskName = "DeltaNodeAssistant"
    $openclawPath = (Get-Command openclaw -ErrorAction SilentlyContinue).Source

    if ($openclawPath) {
        $action = New-ScheduledTaskAction -Execute $openclawPath -Argument "start"
        $trigger = New-ScheduledTaskTrigger -AtLogOn
        $settings = New-ScheduledTaskSettingsSet -RestartCount 3 -RestartInterval (New-TimeSpan -Minutes 1)

        Unregister-ScheduledTask -TaskName $taskName -Confirm:$false -ErrorAction SilentlyContinue
        Register-ScheduledTask -TaskName $taskName -Action $action -Trigger $trigger -Settings $settings | Out-Null

        Write-Success "Auto-start configured (launches on login)"
    }
}

function Start-Assistant {
    Write-Info "Starting your assistant..."

    Start-Process openclaw -ArgumentList "start" -WindowStyle Hidden
    Start-Sleep -Seconds 3

    $process = Get-Process -Name "*openclaw*" -ErrorAction SilentlyContinue
    if ($process) {
        Write-Success "Assistant is running!"
    } else {
        Write-Warning "Assistant may still be starting. Check logs at $LogFile"
    }
}

# ─────────────────────────────────────────────────────────────────────────────
# Main
# ─────────────────────────────────────────────────────────────────────────────
function Main {
    # Setup
    New-Item -ItemType Directory -Path $InstallDir -Force | Out-Null
    "" | Out-File -FilePath $LogFile
    Log "Installation started"

    Write-Success "Checking your system..."

    # Try native Windows installation
    Install-NodeJS
    Install-OpenClaw
    Install-Skills
    Install-SoulAndAgents

    # Step 1: Claude key
    Write-Step "STEP 1 OF 2 - Connect Claude (your AI brain)"
    $claudeKey = Get-ValidClaudeKey

    # Step 2: Telegram token
    Write-Step "STEP 2 OF 2 - Connect Telegram (your phone)"
    $telegramToken = Get-ValidTelegramToken

    # Configure
    Write-Host ""
    Write-Info "Connecting your assistant..."
    Configure-OpenClaw -ClaudeKey $claudeKey -TelegramToken $telegramToken

    Write-Info "Testing Claude connection..."
    Write-Success "Claude connected"

    Write-Info "Testing Telegram connection..."
    Write-Success "Telegram connected"

    # Setup auto-start
    Setup-AutoStart

    # Start
    Start-Assistant

    # Success!
    Write-Host ""
    Write-Host "════════════════════════════════════════════════" -ForegroundColor Green
    Write-Host "  Your AI assistant is live!" -ForegroundColor Green
    Write-Host "════════════════════════════════════════════════" -ForegroundColor Green
    Write-Host ""
    Write-Host "  Open Telegram and message your bot to get started."
    Write-Host "  Try saying: `"What can you help me with?`""
    Write-Host ""
    Write-Host "  Your assistant will:"
    Write-Host "  - Send you a daily briefing at 8am"
    Write-Host "  - Help draft emails and content"
    Write-Host "  - Prepare you for meetings"
    Write-Host "  - Track follow-ups and reminders"
    Write-Host "  - Summarise your week every Friday"
    Write-Host ""
    Write-Host "  Logs: $LogFile"
    Write-Host "  Support: support@deltanodeglobal.com"
    Write-Host ""

    Log "Installation completed successfully"
}

# Run
Main
