# Invoice Chaser

## Triggers
- "chase invoice"
- "unpaid invoice"
- "client hasn't paid"
- "overdue payment"
- "follow up on payment"
- "chase [client] for payment"

## Behavior
1. Get client/company name
2. Get invoice amount
3. Ask how overdue and how many times chased
4. Generate appropriate message based on escalation level:
   - First chase: Friendly reminder
   - Second chase: Firm but polite
   - Third chase: Formal with consequences mentioned
5. Provide both email and phone script versions

## Escalation Levels

### Level 1: Friendly Reminder (1-7 days overdue, first contact)
Tone: Helpful, assumes oversight
```
Subject: Quick reminder - Invoice #[X] from [Your Company]

Hi [Name],

Hope you're well! Just a quick note that invoice #[X] for [amount] was due on [date].

I've attached a copy in case it's helpful. Let me know if you have any questions or if there's anything holding it up on your end.

Happy to help sort out any issues.

Best,
[Your name]
```

### Level 2: Firm Follow-up (8-21 days overdue, second contact)
Tone: Professional, direct, solution-focused
```
Subject: Payment overdue - Invoice #[X] requires attention

Hi [Name],

I'm following up on invoice #[X] for [amount], which is now [X days] overdue.

I wanted to check if there are any issues preventing payment. If there's a problem with the invoice or you need to arrange a payment plan, please let me know and we can work something out.

Could you confirm when we can expect payment?

Thank you,
[Your name]
```

### Level 3: Formal Notice (22+ days overdue, third+ contact)
Tone: Formal, consequences clear, deadline set
```
Subject: URGENT: Final notice for overdue invoice #[X]

Dear [Name],

This is a formal notice regarding invoice #[X] for [amount], which is now [X days] overdue despite previous reminders sent on [dates].

Payment is required within 7 days of this notice. If we do not receive payment by [date], we will need to:
- Pause any ongoing work/services
- Refer the matter to our collections process
- [Add late fees as per contract terms]

To resolve this immediately, please process payment today or contact me to discuss.

Invoice attached for your reference.

Regards,
[Your name]
[Your title]
```

## Phone Scripts

### Level 1 Phone Script
"Hi [Name], it's [Your name] from [Company]. I'm just calling about invoice [number] - it was due on [date] and I wanted to check it hadn't slipped through the cracks. Is everything okay with it? ... Great, when do you think it'll be processed? ... Perfect, I'll make a note. Thanks!"

### Level 2 Phone Script
"Hi [Name], it's [Your name] from [Company]. I'm calling about invoice [number] which is now [X days] overdue. I wanted to understand if there's a problem we need to address, or if I can help move things along on your end? ... I understand. What would help get this resolved this week?"

### Level 3 Phone Script
"Hi [Name], it's [Your name] from [Company]. I need to speak with you about invoice [number]. It's now significantly overdue and I've sent several reminders. I need to understand today what's happening with this payment, because I'm at the point where I'll need to escalate if we can't resolve it. What can we do right now to fix this?"

## Memory Access
- Read: client history, previous invoices, relationship context
- Write: chase history, payment patterns

## Example Interaction
**User:** chase Acme Corp for the £5,000 invoice

**Assistant:** I'll help you chase that payment. Quick questions:

1. How overdue is it?
2. Have you already chased them? How many times?
3. Who's the best contact there?

**User:** 3 weeks overdue, chased once last week, contact is James in finance

**Assistant:** Got it - this is a Level 2 follow-up. Here's what I'd send:

---

**EMAIL VERSION**

**Subject:** Payment overdue - Invoice for £5,000 requires attention

Hi James,

I'm following up on our invoice for £5,000, which is now 3 weeks overdue.

I reached out last week but haven't heard back. I wanted to check if there are any issues preventing payment. If there's a problem with the invoice or you need to discuss payment terms, please let me know and we can work something out.

Could you confirm when we can expect payment?

Thank you,
[Your name]

---

**PHONE SCRIPT**

"Hi James, it's [Your name] from [Company]. I'm calling about the £5,000 invoice which is now 3 weeks overdue. I sent an email last week but wanted to follow up directly. Is everything okay with it? I'd like to understand if there's something holding it up so we can get it resolved this week."

---

Want me to make it more firm, or add any specific details about the work delivered?
