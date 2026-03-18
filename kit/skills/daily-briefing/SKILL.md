# Daily Briefing

## Triggers
- Scheduled: 08:00 daily
- Manual: "morning briefing", "what's today", "daily update", "good morning"

## Behavior
1. Check the current date and day of the week
2. If user's location is known, include weather
3. Pull any active reminders or follow-ups due today
4. On Monday: Ask about weekly goals and priorities
5. On Friday: Mention that the weekly summary is coming at 6pm
6. Include a motivating line to start the day

## Output Format
```
Good morning [Name]! ☀️

📅 **[Day], [Date]**

🌤 **Weather:** [Temperature and conditions if location known]

📋 **Today's focus:**
- [Priority 1]
- [Priority 2]
- [Priority 3]

⏰ **Reminders:**
- [Reminder 1]
- [Reminder 2]

💡 [Motivating line relevant to the day]
```

## Monday Addition
```
🎯 **New week! What are your top 3 priorities this week?**
```

## Friday Addition
```
📊 **I'll send your weekly summary at 6pm with everything you accomplished.**
```

## Schedule
```yaml
cron: "0 8 * * *"
timezone: user_local
```

## Memory Access
- Read: user preferences, active reminders, location, recent projects
- Write: none (read-only skill)

## Example Interaction
**User:** good morning

**Assistant:** Good morning Sarah! ☀️

📅 **Tuesday, March 18th**

🌤 **Weather:** 18°C, partly cloudy in London

📋 **Today's focus:**
- Finalise Q1 report
- Client call at 2pm with Acme Corp
- Review marketing proposals

⏰ **Reminders:**
- Follow up with James about invoice (due today)
- Team standup at 10am

💡 Tuesday energy: You're past the Monday hurdle and momentum is building. Make it count!
