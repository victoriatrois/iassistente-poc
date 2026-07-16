# iAssistente POC - Speech-to-Text Notes App

A proof-of-concept mobile app for capturing and managing voice-to-text notes.

## 📋 Overview

**iAssistente** lets users:

- 🎤 Record voice notes and automatically convert to text
- 💾 Save notes with automatic association to their user
- 📖 View and manage their saved notes
- 🔒 Keep notes private and personal

**Status:** POC - Phase 1 (User Identification) Ready to Start

---

## 🚀 Quick Start

### Prerequisites

- **Docker & Docker Compose**
- **Node.js 18+** & npm
- **Git**

### Setup & Run

**⚠️ Prerequisites Check:**

- Docker Desktop is running (`docker --version` in terminal)
- Node.js installed (`node --version` returns v18 or higher)
- Git installed (`git --version` works)

**1. Create local environment file:**

Navigate to the project root folder and run:

```bash
cp .env.example .env.local
```

Open `.env.local` in your editor. The default values are fine for local development:

```
POSTGRES_PASSWORD=notes_password
```

**2. Start backend + database:**

In your terminal, from the project root:

```bash
docker-compose up
```

**Wait for this message to appear** (takes 10-20 seconds):

```
iassistente-backend | ready - started server on 0.0.0.0:3000
```

✅ You'll know it's ready when you see that message.

**3. Start frontend (open a NEW terminal tab/window):**

```bash
cd frontend
npm install
npm start
```

**Wait for:**

```
To open your app in Expo Go, scan this QR code
```

**4. Choose your platform:**

**iOS** (Mac only):

```bash
npm run ios
```

**Android** (with Android Studio):

```bash
npm run android
```

**Expo Go app** (iOS/Android - easiest):

- Download "Expo Go" app from App Store or Play Store
- Scan the QR code shown in step 3
- App opens in Expo Go

---

**✅ Success = All 3 running:**

- Backend terminal: API logs appearing
- Frontend terminal: `Local: http://...` showing
- Device/Simulator: App displaying

---

## 📚 Documentation

For detailed information, see:

| Topic                      | File                                                                    |
| -------------------------- | ----------------------------------------------------------------------- |
| Full Architecture          | [speech-to-text-poc.md](docs/speech-to-text-poc.md)                     |
| User Stories & Roadmap     | [user-stories.md](docs/user-stories.md)                                 |
| Task Breakdown (25 tasks)  | [implementation-tasks.md](docs/implementation-tasks.md)                 |
| Database Schema & Commands | [postgres-commands.md](docs/postgres-commands.md)                       |
| Setup Reference            | [project-setup-steps-followed.md](docs/project-setup-steps-followed.md) |

---

## 🔧 Essential Commands

### Docker (Backend + Database)

```bash
cd infrastructure
docker-compose up              # Start all services
docker-compose down            # Stop all services
docker-compose logs -f         # View live logs
docker-compose exec postgres psql -U notes_user -d notes_db  # Connect to DB
```

### Development

```bash
cd backend && npm run dev      # Backend server
cd frontend && npm start       # Frontend app
```

---

## 🐛 Troubleshooting

| Issue                 | Solution                                                                           |
| --------------------- | ---------------------------------------------------------------------------------- |
| Port 5432/3000 in use | `lsof -i :5432` then `kill -9 <PID>` or change `infrastructure/docker-compose.yml` |
| Database won't start  | `cd infrastructure && docker-compose logs postgres` to see errors                  |
| Backend error         | `cd infrastructure && docker-compose down -v && docker-compose up --build`         |
| Frontend fails        | `npm start -- --reset-cache && npm install`                                        |

---

## 📂 Project Structure

```
iassistente-poc/
├── backend/               # Next.js API + database services
├── frontend/              # React Native mobile app
├── docs/                  # Documentation files
├── scripts/               # Automation scripts
├── infrastructure/        # Docker & database setup
│   ├── docker-compose.yml # Orchestrates PostgreSQL + Backend
│   └── init.sql           # Auto-creates database schema
├── package.json           # Root: shared dev tools
├── README.md              # This file
└── ...
```

---

## 👥 Contributing

1. **Start Docker**

   ```bash
   docker-compose up
   ```

2. **Start Frontend** (in another terminal)

   ```bash
   cd frontend
   npm install
   npm start
   ```

3. **Pick a task** from [implementation-tasks.md](implementation-tasks.md) — start with Phase 1

4. **Create a feature branch**

   ```bash
   git checkout -b feat/task-name
   ```

5. **Follow conventional commits**
   ```bash
   git commit -m "feat(backend): description"
   ```

See [implementation-tasks.md](implementation-tasks.md) for full task details and dependencies.

---

## 📖 Architecture

See [speech-to-text-poc.md](speech-to-text-poc.md) for:

- User identification flow
- Note creation & retrieval workflows
- Database schema design
- Complete API specifications

---

## 🎯 Development Roadmap

**5 Phases | 25 concrete tasks** (~15-30 days depending on team size)

1. **Phase 1:** User Identification (backend blocker)
2. **Phase 2:** Core Backend Features
3. **Phase 3:** Frontend Foundation
4. **Phase 4:** Feature Implementation
5. **Phase 5:** Error Handling & Polish

See [user-stories.md](user-stories.md) for detailed breakdown and critical path.

---

**Last Updated:** June 27, 2026 | **Setup:** Docker only | **Status:** Phase 1 Ready
