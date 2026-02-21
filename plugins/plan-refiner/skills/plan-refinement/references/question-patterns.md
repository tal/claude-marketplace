# Question Patterns for Strategic Refinement

This reference provides concrete examples of effective questions organized by category. Use these patterns as inspiration when conducting refinement interviews.

## Technical Implementation Questions

### Architecture & Design

**Data Flow:**
- "How should data flow between the frontend and backend—REST, GraphQL, WebSockets, or a combination?"
- "Where should business logic live—frontend, backend, or split between both?"
- "Should this use a microservices architecture or monolith? What's driving that decision?"

**State Management:**
- "What's the source of truth for [data]—database, cache, client state, or combination?"
- "How should we handle state synchronization between multiple clients viewing the same data?"
- "Should state persist across page refreshes, and if so, where—localStorage, sessionStorage, cookies, or server?"

**Data Structures:**
- "Should this be modeled as [structure A] or [structure B]? What's the tradeoff?"
- "How should we represent relationships—foreign keys, embedded documents, or graph?"
- "What's the expected cardinality—one-to-one, one-to-many, many-to-many?"

**Performance:**
- "Should we optimize for read performance or write performance here?"
- "What's an acceptable response time—100ms, 500ms, 2s?"
- "Should this operation be synchronous or asynchronous? What's the user experience implication?"
- "Where should caching happen—CDN, server, client, or multiple layers?"
- "What's the expected dataset size—hundreds, thousands, millions of records?"

**Scalability:**
- "How should this scale—vertical scaling, horizontal scaling, or both?"
- "What's the expected load—requests per second, concurrent users, data volume?"
- "Should we shard data, and if so, by what key?"
- "How do we handle database connection pooling and limits?"

### Integration & APIs

**API Design:**
- "Should this be a single endpoint or multiple? What's the granularity?"
- "How should we version this API—URL path, header, query parameter?"
- "What's the pagination strategy—offset, cursor, or page-based?"
- "Should we support batch operations, or only single-item operations?"

**Authentication & Authorization:**
- "What authentication method—JWT, session cookies, OAuth, API keys?"
- "How should tokens refresh—automatically, manual, or sliding expiration?"
- "What's the authorization model—RBAC, ABAC, or simple owner-based?"
- "Should permissions be checked at API gateway, service level, or both?"

**External Services:**
- "What happens if [external service] is down—fail fast, retry, or queue for later?"
- "Should we have a circuit breaker for this integration?"
- "How do we handle rate limits from [external API]?"
- "Should we cache responses from [external service], and what's the TTL?"

**Data Validation:**
- "Where should validation happen—client, server, or both?"
- "How strict should validation be—fail on first error or collect all errors?"
- "Should we sanitize input, validate and reject, or both?"
- "What's the format for validation errors—field-level, global, or both?"

### Error Handling & Resilience

**Error Strategy:**
- "Should errors be user-facing or logged silently?"
- "What's the fallback behavior if [operation] fails?"
- "Should we retry on failure, and if so, with what strategy—exponential backoff, fixed delay?"
- "How do we distinguish between retryable and non-retryable errors?"

**Failure Scenarios:**
- "What happens if the database is temporarily unavailable?"
- "How do we handle partial failures in batch operations?"
- "What if the operation times out—rollback, retry, or manual intervention?"
- "Should we implement graceful degradation, and what features are non-critical?"

**Monitoring & Debugging:**
- "What should we log—everything, errors only, or custom events?"
- "Should we use structured logging, and what fields are important?"
- "How do we correlate logs across distributed services—trace IDs, request IDs?"
- "What metrics should we track for this feature?"

### Security

**Input Security:**
- "How do we prevent SQL injection in [query]?"
- "Should user input be escaped, sanitized, or both?"
- "What's the strategy for preventing XSS—CSP, output encoding, or both?"
- "How do we validate file uploads—type, size, content scanning?"

**Data Security:**
- "Should sensitive data be encrypted at rest, in transit, or both?"
- "What's the key management strategy?"
- "How do we handle PII—anonymize, pseudonymize, or access control?"
- "Should we audit data access, and what should be logged?"

