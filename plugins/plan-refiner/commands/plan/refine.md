---
name: refine
description: Refine a plan or spec through in-depth strategic questioning
argument-hint: <file-path>
allowed-tools:
  - Read
  - Write
  - Glob
  - AskUserQuestion
  - Skill
---

# Refine Command

Refine a plan, spec, or requirements document through an in-depth interview process using strategic questioning.

## Usage

```bash
/refine @SPEC.md
/refine PLAN.md
/refine @requirements.md
```

## How It Works

This command conducts a thorough refinement interview to transform rough plans into comprehensive, implementable specifications. The process:

1. **Read the input file** provided as argument
2. **Analyze completeness** - identify what's clear vs ambiguous
3. **Conduct strategic interview** using AskUserQuestion tool
4. **Ask non-obvious questions** about technical implementation, UI/UX, tradeoffs, concerns, edge cases
5. **Iterate until complete** - continue until no more valuable questions or user says "stop"
6. **Write versioned output** - create refined spec in versioned file (e.g., `SPEC.v1.md`)

## Instructions for Claude

### Step 1: Parse Input and Read File

Extract the file path from the argument. Handle both formats:
- `@SPEC.md` (file reference)
- `SPEC.md` (plain path)

Read the file using the Read tool to load its current contents.

### Step 2: Analyze Completeness

Load the plan-refinement skill for guidance on analyzing specs:

```
Use Skill tool to load: plan-refinement
```

Review the file contents and assess:
- What is clearly defined?
- What is ambiguous or vague?
- What critical decisions are missing?
- What edge cases are unaddressed?

### Step 3: Pre-Interview Check

If the spec is already quite clear and comprehensive:
1. Acknowledge that the spec appears well-defined
2. Ask if the user wants to proceed anyway
3. If declined, exit gracefully
4. If confirmed, continue with interview

If the spec has clear gaps, proceed directly to interview without asking.

### Step 4: Conduct Refinement Interview

Ask strategic, non-obvious questions using the AskUserQuestion tool.

**Question Strategy:**
- Focus on technical implementation, UI/UX, tradeoffs, concerns, edge cases
- Avoid obvious questions (things clearly stated or easily inferred)
- Batch 1-4 related questions per round
- Frame questions with concrete options and context
- Make tradeoffs explicit

**Iterative Process:**
- Ask questions in rounds
- Let each round's answers inform the next round
- Continue until you have no more non-obvious questions
- Stop when user says "stop" or indicates they're done
- Typical refinement: 3-5 rounds of questions

**Example question format:**
```
Question: "How should we handle API rate limit errors during bulk operations?"
Header: "Rate limits"
Options:
  - "Fail fast" - Return error immediately
  - "Retry with backoff" - Exponential backoff retry strategy
  - "Queue for later" - Queue requests and process when limit resets
```

Refer to the plan-refinement skill for:
- Question pattern examples
- Completeness checklist
- Tradeoff frameworks

### Step 5: Determine Version Number

After interview complete, determine output filename:

1. **Parse base filename:**
   - If input is `SPEC.md` → base is `SPEC`
   - If input is `SPEC.v2.md` → base is `SPEC`
   - Extract everything before `.v{N}.md` pattern

2. **Find existing versions:**
   - Use Glob to search for `{base}.v*.md` in same directory
   - Parse version numbers from matches
   - Find highest version number (or 0 if none exist)

3. **Calculate next version:**
   - Next version = highest version + 1
   - Output filename = `{base}.v{next}.md`

4. **Handle collisions:**
   - If output file already exists, ask user:
     - "File `{output}` already exists. Should I overwrite it, skip to v{next+1}, or cancel?"
     - Options: Overwrite / Skip to next / Cancel
   - Act based on user's choice

**Example version progression:**
```
SPEC.md → SPEC.v1.md → SPEC.v2.md → SPEC.v3.md
```

### Step 6: Synthesize Refined Spec

Combine original content with clarifications from interview into comprehensive refined spec.

**Organization:**
- Start with summary of changes (if user wants it - see Step 7)
- Keep original structure where possible
- Add new sections for areas that were clarified
- Include technical details discovered through questions
- Document key decisions and their rationale
- Add sections for error handling, edge cases, etc. as appropriate

**Writing style:**
- Clear and specific
- Includes concrete details
- Documents tradeoffs considered
- Provides enough detail for implementation
- Well-organized and scannable

### Step 7: Ask About Change Summary

Before writing the refined spec, use AskUserQuestion to ask:

```
Question 1: "Would you like to include a summary of changes and clarifications at the top of the refined spec?"
Header: "Summary"
Options:
  - "Yes" - Include summary section
  - "No" - Just write refined spec
```

```
Question 2: "Should I remember this preference for future refinement sessions?"
Header: "Remember"
Options:
  - "Yes, remember" - Save to memory for future sessions
  - "No, just this time" - Don't save preference
```

If user wants summary, add a "Refinement Summary" section at the top:

```markdown
## Refinement Summary

**Changes from v{N-1}:**
- Clarified [aspect]
- Added details about [topic]
- Resolved ambiguity in [area]
- Specified approach for [concern]

**Key Decisions:**
- [Decision 1]: [Rationale]
- [Decision 2]: [Rationale]
```

If user wants to remember preference, use memory to store it.

### Step 8: Write Refined Spec

Use Write tool to create the versioned output file with the refined specification.

Confirm to user:
```
Refined spec written to {output filename}.

[Brief summary of what was clarified]
```

## Example Flow

**User runs:** `/refine @SPEC.md`

**Process:**
1. Read SPEC.md
2. Analyze: finds several ambiguities
3. Interview:
   - Round 1: Ask about architecture and data model (3 questions)
   - Round 2: Ask about error handling and validation (4 questions)
   - Round 3: Ask about UI/UX flows (3 questions)
   - Round 4: Ask about edge cases (2 questions)
4. Determine output: No existing versions → SPEC.v1.md
5. Ask about summary: User wants summary, remember preference
6. Synthesize: Combine original + answers into comprehensive spec
7. Write: Create SPEC.v1.md

**Result:** User has refined spec with all ambiguities resolved and implementation details clarified.

## Tips

- **Load the skill:** Use Skill tool to load plan-refinement skill for guidance
- **Be patient:** Refinement takes multiple rounds - don't rush
- **Stay strategic:** Ask questions that uncover non-obvious complexity
- **Listen to user:** If they say "stop", wrap up current round and finish
- **Iterate thoughtfully:** Each round should build on previous answers
- **Document decisions:** Make sure refined spec includes rationale for choices

## Important Notes

- **One file at a time:** This command processes one file per invocation
- **No confirmation needed:** Start refinement immediately after reading file
- **Version safely:** Always increment version, never overwrite without asking
- **Be thorough:** Continue interviewing until spec is truly complete or user stops
- **Preserve content:** Keep all original content, enhance with clarifications
