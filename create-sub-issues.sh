#!/bin/bash
# create-sub-issues.sh
# Creates GitHub sub-issues for the iassistente-poc project based on implementation tasks.
# These are child issues of the main user stories.
# Usage: ./create-sub-issues.sh [owner/repo]
# Example: ./create-sub-issues.sh victoriatrois/iassistente-poc
# Requires: gh CLI authenticated (run `gh auth login` first)

set -e

REPO="${1:-victoriatrois/iassistente-poc}"

echo "Creating sub-issues in $REPO..."
echo "Reference: implementation-tasks.md"
echo ""

# ---------------------------------------------------------------------------
# Helper
# ---------------------------------------------------------------------------
create_issue() {
  local title="$1" body="$2" labels="$3"
  echo "  Creating: $title"
  gh issue create \
    --title "$title" \
    --body "$body" \
    --label "$labels" \
    --repo "$REPO"
}

# ---------------------------------------------------------------------------
# Phase 1 – US04 Sub-tasks
# ---------------------------------------------------------------------------
echo "📋 Phase 1: User Identification (US04 Sub-tasks)"

create_issue \
  "[04.1] Create User Service Module" \
  "## Task

Create TypeScript service with database queries for user management.

## Deliverable

\`backend/lib/userService.ts\`

## Functions

\`\`\`typescript
export async function createUser(name: string): Promise<{ id: string; name: string; created_at: string }> {
  // Insert into users table, return new user
}

export async function getUserById(id: string): Promise<{ id: string; name: string; created_at: string } | null> {
  // Query users table, return user or null
}
\`\`\`

## Acceptance Criteria

- [ ] Can create user in database
- [ ] Can retrieve user by ID
- [ ] Handles database errors gracefully
- [ ] Unit tests pass

## Duration

~1 day

## Related

- Parent: [US04] Identify the Current User

_Source: [implementation-tasks.md](implementation-tasks.md)_" \
  "backend,phase-1"

create_issue \
  "[04.2] Create User Identification Middleware" \
  "## Task

Express middleware to extract and identify user from request.

## Deliverable

\`backend/middleware/userAuth.ts\`

## Strategy

Use query parameter (e.g., \`?userId=abc-123\`) for POC.

## Behavior

- Extract \`userId\` from query params
- Call \`getUserById(userId)\`
- Set \`req.user = { id, name, created_at }\` on request context
- Return 401 if user not found

## Acceptance Criteria

- [ ] Middleware sets \`req.user\` correctly
- [ ] Returns 401 for invalid user ID
- [ ] Middleware chain works
- [ ] Unit tests pass

## Duration

~0.5 days

## Related

- Parent: [US04] Identify the Current User
- Depends on: [04.1] Create User Service Module

_Source: [implementation-tasks.md](implementation-tasks.md)_" \
  "backend,phase-1"

create_issue \
  "[04.3] Create POST /api/users Endpoint" \
  "## Task

API endpoint to create or get user.

## Deliverable

\`backend/app/api/users/route.ts\` (Next.js API route)

## Request

\`\`\`json
POST /api/users
{ \"name\": \"Victoria\" }
\`\`\`

## Response (Success)

\`\`\`json
200 OK
{ \"id\": \"uuid\", \"name\": \"Victoria\", \"created_at\": \"2026-06-27T...\" }
\`\`\`

## Response (Error)

\`\`\`json
400 Bad Request
{ \"error\": \"Name is required\" }
\`\`\`

## Behavior

- If user exists → return existing user
- If not → create new user with provided name

## Acceptance Criteria

- [ ] Creates new users
- [ ] Returns existing users if already created
- [ ] Validates name field (not empty)
- [ ] Returns correct HTTP status codes
- [ ] API tests pass

## Duration

~1 day

## Related

- Parent: [US04] Identify the Current User
- Depends on: [04.1] Create User Service Module, [04.2] Create User Identification Middleware

_Source: [implementation-tasks.md](implementation-tasks.md)_" \
  "backend,phase-1"

create_issue \
  "[04.4] Document User Identification Strategy" \
  "## Task

Write decision document explaining the user identification approach.

## Deliverable

\`backend/docs/user-identification-strategy.md\`

## Content

- Why query param approach for POC (simple, stateless)
- Limitations (not secure, for development only)
- Migration path to JWT tokens in production
- Example requests/responses

## Acceptance Criteria

- [ ] Document explains current approach
- [ ] Lists security considerations
- [ ] Suggests production improvements

## Duration

~0.5 days

## Related

- Parent: [US04] Identify the Current User

_Source: [implementation-tasks.md](implementation-tasks.md)_" \
  "backend,phase-1,documentation"

# ---------------------------------------------------------------------------
# Phase 2 – US01 Backend Sub-tasks
# ---------------------------------------------------------------------------
echo ""
echo "📋 Phase 2: Core Backend (US01 Backend Sub-tasks)"

create_issue \
  "[01B.1] Create Note Service Module" \
  "## Task

Create TypeScript service with database operations for notes.

## Deliverable

\`backend/lib/noteService.ts\`

## Functions

\`\`\`typescript
export async function createNote(userId: string, content: string): Promise<{
  id: string;
  user_id: string;
  content: string;
  created_at: string;
}> {
  // Insert into notes table, return new note
}

export function validateNoteContent(content: string): boolean {
  // Ensure content exists and is not empty
  return content && content.trim().length > 0;
}
\`\`\`

## Acceptance Criteria

- [ ] Creates note in database with correct user_id
- [ ] Validates content (not null, not empty)
- [ ] Returns note with all fields
- [ ] Unit tests pass

## Duration

~1 day

## Related

- Parent: [US01] Create a Note Using Voice
- Depends on: Phase 1 complete (user identification)

_Source: [implementation-tasks.md](implementation-tasks.md)_" \
  "backend,phase-2"

create_issue \
  "[01B.2] Create POST /api/notes Endpoint" \
  "## Task

API endpoint to save a note to the database.

## Deliverable

\`backend/app/api/notes/route.ts\` (Next.js API route)

## Request

\`\`\`json
POST /api/notes?userId=abc-123
{ \"content\": \"Today I need to buy milk\" }
\`\`\`

## Response (Success)

\`\`\`json
201 Created
{ \"id\": \"note-uuid\", \"user_id\": \"abc-123\", \"content\": \"...\", \"created_at\": \"...\" }
\`\`\`

## Response (Error)

\`\`\`json
400 Bad Request
{ \"error\": \"Content is required and cannot be empty\" }
\`\`\`

## Validations

- User exists (use middleware)
- Content exists
- Content is not empty

## Error Handling

- 400 for validation errors
- 401 for missing/invalid user
- 500 for database errors

## Acceptance Criteria

- [ ] Creates note in database
- [ ] Validates all inputs
- [ ] Returns correct HTTP status codes
- [ ] API tests pass (happy path + all errors)

## Duration

~1 day

## Related

- Parent: [US01] Create a Note Using Voice
- Depends on: [01B.1] Create Note Service Module, Phase 1 complete

_Source: [implementation-tasks.md](implementation-tasks.md)_" \
  "backend,phase-2"

create_issue \
  "[01B.3] Add API Error Handling & Logging" \
  "## Task

Centralized error handler for POST /api/notes with structured logging.

## Deliverable

\`backend/lib/errorHandler.ts\`, update route

## Behavior

- All errors return consistent JSON format:
  \`\`\`json
  { \"error\": \"User friendly message\", \"status\": 400 }
  \`\`\`
- Log all errors with timestamp and context
- Different errors have different status codes

## Acceptance Criteria

- [ ] All errors caught and handled
- [ ] Consistent error response format
- [ ] Logging works
- [ ] Tests cover error scenarios

## Duration

~1 day

## Related

- Parent: [US01] Create a Note Using Voice
- Depends on: [01B.2] Create POST /api/notes Endpoint

_Source: [implementation-tasks.md](implementation-tasks.md)_" \
  "backend,phase-2"

# ---------------------------------------------------------------------------
# Phase 2 – US02 Backend Sub-tasks
# ---------------------------------------------------------------------------
echo ""
echo "📋 Phase 2: Core Backend (US02 Backend Sub-tasks)"

create_issue \
  "[02B.1] Create GET /api/notes Endpoint" \
  "## Task

API endpoint to retrieve only the current user's notes.

## Deliverable

\`backend/app/api/notes/GET/route.ts\`

## Request

\`\`\`
GET /api/notes?userId=abc-123
\`\`\`

## Response

\`\`\`json
200 OK
{
  \"notes\": [
    { \"id\": \"uuid1\", \"content\": \"Note 1\", \"created_at\": \"...\" },
    { \"id\": \"uuid2\", \"content\": \"Note 2\", \"created_at\": \"...\" }
  ]
}
\`\`\`

## Behavior

- Identify current user (middleware)
- Query: \`SELECT * FROM note WHERE user_id = ? ORDER BY created_at DESC\`
- Return all user's notes

## Acceptance Criteria

- [ ] Returns only current user's notes
- [ ] Rejects requests with invalid/missing user
- [ ] Returns empty array if no notes
- [ ] Tests verify user isolation

## Duration

~1 day

## Related

- Parent: [US02] View My Saved Notes
- Depends on: Phase 1 complete

_Source: [implementation-tasks.md](implementation-tasks.md)_" \
  "backend,phase-2"

create_issue \
  "[02B.2] Add Pagination to GET /api/notes" \
  "## Task

Add pagination support to GET /api/notes for handling large datasets.

## Deliverable

Update \`backend/app/api/notes/GET/route.ts\`

## Request

\`\`\`
GET /api/notes?userId=abc-123&limit=10&offset=0
\`\`\`

## Response

\`\`\`json
200 OK
{
  \"notes\": [...],
  \"total\": 42,
  \"limit\": 10,
  \"offset\": 0
}
\`\`\`

## Behavior

- Add LIMIT and OFFSET to SQL query
- Return total count for frontend

## Acceptance Criteria

- [ ] Pagination works correctly
- [ ] Tests cover boundary cases (offset out of range, etc.)

## Duration

~1 day

## Related

- Parent: [US02] View My Saved Notes
- Depends on: [02B.1] Create GET /api/notes Endpoint

_Source: [implementation-tasks.md](implementation-tasks.md)_" \
  "backend,phase-2"

# ---------------------------------------------------------------------------
# Phase 3 – US05 Frontend Sub-tasks
# ---------------------------------------------------------------------------
echo ""
echo "📋 Phase 3: Frontend Foundation (US05 Sub-tasks)"

create_issue \
  "[05F.1] Setup Permissions Library" \
  "## Task

Install and configure react-native-permissions library.

## Deliverable

\`frontend/lib/permissions.ts\` - initialization and helper functions

## Functions

\`\`\`typescript
export async function checkMicrophonePermission(): Promise<string> {
  // Return permission status (granted, denied, unknown, etc.)
}

export async function requestMicrophonePermission(): Promise<boolean> {
  // Request permission, return true if granted
}
\`\`\`

## Acceptance Criteria

- [ ] Library installed
- [ ] Can check permission status
- [ ] Can request permission
- [ ] Works on iOS and Android

## Duration

~0.5 days

## Related

- Parent: [US05] Handle Microphone Permission

_Source: [implementation-tasks.md](implementation-tasks.md)_" \
  "frontend,phase-3"

create_issue \
  "[05F.2] Create Permission Request Hook" \
  "## Task

Create React hook to handle microphone permission requests.

## Deliverable

\`frontend/hooks/useAudioPermission.ts\`

## Hook

\`\`\`typescript
export function useAudioPermission() {
  const [status, setStatus] = useState('unknown');
  const isGranted = status === 'granted';
  
  const requestPermission = async () => {
    // Request and return result
  };
  
  return { status, isGranted, requestPermission };
}
\`\`\`

## Acceptance Criteria

- [ ] Returns current permission status
- [ ] Can request permission
- [ ] Updates state correctly
- [ ] Tests pass

## Duration

~1 day

## Related

- Parent: [US05] Handle Microphone Permission
- Depends on: [05F.1] Setup Permissions Library

_Source: [implementation-tasks.md](implementation-tasks.md)_" \
  "frontend,phase-3"

create_issue \
  "[05F.3] Create Permission UI Component" \
  "## Task

Create a UI component to display permission status and request button.

## Deliverable

\`frontend/components/PermissionPrompt.tsx\`

## Scenarios

- **Granted:** Hide component
- **Denied:** Show \"Microphone permission denied. Please enable in Settings.\"
- **Requesting:** Show \"Requesting permission...\"
- **Not asked yet:** Show \"Enable Microphone\" button

## Acceptance Criteria

- [ ] Renders correctly for all states
- [ ] Button requests permission
- [ ] Messages are clear
- [ ] Visual tests pass

## Duration

~1 day

## Related

- Parent: [US05] Handle Microphone Permission
- Depends on: [05F.2] Create Permission Request Hook

_Source: [implementation-tasks.md](implementation-tasks.md)_" \
  "frontend,phase-3"

create_issue \
  "[05F.4] Setup Basic App Navigation" \
  "## Task

Create app shell with basic screen structure and navigation.

## Deliverable

- \`frontend/navigation/RootNavigator.tsx\`
- \`frontend/screens/RecordingScreen.tsx\` (stub)
- \`frontend/screens/NotesListScreen.tsx\` (stub)
- \`frontend/screens/NoteDetailScreen.tsx\` (stub)

## Structure

\`\`\`
App
├─ RecordingScreen
├─ NotesListScreen
└─ NoteDetailScreen
\`\`\`

## Acceptance Criteria

- [ ] App renders without errors
- [ ] Can navigate between screens
- [ ] All screens render (even if empty)

## Duration

~1 day

## Related

- Parent: [US05] Handle Microphone Permission

_Source: [implementation-tasks.md](implementation-tasks.md)_" \
  "frontend,phase-3"

create_issue \
  "[05F.5] Setup Axios API Client" \
  "## Task

Create API client module for backend communication.

## Deliverable

\`frontend/lib/api.ts\`

## Functions

\`\`\`typescript
const API_BASE_URL = 'http://localhost:3000';

export const apiClient = axios.create({
  baseURL: API_BASE_URL,
});

export async function createUser(name: string): Promise<User> { ... }
export async function getNotes(userId: string): Promise<Note[]> { ... }
export async function createNote(userId: string, content: string): Promise<Note> { ... }
\`\`\`

## Acceptance Criteria

- [ ] Axios configured with correct base URL
- [ ] Helper functions for all endpoints
- [ ] Error handling
- [ ] Tests pass

## Duration

~0.5 days

## Related

- Parent: [US05] Handle Microphone Permission

_Source: [implementation-tasks.md](implementation-tasks.md)_" \
  "frontend,phase-3"

create_issue \
  "[05F.6] Create Mock Data for Testing" \
  "## Task

Create mock data to test UI without backend.

## Deliverable

\`frontend/lib/mockData.ts\`

## Content

\`\`\`typescript
export const mockUser = { id: '123', name: 'Victoria' };
export const mockNotes = [
  { id: '1', content: 'Buy milk', created_at: '...' },
  { id: '2', content: 'Call John', created_at: '...' }
];
\`\`\`

## Acceptance Criteria

- [ ] Realistic mock data
- [ ] Can be imported in components

## Duration

~0.5 days

## Related

- Parent: [US05] Handle Microphone Permission

_Source: [implementation-tasks.md](implementation-tasks.md)_" \
  "frontend,phase-3"

# ---------------------------------------------------------------------------
# Phase 4 – US01 Frontend Sub-tasks
# ---------------------------------------------------------------------------
echo ""
echo "📋 Phase 4: Frontend Features (US01 Frontend Sub-tasks)"

create_issue \
  "[01F.1] Create Recording Screen Component" \
  "## Task

Build UI for recording screen with buttons and text display.

## Deliverable

\`frontend/screens/RecordingScreen.tsx\` (enhanced)

## UI Elements

- Start Recording button
- Stop Recording button (disabled initially)
- Text display area for transcribed content
- Save button (disabled if no content)

## Acceptance Criteria

- [ ] Screen renders correctly
- [ ] Buttons are positioned well
- [ ] All UI elements visible
- [ ] No runtime errors

## Duration

~1 day

## Related

- Parent: [US01] Create a Note Using Voice
- Depends on: Phase 3 complete

_Source: [implementation-tasks.md](implementation-tasks.md)_" \
  "frontend,phase-4"

create_issue \
  "[01F.2] Integrate Speech-to-Text Library" \
  "## Task

Connect react-native-voice library to recording screen.

## Deliverable

Update \`frontend/screens/RecordingScreen.tsx\`

## Behavior

- Start button triggers recording
- Stop button stops recording
- Transcribed text displayed in real-time
- Handle recording errors

## Acceptance Criteria

- [ ] Can start recording
- [ ] Can stop recording
- [ ] Text appears on screen
- [ ] Works on iOS and Android emulators
- [ ] Tests pass

## Duration

~1.5 days

## Related

- Parent: [US01] Create a Note Using Voice
- Depends on: [01F.1] Create Recording Screen Component

_Source: [implementation-tasks.md](implementation-tasks.md)_" \
  "frontend,phase-4"

create_issue \
  "[01F.3] Add Save Button & API Integration" \
  "## Task

Implement save functionality and integrate with backend API.

## Deliverable

Update \`frontend/screens/RecordingScreen.tsx\`

## Behavior

- Save button sends \`{ content, userId }\` to backend
- Show loading state while saving
- Show success message: \"Note saved!\"
- Show error message if save fails

## Acceptance Criteria

- [ ] Can save note
- [ ] Loading state displays
- [ ] Success/error messages display
- [ ] API tests pass (mocked)

## Duration

~1 day

## Related

- Parent: [US01] Create a Note Using Voice
- Depends on: [01F.2] Integrate Speech-to-Text Library, Phase 2 complete

_Source: [implementation-tasks.md](implementation-tasks.md)_" \
  "frontend,phase-4"

create_issue \
  "[01F.4] Add Error Handling to Recording Screen" \
  "## Task

Add comprehensive error handling to recording screen.

## Deliverable

Update \`frontend/screens/RecordingScreen.tsx\`

## Error Scenarios

- Permission denied → Show permission prompt
- Recording failed → Show \"Recording failed, try again\"
- Save failed → Show \"Save failed, retry?\"

## Acceptance Criteria

- [ ] Error messages clear and helpful
- [ ] User can retry after error
- [ ] Tests cover error paths

## Duration

~1 day

## Related

- Parent: [US01] Create a Note Using Voice
- Depends on: [01F.3] Add Save Button & API Integration

_Source: [implementation-tasks.md](implementation-tasks.md)_" \
  "frontend,phase-4"

# ---------------------------------------------------------------------------
# Phase 4 – US02 Frontend Sub-tasks
# ---------------------------------------------------------------------------
echo ""
echo "📋 Phase 4: Frontend Features (US02 Frontend Sub-tasks)"

create_issue \
  "[02F.1] Create Notes List Screen Component" \
  "## Task

Build UI for notes list screen.

## Deliverable

\`frontend/screens/NotesListScreen.tsx\` (enhanced)

## UI Elements

- FlatList of notes
- Each note shows: content preview + creation date
- Pull-to-refresh to reload
- Empty state message if no notes

## Acceptance Criteria

- [ ] Screen renders correctly
- [ ] List displays with mock data
- [ ] Pull-to-refresh works
- [ ] Empty state displays

## Duration

~1 day

## Related

- Parent: [US02] View My Saved Notes
- Depends on: Phase 3 complete

_Source: [implementation-tasks.md](implementation-tasks.md)_" \
  "frontend,phase-4"

create_issue \
  "[02F.2] Connect GET /api/notes Endpoint" \
  "## Task

Implement API integration to fetch user's notes.

## Deliverable

Update \`frontend/screens/NotesListScreen.tsx\`

## Behavior

- Fetch notes when screen loads
- Display loading spinner while fetching
- Display error message if fetch fails
- Refresh on pull-to-refresh

## Acceptance Criteria

- [ ] Fetches notes from backend
- [ ] Loading state displays
- [ ] Error state displays
- [ ] Data refreshes on pull
- [ ] Tests pass

## Duration

~1 day

## Related

- Parent: [US02] View My Saved Notes
- Depends on: [02F.1] Create Notes List Screen Component, Phase 2 complete

_Source: [implementation-tasks.md](implementation-tasks.md)_" \
  "frontend,phase-4"

create_issue \
  "[02F.3] Add Note Selection & Navigation" \
  "## Task

Implement navigation to note detail screen.

## Deliverable

Update navigation and routes

## Behavior

- Tap note in list → navigate to \`NoteDetailScreen\`
- Pass note ID as parameter
- Detail screen retrieves and displays note

## Acceptance Criteria

- [ ] Navigation works
- [ ] Correct note displayed on detail screen
- [ ] Can go back to list

## Duration

~0.5 days

## Related

- Parent: [US02] View My Saved Notes
- Depends on: [02F.2] Connect GET /api/notes Endpoint

_Source: [implementation-tasks.md](implementation-tasks.md)_" \
  "frontend,phase-4"

# ---------------------------------------------------------------------------
# Phase 4 – US03 Frontend Sub-tasks
# ---------------------------------------------------------------------------
echo ""
echo "📋 Phase 4: Frontend Features (US03 Frontend Sub-tasks)"

create_issue \
  "[03F.1] Create Note Detail Screen" \
  "## Task

Build UI for viewing a single note.

## Deliverable

\`frontend/screens/NoteDetailScreen.tsx\` (enhanced)

## UI Elements

- Full note content
- Creation date
- Back button

## Acceptance Criteria

- [ ] Displays note correctly
- [ ] Date formatted nicely
- [ ] Navigation works

## Duration

~1 day

## Related

- Parent: [US03] View a Note
- Depends on: [02F.3] Add Note Selection & Navigation

_Source: [implementation-tasks.md](implementation-tasks.md)_" \
  "frontend,phase-4"

# ---------------------------------------------------------------------------
# Phase 5 – US06 Sub-tasks
# ---------------------------------------------------------------------------
echo ""
echo "📋 Phase 5: Error Handling & Polish (US06 Sub-tasks)"

create_issue \
  "[06.1] Add Try/Catch to All API Calls" \
  "## Task

Wrap all API calls in error handlers across the application.

## Deliverable

Update all components using API:
- POST /api/users
- POST /api/notes
- GET /api/notes

## Acceptance Criteria

- [ ] No unhandled promise rejections
- [ ] All errors caught and logged
- [ ] User sees error messages
- [ ] Tests pass

## Duration

~1 day

## Related

- Parent: [US06] Handle Communication Failures

_Source: [implementation-tasks.md](implementation-tasks.md)_" \
  "frontend,phase-5"

create_issue \
  "[06.2] Create Error Message Component" \
  "## Task

Build reusable error message component for consistent error display.

## Deliverable

\`frontend/components/ErrorAlert.tsx\`

## Features

- Shows error message
- Retry button
- Dismiss button

## Acceptance Criteria

- [ ] Renders errors clearly
- [ ] Buttons work
- [ ] Can be reused across screens
- [ ] Tests pass

## Duration

~1 day

## Related

- Parent: [US06] Handle Communication Failures
- Depends on: [06.1] Add Try/Catch to All API Calls

_Source: [implementation-tasks.md](implementation-tasks.md)_" \
  "frontend,phase-5"

create_issue \
  "[06.3] Add Retry Logic" \
  "## Task

Implement automatic retry mechanism for failed API calls.

## Deliverable

\`frontend/lib/retryUtils.ts\`

## Behavior

- Retry failed requests up to 3 times
- Exponential backoff (1s, 2s, 4s)

## Acceptance Criteria

- [ ] Retries work
- [ ] Backoff timing correct
- [ ] Tests pass

## Duration

~1 day

## Related

- Parent: [US06] Handle Communication Failures
- Depends on: [06.2] Create Error Message Component

_Source: [implementation-tasks.md](implementation-tasks.md)_" \
  "frontend,phase-5"

echo ""
echo "✅ All sub-issues created successfully in $REPO"
echo ""
echo "📊 Summary:"
echo "  Phase 1 (US04):     4 tasks"
echo "  Phase 2 (US01-02):  5 tasks (backend only)"
echo "  Phase 3 (US05):     6 tasks (frontend only)"
echo "  Phase 4 (US01-03):  7 tasks (frontend only)"
echo "  Phase 5 (US06):     3 tasks (frontend + backend)"
echo "  ─────────────────────────"
echo "  Total:             25 sub-tasks"
echo ""
echo "Total estimated duration: 25-30 days of work"
echo "With 2 developers in parallel: ~15 days"
