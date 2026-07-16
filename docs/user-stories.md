# User Stories & Implementation Roadmap

## 🚀 Development Roadmap

```
Phase 1: User Identification (Backend Blocker)
└─ US04: Identify the Current User

Phase 2: Core Backend Features
├─ US01: Create a Note Using Voice (POST /api/notes)
└─ US02: View My Saved Notes (GET /api/notes)

Phase 3: Frontend Foundation
├─ US05: Handle Microphone Permission
├─ Basic app structure & navigation
└─ API client setup

Phase 4: Frontend Features
├─ US01: Create Note UI (recording screen)
├─ US02: View Notes List UI
└─ US03: View a Single Note

Phase 5: Error Handling & Polish
└─ US06: Handle Communication Failures
```

## Execution Priority

**Critical Path (Must Complete):** US04 → US01 → US02 → US05 → US06

- US04 is a blocker for backend development
- US01 & US02 must be complete before frontend integration
- US05 & US03 UI features depend on backend being ready
- US06 wraps up error handling across the system

---

## ✅ Project Setup (Completed)

- [x] Frontend React Native project with TypeScript
- [x] Backend Next.js project with TypeScript
- [x] PostgreSQL database & tables created
- [x] Database schema: `user` and `note` tables with UUID PKs
- [x] Dependencies installed (react-native-voice, axios, pg)

See [project-setup-steps-followed.md](project-setup-steps-followed.md) for setup reference.

---

## Complete User Story Specifications

Detailed user story definitions, acceptance criteria, business rules, and domain model are in [speech-to-text-poc.md](speech-to-text-poc.md).
