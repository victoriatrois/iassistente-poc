#!/bin/bash
# create-issues.sh
# Creates GitHub issues for the iassistente-poc project based on the .md files.
# Usage: ./create-issues.sh [owner/repo]
# Example: ./create-issues.sh victoriatrois/iassistente-poc
# Requires: gh CLI authenticated (run `gh auth login` first)

set -e

REPO="${1:-victoriatrois/iassistente-poc}"

echo "Creating issues in $REPO..."

# ---------------------------------------------------------------------------
# Create labels
# ---------------------------------------------------------------------------
create_label() {
  local name="$1" color="$2" description="$3"
  gh label create "$name" --color "$color" --description "$description" --repo "$REPO" 2>/dev/null \
    || echo "  Label '$name' already exists, skipping."
}

echo "Creating labels..."
create_label "user-story"  "0075ca" "User-facing feature or requirement"
create_label "backend"     "e4e669" "Backend / API work"
create_label "frontend"    "d93f0b" "Frontend / React Native work"
create_label "database"    "0e8a16" "Database / schema work"
create_label "blocker"     "b60205" "Blocks other work"
create_label "phase-1"     "bfd4f2" "Phase 1: User Identification"
create_label "phase-2"     "c5def5" "Phase 2: Core Backend Features"
create_label "phase-3"     "fef2c0" "Phase 3: Frontend Foundation"
create_label "phase-4"     "f9d0c4" "Phase 4: Frontend Features"
create_label "phase-5"     "e1d7f0" "Phase 5: Error Handling & Polish"

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
# Phase 1 – US04: Identify the Current User (BLOCKER)
# ---------------------------------------------------------------------------
create_issue \
  "[US04] Identify the Current User" \
  "## User Story

As a user,
I want my notes to be associated with me,
so that they remain separate from notes created by other users.

## Acceptance Criteria

- [ ] Every note is linked to exactly one user.
- [ ] Users can only access their own notes.
- [ ] Backend identifies the current user before retrieving notes.

## Business Rules

- Every Note must belong to exactly one User.
- A User can own many Notes.
- Users can only access their own Notes.
- The backend must identify the current User before creating or retrieving Notes.

## Implementation Tasks (Backend)

