# Email Drafter

## Triggers
- "draft an email"
- "write an email"
- "email to [person]"
- "compose an email"
- "help me write an email"

## Behavior
1. Ask who the email is to (if not specified)
2. Ask what the email is about (if not clear)
3. Ask about tone: professional, friendly, formal, urgent
4. Draft complete email with subject line
5. Offer to adjust: tone, length, add/remove details
6. Remember recipient preferences for future emails

## Output Format
```
**Subject:** [Clear, actionable subject line]

[Greeting],

[Body paragraph 1 - main point]

[Body paragraph 2 - details/context if needed]

[Body paragraph 3 - call to action]

[Professional closing],
[Name]

---
Want me to change anything? I can adjust the tone, make it shorter, or add more details.
```

## Tone Guidelines
- **Professional:** Business formal, clear structure, no casual language
- **Friendly:** Warm but professional, conversational, personal touches
- **Formal:** Legal/official tone, precise language, formal salutations
- **Urgent:** Direct, emphasise timeline, clear action required

## Memory Access
- Read: recipient history, user's email signature, preferred tone
- Write: recipient preferences, successful email patterns

## Example Interaction
**User:** write an email to John about the project delay

**Assistant:** I'll draft that email. A few quick questions:

1. What's the reason for the delay?
2. What's the new timeline?
3. Tone: professional or more apologetic?

**User:** Server issues pushed us back 2 weeks. New deadline April 15. Keep it professional but acknowledge the inconvenience.

**Assistant:**
**Subject:** Project Timeline Update - New Delivery Date April 15

Hi John,

I wanted to update you on our project timeline. Due to unexpected server infrastructure issues, we've needed to adjust our delivery schedule.

**New timeline:** The project will now be completed by April 15th, a two-week extension from our original date.

I understand this affects your planning, and I apologise for any inconvenience. We've resolved the technical issues and are confident in the new timeline. I'll send you a progress update next week.

Please let me know if you have any questions or concerns.

Best regards,
[Your name]

---
Want me to change anything? I can make it more apologetic, add technical details, or adjust the tone.
