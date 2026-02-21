# Example: Feature Spec Refinement

This example demonstrates how a rough feature idea transforms into an implementable spec through strategic questioning.

## Before Refinement (SPEC.md)

```markdown
# User Profile Feature

## Overview
Add user profiles to the app so users can manage their information.

## Requirements
- Users should be able to edit their profile
- Profile should show user info like name, email, bio
- Users can upload a profile picture
- Make it user-friendly and fast

## Technical Notes
- Use React for the frontend
- Store data in database
- Should be secure
```

### Issues with Original Spec

❌ **Vague requirements**: "user-friendly", "fast" not quantified
❌ **Missing details**: What fields exactly? Edit flow? Validation?
❌ **No error handling**: What if upload fails? Validation errors?
❌ **Security undefined**: What makes it "secure"?
❌ **No edge cases**: Large files? Invalid data? Concurrent edits?
❌ **UI/UX unspecified**: Layout? Interaction patterns?

## Refinement Interview Questions

### Round 1: Core Functionality

**Q1: What profile fields should users be able to edit?**
- Options:
  - Basic (name, email, bio)
  - Extended (+ phone, location, birthday, social links)
  - Custom (configurable fields)

**User Answer:** Extended - include phone, location, and birthday

**Q2: Should profile editing happen inline or in a dedicated page/modal?**
- Options:
  - Inline editing (click-to-edit fields)
  - Edit mode (toggle to edit, save/cancel)
  - Dedicated edit page (separate route)
  - Modal overlay (popup form)

**User Answer:** Edit mode - view by default with "Edit Profile" button, then save/cancel

**Q3: How should we handle email changes?**
- Options:
  - Allow immediate change (email is just a field)
  - Require verification (send confirmation email)
  - Block changes (email is fixed after signup)

**User Answer:** Require verification - send confirmation to new email, don't change until verified

### Round 2: Profile Picture Handling

**Q4: What file types and size limits for profile pictures?**
- Options:
  - Permissive (any image, up to 10MB)
  - Standard (JPG/PNG only, up to 5MB)
  - Strict (JPG/PNG, max 2MB, auto-resize)

**User Answer:** Standard - JPG/PNG only, max 5MB, show error if exceeded

**Q5: Should we crop/resize images or accept as-is?**
- Options:
  - Accept as-is (users upload correctly sized images)
  - Auto-resize (resize to standard dimensions server-side)
  - Interactive crop (users crop before upload)

**User Answer:** Interactive crop - let users choose crop area, then resize to 400x400px

**Q6: Where should profile pictures be stored?**
- Options:
  - Database (as blob)
  - Local filesystem (server storage)
  - Cloud storage (S3, Cloudinary, etc.)

**User Answer:** S3 - use presigned URLs for uploads, store URL in database

### Round 3: Validation & Error Handling

**Q7: What validation rules for each field?**
- Name: Required? Min/max length? Allow special chars?
- Email: Required? Format validation? Domain restrictions?
- Phone: Required? Format? International support?
- Location: Required? Free text or dropdown?
- Birthday: Required? Min age restriction?
- Bio: Required? Max length? Allow markdown/HTML?

**User Answer:**
- Name: Required, 1-100 chars, letters/spaces/hyphens only
- Email: Required, standard format, no domain restrictions
- Phone: Optional, format (XXX) XXX-XXXX, US only for MVP
- Location: Optional, free text, 1-100 chars
- Birthday: Optional, must be 13+ years old if provided
- Bio: Optional, max 500 chars, plain text only

**Q8: When should validation happen - on blur, on change, or on submit?**
- Options:
  - On submit only (validate when save clicked)
  - On blur (validate when field loses focus)
  - On change (validate as user types)
  - Hybrid (on blur for first error, then on change)

**User Answer:** Hybrid - validate on blur, then show real-time validation on change after first error

**Q9: How should validation errors be displayed?**
- Options:
  - Inline below field (error text under input)
  - Toast notification (temporary popup)
  - Error summary at top (list of all errors)
  - Combination (inline + summary)

**User Answer:** Inline below field with red border on invalid input

### Round 4: UX & Edge Cases

**Q10: What happens if user navigates away with unsaved changes?**
- Options:
  - Allow navigation (lose changes)
  - Block navigation (show confirmation dialog)
  - Auto-save draft (restore on return)

**User Answer:** Show confirmation dialog - "You have unsaved changes. Discard or continue editing?"

