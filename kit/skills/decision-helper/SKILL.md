# Decision Helper

## Triggers
- "should I"
- "help me decide"
- "pros and cons"
- "what would you do"
- "deciding between"
- "can't decide"
- "weigh up"

## Behavior
1. Clarify the decision and options
2. Ask what makes this decision difficult
3. Identify key criteria that matter
4. Create structured pros/cons analysis
5. Give clear recommendation with reasoning
6. Ask the key question that often unlocks the answer

## Output Format
```
## Decision: [Clear statement of the choice]

### The Options
**Option A:** [Description]
**Option B:** [Description]

### Analysis

#### Option A: [Name]
**Pros:**
✅ [Pro 1]
✅ [Pro 2]
✅ [Pro 3]

**Cons:**
❌ [Con 1]
❌ [Con 2]

**Best if:** [Scenario where this is the right choice]

#### Option B: [Name]
**Pros:**
✅ [Pro 1]
✅ [Pro 2]
✅ [Pro 3]

**Cons:**
❌ [Con 1]
❌ [Con 2]

**Best if:** [Scenario where this is the right choice]

### My Recommendation
**Go with [Option]** because [clear reasoning based on what user said matters most].

### The Key Question
[One question that often clarifies the right answer - usually about values, priorities, or gut feeling]
```

## Decision Frameworks Used
- **Reversibility:** Can you undo this? Reversible decisions deserve less agonising
- **10/10/10:** How will you feel about this in 10 minutes, 10 months, 10 years?
- **Regret Minimisation:** Which choice would you regret NOT taking?
- **Opportunity Cost:** What do you give up with each option?

## Memory Access
- Read: user's values, past decisions, current priorities
- Write: decision outcomes (for learning patterns)

## Example Interaction
**User:** should I hire a contractor or a full-time employee for this role?

**Assistant:** Good question - this is a common decision point. Let me understand the situation:

1. What's the role/work involved?
2. How long do you expect to need this person?
3. What's your rough budget for each option?
4. Is there anything specific making this decision hard?

**User:** Marketing role. Probably need them for at least a year. Contractor would be £60k/year, employee about £50k plus benefits. The hard part is I'm not sure if the role will grow or if I need flexibility.

**Assistant:**
## Decision: Contractor vs Full-Time Employee (Marketing Role)

### The Options
**Option A:** Hire a contractor at £60k/year
**Option B:** Hire a full-time employee at £50k + benefits (~£60-65k total cost)

### Analysis

#### Option A: Contractor
**Pros:**
✅ Flexibility to end engagement if role doesn't work out
✅ No employment law obligations
✅ Often more experienced/specialist talent
✅ Can scale hours up/down

**Cons:**
❌ Less invested in company long-term
❌ May have other clients competing for attention
❌ You don't build internal capability
❌ Flight risk if they get a better offer

**Best if:** You're uncertain about the role's longevity, need specialist skills quickly, or want to test the position before committing.

#### Option B: Full-Time Employee
**Pros:**
✅ Full dedication and loyalty
✅ Builds internal capability and culture
✅ More control over priorities and growth
✅ Lower long-term cost if role extends beyond 2 years

**Cons:**
❌ Harder to exit if it doesn't work out (notice period, employment rights)
❌ Benefits add 15-20% to base cost
❌ Longer hiring process typically
❌ You're committing to the role existing

**Best if:** You're confident marketing needs will persist or grow, and you want someone who'll grow with the company.

### My Recommendation
**Go with the contractor first** - but with a view to converting them or hiring someone permanent in 6-9 months.

Here's why: You said you're "not sure if the role will grow" - that uncertainty is the key factor. A contractor gives you 6 months of data on whether this marketing function is working and growing. If it is, you'll know exactly what you need in a full-time hire. If it isn't, you haven't committed to a harder exit.

The £5-10k "premium" for the contractor is insurance against the uncertainty.

### The Key Question
**If you hired an employee and it didn't work out after 6 months, how painful would that exit be - financially and emotionally?**

If the answer is "very painful" - start with the contractor. If it's "manageable, we'd figure it out" - go direct to employee.

---
Would you like me to help think through what to look for in either type of hire?
