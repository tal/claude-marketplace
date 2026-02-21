---
name: phase
description: Break a spec into high-level, independently testable implementation phases
argument-hint: <spec-file-path>
allowed-tools:
  - Read
  - Write
  - Glob
  - AskUserQuestion
  - Skill
  - Task
  - TodoWrite
  - TodoRead
---

# Phase Command

Take a spec and break it into high-level, independently testable implementation phases. Each phase is a few bullet points — just enough to understand what it delivers and how it relates to its siblings. No deep implementation details.

## Usage

```bash
/phase @SPEC.md                # Phase a spec file
/phase plans/auth-system.md    # Phase a plan file
/phase                          # List available specs/plans and select one
```

## Instructions for Claude

### Step 1: Load the Spec

**If a file path is provided** (starts with `@` or ends in `.md`/`.txt`):

- Read the file completely

**If no argument is provided:**

- Use Glob to search for `plans/*.md`, `specs/*.md`, and `*.spec.md`
- Also search for `SPEC*.md` in the current directory
- If multiple files exist, use AskUserQuestion to let the user pick one
- If none exist, tell the user to provide a spec file and exit

### Step 2: Analyze the Spec

Read the spec and identify:

- **Core deliverables** — what concrete things need to exist when this is done
- **Natural groupings** — items that belong together (same feature, same subsystem, same layer)
- **Dependencies** — what must exist before something else can be built
- **Foundation work** — types, schemas, infrastructure everything else depends on
- **Independently testable units** — the smallest groups of work that can be verified on their own

### Step 3: Interview for Phasing Strategy

Use AskUserQuestion to understand how the user wants the work phased. Keep this focused — this is about structure, not implementation details.

**Key questions to explore:**

1. **What drives phase ordering?**
   - Risk-first (validate unknowns early)
   - Value-first (most useful thing first)
   - Dependency-order (foundations then layers)
   - Some combination

2. **Phase granularity** — How many phases feel right?
   - Few large phases (2-3) vs many small ones (5-8)
   - Should early phases be smaller to build momentum?

3. **What's the MVP?** — The smallest independently useful subset

4. **What gets deferred?** — Items that are explicitly out of scope or "later"

5. **Testing boundaries** — What makes each phase "independently testable"?
   - Unit tests sufficient?
   - Integration tests required?
   - End-to-end verification needed?

**Interview pacing:**

- 2-4 rounds is typical — this is about structure, not exhaustive detail
- Stop when every item in the spec has a phase assignment
- Stop when the user says "stop", "done", or similar

### Step 4: Determine Output File

Default output: same filename with `.phased` inserted before `.md`
- Example: `SPEC.md` -> `SPEC.phased.md`
- Example: `plans/auth-system.md` -> `plans/auth-system.phased.md`

If the output file already exists, ask the user what to do.

**Ask the user to confirm the output path** before writing.

### Step 5: Write the Phased Plan

Write a high-level phased breakdown. Each phase is **bullet points only** — no deep implementation details. The goal is a map, not a manual.

**Phased plan structure:**

```markdown
# [Title] — Phased Implementation

## Overview

[1-2 sentences: what this is and why it's phased this way]

**Source spec:** [path to original spec file]

---

## Phase Relationships

[ASCII diagram showing how phases relate to each other — dependencies, parallel tracks, and flow]

Example:

┌─────────────┐     ┌─────────────┐     ┌─────────────┐
│   Phase 1   │────→│   Phase 2   │────→│   Phase 4   │
│ Foundation  │     │  Core API   │  ┌─→│ Integration │
└─────────────┘     └─────────────┘  │  └─────────────┘
       │                             │
       │            ┌─────────────┐  │
       └───────────→│   Phase 3   │──┘
                    │     UI      │
                    └─────────────┘

---

## Phase 1: [Descriptive Name]

**Goal:** [One sentence — what's true when this phase is done]

**Delivers:**
- [Concrete deliverable]
- [Concrete deliverable]
- [Concrete deliverable]

**Testable by:**
- [How you verify this phase works independently]

**Depends on:** nothing
**Unblocks:** Phase 2, Phase 3

---

## Phase 2: [Descriptive Name]

**Goal:** [One sentence]

**Delivers:**
- [Bullet point]
- [Bullet point]

**Testable by:**
- [Verification approach]

**Depends on:** Phase 1
**Unblocks:** Phase 4

---

[...repeat for each phase...]

---

## Deferred / Out of Scope

- [Item] — [why it's deferred]

## Open Questions

- [Anything unresolved about the phasing]
```

**Writing rules:**

- **Bullet points only** — 3-6 bullets per phase for deliverables
- **One-sentence goals** — if you can't say what a phase does in one sentence, it's too big
- **ASCII diagrams are required** — show how phases connect, what's parallel, what's sequential
- **Every spec item gets a home** — nothing silently dropped, either in a phase or explicitly deferred
- **Each phase must be independently testable** — if you can't describe how to verify it, rethink the boundary
- **No implementation details** — no code examples, no file paths, no function signatures. That comes later with `/next-phase`.

### Step 6: Confirm Completion

After writing, tell the user:

```
Phased plan written to {path}.

[N] phases:
1. [Phase 1 name] — [goal sentence]
2. [Phase 2 name] — [goal sentence]
...

Next steps: Use `/next-phase` to fill out the next phase with implementation details.
```

## Important Notes

- **High-level only** — This command produces a map, not implementation details. Keep it concise.
- **Independently testable** — This is the key constraint. Every phase must have a clear "done" verification.
- **ASCII diagrams required** — Phase relationships must be visually clear.
- **Preserve all spec items** — Everything is either in a phase or explicitly deferred. Nothing vanishes.
- **Phases are ordered** — The numbering implies a recommended execution order, but the dependency diagram shows what's truly sequential vs parallel.
