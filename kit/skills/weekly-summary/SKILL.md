# Weekly Summary

## Triggers
- Scheduled: 18:00 every Friday
- Manual: "weekly summary", "week in review", "what did I do this week", "summarise my week"

## Behavior
1. Review all conversations from the past 7 days
2. Categorise work into themes
3. Identify decisions made
4. List pending items and follow-ups
5. Ask about biggest win
6. Set intention for next week

## Output Format
```
## 📊 Weekly Summary
**Week of [Date Range]**

### Work Completed
**[Category 1]**
- [Item completed]
- [Item completed]

**[Category 2]**
- [Item completed]
- [Item completed]

**[Category 3]**
- [Item completed]
- [Item completed]

### Decisions Made
- [Decision 1]
- [Decision 2]
- [Decision 3]

### Content Created
- [Content piece 1]
- [Content piece 2]

### Meetings & Calls
- [Meeting 1 with outcome]
- [Meeting 2 with outcome]

### Still Pending
⏳ [Pending item 1]
⏳ [Pending item 2]
⏳ [Pending item 3]

### Follow-Ups Scheduled
📅 [Follow-up 1 - date]
📅 [Follow-up 2 - date]

---

🎯 **What was your biggest win this week?**

[After user responds]

💪 Great week! That's worth celebrating.

**Looking ahead:** What's the ONE thing that would make next week a success?
```

## Schedule
```yaml
cron: "0 18 * * 5"
timezone: user_local
```

## Memory Access
- Read: All conversations from past 7 days, scheduled items, completed tasks
- Write: Weekly summary archive, wins log, patterns

## Example Output
```
## 📊 Weekly Summary
**Week of March 11-17, 2024**

### Work Completed
**Client Work**
- Delivered Q1 report to Acme Corp
- Completed website redesign proposal for Smith Co
- Resolved billing issue with Johnson Ltd

**Internal**
- Hired new marketing contractor (decision: Sarah from the interviews)
- Updated pricing page copy
- Fixed CRM automation bug

**Content**
- Published LinkedIn post on customer feedback (142 likes)
- Drafted newsletter for Monday send

### Decisions Made
- Contractor over full-time for marketing role
- Pushed product launch to April 15
- Approved new office equipment budget

### Meetings & Calls
- Acme Corp renewal call → verbal commitment to renew
- Sarah interview → hired
- Team planning → Q2 priorities set

### Still Pending
⏳ Send contract to Sarah (new hire)
⏳ Review competitor analysis from research
⏳ Finalise April content calendar

### Follow-Ups Scheduled
📅 Sarah (proposal) - Tuesday
📅 James at Acme (contract) - Thursday
📅 Mike (networking) - Next Monday

---

🎯 **What was your biggest win this week?**
```

**User:** Getting the verbal commitment from Acme to renew - that was a big one we were worried about.

**Assistant:**
💪 That's a huge win! Retaining Acme removes a lot of uncertainty. Worth celebrating.

**Looking ahead:** What's the ONE thing that would make next week a success?

**User:** Getting Sarah's contract signed and her started.

**Assistant:**
Perfect. I'll make that the priority check-in for Monday's briefing.

Have a great weekend! You've earned it. 🎉
