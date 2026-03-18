# Skill Builder

## Triggers
- "create a skill"
- "teach you something"
- "I need you to always"
- "add a new skill"
- "can you learn to"
- "make a skill for"

## Behavior
1. Ask what the skill should do
2. Ask when/how it should be triggered
3. Ask what the output should look like
4. Generate a complete SKILL.md file
5. Save to ~/.openclaw/skills/custom/[skill-name]/
6. Confirm skill is active and suggest a test prompt

## Output Format

### Discovery Questions
```
I'll help you create a new skill. Let me understand what you need:

1. **What should this skill do?**
   (e.g., "Generate social media posts for product launches")

2. **When should I activate it?**
   (e.g., "When you say 'launch post' or 'product announcement'")

3. **What should the output look like?**
   (e.g., "A LinkedIn post, a tweet, and an email announcement")

4. **Any specific rules or format?**
   (e.g., "Always include 3 hashtags, keep LinkedIn under 300 words")
```

### Generated Skill Confirmation
```
✅ **New skill created: [Skill Name]**

**Saved to:** ~/.openclaw/skills/custom/[skill-name]/SKILL.md

**Triggers:**
- "[trigger 1]"
- "[trigger 2]"
- "[trigger 3]"

**What it does:**
[Description]

**Test it now by saying:**
"[example trigger phrase]"
```

## Generated SKILL.md Template
```markdown
# [Skill Name]

## Triggers
- "[trigger 1]"
- "[trigger 2]"
- "[trigger 3]"

## Behavior
1. [Step 1]
2. [Step 2]
3. [Step 3]

## Output Format
[Defined format based on user requirements]

## Rules
- [Rule 1]
- [Rule 2]

## Memory Access
- Read: [what it needs to read]
- Write: [what it stores]

## Example
**User:** [example input]
**Assistant:** [example output]
```

## Memory Access
- Read: existing skills, user preferences
- Write: new skill files to custom skills directory

## Example Interaction
**User:** I need you to always generate a daily standup update in a specific format

**Assistant:** I'll create a skill for that. Let me understand exactly what you need:

1. **When should I generate this?**
   - Automatically at a certain time?
   - When you say specific words?

2. **What format do you use for standup?**
   - The classic "Yesterday/Today/Blockers"?
   - Something different?

3. **Where does this standup go?**
   - Slack?
   - Email?
   - Just for your reference?

**User:** When I say "standup" or "daily update". Use yesterday/today/blockers format. It's for Slack.

**Assistant:** Got it. One more question: should I ask you questions to fill in the details, or should I generate it based on what we discussed this week?

**User:** Generate it from our conversations, but let me edit before sending.

**Assistant:**
✅ **New skill created: Daily Standup**

**Saved to:** ~/.openclaw/skills/custom/daily-standup/SKILL.md

**Triggers:**
- "standup"
- "daily update"
- "standup update"

**What it does:**
Reviews our recent conversations and generates a standup update in Yesterday/Today/Blockers format, optimised for Slack. Shows you the draft for editing before you paste it.

**Test it now by saying:**
"standup"

---

Here's the skill file I created:

```markdown
# Daily Standup

## Triggers
- "standup"
- "daily update"
- "standup update"
- "generate my standup"

## Behavior
1. Review conversations from yesterday and today
2. Identify completed work for "Yesterday"
3. Identify planned/discussed work for "Today"
4. Note any mentioned blockers or concerns
5. Format for Slack (with emoji)
6. Present draft for user to edit/approve

## Output Format
**Yesterday:**
• [completed item 1]
• [completed item 2]

**Today:**
• [planned item 1]
• [planned item 2]

**Blockers:**
• [blocker or "None! 🟢"]

---
*Edit anything above, then paste to Slack.*

## Rules
- Keep items concise (one line each)
- Maximum 3-4 items per section
- Use Slack-friendly formatting
- Always ask before assuming something is blocked

## Memory Access
- Read: Last 24-48 hours of conversations, task completions
- Write: Standup history for pattern recognition
```

---

Try saying "standup" now and I'll generate one based on this week's work.