**Q11: Should profile changes be immediate or require review/approval?**
- Options:
  - Immediate (changes visible right away)
  - Moderated (admin approval required)
  - Staged (changes pending, apply after verification)

**User Answer:** Immediate except email (which requires verification per earlier answer)

**Q12: What's the loading/saving UX?**
- Options:
  - Block UI (disable during save, show spinner)
  - Optimistic (show change immediately, rollback on error)
  - Progressive (save field-by-field as they blur)

**User Answer:** Block UI with "Saving..." button state, disable inputs during save

### Round 5: Performance & Security

**Q13: What's an acceptable profile load time?**
- Options:
  - Instant (<100ms)
  - Fast (<500ms)
  - Acceptable (<2s)

**User Answer:** Fast - under 500ms for profile load

**Q14: Should profile data be cached client-side?**
- Options:
  - No caching (always fetch fresh)
  - Cache briefly (5 min TTL)
  - Cache with invalidation (cache until profile updated)

**User Answer:** Cache with invalidation - cache in React Query, invalidate on successful save

**Q15: How do we prevent unauthorized profile access/editing?**
- Options:
  - Session-based auth (user can only edit their own)
  - Token-based with RBAC (support admin edits)
  - Public profiles with privacy settings

**User Answer:** Session-based - users can only view/edit their own profile, verify user ID server-side

## After Refinement (SPEC.v1.md)

