# Implementation Tasks Breakdown

This document breaks down each user story into concrete, independently testable tasks that can be completed in 1-2 days.

**Reference:** [user-stories.md](user-stories.md) | [speech-to-text-poc.md](speech-to-text-poc.md)

---

## Phase 1: User Identification (US04)

### Task 04.1: Create User Service Module

- **User Story:** US04
- **Duration:** ~1 day
- **What:** TypeScript service with database queries
- **Deliverable:** `backend/lib/userService.ts`
- **Functions:**
  - `createUser(name: string)` → returns `{ id, name, created_at }`
  - `getUserById(id: string)` → returns user object or null
  - Database connection pool
- **Acceptance Criteria:**
  - Can create user in database
  - Can retrieve user by ID
  - Handles database errors gracefully
  - Unit tests pass
- **Done when:** Both functions tested and working with real database

---

### Task 04.2: Create User Identification Middleware

- **User Story:** US04
- **Duration:** ~0.5 days
- **What:** Express middleware to extract user from request
- **Deliverable:** `backend/middleware/userAuth.ts`
- **Strategy:** Use query parameter (e.g., `?userId=abc-123`)
- **Behavior:**
  - Extracts `userId` from query params
  - Calls `getUserById(userId)`
  - Sets `req.user = { id, name, created_at }` on request context
  - Returns 401 if user not found
- **Acceptance Criteria:**
  - Middleware sets `req.user` correctly
  - Returns 401 for invalid user ID
  - Middleware chain works
  - Unit tests pass
- **Done when:** Any route can access `req.user.id` after middleware runs

---

### Task 04.3: Create POST /api/users Endpoint

- **User Story:** US04
- **Duration:** ~1 day
- **What:** Endpoint to create or get user
- **Deliverable:** `backend/app/api/users/route.ts` (Next.js API route)
- **Request:**
  ```json
  POST /api/users
  { "name": "Victoria" }
  ```
- **Response (Success):**
  ```json
  200 OK
  { "id": "uuid", "name": "Victoria", "created_at": "2026-06-27T..." }
  ```
- **Response (Error):**
  ```json
  400 Bad Request
  { "error": "Name is required" }
  ```
- **Behavior:**
  - If user exists → return existing user
  - If not → create new user with provided name
- **Acceptance Criteria:**
  - Creates new users
  - Returns existing users if already created
  - Validates name field (not empty)
  - Returns correct HTTP status codes
  - API tests pass
- **Done when:** Frontend can call endpoint and get user ID

---

### Task 04.4: Document User Identification Strategy

- **User Story:** US04
- **Duration:** ~0.5 days
- **What:** Write decision document
- **Deliverable:** `backend/docs/user-identification-strategy.md`
- **Content:**
  - Why query param approach for POC (simple, stateless)
  - Limitations (not secure, for development only)
  - Migration path to JWT tokens in production
  - Example requests/responses
- **Acceptance Criteria:**
  - Document explains current approach
  - Lists security considerations
  - Suggests production improvements
- **Done when:** Any developer can understand the user ID strategy

---

## Phase 2: Core Backend Features

### Task 01B.1: Create Note Service Module

- **User Story:** US01
- **Duration:** ~1 day
- **What:** `backend/lib/noteService.ts` - database operations for notes
- **Deliverable:**
  - `createNote(userId: string, content: string)` → `{ id, user_id, content, created_at }`
  - `validateNoteContent(content: string)` → `boolean`
- **Functions:**
  ```typescript
  export async function createNote(userId: string, content: string) {
    // Insert into notes table, return new note
  }

  export function validateNoteContent(content: string): boolean {
    // Ensure content exists and is not empty
    return content && content.trim().length > 0;
  }
  ```
- **Acceptance Criteria:**
  - Creates note in database with correct user_id
  - Validates content (not null, not empty)
  - Returns note with all fields
  - Unit tests pass
- **Done when:** Can create and validate notes

---

### Task 01B.2: Create POST /api/notes Endpoint

- **User Story:** US01
- **Duration:** ~1 day
- **What:** API endpoint to save a note
- **Deliverable:** `backend/app/api/notes/route.ts` (Next.js API route)
- **Request:**
  ```json
  POST /api/notes?userId=abc-123
  { "content": "Today I need to buy milk" }
  ```
- **Response (Success):**
  ```json
  201 Created
  { "id": "note-uuid", "user_id": "abc-123", "content": "...", "created_at": "..." }
  ```
- **Response (Error):**
  ```json
  400 Bad Request
  { "error": "Content is required and cannot be empty" }
  ```
