# Meeting Prep

## Triggers
- "prep for meeting"
- "prepare for meeting"
- "I have a meeting with"
- "meeting prep"
- "get ready for meeting"
- "meeting with [person]"

## Behavior
1. Ask who the meeting is with (if not specified)
2. Ask what the meeting is about
3. Ask how long the meeting is
4. Generate structured prep document:
   - Meeting agenda
   - 5 key questions to ask
   - Important points to make
   - Desired outcomes
5. Offer to add context from previous interactions

## Output Format
```
## Meeting Prep: [Meeting Title]
**With:** [Person/People]
**Duration:** [Time]
**Date:** [If known]

### Agenda
1. [Opening/rapport - 2 min]
2. [Main topic 1 - X min]
3. [Main topic 2 - X min]
4. [Next steps/wrap-up - 5 min]

### Questions to Ask
1. [Strategic question about their priorities]
2. [Clarifying question about specifics]
3. [Forward-looking question about next steps]
4. [Question about challenges/concerns]
5. [Question about timeline/resources]

### Key Points to Make
- [Your main message/ask]
- [Supporting point 1]
- [Supporting point 2]
- [Value proposition/benefit to them]

### Desired Outcomes
✅ [Primary outcome you want]
✅ [Secondary outcome]
✅ [Agreement/next step to secure]

### Notes
[Any context from previous meetings or relevant background]
```

## Memory Access
- Read: previous meetings with person, relationship history, project context
- Write: meeting outcomes (after meeting if user shares)

## Example Interaction
**User:** I have a meeting with Sarah from Acme Corp tomorrow about renewing our contract

**Assistant:** I'll prepare you for that meeting. A few quick questions:

1. How long is the meeting?
2. Are there any specific concerns or changes to discuss?
3. What's your ideal outcome?

**User:** 30 minutes. They mentioned budget concerns. I want to renew at current rate or offer a small discount.

**Assistant:**
## Meeting Prep: Contract Renewal Discussion
**With:** Sarah, Acme Corp
**Duration:** 30 minutes

### Agenda
1. Catch up and relationship check - 3 min
2. Understand their current situation and concerns - 8 min
3. Review value delivered this year - 7 min
4. Discuss renewal terms - 10 min
5. Agree next steps - 2 min

### Questions to Ask
1. "How has your team's experience been with our service this year?"
2. "What's driving the budget concerns - company-wide cuts or specific to this area?"
3. "What would make this renewal a clear win for you internally?"
4. "Are there additional services that would add value for your team?"
5. "What's your timeline for finalising the renewal decision?"

### Key Points to Make
- Highlight specific value delivered (reference metrics if available)
- Emphasise continuity and switching costs
- Position any discount as a partnership investment, not a concession
- Mention any upcoming features/improvements

### Desired Outcomes
✅ Verbal commitment to renew
✅ Agreement on pricing (current rate or max 10% discount)
✅ Clear timeline to signed contract

### Notes
Budget objections often mean they need ammunition to justify internally. Focus on ROI and value metrics they can share with their finance team.

---
Want me to add anything? I can prepare specific talking points about value delivered or discount negotiation tactics.