```markdown
# User Profile Feature - Refined Specification

## Refinement Summary

**Changes from original:**
- Defined exact profile fields with validation rules
- Specified edit flow (view mode → edit mode → save/cancel)
- Clarified email change requires verification
- Detailed profile picture upload with interactive crop and S3 storage
- Defined validation timing (hybrid: on blur, then on change)
- Specified error display (inline below fields)
- Addressed unsaved changes (confirmation dialog)
- Set performance target (<500ms load) and caching strategy
- Clarified security model (session-based, own profile only)

**Key Decisions:**
- **Edit flow**: Toggle edit mode (not inline) for clearer save/cancel
- **Email verification**: Prevent email hijacking with confirmation flow
- **Image handling**: Interactive crop + S3 storage for quality and scalability
- **Validation UX**: Hybrid approach balances immediate feedback with not overwhelming user
- **Performance**: Client-side caching with invalidation for fast subsequent loads

---

## Overview

Users can view and edit their profile information including name, email, phone, location, birthday, bio, and profile picture. Profile editing uses a toggle edit mode with save/cancel actions. Email changes require verification. Profile pictures support interactive cropping and are stored in S3.

## User Stories

### View Profile
**As a** logged-in user
**I want to** view my profile information
**So that** I can see what others see and verify my details are correct

**Acceptance Criteria:**
- Profile page displays all fields: name, email, phone, location, birthday, bio, profile picture
- Optional fields (phone, location, birthday, bio) show as empty or "Not provided"
- Profile picture shows default avatar if not uploaded
- Page loads in under 500ms (cached) or under 2s (initial load)
- Only accessible to the profile owner (verify session user ID matches profile user ID)

### Edit Profile
**As a** logged-in user
**I want to** edit my profile information
**So that** I can keep my details up to date

**Acceptance Criteria:**
- "Edit Profile" button toggles from view mode to edit mode
- Edit mode shows all fields as editable inputs
- "Save" and "Cancel" buttons replace "Edit Profile" button
- Cancel returns to view mode without saving changes
- If navigating away with unsaved changes, show confirmation: "You have unsaved changes. Discard or continue editing?"
- Save validates all fields and shows inline errors if invalid
- Successful save shows "Saving..." button state, then returns to view mode with updated data
- Email changes initiate verification flow (see Email Verification user story)

### Upload Profile Picture
**As a** logged-in user
**I want to** upload and crop a profile picture
**So that** my profile has a personalized image

**Acceptance Criteria:**
- "Upload Photo" button opens file picker
- Only JPG/PNG files accepted, max 5MB
- Show error if file type or size invalid: "Please upload a JPG or PNG image under 5MB"
- After file selected, show interactive crop interface
- Crop interface allows drag/zoom to select area
- "Apply" button uploads cropped image to S3, shows upload progress
- Image resized to 400x400px server-side before saving to S3
- Profile picture URL stored in database
- On error (upload failure, network timeout), show: "Upload failed. Please try again."

### Change Email (Verification Flow)
**As a** logged-in user
**I want to** change my email address
**So that** I can use a different email for my account

**Acceptance Criteria:**
- When user changes email field and saves, validation checks email format
- Server sends verification email to NEW email address
- Message shown: "Verification email sent to [new email]. Please confirm to complete the change."
- Email is NOT changed in database until verification link clicked
- User can still log in with OLD email until verification complete
- Verification link expires after 24 hours
- After verification, email updated and confirmation shown on next login

## Profile Fields Specification

| Field | Required | Type | Validation | Display |
|-------|----------|------|------------|---------|
| **Name** | Yes | Text | 1-100 chars, letters/spaces/hyphens only | Single-line input |
| **Email** | Yes | Email | Standard email format | Single-line input (triggers verification flow on change) |
| **Phone** | No | Phone | Format: (XXX) XXX-XXXX, US only | Masked input with format enforcer |
| **Location** | No | Text | 1-100 chars | Single-line input |
| **Birthday** | No | Date | Must be 13+ years ago if provided | Date picker |
| **Bio** | No | Textarea | Max 500 chars, plain text only | Multi-line textarea with char counter |
| **Profile Picture** | No | Image | JPG/PNG, max 5MB, cropped to 400x400 | Image upload with crop interface |

### Validation Rules Detail

**Name:**
- Required field
- Min length: 1 character
- Max length: 100 characters
- Allowed characters: letters (a-z, A-Z), spaces, hyphens
- Error messages:
  - Empty: "Name is required"
  - Too long: "Name must be 100 characters or less"
  - Invalid chars: "Name can only contain letters, spaces, and hyphens"

**Email:**
- Required field
- Must match standard email format (contains @ and domain)
- No domain restrictions
- Error messages:
  - Empty: "Email is required"
  - Invalid format: "Please enter a valid email address"
- Note: Changing email triggers verification flow

**Phone:**
- Optional field
- Format: (###) ###-####
- US phone numbers only (MVP scope)
- Input masked to enforce format
- Error messages:
  - Invalid format: "Phone must be in format (XXX) XXX-XXXX"

**Location:**
- Optional field
- Free text entry
- Max length: 100 characters
- Error messages:
  - Too long: "Location must be 100 characters or less"

**Birthday:**
- Optional field
- Must be at least 13 years ago if provided (age restriction)
- Date picker for easy selection
- Error messages:
  - Too recent: "You must be at least 13 years old"

**Bio:**
- Optional field
- Plain text only (no HTML, markdown, or special formatting)
- Max length: 500 characters
- Character counter shown: "X / 500 characters"
- Error messages:
  - Too long: "Bio must be 500 characters or less"

### Validation Timing

**Hybrid approach:**
1. **On blur** (field loses focus): Validate and show error if invalid
2. **On change** (after first error): If field has already shown error, re-validate on each change to show when it becomes valid
3. **On submit**: Validate all fields, focus first invalid field, prevent save if any errors

**Example flow:**
1. User fills in name as "John123" (invalid chars)
2. User tabs to next field (blur event)
3. Error shown: "Name can only contain letters, spaces, and hyphens"
4. User clicks back into name field and types "John" (on change validation)
5. Error clears immediately when valid

### Error Display

**Visual design:**
- Invalid input: Red border on input field
- Error message: Red text below input field
- Icon: Red exclamation icon next to error message
- All errors are inline (no toast, no summary at top)

**Example:**
```
Name: [John123_____________] ← red border
      ⚠ Name can only contain letters, spaces, and hyphens
      ↑ red text
```

## UI/UX Specifications

### View Mode

**Layout:**
```
[Profile Picture]     Name: John Doe
  (400x400)          Email: john@example.com
                     Phone: (555) 123-4567
                     Location: San Francisco, CA
                     Birthday: January 15, 1990

                     Bio:
                     Software engineer who loves hiking
                     and photography.

                     [Edit Profile Button]
```

**States:**
- Default avatar shown if no profile picture uploaded
- Optional fields show "Not provided" if empty
- Profile picture hoverable with "Change Photo" tooltip

### Edit Mode

**Layout:**
```
[Profile Picture]     Name: [___________________]
  [Change Photo]      Email: [___________________]
                     Phone: [___________________] (optional)
                     Location: [___________________] (optional)
                     Birthday: [____/____/________] (optional)

                     Bio: (optional)
                     [_____________________________]
                     [_____________________________]
                     [_____________________________]
                     Character counter: 45 / 500

                     [Save]  [Cancel]