- **Validations:**
  - User exists (use middleware from 04.2)
  - Content exists
  - Content is not empty
- **Error Handling:**
  - 400 for validation errors
  - 401 for missing/invalid user
  - 500 for database errors
- **Acceptance Criteria:**
  - Creates note in database
  - Validates all inputs
  - Returns correct HTTP status codes
  - API tests pass (happy path + all errors)
- **Done when:** Frontend can POST a note and it's stored in DB

---

### Task 01B.3: Add API Error Handling & Logging

- **User Story:** US01
- **Duration:** ~1 day
- **What:** Centralized error handler for POST /api/notes
- **Deliverable:** `backend/lib/errorHandler.ts`, update route
- **Behavior:**
  - All errors return consistent JSON format:
    ```json
    { "error": "User friendly message", "status": 400 }
    ```
  - Log all errors with timestamp and context
  - Different errors have different status codes
- **Acceptance Criteria:**
  - All errors caught and handled
  - Consistent error response format
  - Logging works
  - Tests cover error scenarios
- **Done when:** All errors return structured responses and are logged

---

### Task 02B.1: Create GET /api/notes Endpoint

- **User Story:** US02
- **Duration:** ~1 day
- **What:** Retrieve only current user's notes
- **Deliverable:** `backend/app/api/notes/GET/route.ts`
- **Request:**
  ```
  GET /api/notes?userId=abc-123
  ```
- **Response:**
  ```json
  200 OK
  {
    "notes": [
      { "id": "uuid1", "content": "Note 1", "created_at": "..." },
      { "id": "uuid2", "content": "Note 2", "created_at": "..." }
    ]
  }
  ```
- **Behavior:**
  - Identify current user (middleware)
  - Query database: `SELECT * FROM note WHERE user_id = ? ORDER BY created_at DESC`
  - Return all user's notes
- **Acceptance Criteria:**
  - Returns only current user's notes
  - Rejects requests with invalid/missing user
  - Returns empty array if no notes
  - Tests verify user isolation
- **Done when:** Can retrieve all user's notes

---

### Task 02B.2: Add Pagination to GET /api/notes

- **User Story:** US02
- **Duration:** ~1 day
- **What:** Support `?limit=10&offset=0` for large datasets
- **Deliverable:** Update GET /api/notes route
- **Request:**
  ```
  GET /api/notes?userId=abc-123&limit=10&offset=0
  ```
- **Response:**
  ```json
  200 OK
  {
    "notes": [...],
    "total": 42,
    "limit": 10,
    "offset": 0
  }
  ```
- **Behavior:**
  - Add LIMIT and OFFSET to SQL query
  - Return total count for frontend
- **Acceptance Criteria:**
  - Pagination works correctly
  - Tests cover boundary cases (offset out of range, etc.)
- **Done when:** Frontend can implement infinite scroll

---

## Phase 3: Frontend Foundation

### Task 05F.1: Setup Permissions Library

- **User Story:** US05
- **Duration:** ~0.5 days
- **What:** Install & configure `react-native-permissions`
- **Deliverable:** `frontend/lib/permissions.ts` - initialization and helper functions
- **Functions:**
  - `checkMicrophonePermission()` → status
  - `requestMicrophonePermission()` → true/false
- **Acceptance Criteria:**
  - Library installed
  - Can check permission status
  - Can request permission
  - Works on iOS and Android
- **Done when:** Can check permission status

---

### Task 05F.2: Create Permission Request Hook

- **User Story:** US05
- **Duration:** ~1 day
- **What:** React hook to handle microphone permission
- **Deliverable:** `frontend/hooks/useAudioPermission.ts`
- **Hook:**
  ```typescript
  export function useAudioPermission() {
    const [status, setStatus] = useState("unknown");
    const isGranted = status === "granted";

    const requestPermission = async () => {
      // Request and return result
    };

    return { status, isGranted, requestPermission };
  }
  ```
- **Acceptance Criteria:**
  - Returns current permission status
  - Can request permission
  - Updates state correctly
  - Tests pass
- **Done when:** Hook works in a test component

---

### Task 05F.3: Create Permission UI Component

- **User Story:** US05
- **Duration:** ~1 day
- **What:** Show permission status & request button
- **Deliverable:** `frontend/components/PermissionPrompt.tsx`
- **Scenarios:**
  - **Granted:** Hide component
  - **Denied:** Show "Microphone permission denied. Please enable in Settings."
  - **Requesting:** Show "Requesting permission..."
  - **Not asked yet:** Show "Enable Microphone" button
