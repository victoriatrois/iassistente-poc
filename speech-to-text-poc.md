# Speech-to-Text POC Architecture

## 1. The flow

### Scenario 0 - Identify User

1. User opens the React Native app.
2. User provides authentication credentials (or selects an existing account).
3. App sends authentication data to the backend.
4. Backend validates the user's identity.
5. Backend returns a successful authentication response.
6. App stores the user session information.
7. User can access their notes.

#### Business Rules

- Every Note must belong to exactly one User.
- A User can own many Notes.
- Users can only access their own Notes.
- The backend must identify the current User before creating or retrieving Notes.

#### Domain Model

```text
User
 ├─ id
 ├─ name
 └─ created_at

1 User ─> * Note

Note
 ├─ id
 ├─ user_id
 ├─ content
 ├─ created_at
 └─ updated_at
```

### Scenario 1 - Create Note

1. User opens the React Native app.
2. User taps **Start Recording**.
3. App starts listening to the microphone.
4. Speech is converted to text.
5. User taps **Stop Recording**.
6. Written note is sent to the backend.
7. Backend associates the note with the current user.
8. Backend stores the note in the database.
9. User can see confirmation that the note was saved.

### Scenario 2 - View Notes

1. User opens the React Native app.
2. User taps **See Notes**.
3. App sends a request to the backend.
4. Backend identifies the current user.
5. Backend retrieves the authenticated user's notes from the database.
6. Backend returns the notes as JSON.
7. App displays a list of notes to the user.

## 2. Speech-to-text will happen on the mobile device

Microphone → Speech-to-Text Library → Text → Node API → Database

## 3. React Native responsibilities

### UI Layer

Responsibilities:
- Display buttons
- Display notes
- Display save status
- Display notes taken

### Speech Recognition Layer

Responsibilities:
- Request microphone permission
- Start listening
- Receive spoken note
- Stop listening

### API Communication Layer

Responsibilities:
- Send written note to backend
- Receive success/error response
- Retrieve the current user's notes

Example payload:

{
  "content": "Today I need to buy milk"
}

## 4. Backend responsibilities

### POST /notes

Validates:
- User exists
- Content exists
- Content is not empty

Then:
- Associates the note with the current user
- Stores the note

### GET /notes

Validates:
- User exists
- User is authorized

Then:
- Retrieves only notes belonging to the current user
- Returns them as JSON

## 5. Database Design (Implemented)

**Schema is already created.** See [project-setup-steps-followed.md](project-setup-steps-followed.md) for implementation details.

**Domain Model:**

```text
User
 ├─ id (UUID)
 ├─ name (VARCHAR)
 └─ created_at (TIMESTAMP)

1 User ─> * Note

Note
 ├─ id (UUID)
 ├─ user_id (UUID FK)
 ├─ content (TEXT)
 ├─ created_at (TIMESTAMP)
 └─ updated_at (TIMESTAMP)
```

Business Rule: A Note must belong to exactly one User.

## 6. Technology Stack (Decided)

| Layer | Technology |
|-------|-----------|
| Frontend | React Native + TypeScript |
| Backend | Next.js + TypeScript + Node.js |
| Database | PostgreSQL |
| Speech Recognition | react-native-voice |
| HTTP Client | axios |

## 7. Non-Functional Requirements

- **Permission Handling**: App must request microphone permission before recording begins
- **Network Resilience**: App must handle API unavailability with user-friendly error messages
- **Data Isolation**: Users can only access their own notes (enforced by backend)
- **User Identification**: Every API request must be associated with an authenticated user

## 8. User Stories

### Epic: Note Management

#### US01 - Create a Note Using Voice

As a user,
I want to dictate a note using my voice,
so that I can quickly capture information without typing.

Acceptance Criteria:
- User can start recording.
- Application requests microphone permission if necessary.
- Speech is converted into text.
- User can stop recording.
- Generated text is displayed.
- Note is saved successfully.
- Note is associated with the current user.

#### US02 - View My Saved Notes

As a user,
I want to see my saved notes,
so that I can review information I captured previously.

Acceptance Criteria:
- User can access the notes list.
- Application retrieves notes from the backend.
- Only notes belonging to the current user are returned.
- Notes are displayed in a list.
- Each note displays its content and creation date.

#### US03 - View a Note

As a user,
I want to open a specific note,
so that I can read its complete content.

Acceptance Criteria:
- User can select a note from the list.
- Application retrieves the selected note.
- The selected note belongs to the current user.
- Complete note content is displayed.

### Epic: User Management

#### US04 - Identify the Current User

As a user,
I want my notes to be associated with me,
so that they remain separate from notes created by other users.

Acceptance Criteria:
- Every note is linked to exactly one user.
- Users can only access their own notes.
- Backend identifies the current user before retrieving notes.

### Epic: Reliability

#### US05 - Handle Microphone Permission

As a user,
I want to be informed when microphone access is required,
so that I understand why recording cannot start.

Acceptance Criteria:
- Application requests microphone permission.
- If permission is denied, an explanatory message is shown.
- Recording cannot start without permission.

#### US06 - Handle Communication Failures

As a user,
I want to receive feedback when a save operation fails,
so that I know my note was not stored successfully.

Acceptance Criteria:
- Application detects communication failures.
- Error message is displayed.
- User remains on the current screen.