**Access Control:**
- "Who can perform this operation—all users, authenticated users, admins, or custom role?"
- "Should we implement rate limiting to prevent abuse?"
- "How do we prevent CSRF attacks?"
- "Should API endpoints require authentication, authorization, or both?"

## UI/UX Questions

### User Flow

**Navigation:**
- "After completing [action], where should the user land—same page, list view, details view?"
- "Should this open in a new tab, modal, slide-over, or inline?"
- "How does the user get back—back button, breadcrumb, explicit navigation?"
- "Should navigation be blocked during unsaved changes, and how?"

**Interaction Patterns:**
- "Should this be drag-and-drop, click-to-select, or both?"
- "How do users initiate [action]—button, keyboard shortcut, context menu, or multiple ways?"
- "Should this support keyboard navigation, and what's the tab order?"
- "Is this a single-page flow or multi-step wizard?"

**Feedback:**
- "How do we indicate loading state—spinner, skeleton, progress bar, or optimistic update?"
- "Should successful actions show a toast, banner, inline message, or just update the UI?"
- "What happens on error—modal, inline message, toast notification?"
- "Should we use confirmation dialogs, or allow easy undo?"

### Forms & Input

**Validation:**
- "Should validation trigger on blur, on change, or on submit?"
- "How should errors be displayed—inline, at top, or both?"
- "Should we prevent invalid input or allow it and show errors?"
- "What's the UX for showing field-level vs form-level errors?"

**Data Entry:**
- "Should we provide autocomplete, type-ahead, or dropdown?"
- "How do we handle optional vs required fields—asterisks, labels, or different styling?"
- "Should we save drafts automatically or only on explicit save?"
- "What happens if the user navigates away with unsaved changes?"

**Complex Inputs:**
- "For date selection—calendar picker, text input, or both?"
- "For file upload—drag-and-drop, file picker, or both?"
- "For rich text—WYSIWYG editor, markdown, or plain text?"
- "For selecting from many options—searchable dropdown, modal picker, or inline list?"

### Visual Design

**Layout:**
- "Should this be full-width, centered, or sidebar layout?"
- "What are the responsive breakpoints—mobile, tablet, desktop?"
- "How should content reflow on smaller screens—stack, hide, or collapse?"
- "Should navigation be sticky, fixed, or scroll with content?"

**Visual Hierarchy:**
- "What's the primary action on this page, and how should it be emphasized?"
- "Should secondary actions be visible or hidden in a menu?"
- "How do we guide attention—color, size, position, or animation?"
- "What information is above the fold vs below?"

**States:**
- "What does this look like when empty—placeholder, empty state illustration, or CTA?"
- "How do we show disabled state—grayed out, hidden, or with explanation?"
- "Should we show loading skeletons or spinners?"
- "What happens on hover, focus, and active states?"

### Accessibility

**Screen Readers:**
- "What should be announced when [event] happens?"
- "Should images have alt text, and what should it say?"
- "Are ARIA labels needed for custom components?"
- "Is the semantic HTML structure clear for assistive tech?"

**Keyboard Navigation:**
- "Should this be keyboard-accessible, and what's the interaction pattern?"
- "What's the focus order, and does it make logical sense?"
- "Should we provide skip links for long pages?"
- "How do we handle focus trapping in modals?"

**Visual Accessibility:**
- "Does this meet WCAG AA contrast ratios?"
- "Should we support high contrast mode?"
- "Are interactive elements large enough for touch targets (44x44px)?"
- "Does color alone convey information, or is there another indicator?"

## Tradeoff Questions

### Performance vs Complexity

- "Is it worth optimizing this to save 50ms if it makes the code 3x more complex?"
- "Should we cache aggressively (better performance) or fetch fresh data (simpler, always current)?"
- "Is pre-rendering worth the build time and infrastructure cost?"
- "Should we lazy-load this, or is the added complexity not worth it?"

### Flexibility vs Simplicity

- "Should this be configurable or hardcoded? What's likely to change?"
- "Is a plugin system needed, or will the core functionality suffice?"
- "Should we design for extensibility now or wait for concrete needs?"
- "How many options should we expose—all possibilities or opinionated defaults?"

### Time vs Quality

- "Can we ship an MVP with [reduced scope] and iterate, or must it be complete?"
- "What's the minimum viable version that provides value?"
- "Should we refactor now or accept technical debt for faster shipping?"
- "Which features are must-have vs nice-to-have for launch?"