- **Acceptance Criteria:**
  - Renders correctly for all states
  - Button requests permission
  - Messages are clear
  - Visual tests pass
- **Done when:** User sees appropriate messages

---

### Task 05F.4: Setup Basic App Navigation

- **User Story:** US05
- **Duration:** ~1 day
- **What:** Create app shell with screens
- **Deliverable:**
  - `frontend/navigation/RootNavigator.tsx`
  - `frontend/screens/RecordingScreen.tsx` (stub)
  - `frontend/screens/NotesListScreen.tsx` (stub)
  - `frontend/screens/NoteDetailScreen.tsx` (stub)
- **Structure:**
  ```
  App
  ├─ RecordingScreen
  ├─ NotesListScreen
  └─ NoteDetailScreen
  ```
- **Acceptance Criteria:**
  - App renders without errors
  - Can navigate between screens
  - All screens render (even if empty)
- **Done when:** App structure works

---

### Task 05F.5: Setup Axios API Client

- **User Story:** US05
- **Duration:** ~0.5 days
- **What:** Create API client module
- **Deliverable:** `frontend/lib/api.ts`
- **Functions:**
  ```typescript
  const API_BASE_URL = 'http://localhost:3000';

  export const apiClient = axios.create({
    baseURL: API_BASE_URL,
  });

  export async function createUser(name: string) { ... }
  export async function getNotes(userId: string) { ... }
  export async function createNote(userId: string, content: string) { ... }
  ```
- **Acceptance Criteria:**
  - Axios configured with correct base URL
  - Helper functions for all endpoints
  - Error handling
- **Done when:** Can make API calls from components

---

### Task 05F.6: Create Mock Data for Testing

- **User Story:** US05
- **Duration:** ~0.5 days
- **What:** Mock data to test UI without backend
- **Deliverable:** `frontend/lib/mockData.ts`
- **Content:**
  ```typescript
  export const mockUser = { id: "123", name: "Victoria" };
  export const mockNotes = [
    { id: "1", content: "Buy milk", created_at: "..." },
    { id: "2", content: "Call John", created_at: "..." },
  ];
  ```
- **Acceptance Criteria:**
  - Realistic mock data
  - Can be imported in components
- **Done when:** Can test UI without real backend

---

## Phase 4: Frontend Features

### Task 01F.1: Create Recording Screen Component

- **User Story:** US01 (Frontend)
- **Duration:** ~1 day
- **What:** Basic screen with Start/Stop buttons
- **Deliverable:** `frontend/screens/RecordingScreen.tsx` (enhanced)
- **UI:**
  - Start Recording button
  - Stop Recording button (disabled initially)
  - Text display area for transcribed content
  - Save button (disabled if no content)
- **Acceptance Criteria:**
  - Screen renders correctly
  - Buttons are positioned well
  - All UI elements visible
  - No runtime errors
- **Done when:** Screen renders without errors

---

### Task 01F.2: Integrate Speech-to-Text Library

- **User Story:** US01 (Frontend)
- **Duration:** ~1.5 days
- **What:** Connect `react-native-voice` to buttons
- **Deliverable:** Update `RecordingScreen.tsx`
- **Behavior:**
  - Start button triggers recording
  - Stop button stops recording
  - Transcribed text displayed in real-time
  - Handle recording errors
- **Acceptance Criteria:**
  - Can start recording
  - Can stop recording
  - Text appears on screen
  - Works on iOS and Android emulators
  - Tests pass
- **Done when:** Can record and see text appear

---

### Task 01F.3: Add Save Button & API Integration

- **User Story:** US01 (Frontend)
- **Duration:** ~1 day
- **What:** Connect to POST /api/notes endpoint
- **Deliverable:** Update `RecordingScreen.tsx`
- **Behavior:**
  - Save button sends `{ content, userId }` to backend
  - Show loading state while saving
  - Show success message: "Note saved!"
  - Show error message if save fails
- **Acceptance Criteria:**
  - Can save note
  - Loading state displays
  - Success/error messages display
  - API tests pass (mocked)
- **Done when:** Can save note and see confirmation

---

### Task 01F.4: Add Error Handling to Recording Screen

- **User Story:** US01 (Frontend)
- **Duration:** ~1 day
- **What:** Handle permission denied, API errors, recording failures
- **Deliverable:** Update `RecordingScreen.tsx` with error handling
- **Scenarios:**
  - Permission denied → Show permission prompt
  - Recording failed → Show "Recording failed, try again"
  - Save failed → Show "Save failed, retry?"
