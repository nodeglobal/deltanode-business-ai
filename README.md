# DeltaNode Business AI

Your AI business assistant. Zero config. Zero backend. Zero monthly cost to you.

## What Is This?

DeltaNode Business AI is a one-command installer that sets up a fully configured AI assistant powered by Claude. Users run one command, answer two questions, and get a working AI assistant in Telegram.

### What Users Get
- **Daily briefings** at 8am with their day's priorities
- **Email drafting** with tone control and revisions
- **Meeting prep** with agendas, questions, and talking points
- **Research reports** synthesised and formatted
- **Content writing** for LinkedIn, blogs, newsletters
- **Invoice chasing** with escalating templates
- **Decision support** with structured pros/cons analysis
- **Follow-up tracking** with scheduled reminders
- **Weekly summaries** every Friday at 6pm
- **Custom skills** they can create themselves

### User Cost
- **Your product:** One-time purchase (recommended: $197)
- **Claude API:** ~$5-10/month paid directly to Anthropic
- **Telegram:** Free

## Installation

### Mac/Linux
```bash
curl -fsSL https://deltanode.io/install.sh | bash
```

### Windows
Download and double-click `DeltaNode-Install.bat`

## Hosting the Installer

### Option 1: Cloudflare Pages (Recommended)

1. Create a GitHub repo with these files:
   ```
   /install.sh
   /kit/skills.tar.gz    (created from kit/ folder)
   /install.bat
   /install.ps1
   ```

2. Connect to Cloudflare Pages

3. Set custom domain: `deltanode.io`

4. Update `install.sh` SKILLS_URL to: `https://deltanode.io/kit/skills.tar.gz`

### Option 2: GitHub Releases

1. Create a release on GitHub

2. Upload:
   - `install.sh`
   - `install.bat`
   - `install.ps1`
   - `skills.tar.gz`

3. Update installer URLs to raw GitHub release URLs

### Creating skills.tar.gz

```bash
cd kit
tar -czvf skills.tar.gz skills/ SOUL.md AGENTS.md
```

## Updating Skills

To push skill updates to all users:

1. Edit skill files in `kit/skills/`
2. Recreate `skills.tar.gz`
3. Upload to your hosting
4. Users get updates on next install or when they run:
   ```bash
   curl -fsSL https://deltanode.io/update-skills.sh | bash
   ```

## File Structure

```
deltanode-business-ai/
├── install.sh              # Mac/Linux installer
├── install.bat             # Windows launcher
├── install.ps1             # Windows PowerShell installer
├── kit/
│   ├── SOUL.md             # Assistant personality
│   ├── AGENTS.md           # Agent configuration
│   └── skills/
│       ├── daily-briefing/SKILL.md
│       ├── email-drafter/SKILL.md
│       ├── meeting-prep/SKILL.md
│       ├── research/SKILL.md
│       ├── content-writer/SKILL.md
│       ├── invoice-chaser/SKILL.md
│       ├── decision-helper/SKILL.md
│       ├── follow-up/SKILL.md
│       ├── weekly-summary/SKILL.md
│       └── skill-builder/SKILL.md
├── test/
│   ├── test-install-mac.sh
│   └── test-invalid-inputs.sh
└── README.md
```

## Technical Details

### Dependencies
- **Node.js 22+**: Installed automatically
- **OpenClaw**: AI agent framework, installed automatically
- **Homebrew** (Mac only): Installed automatically if missing

### Auto-Start
- **Mac**: LaunchAgent at `~/Library/LaunchAgents/io.deltanode.assistant.plist`
- **Linux**: Systemd user service at `~/.config/systemd/user/deltanode.service`
- **Windows**: Task Scheduler task "DeltaNodeAssistant"

### Logs
- Install log: `~/.deltanode/install.log`
- Runtime log: `~/.deltanode/assistant.log`
- Error log: `~/.deltanode/assistant.error.log`

### Memory
- Stored at: `~/.openclaw/memory/`
- Format: JSON
- Persists across sessions

## Pricing Recommendation

**$197 one-time payment**

Positioning:
- "Your AI business assistant, forever"
- "No subscriptions. No monthly fees. One payment."
- "Claude API costs ~$5-10/month paid directly to Anthropic—no markup from us."

Why this works:
- High enough to signal quality
- Low enough for impulse business purchase
- One-time removes subscription fatigue
- Transparent about Claude costs builds trust

## Support

- **Email:** support@deltanodeglobal.com
- **Documentation:** https://deltanode.io/docs
- **Issues:** Submit via email with logs from `~/.deltanode/`

## License

Proprietary. All rights reserved by DeltaNode Global.

---

Built with ❤️ by DeltaNode Global