### Cost vs Scale

- "Should we use managed services (expensive, easy) or self-host (cheap, complex)?"
- "Is this optimization worth the engineering time?"
- "Should we build this in-house or use a third-party service?"
- "What's the cost at scale, and is there a cheaper approach?"

### User Experience vs Implementation

- "Should we implement this feature even though it's technically challenging?"
- "Is the ideal UX worth the engineering complexity?"
- "Can we achieve 80% of the UX benefit with 20% of the effort?"
- "Should we compromise on UX to ship faster, or wait for the ideal solution?"

## Edge Case Questions

### Boundary Conditions

- "What happens with empty data—show empty state, hide section, or show placeholder?"
- "How do we handle extremely long values—truncate, wrap, scroll?"
- "What if there's only one item in a list that usually has many?"
- "What if there are thousands of items—pagination, virtual scrolling, or search?"

### Concurrency

- "What if two users edit the same record simultaneously?"
- "Should we implement optimistic locking, pessimistic locking, or last-write-wins?"
- "How do we handle race conditions in [operation]?"
- "What if the same user has multiple tabs open?"

### Data Integrity

- "What if a related record is deleted while this operation is in progress?"
- "Should we use soft deletes or hard deletes?"
- "How do we handle orphaned data?"
- "What's the cascade behavior for related records?"

### Network Issues

- "What happens if the request times out?"
- "Should we retry automatically, or require user action?"
- "How do we handle offline scenarios—queue for later, fail, or cached data?"
- "What if the response is received but the confirmation isn't sent?"

### Invalid States

- "How do we prevent [invalid state] from occurring?"
- "What if data gets into an invalid state—detect and fix, or prevent entirely?"
- "Should we validate on write or allow invalid states with validation on read?"
- "What's the recovery strategy if validation fails?"

## Concern & Constraint Questions

### Budget & Resources

- "What's the budget for infrastructure—constrained or flexible?"
- "How much engineering time is available for this?"
- "Should we optimize for one-time build cost or ongoing operational cost?"
- "Are there licensing costs we need to consider for tools/libraries?"

### Timeline

- "What's the deadline—firm or flexible?"
- "Is there a milestone or event driving the timeline?"
- "Can we ship incrementally, or does it need to be all-at-once?"
- "What's the impact of delaying [feature]?"

### Team & Expertise

- "What's the team's familiarity with [technology]?"
- "Do we have the expertise to maintain [complex solution]?"
- "Should we choose simpler tech the team knows, or invest in learning better tech?"
- "Who will maintain this long-term?"

### Maintenance & Operations

- "How will this be deployed—manual, CI/CD, or other?"
- "What's the monitoring strategy?"
- "How do we handle updates—rolling, blue-green, or downtime?"
- "Who's on-call if this breaks at 3am?"

### Backwards Compatibility

- "Do we need to support existing users/data, or is this greenfield?"
- "Can we introduce breaking changes, or must it be backwards compatible?"
- "What's the migration strategy for existing data?"
- "Should we support old API versions, and for how long?"

### Compliance & Legal

- "Are there regulatory requirements (GDPR, HIPAA, etc.)?"
- "Do we need audit logs for compliance?"
- "What data retention policies apply?"
- "Are there geographic restrictions on data storage?"

## Question Formulation Tips

### Make Questions Concrete

**Vague:**
- "How should we handle errors?"

**Concrete:**
- "When the payment API returns a 503 error, should we retry automatically with exponential backoff, show an error to the user, or queue the payment for later processing?"

### Provide Context

**Without context:**
- "Should we cache this?"

**With context:**
- "This API endpoint gets called on every page load (100+ times/minute) and the data changes infrequently (once per day). Should we cache responses with a 1-hour TTL, or is real-time data critical enough to always fetch fresh?"

### Offer Concrete Options

**Open-ended:**
- "What should we do here?"

**Concrete options:**
- "Should we: A) Show a loading spinner and block interaction, B) Show optimistic UI and rollback on error, or C) Disable the action until data loads?"

### Frame Tradeoffs

**Simple question:**
- "Should we use option A or B?"

