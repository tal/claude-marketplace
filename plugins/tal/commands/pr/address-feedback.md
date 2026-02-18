---
argument-hint: [pr-number|pr-url|comment-url]
description: Address pull request feedback and review comments
---

# Address PR Feedback

Systematically address pull request review comments and feedback.

## Arguments Provided

$ARGUMENTS

## Instructions

Follow these steps to address PR feedback:

### 1. Fetch PR Comments

**First, attempt to use the `get-pr-feedback` skill.** This skill is designed to fetch and analyze pull request review comments from GitHub, including resolution status and context. The skill should handle fetching comments based on the provided arguments (PR number, PR URL, comment URL, or current branch).

If the skill auto-activates successfully, it will retrieve the comments and you can proceed to step 2.

**If the skill doesn't auto-activate**, use the direct implementation with enhanced error checking:

**Step 1: Pre-flight checks**
Before running the script, perform validation using the Bash tool:

1. Verify we're in a git repository:
   ```bash
   git rev-parse --is-inside-work-tree
   ```
   If this fails, inform the user they must run the command from within their git repository.

2. If no arguments were provided, verify a PR exists for the current branch:
   ```bash
   gh pr view --json number,url
   ```
   If this fails, inform the user they need to either:
   - Provide a PR number/URL as an argument
   - Create a PR for their current branch
   - Check out the branch associated with the PR they want to address

3. Display which PR will be queried (for transparency):
   - If no arguments: Show the PR number and URL from step 2
   - If arguments provided: Show what argument was provided

**Step 2: Fetch comments**
Run the script using the Bash tool with the `-a` flag to filter for actionable threads (compact mode is default, preventing output truncation on large PRs):

```bash
${CLAUDE_PLUGIN_ROOT}/skills/get-pr-feedback/get-pr-comments.sh -a $ARGUMENTS
```

**Step 3: Display diagnostic information**
The script returns an array of actionable review threads (with `-a` flag, already filtered to unresolved and not outdated). Analyze and display:

1. **Actionable threads found**:
   - Count threads: `jq 'length'`
   - Count total comments: `jq '[.[].comments | length] | add'`
   - If 0 threads, inform user "No unresolved, non-outdated review threads found on this PR - all feedback has been addressed!" and stop
   - Display: "Found X actionable threads (Y comments total) to address"

2. **Summary by author**: Count comments by author across all threads
   - Example: "caseyboland1: 3 comments, zinebfadili: 2 comments"

3. **Brief preview**: Show each thread with:
   - First comment's author, file, and preview
   - Number of replies in the thread
   - Example: "- caseyboland1 on TopBar.tsx:42 - Environment seems like it should be... (2 replies)"

4. **Thread structure note**: Threads are sorted newest-first by default, showing the most recent feedback first for relevance.

This diagnostic output helps verify the script is working correctly and shows what will be addressed.

**Supported argument types:**
- **No argument**: Uses current branch's PR
- **PR number**: Fetches all comments from that PR (e.g., `123`)
- **PR URL**: Fetches all comments from that PR (e.g., `https://github.com/owner/repo/pull/123`)
- **Specific comment URL**: Fetches only that comment (e.g., `https://github.com/owner/repo/pull/123#discussion_r2406356483`)

### 2. Check for PR and Comments

Examine the script output:
- Check stderr for "unable to determine PR" messages - means no PR was found
  - Inform the user and ask if they want to create a PR or provide a PR number
- Empty array `[]` with no stderr warnings - means no review comments exist yet
  - Inform the user that there are no comments to address
- Only proceed to step 3 if there are actual comments to address

### 3. Analyze Threads and Comments

**Note:** The script already filtered to actionable threads only (unresolved and not outdated) using the `-a` flag, so you don't need to filter again.

**Special Case - Specific Comment URL:** If the user provided a specific comment URL and the script returned 0 threads, it means that specific comment thread is either resolved or outdated. Use AskUserQuestion to confirm:
- "The requested thread is either resolved or outdated. Do you want me to fetch it anyway (without the -a filter) to show its status?"
- If user says yes, re-run without the `-a` flag to see the thread status

For all threads to address:
- Review the entire thread conversation (first comment + all replies)
- Identify actionable feedback in the original comment (code changes needed)
- Consider context from replies - they may clarify or modify the original request
- Distinguish between questions, suggestions, and required changes
- Note the file path and line numbers from the first comment
- Group threads by file or topic for efficient addressing

### 4. Create a Task Plan

Use the TodoWrite tool to create a task list with:
- One task per logical change or group of related changes
- Tasks ordered by file or logical dependency
- Clear descriptions referencing the comment author and location

### 5. Address Each Thread

For each actionable thread:
1. Review the entire thread conversation to understand the full context
   - Read the first comment (`.comments[0]`) for the original feedback
   - Review any replies (`.comments[1:]`) for clarifications or additional context
2. Read the relevant file section using the path and line information from the first comment
3. Understand the context from the diff_hunk if needed
4. Make the requested changes using the Edit tool
5. Mark the todo as completed

### 6. Verify Changes

After addressing all feedback:
- Run relevant tests if requested
- Run the build to ensure no breakage
- Review all changes made

### 7. Respond (Optional)

If the user wants to reply to comments on GitHub, you can help draft responses or use `gh` CLI to post replies.

Now proceed with these steps.