```

**States:**
- All inputs enabled and editable
- Save button shows "Saving..." when request in progress
- All inputs disabled during save
- Cancel button always enabled

### Profile Picture Upload

**Upload flow:**
1. Click "Change Photo" button or profile picture area
2. File picker opens
3. User selects JPG or PNG file
4. If file invalid (wrong type or > 5MB), show error inline
5. If valid, show crop interface:
```
┌────────────────────────────┐
│                            │
│   [Crop area selector]     │
│   with drag/zoom controls  │
│                            │
└────────────────────────────┘
      [Cancel]  [Apply]
```
6. User adjusts crop, clicks Apply
7. Upload progress bar shown
8. On success, show new cropped image
9. On error, show error message with retry option

## Technical Specifications

### Frontend

**Technology:** React 18 with React Query for data fetching

**Component Structure:**
```
<ProfilePage>
  <ProfileHeader picture={user.picture} name={user.name} />
  {editMode ? (
    <ProfileEditForm user={user} onSave={handleSave} onCancel={handleCancel} />
  ) : (
    <ProfileView user={user} onEdit={enterEditMode} />
  )}
</ProfilePage>
```

**State Management:**
- React Query for server state (profile data)
- Local state for edit mode toggle
- Local state for unsaved changes tracking
- Form state managed by React Hook Form for validation

**Validation:**
- Use Yup schema for field validation rules
- React Hook Form for validation timing (on blur, then on change)
- Custom phone number mask using react-input-mask

### Backend

**Endpoints:**

**GET /api/profile**
- Auth: Required (session-based)
- Response: User profile object
```json
{
  "id": "user-123",
  "name": "John Doe",
  "email": "john@example.com",
  "phone": "(555) 123-4567",
  "location": "San Francisco, CA",
  "birthday": "1990-01-15",
  "bio": "Software engineer...",
  "picture_url": "https://s3.../profile-123.jpg"
}
```
- Status codes:
  - 200: Success
  - 401: Unauthorized (not logged in)
  - 404: Profile not found

**PUT /api/profile**
- Auth: Required (session-based, can only update own profile)
- Request body: Partial user profile object (only changed fields)
```json
{
  "name": "John Doe",
  "phone": "(555) 123-4567",
  "location": "San Francisco, CA",
  "birthday": "1990-01-15",
  "bio": "Updated bio..."
}
```
- Response: Updated user profile object (same as GET)
- Validation: Server-side validation matches frontend rules
- Special handling: If email changed, initiate verification flow (see below)
- Status codes:
  - 200: Success
  - 400: Validation error (return field-level errors)
  - 401: Unauthorized
  - 403: Forbidden (trying to update another user's profile)

**POST /api/profile/picture**
- Auth: Required
- Request: Presigned URL request
- Response: Presigned S3 URL for upload
```json
{
  "upload_url": "https://s3.../presigned-url",
  "key": "profile-pictures/user-123-timestamp.jpg"
}
```
- Frontend uploads cropped image to presigned URL
- After successful upload, PUT /api/profile with new picture_url

**POST /api/profile/email/verify**
- Auth: Required
- Request body: New email address
```json
{
  "email": "newemail@example.com"
}
```
- Sends verification email to new address
- Token stored server-side with 24hr expiration
- Response:
```json
{
  "message": "Verification email sent",
  "pending_email": "newemail@example.com"
}
```
- Status codes:
  - 200: Email sent
  - 400: Invalid email format
  - 429: Too many verification attempts (rate limiting)

**GET /api/profile/email/verify/:token**
- No auth required (token-based)
- Verifies token, updates email if valid
- Response: Redirect to profile page with success message
- Status codes:
  - 302: Redirect on success
  - 400: Invalid or expired token

### Database

**Schema:**
```sql
CREATE TABLE users (
  id UUID PRIMARY KEY,
  name VARCHAR(100) NOT NULL,
  email VARCHAR(255) NOT NULL UNIQUE,
  phone VARCHAR(20) NULL,
  location VARCHAR(100) NULL,
  birthday DATE NULL,
  bio VARCHAR(500) NULL,
  picture_url VARCHAR(500) NULL,
  created_at TIMESTAMP NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMP NOT NULL DEFAULT NOW()
);