- **Acceptance Criteria:**
  - Error messages clear and helpful
  - User can retry after error
  - Tests cover error paths
- **Done when:** User sees helpful error messages

---

### Task 02F.1: Create Notes List Screen Component

- **User Story:** US02 (Frontend)
- **Duration:** ~1 day
- **What:** Screen showing all user notes
- **Deliverable:** `frontend/screens/NotesListScreen.tsx` (enhanced)
- **UI:**
  - FlatList of notes
  - Each note shows: content preview + creation date
  - Pull-to-refresh to reload
  - Empty state message if no notes
- **Acceptance Criteria:**
  - Screen renders correctly
  - List displays with mock data
  - Pull-to-refresh works
  - Empty state displays
- **Done when:** Component renders correctly

---

### Task 02F.2: Connect GET /api/notes Endpoint

- **User Story:** US02 (Frontend)
- **Duration:** ~1 day
- **What:** Fetch notes on screen mount
- **Deliverable:** Update `NotesListScreen.tsx`
- **Behavior:**
  - Fetch notes when screen loads
  - Display loading spinner while fetching
  - Display error message if fetch fails
  - Refresh on pull-to-refresh
- **Acceptance Criteria:**
  - Fetches notes from backend
  - Loading state displays
  - Error state displays
  - Data refreshes on pull
  - Tests pass
- **Done when:** Can fetch and display notes

---

### Task 02F.3: Add Note Selection & Navigation

- **User Story:** US02 (Frontend)
- **Duration:** ~0.5 days
- **What:** Tap note → navigate to detail screen
- **Deliverable:** Update navigation and routes
- **Behavior:**
  - Tap note in list → navigate to `NoteDetailScreen`
  - Pass note ID as parameter
  - Detail screen retrieves and displays note
- **Acceptance Criteria:**
  - Navigation works
  - Correct note displayed on detail screen
  - Can go back to list
- **Done when:** Can tap note and see detail

---

### Task 03F.1: Create Note Detail Screen

- **User Story:** US03 (Frontend)
- **Duration:** ~1 day
- **What:** Display full note content
- **Deliverable:** `frontend/screens/NoteDetailScreen.tsx` (enhanced)
- **UI:**
  - Full note content
  - Creation date
  - Back button
- **Acceptance Criteria:**
  - Displays note correctly
  - Date formatted nicely
  - Navigation works
- **Done when:** Can view single note details

---

## Phase 5: Error Handling & Polish

### Task 06.1: Add Try/Catch to All API Calls

- **User Story:** US06
- **Duration:** ~1 day
- **What:** Wrap all API calls in error handlers
- **Deliverable:** Update all components using API
- **Locations:**
  - POST /api/users
  - POST /api/notes
  - GET /api/notes
- **Acceptance Criteria:**
  - No unhandled promise rejections
  - All errors caught and logged
  - User sees error messages
  - Tests pass
- **Done when:** No unhandled errors

---

### Task 06.2: Create Error Message Component

- **User Story:** US06
- **Duration:** ~1 day
- **What:** Reusable component to display errors
- **Deliverable:** `frontend/components/ErrorAlert.tsx`
- **Features:**
  - Shows error message
  - Retry button
  - Dismiss button
- **Acceptance Criteria:**
  - Renders errors clearly
  - Buttons work
  - Can be reused across screens
  - Tests pass
- **Done when:** Used consistently across app

---

### Task 06.3: Add Retry Logic

- **User Story:** US06
- **Duration:** ~1 day
- **What:** Automatically retry failed API calls
- **Deliverable:** `frontend/lib/retryUtils.ts`
- **Behavior:**
  - Retry failed requests up to 3 times
  - Exponential backoff (1s, 2s, 4s)
- **Acceptance Criteria:**
  - Retries work
  - Backoff timing correct
  - Tests pass
- **Done when:** Failed requests retry properly

---

## Execution Summary

**Total Estimated Duration:** ~25-30 days of work

**Critical Path Order:**

1. Phase 1 (4 tasks) - Days 1-4
2. Phase 2 (5 tasks) - Days 5-10
3. Phase 3 (6 tasks) - Days 11-16 (parallel with Phase 2)
4. Phase 4 (7 tasks) - Days 17-23 (after Phase 2 complete)
5. Phase 5 (3 tasks) - Days 24-26

**With 2 developers (1 backend, 1 frontend):** Can complete in ~15 days by running Phases in parallel.