**Framed with tradeoffs:**
- "Should we use Option A (faster implementation, higher maintenance cost) or Option B (slower to build, more maintainable long-term)?"

### Layer Questions

Start with high-level decisions, then drill down:

**Layer 1:** "Should authentication be session-based or token-based?"
**Layer 2:** "For token-based auth, should we use JWT or opaque tokens?"
**Layer 3:** "For JWT, should tokens be short-lived with refresh tokens, or long-lived?"
**Layer 4:** "Should refresh tokens be stored in httpOnly cookies or localStorage?"

This progressive refinement ensures each question builds on previous answers.

## Anti-Patterns to Avoid

### Obvious Questions

❌ "Should we add a submit button to the form?"
❌ "Will this need a database?"
❌ "Should we handle errors?"

These have obvious answers and waste time.

### Leading Questions

❌ "Wouldn't it be better to use microservices instead of a monolith?"

This presupposes the answer. Instead:
✅ "Should this use microservices or a monolith, considering the team size and deployment complexity?"

### Too Many Options

❌ "Should we use React, Vue, Angular, Svelte, or something else?"

This overwhelms. Instead:
✅ "Should we use React (team familiarity) or Vue (simpler learning curve)?"

Limit to 2-4 concrete options.

### Questions Without Context

❌ "What's the performance target?"

Too vague. Instead:
✅ "For the search feature, what's an acceptable response time—instant (<100ms), fast (<500ms), or acceptable (<2s)?"

### Binary Questions Without Nuance

❌ "Should we optimize for performance?"

Everything should be "optimized" to some degree. Instead:
✅ "Should we aggressively optimize for sub-100ms response time (requires caching, complexity), or is 500ms acceptable (simpler implementation)?"

## Effective Question Sequences

### Example: Feature Refinement

**Round 1 - Architecture:**
1. "Should this be client-side rendering, server-side rendering, or hybrid?"
2. "Where should data fetching happen—page load, on-demand, or prefetch?"
3. "Should state be managed locally, globally, or server-side?"

**Round 2 - Implementation:**
1. "For the [specific UI element], should it be a modal, slide-over, or inline?"
2. "How should we handle loading—skeleton screens, spinners, or optimistic updates?"
3. "Should validation happen on blur, on change, or on submit?"

**Round 3 - Edge Cases:**
1. "What happens if the API times out during [operation]?"
2. "How do we handle concurrent edits by multiple users?"
3. "What's the behavior with empty data or extremely large datasets?"

### Example: API Refinement

**Round 1 - Design:**
1. "Should this be REST, GraphQL, or RPC-style?"
2. "What's the resource model—how are entities related?"
3. "Should we support bulk operations, or only single-item CRUD?"

**Round 2 - Details:**
1. "For authentication, should we use JWT in headers, session cookies, or API keys?"
2. "How should we version this API—URL path, header, or not at all?"
3. "What's the pagination strategy—cursor-based, offset-based, or page numbers?"

**Round 3 - Reliability:**
1. "What's the retry strategy for failed requests—exponential backoff, fixed delay, or no retry?"
2. "How do we handle rate limiting—reject requests or queue them?"
3. "Should endpoints be idempotent, and how do we achieve that?"

### Example: Architecture Refinement

**Round 1 - High-Level:**
1. "Should this be microservices or monolith?"
2. "What's the deployment model—containers, serverless, or VMs?"
3. "Where does business logic live—backend, frontend, or split?"

**Round 2 - Data:**
1. "What's the database choice—relational, document, or graph?"
2. "Should we use database transactions, eventual consistency, or SAGA pattern?"
3. "What's the caching strategy—Redis, in-memory, or CDN?"

**Round 3 - Operations:**
1. "How should services communicate—REST, message queue, or gRPC?"
2. "What's the monitoring approach—logs, metrics, traces, or all three?"
3. "How do we handle service failures—circuit breaker, retry, or failover?"

## Conclusion

Effective questioning transforms vague ideas into implementable specs. Focus on:

- **Concrete, contextual questions** over vague generalities
- **Tradeoffs and implications** over simple yes/no
- **Progressive refinement** over exhaustive upfront questioning
- **Non-obvious decisions** over obvious confirmations

Use these patterns as inspiration, but adapt to each unique spec. The goal is clarity and actionability, not perfect completeness.
