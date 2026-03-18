# Follow-Up Tracker

## Triggers
- "remind me to follow up"
- "follow up with [name]"
- "remind me about [topic]"
- "set a follow-up"
- "I need to remember to"
- "don't let me forget"

## Behavior
1. Extract who to follow up with
2. Extract what the follow-up is about
3. Ask when to remind (if not specified)
4. Store in memory with scheduled reminder
5. Generate draft follow-up message
6. At scheduled time, send reminder with draft

## Output Format

### When Setting Follow-Up
```
✅ **Follow-up scheduled**

**Who:** [Name/Company]
**What:** [Topic]
**When:** [Date and time]

**Draft message I'll have ready:**
---
[Pre-written follow-up message]
---

I'll remind you at the scheduled time with this draft ready to send.
```

### When Reminder Triggers
```
⏰ **Follow-up reminder**

Time to follow up with **[Name]** about **[Topic]**.

You scheduled this on [original date] because: [context if provided]

**Here's the draft I prepared:**
---
[Follow-up message]
---

Reply "send" to use this draft, or tell me how you'd like to adjust it.
```

## Smart Timing
- If user says "next week" → Schedule for Monday 9am
- If user says "in a few days" → Schedule for 3 days later, 9am
- If user says "after the meeting" → Ask for specific time
- If user says "end of month" → Schedule for last business day, 10am

## Follow-Up Types
- **Meeting follow-up:** Thanks, summary, next steps
- **Proposal follow-up:** Check-in, answer questions, soft close
- **Networking follow-up:** Personal connection, offer value
- **Task follow-up:** Status check, offer help
- **Sales follow-up:** Provide value, address concerns, next step

## Memory Access
- Read: relationship history, previous interactions, context
- Write: scheduled reminders, follow-up history, outcomes

## Example Interaction
**User:** remind me to follow up with Sarah about the proposal next Tuesday

**Assistant:**
✅ **Follow-up scheduled**

**Who:** Sarah
**What:** The proposal
**When:** Tuesday, March 25th at 9:00am

**Draft message I'll have ready:**
---
Hi Sarah,

I wanted to check in on the proposal I sent over. Have you had a chance to review it?

Happy to jump on a quick call if you'd like to discuss any questions, or I can provide additional information over email - whatever's easiest for you.

Let me know how you'd like to proceed.

Best,
[Your name]
---

I'll remind you Tuesday morning with this draft ready to send.

Want me to adjust the timing or the message?

---

**[On Tuesday 9am]:**

⏰ **Follow-up reminder**

Time to follow up with **Sarah** about **the proposal**.

You scheduled this last week after sending her a proposal.

**Here's the draft I prepared:**
---
Hi Sarah,

I wanted to check in on the proposal I sent over. Have you had a chance to review it?

Happy to jump on a quick call if you'd like to discuss any questions, or I can provide additional information over email - whatever's easiest for you.

Let me know how you'd like to proceed.

Best,
[Your name]
---

Reply "send" to use this draft, or tell me how you'd like to adjust it.

---

## Managing Follow-Ups

**User:** what follow-ups do I have scheduled?

**Assistant:**
📋 **Your scheduled follow-ups:**

1. **Tuesday, Mar 25** - Sarah (proposal) - 9:00am
2. **Friday, Mar 28** - James at Acme (invoice) - 10:00am
3. **Monday, Mar 31** - Networking follow-up with Mike - 9:00am

Want to edit, cancel, or add to any of these?
