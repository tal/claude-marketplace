---
name: next-phase
description: Fill out the next unfilled phase with implementation details from spec and codebase
argument-hint: [phased-plan-path]
allowed-tools:
  - Read
  - Write
  - Glob
  - Grep
  - AskUserQuestion
  - Skill
  - Task
  - TodoWrite
  - TodoRead
---

# Next Phase Command

Find the next unfilled phase in a phased plan, then flesh it out with full implementation details by reading the original spec and exploring what was actually built in previous phases.

## Usage

```bash
/next-phase @SPEC.phased.md              # Fill next phase in this phased plan
/next-phase plans/auth-system.phased.md   # Fill next phase by path
/next-phase                                # List available phased plans and select one
```

## Instructions for Claude

### Step 1: Load the Phased Plan

**If a file path is provided** (starts with `@` or ends in `.md`/`.txt`):

- Read the file completely

**If no argument is provided:**

- Use Glob to search for `**/*.phased.md` and `**/*.phased.v*.md`
- If multiple files exist, use AskUserQuestion to let the user pick one
- If none exist, tell the user to create one first with `/phase` and exit

### Step 2: Find the Next Unfilled Phase

Parse the phased plan and identify which phases are filled vs unfilled.

**A phase is "filled"** if it has an `### Implementation Details` section (or similar detailed subsection with code examples, file paths, or step-by-step instructions).

**A phase is "unfilled"** if it only has the high-level bullet points from `/phase` (Goal, Delivers, Testable by, Depends on, Unblocks).

Find the first unfilled phase whose dependencies are all filled (or have no dependencies).

If all phases are already filled:
- Tell the user all phases are complete
- Suggest using `/act-on-plan` to execute
- Exit

If the next unfilled phase has unfilled dependencies:
- Warn the user and ask if they want to proceed anyway or fill the dependency first

### Step 3: Read the Original Spec

The phased plan should have a `**Source spec:**` link at the top. Read that spec file to get the full context and requirements for the work in this phase.

If the source spec link is missing or the file doesn't exist:
- Use AskUserQuestion to ask the user for the spec file path
- Read that file

### Step 4: Explore Previous Phase Implementation

**This step is critical.** Previous phases may have been implemented differently than originally planned — additional prompts, code review feedback, or runtime discoveries could have changed the approach. The implementation details for this phase must be based on **what actually exists**, not just what was planned.

Spawn an Explore subagent via Task tool:

```
Task tool with subagent_type: "Explore"
Prompt: I need to understand what was actually implemented for the previous phases of this plan.

The phased plan is at: [phased plan path]
The previous filled phases cover: [list what previous phases delivered]

Research the codebase to find:
1. What was actually built for the previous phases — look at the relevant source files
2. Check the recent git commits (last 20-30 commits) to understand what changed and why
3. Any deviations from the original plan — things done differently, added, or skipped
4. The current state of types, interfaces, APIs, and data structures that this next phase will build on
5. Existing patterns and conventions established by previous phases

Return:
- Full contents of key files from previous phase implementation
- Summary of recent commits related to the plan
- Any deviations from the original phased plan
- Current state of interfaces/types this next phase depends on
```

Wait for the exploration results before proceeding.

**If this is Phase 1** (no previous phases):
- Still explore the codebase for existing code related to the spec
- Skip the "deviations from plan" part
- Focus on existing patterns, types, and conventions

### Step 5: Conduct Implementation Interview

Now that you understand both the spec and the actual state of the codebase, interview the user about implementation details for this specific phase.

**Critical rules:**

- Questions must be informed by what you learned from the codebase exploration
- Ask about deviations — "I noticed the previous phase used X instead of Y from the plan. Should this phase follow the same approach?"
- Questions must be **non-obvious** — don't ask things the spec or code already answer
- Each round should have 1-4 related questions
- Let answers inform the next round

**Dimensions to explore for this phase:**

1. **Implementation approach** — How should each deliverable be built, given what exists now?
2. **Interface with previous phases** — How does this phase connect to what's already built?
3. **Deviations to account for** — What changed from the original plan that affects this phase?
4. **Testing strategy** — How do we verify this phase independently?
5. **Edge cases specific to this phase** — What can go wrong?
6. **Migration/integration** — Does this phase require data migration or changes to existing code?

**Interview pacing:**

- 3-5 rounds is typical
- Stop when implementation details are clear enough to code from
- Stop when the user says "stop" or similar

### Step 6: Write the Filled Phase

Update the phased plan file by replacing the unfilled phase section with a fully detailed version. **Do not modify other phases.**

**Filled phase structure:**

```markdown
## Phase N: [Descriptive Name]

**Goal:** [One sentence — preserved from original]

**Status:** detailed

**Delivers:**
- [Original bullet points preserved]

**Testable by:**
- [Original or updated based on interview]

**Depends on:** [preserved]
**Unblocks:** [preserved]

### Implementation Details

#### [Deliverable 1 Name]

[Detailed description of what to build]

**Files to create/modify:**
- `path/to/file.ts` — [what changes]
- `path/to/other.ts` — [what changes]

**Key types and interfaces:**

```typescript
// Type definitions, function signatures
```

[Step-by-step implementation notes if the approach isn't obvious]

#### [Deliverable 2 Name]

[Same structure...]

### Testing Plan

- [ ] [Specific test case 1]
- [ ] [Specific test case 2]
- [ ] [Integration test with previous phase]

### Notes from Codebase Exploration

[Anything discovered during exploration that's relevant — deviations from plan, patterns to follow, existing code to reuse or extend]
```

**Writing rules:**

- **Preserve the original high-level content** — Goal, Delivers bullets, Testable by, Depends on, Unblocks stay
- **Add `**Status:** detailed`** to mark this phase as filled
- **Include code examples** — type definitions, function signatures, key logic. Be concrete.
- **Reference actual file paths** from the codebase exploration
- **Account for deviations** — if previous phases went off-plan, adjust this phase accordingly
- **Testing is required** — specific test cases, not vague "add tests"

### Step 7: Confirm Completion

After writing, tell the user:

```
Phase [N]: [Name] has been filled out in {path}.

Implementation covers:
- [Brief summary of what was detailed]

Based on codebase exploration:
- [Any notable deviations or discoveries from previous phases]

Next steps:
- Use `/act-on-plan` to execute this phase
- Use `/next-phase` to fill out the next phase after implementing this one
```

## Important Notes

- **Codebase exploration is mandatory** — Previous phases may have diverged from the plan. This phase must build on what actually exists, not what was originally planned.
- **Recent commits matter** — Check git history to understand why things changed, not just what changed.
- **One phase at a time** — This command fills exactly one phase per invocation. Run it again for the next phase.
- **Don't modify other phases** — Only update the target phase section in the file.
- **Concrete over abstract** — File paths, type definitions, function signatures. A developer should be able to start coding from this.
- **Mark filled phases** — Add `**Status:** detailed` so the command can distinguish filled from unfilled phases on subsequent runs.