- [ ] Create user service module
- [ ] Setup user identification middleware
- [ ] Create \`POST /api/users\` endpoint (create/get user)
- [ ] Add user ID to request context
- [ ] Document user identification strategy (session ID, token, header-based, etc.)

## Notes

This is the **critical blocker** for all other backend development. Must be completed first.

_Source: [user-stories.md](docs/user-stories.md), [speech-to-text-poc.md](docs/speech-to-text-poc.md), [step-8-suggested-implementation-order.md](docs/step-8-suggested-implementation-order.md)_" \
  "user-story,backend,blocker,phase-1"

# ---------------------------------------------------------------------------
# Phase 2 – US01: Create a Note Using Voice
# ---------------------------------------------------------------------------
create_issue \
  "[US01] Create a Note Using Voice" \
  "## User Story

As a user,
I want to dictate a note using my voice,
so that I can quickly capture information without typing.

## Acceptance Criteria

- [ ] User can start recording.
- [ ] Application requests microphone permission if necessary.
- [ ] Speech is converted into text.
- [ ] User can stop recording.
- [ ] Generated text is displayed.
- [ ] Note is saved successfully.
- [ ] Note is associated with the current user.

## Backend Implementation Tasks (\`POST /api/notes\`)

- [ ] Create endpoint
- [ ] Validate: user exists, content exists, content not empty
- [ ] Associate note with user
- [ ] Store in database
- [ ] Return success response with note ID

### Request payload

\`\`\`json
{ \"content\": \"Today I need to buy milk\" }
\`\`\`

## Frontend Implementation Tasks

- [ ] Create recording screen component
- [ ] Add Start/Stop Recording buttons
- [ ] Integrate speech-to-text library (\`react-native-voice\`)
- [ ] Display transcribed text
- [ ] Add Save button
- [ ] Connect to \`POST /api/notes\`
- [ ] Display save confirmation

## Flow

1. User opens the React Native app.
2. User taps **Start Recording**.
3. App starts listening to the microphone.
4. Speech is converted to text.
5. User taps **Stop Recording**.
6. Written note is sent to the backend.
7. Backend associates the note with the current user.
8. Backend stores the note in the database.
9. User sees confirmation that the note was saved.

_Source: [speech-to-text-poc.md](speech-to-text-poc.md), [step-8-suggested-implementation-order.md](step-8-suggested-implementation-order.md)_" \
  "user-story,backend,frontend,phase-2,phase-4"

# ---------------------------------------------------------------------------
# Phase 2 – US02: View My Saved Notes
# ---------------------------------------------------------------------------
create_issue \
  "[US02] View My Saved Notes" \
  "## User Story

As a user,
I want to see my saved notes,
so that I can review information I captured previously.

## Acceptance Criteria

- [ ] User can access the notes list.
- [ ] Application retrieves notes from the backend.
- [ ] Only notes belonging to the current user are returned.
- [ ] Notes are displayed in a list.
- [ ] Each note displays its content and creation date.

## Backend Implementation Tasks (\`GET /api/notes\`)

- [ ] Create endpoint
- [ ] Identify current user
- [ ] Retrieve only user's notes from database
- [ ] Return as JSON array with \`created_at\` and \`content\`

## Frontend Implementation Tasks

- [ ] Create notes list screen
- [ ] Connect to \`GET /api/notes\`
- [ ] Display notes with dates
- [ ] Add navigation to note detail screen

## Flow

1. User opens the React Native app.
2. User taps **See Notes**.
3. App sends a request to the backend.
4. Backend identifies the current user.
5. Backend retrieves the authenticated user's notes from the database.
6. Backend returns the notes as JSON.
7. App displays a list of notes to the user.

_Source: [speech-to-text-poc.md](speech-to-text-poc.md), [step-8-suggested-implementation-order.md](step-8-suggested-implementation-order.md)_" \
  "user-story,backend,frontend,phase-2,phase-4"

# ---------------------------------------------------------------------------
# Phase 3 – US05: Handle Microphone Permission
# ---------------------------------------------------------------------------
create_issue \
  "[US05] Handle Microphone Permission" \
  "## User Story

As a user,
I want to be informed when microphone access is required,
so that I understand why recording cannot start.

## Acceptance Criteria

- [ ] Application requests microphone permission.
- [ ] If permission is denied, an explanatory message is shown.
- [ ] Recording cannot start without permission.

## Implementation Tasks (Frontend)

- [ ] Setup React Native Permissions library
- [ ] Request microphone permission on app start
- [ ] Handle permission granted scenario
- [ ] Handle permission denied scenario with explanatory message
- [ ] Create basic app structure with screens (Recording, Notes List, Detail)
- [ ] Setup axios client for API communication
- [ ] Create mock data to test UI without backend

**Done when:** Frontend screens render, microphone permission works, buttons respond.

_Source: [speech-to-text-poc.md](speech-to-text-poc.md), [step-8-suggested-implementation-order.md](step-8-suggested-implementation-order.md)_" \
  "user-story,frontend,phase-3"

# ---------------------------------------------------------------------------
# Phase 4 – US03: View a Single Note
# ---------------------------------------------------------------------------
create_issue \
  "[US03] View a Note" \
  "## User Story

As a user,
I want to open a specific note,
so that I can read its complete content.

## Acceptance Criteria

- [ ] User can select a note from the list.
- [ ] Application retrieves the selected note.
- [ ] The selected note belongs to the current user.
- [ ] Complete note content is displayed.

## Implementation Tasks (Frontend)

- [ ] Create note detail screen
- [ ] Display complete note content
- [ ] Add back navigation
- [ ] Display creation date

_Source: [speech-to-text-poc.md](speech-to-text-poc.md), [step-8-suggested-implementation-order.md](step-8-suggested-implementation-order.md)_" \
  "user-story,frontend,phase-4"

# ---------------------------------------------------------------------------
# Phase 5 – US06: Handle Communication Failures
# ---------------------------------------------------------------------------
create_issue \
  "[US06] Handle Communication Failures" \
  "## User Story

As a user,
I want to receive feedback when a save operation fails,
so that I know my note was not stored successfully.

## Acceptance Criteria

- [ ] Application detects communication failures.
- [ ] Error message is displayed.
- [ ] User remains on the current screen.

## Implementation Tasks

- [ ] Add try/catch to all API calls
- [ ] Display user-friendly error messages
- [ ] Handle network timeout scenarios
- [ ] Handle 4xx/5xx API responses
- [ ] Implement retry mechanism (optional)
- [ ] Add loading states to UI
- [ ] Test error scenarios thoroughly

**Done when:** All user interactions gracefully handle failures with informative feedback.

## Non-Functional Requirements (from architecture doc)

- **Permission Handling**: App must request microphone permission before recording begins
- **Network Resilience**: App must handle API unavailability with user-friendly error messages
- **Data Isolation**: Users can only access their own notes (enforced by backend)
- **User Identification**: Every API request must be associated with an authenticated user

_Source: [speech-to-text-poc.md](speech-to-text-poc.md), [step-8-suggested-implementation-order.md](step-8-suggested-implementation-order.md)_" \
  "user-story,frontend,backend,phase-5"

echo ""
echo "✅ All issues created successfully in $REPO"