CREATE TABLE email_verifications (
  id UUID PRIMARY KEY,
  user_id UUID NOT NULL REFERENCES users(id),
  new_email VARCHAR(255) NOT NULL,
  token VARCHAR(64) NOT NULL UNIQUE,
  expires_at TIMESTAMP NOT NULL,
  created_at TIMESTAMP NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_email_verifications_token ON email_verifications(token);
CREATE INDEX idx_email_verifications_expires ON email_verifications(expires_at);
```

### S3 Configuration

**Bucket:** `app-profile-pictures`
**Region:** us-east-1
**Access:** Private (presigned URLs only)
**Image processing:**
- Resize to 400x400px using Sharp library
- Convert to JPG (optimize file size)
- Quality: 85%
**Naming pattern:** `profile-pictures/{user-id}-{timestamp}.jpg`
**Lifecycle:** No expiration (permanent storage)

### Performance Targets

- **Profile load:** <500ms (cached), <2s (initial)
- **Save operation:** <1s
- **Image upload:** <3s for 5MB file
- **Caching:** React Query with 5-minute stale time, invalidate on save

### Security

**Authentication:**
- Session-based auth (cookies)
- Verify user ID in session matches profile user ID on all requests
- CSRF protection enabled

**Authorization:**
- Users can only view/edit their own profile
- Server-side check: `if (session.user_id !== profile.user_id) return 403`

**Input Validation:**
- Server-side validation matches frontend rules
- Sanitize all text inputs (prevent XSS)
- Email verification prevents email hijacking
- Rate limit verification emails (max 3 per hour per user)

**File Upload:**
- Validate file type (magic number check, not just extension)
- Validate file size before generating presigned URL
- S3 bucket has public access blocked
- Presigned URLs expire after 10 minutes

## Error Handling

### Frontend Errors

**Validation errors:** Shown inline below field
**Save errors:** Show at top of form or inline depending on error type
**Upload errors:** Inline in upload interface

**Example error messages:**
```typescript
{
  "name": "Name is required",
  "email": "Please enter a valid email address",
  "phone": "Phone must be in format (XXX) XXX-XXXX",
  "picture": "Upload failed. Please try again."
}
```

### Backend Errors

**400 Bad Request:** Validation errors
```json
{
  "error": "Validation failed",
  "fields": {
    "name": "Name must be 100 characters or less",
    "email": "Email format is invalid"
  }
}
```

**401 Unauthorized:** Not logged in
```json
{
  "error": "Authentication required"
}
```

**403 Forbidden:** Trying to edit another user's profile
```json
{
  "error": "You can only edit your own profile"
}
```

**429 Too Many Requests:** Rate limiting
```json
{
  "error": "Too many verification emails sent. Please try again later."
}
```

**500 Internal Server Error:** Unexpected server error
```json
{
  "error": "An unexpected error occurred. Please try again."
}
```

### Network Errors

**Timeout:** Show "Request timed out. Please try again."
**Offline:** Show "You appear to be offline. Please check your connection."
**Generic fetch error:** Show "An error occurred. Please try again."

## Edge Cases

### Unsaved Changes
**Scenario:** User edits profile but navigates away without saving
**Handling:** Show confirmation dialog: "You have unsaved changes. Discard or continue editing?"
**Implementation:** Track form dirty state, use window.onbeforeunload + React Router prompt

### Concurrent Edits
**Scenario:** User has profile open in multiple tabs, edits in both
**Handling:** Last write wins (no conflict resolution)
**Future consideration:** Add optimistic locking with version field

### Invalid Image Upload
**Scenario:** User tries to upload TXT file renamed to .jpg
**Handling:** Server validates file type by magic number, rejects invalid files
**Error:** "Invalid file type. Please upload a JPG or PNG image."

### Large Bio Paste
**Scenario:** User pastes 10,000 character text into bio field
**Handling:** Textarea enforces max length (truncates on paste or shows error)
**Implementation:** Use maxLength prop on textarea + validation

### Email Already in Use
**Scenario:** User tries to change email to one already registered
**Handling:** Server returns 400 error: "Email is already in use"
**Display:** Inline error below email field

### Verification Email Not Received
**Scenario:** User doesn't receive verification email
**Handling:** Add "Resend verification email" button (rate limited)
**Display:** "Didn't receive the email? [Resend]"

### Expired Verification Link
**Scenario:** User clicks verification link after 24 hours
**Handling:** Show error page: "Verification link expired. Please request a new one."
**Action:** Redirect to profile page, show resend option

## Testing Strategy

### Unit Tests
- Field validation functions
- Form state management
- Image crop calculations
- Email verification token generation

### Integration Tests
- Save profile flow (happy path)
- Email verification flow (happy path)
- Image upload flow (happy path)
- Validation error display
- Unsaved changes dialog

### E2E Tests
- Complete profile edit flow
- Profile picture upload and crop
- Email change with verification
- Error handling scenarios
- Cross-browser testing (Chrome, Firefox, Safari)

### Acceptance Testing
- Load profile in under 500ms (cached)
- Save completes in under 1s
- Image upload under 3s
- Validation errors clear within 100ms of fix
- No XSS vulnerabilities (automated security scan)

## Implementation Checklist

**Phase 1: Basic Profile View/Edit**
- [ ] Create profile page component
- [ ] Implement view/edit mode toggle
- [ ] Add form inputs for all fields
- [ ] Implement field validation
- [ ] Add save/cancel functionality
- [ ] Implement unsaved changes warning

**Phase 2: Backend & API**
- [ ] Create database schema
- [ ] Implement GET /api/profile endpoint
- [ ] Implement PUT /api/profile endpoint
- [ ] Add server-side validation
- [ ] Add authentication checks
- [ ] Add authorization (own profile only)

**Phase 3: Profile Picture Upload**
- [ ] Implement file picker
- [ ] Add file type/size validation
- [ ] Create crop interface component
- [ ] Set up S3 bucket and permissions
- [ ] Implement presigned URL generation
- [ ] Add image resize on server
- [ ] Implement upload progress

**Phase 4: Email Verification**
- [ ] Create email verifications table
- [ ] Implement verification email sending
- [ ] Create verification link handler
- [ ] Add rate limiting for verification emails
- [ ] Implement token expiration
- [ ] Add resend verification functionality

**Phase 5: Polish & Testing**
- [ ] Add loading states
- [ ] Implement error handling
- [ ] Add character counters
- [ ] Implement phone number masking
- [ ] Write unit tests
- [ ] Write integration tests
- [ ] Write E2E tests
- [ ] Performance testing
- [ ] Security audit

## Success Metrics

- Profile load time < 500ms (p95)
- Save success rate > 99%
- Image upload success rate > 95%
- Email verification completion rate > 80%
- User satisfaction score > 4.5/5

---

## Appendix: Rationale for Key Decisions

### Why Edit Mode Instead of Inline Editing?
- **Clarity:** Clear save/cancel actions reduce accidental edits
- **Complexity:** Inline editing adds significant state management complexity
- **Error handling:** Easier to show validation errors in dedicated edit mode
- **Unsaved changes:** Simpler to track and warn about unsaved edits

### Why Email Verification Flow?
- **Security:** Prevents email hijacking attacks
- **Reliability:** Ensures user owns the new email address
- **Industry standard:** Users expect email changes to require verification

### Why S3 for Profile Pictures?
- **Scalability:** Handles unlimited images, no server storage limits
- **Performance:** CDN-ready for fast global delivery
- **Cost:** Cheaper than server storage at scale
- **Separation:** Keeps image storage separate from app logic

### Why Hybrid Validation Timing?
- **Balance:** Not too aggressive (on change from start) or too passive (on submit only)
- **UX research:** Users prefer feedback soon after blur, but not constant re-validation while typing
- **Error recovery:** Once error shown, real-time feedback helps user fix it

### Why No Optimistic Updates?
- **Simplicity:** Easier to implement and reason about
- **Error handling:** Clearer when save fails (no rollback needed)
- **User expectation:** Explicit save action sets expectation of wait time
- **Future:** Can add optimistic updates if users request faster feedback
```

---

## Transformation Analysis

### What Changed
1. **Vague → Specific**: "user-friendly" became detailed UX flows with timing and error handling
2. **Incomplete → Complete**: Added all validation rules, error messages, and edge cases
3. **Ambiguous → Decided**: Made concrete decisions on email verification, image storage, validation timing
4. **Generic → Detailed**: Spec now includes API contracts, database schema, component structure
5. **Assumption → Explicit**: Security model, performance targets, and tradeoffs documented

### Key Interview Techniques Used
- **Offered concrete options** instead of open-ended questions
- **Framed tradeoffs** (edit mode vs inline editing)
- **Probed edge cases** (unsaved changes, concurrent edits, invalid uploads)
- **Quantified vague terms** ("fast" → "<500ms")
- **Iteratively built understanding** (profile fields → validation → UX → technical)

### Result
Original spec was ~10 lines and unimplementable. Refined spec is comprehensive and actionable—a developer could implement this without constant clarification questions.
