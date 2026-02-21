# Act on Plan

Execute action items from a plan file in the `plans/` directory.

## Arguments

- `$ARGUMENTS` - Optional: The name of the plan file to act on (e.g., `2025-01-15_review` or `2025-01-15_review.md`)

## Task

Analyze the specified plan/review report (or prompt user to select one), present actionable items to the user, execute selected items (parallelizing where possible), and track completion status.

## Steps

### 1. Find the Plan to Act On

**If `$ARGUMENTS` is provided:**

Look for a matching plan file:

```bash
# Try exact match first, then with .md extension
ls plans/$ARGUMENTS 2>/dev/null || ls plans/$ARGUMENTS.md 2>/dev/null || ls plans/$ARGUMENTS.partial.md 2>/dev/null
```

If no matching file is found, inform the user and list available plans.

**If `$ARGUMENTS` is empty or not provided:**

List available plans and ask the user which one to act on:

```bash
ls -t plans/*.md | grep -v -E '\.completed\.md$'
```

Use AskUserQuestion to present the available plans and let the user select one. Group them by status:

- Active plans (`.md` without suffix)
- Partial plans (`.partial.md`)

If no plans exist at all, inform the user and exit.

### 2. Analyze the Plan

Read the plan file and extract:

- **Sections/Phases**: Major groupings of work (e.g., "Critical Issues", "High Priority", "Medium Priority")
- **Action Items**: Individual tasks that can be acted upon
- **Dependencies**: Items that must be completed before others
- **Parallelizable Groups**: Items that can be worked on simultaneously

For each action item, determine:

- Is it actionable by code changes? (vs. documentation-only or requires external action)
- What files would need to be modified?
- Can it be done independently of other items?

### 3. Present Options to User

Use AskUserQuestion to let the user select which items to work on:

- Group items by priority/section
- Indicate which items are parallelizable
- Show estimated complexity (files affected)
- Allow multi-select for batch execution

Example question format:

```
Which items should I work on?

Priority: Critical
- [ ] Item 1: Add data validation on Firestore reads (1 file)
- [ ] Item 2: Fix TOCTOU race condition (1 file)

Priority: High
- [ ] Item 3: Add tests for firestore-adapter (new file)
- [ ] Item 4: Add concurrency limiting (1 file)
```

### 4. Execute Selected Items

For selected items:

1. **Create todo list with final step**: Use TodoWrite to create todos for all selected action items, then add a final todo "Rename plan file to .completed.md or .partial.md" at the END of the list. This ensures the rename step survives context compaction and is completed last.
2. **Group parallelizable tasks**: Items affecting different files with no dependencies
3. **Spawn subagents**: Use the Task tool with `run_in_background: true` for parallel execution
   - Each subagent gets: the specific issue description, file location, recommendation, and instruction to implement the fix
   - Subagent prompt should include: "After completing the fix, summarize what was changed."
4. **Wait for completion**: Use TaskOutput to gather results from all subagents
5. **Handle failures**: If a subagent fails, log the failure and continue with others

Example subagent spawning:

```
For 3 independent issues:
- Spawn Agent A for Issue 1 (background)
- Spawn Agent B for Issue 2 (background)
- Spawn Agent C for Issue 3 (background)
- Wait for all to complete
- Collect results
```

### 5. Update the Plan File

After execution, modify the plan file to add/update a "Completed Items" section:

```markdown
---

## Completed Items

### [Date] - Session 1

#### Item 1: [Title]

- **Status**: Completed
- **Changes**:
  - Modified `src/lib/firestore/game-data.ts`: Added zod validation schema
  - Added `src/lib/firestore/validation.ts`: New validation utilities
- **Notes**: [Any relevant notes from the subagent]

#### Item 2: [Title]

- **Status**: Completed
- **Changes**: [list of changes]

#### Item 3: [Title]

- **Status**: Failed
- **Reason**: [Why it failed]
- **Notes**: [What needs to be done manually]
```

### 6. Check for Plan Completion and Rename

After updating, analyze the plan's completion status:

1. Count total actionable items in original sections
2. Count completed items in the "Completed Items" section
3. Determine the appropriate file state:

**If ALL items complete** (or remaining items marked as won't-fix/external):

- Rename file to `plans/YYYY-MM-DD_name.completed.md`
- Inform user the plan is fully resolved

**If SOME items complete** (partial progress made this session):

- Rename file to `plans/YYYY-MM-DD_name.partial.md`
- Inform user of progress and remaining items

**If file is already `.partial.md`**:

- Keep the `.partial.md` extension if still incomplete
- Rename to `.completed.md` when all items are done

Example renames:

- `plans/2025-01-15_review.md` → `plans/2025-01-15_review.partial.md` (some done)
- `plans/2025-01-15_review.partial.md` → `plans/2025-01-15_review.completed.md` (all done)

## Completion Criteria

A plan is considered complete when:

- All "Must Fix" / "Critical" items are resolved
- All "Should Fix" / "High Priority" items are resolved OR explicitly deferred
- Medium/Low priority items are either resolved or documented as deferred

## Output

After execution, provide:

1. Summary of items attempted
2. Success/failure status for each
3. Files modified
4. Plan status: complete (`.completed.md`), partial (`.partial.md`), or unchanged
5. Any items that need manual attention

## Notes

- Always read the full plan before presenting options
- Preserve the original plan content - only append the Completed Items section
- If an item requires clarification, ask before spawning the subagent
- For items that touch the same file, execute sequentially to avoid conflicts
- Run tests after code changes when applicable
- Commit changes are NOT automatic - user must explicitly request commits
